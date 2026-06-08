//
//  Models.swift
//  HabitApp
//

import Foundation
import SwiftUI

// MARK: - Habit

struct Habit: Identifiable {
    let id = UUID()
    var name: String
    var icon: String
    var amountPerDay: Int
    var targetDate: Date
    var remindersOn: Bool
    var completed: Int = 0
    var isFrozen: Bool = false
}

// MARK: - JournalEntry

struct JournalEntry: Identifiable {
    let id = UUID()
    let habit: String
    let mood: Mood
    let date: Date
    let text: String
}

// MARK: - Mood

enum Mood: String, CaseIterable {
    case happy, neutral, stressed, sad, angry

    var title: String { rawValue.capitalized }

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
