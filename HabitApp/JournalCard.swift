//
//  JournalCard.swift
//  HabitApp
//

import SwiftUI

struct JournalCard: View {
    let entry: JournalEntry

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(spacing: 4) {
                Text(entry.date.formatted(.dateTime.day()))
                    .font(.system(size: 34, weight: .medium))
                Text(entry.date.formatted(.dateTime.weekday(.abbreviated)))
                    .font(.subheadline)
            }
            .frame(width: 70)

            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 6) {
                    Text(entry.mood.emoji)
                        .font(.system(size: 18))
                    Text(entry.mood.title)
                        .font(.caption)
                        .fontWeight(.medium)
                }
                Text(entry.text)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(entry.mood.color)
            .cornerRadius(18)
        }
    }
}

#Preview {
    JournalCard(entry: JournalEntry(
        habit: "Reading",
        mood: .happy,
        date: Date(),
        text: "Today I completed my reading habit."
    ))
    .padding()
}
