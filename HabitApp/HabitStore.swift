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

    private func resetIfNewDay() {
        let calendar = Calendar.current
        let today    = calendar.startOfDay(for: Date())

        if let savedData = UserDefaults.standard.object(forKey: lastOpenKey) as? Date {
            let lastOpen = calendar.startOfDay(for: savedData)
            if lastOpen < today {
                // New day — reset completed counts
                resetDailyProgress()
            }
        }

        // Always update last open date to today
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

    func incrementCompleted(id: UUID) {
        if let i = habits.firstIndex(where: { $0.id == id }) {
            if !habits[i].isFrozen && habits[i].completed < habits[i].amountPerDay {
                habits[i].completed += 1
            }
        }
    }

    func resetDailyProgress() {
        for i in habits.indices {
            if !habits[i].isFrozen {
                habits[i].completed = 0
            }
        }
    }
}
