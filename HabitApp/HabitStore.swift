//
//  HabitStore.swift
//  HabitApp
//

import Foundation
import SwiftUI
import Combine

class HabitStore: ObservableObject {
    @Published var habits: [Habit] = [] {
        didSet { save() }
    }

    private let habitsKey   = "saved_habits"
    private let lastOpenKey = "last_open_date"

    init() {
        load()
        resetIfNewDay()
    }

    // MARK: - Daily Reset
    // ملاحظة: ما عاد نحتاج تصفير completed يدويًا لأن التتبع صار عبر dailyProgress
    // (كل يوم له مفتاحه الخاص تلقائيًا). أبقينا الدالة للحفاظ على تاريخ آخر فتح فقط.

    private func resetIfNewDay() {
        let calendar = Calendar.current
        let today    = calendar.startOfDay(for: Date())

        if let savedData = UserDefaults.standard.object(forKey: lastOpenKey) as? Date {
            let lastOpen = calendar.startOfDay(for: savedData)
            if lastOpen < today {
                // يوم جديد — ما نحتاج نسوي شي، dailyProgress يفصل تلقائيًا حسب التاريخ
            }
        }

        // تحديث تاريخ آخر فتح دائمًا
        UserDefaults.standard.set(Date(), forKey: lastOpenKey)
    }

    // MARK: - Persistence

    private func save() {
        if let encoded = try? JSONEncoder().encode(habits) {
            UserDefaults.standard.set(encoded, forKey: habitsKey)
        }
    }

    private func load() {
        guard
            let data    = UserDefaults.standard.data(forKey: habitsKey),
            let decoded = try? JSONDecoder().decode([Habit].self, from: data)
        else { return }
        habits = decoded
    }

    // MARK: - Actions

    func add(_ habit: Habit) {
        habits.append(habit)
    }

    func delete(id: UUID) {
        habits.removeAll { $0.id == id }
    }

    func update(_ updated: Habit) {
        if let i = habits.firstIndex(where: { $0.id == updated.id }) {
            habits[i] = updated
        }
    }

    func toggleFreeze(id: UUID) {
        if let i = habits.firstIndex(where: { $0.id == id }) {
            habits[i].isFrozen.toggle()
        }
    }

    /// يزيد عداد اليوم الحالي فقط لهذي العادة.
    /// إذا وصل للهدف وضغط مرة ثانية، يرجع يصفر اليوم (toggle).
    func incrementCompleted(id: UUID) {
        guard let i = habits.firstIndex(where: { $0.id == id }) else { return }
        guard !habits[i].isFrozen else { return }

        let key = Habit.dayKey(for: Date())
        let current = habits[i].dailyProgress[key] ?? 0
        let goal = habits[i].amountPerDay

        if current < goal {
            habits[i].dailyProgress[key] = current + 1
        } else {
            habits[i].dailyProgress[key] = 0
        }
    }
}
