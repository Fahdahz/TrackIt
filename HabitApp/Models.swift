//
//  Models.swift
//  HabitApp
//

import Foundation
import SwiftUI

// MARK: - Habit

struct Habit: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var icon: String
    var amountPerDay: Int
    var targetDate: Date
    var remindersOn: Bool
    var completed: Int = 0
    var isFrozen: Bool = false
    var reminderTime: Date? = nil

    // 🆕 سجل الإنجاز اليومي: التاريخ (yyyy-MM-dd) -> عدد المرات المنجزة
    var dailyProgress: [String: Int] = [:]
}

// MARK: - Habit Helpers (Daily Progress & Streak)

extension Habit {
    /// يحول التاريخ إلى مفتاح نصي ثابت بدون وقت (yyyy-MM-dd)
    static func dayKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .current
        return formatter.string(from: date)
    }

    /// عدد مرات الإنجاز ليوم معين
    func progress(on date: Date) -> Int {
        dailyProgress[Habit.dayKey(for: date)] ?? 0
    }

    /// هل العادة مكتملة في يوم معين (وصلت للهدف)؟
    func isCompleted(on date: Date) -> Bool {
        progress(on: date) >= amountPerDay
    }

    /// عدد الأيام المتتالية المكتملة (تحسب بدءًا من اليوم رجوعًا للخلف)
    var currentStreak: Int {
        guard amountPerDay > 0 else { return 0 }
        var streak = 0
        var date = Date()
        let calendar = Calendar.current

        while isCompleted(on: date) {
            streak += 1
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: date) else { break }
            date = previousDay
        }
        return streak
    }
}

// MARK: - JournalEntry

struct JournalEntry: Identifiable {
    var id: UUID = UUID()
    let habit: String
    let mood: Mood
    let date: Date
    let text: String
}

// MARK: - Mood

enum Mood: String, CaseIterable {
    case happy, neutral, stressed, sad, angry

    var title: String { rawValue.capitalized }

    var emoji: String {
        switch self {
        case .happy:    return "😊"
        case .neutral:  return "😐"
        case .stressed: return "😰"
        case .sad:      return "😢"
        case .angry:    return "😠"
        }
    }

    var color: Color {
        switch self {
        case .happy:    return Color(red: 0.98, green: 0.73, blue: 0.42)
        case .neutral:  return Color(red: 0.92, green: 0.89, blue: 0.85)
        case .stressed: return Color(red: 0.80, green: 0.72, blue: 0.91)
        case .sad:      return Color(red: 0.73, green: 0.83, blue: 0.95)
        case .angry:    return Color(red: 0.94, green: 0.67, blue: 0.65)
        }
    }
}
