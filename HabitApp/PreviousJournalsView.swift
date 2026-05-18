//
//  PreviousJournalsView.swift
//  HabitApp
//
//  Created by Fahdah Alsamari on 30/11/1447 AH.
//

import SwiftUI

struct PreviousJournalsView: View {

    // MARK: - STATES

    @State private var selectedDate = Date()

    // MARK: - BODY

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(alignment: .leading, spacing: 26) {

                    // MARK: - TITLE

                    Text("Previous Journals")
                        .font(
                            .system(
                                size: 28,
                                weight: .semibold,
                                design: .serif
                            )
                        )
                        .padding(.top, 10)
                        .padding(.horizontal, 60)

                    // MARK: - DATE TITLE

                    Text("Pick a Specific Date")
                        .font(
                            .system(
                                size: 22,
                                weight: .semibold,
                                design: .serif
                            )
                        )
                        .padding(.horizontal, 15)
                        .padding(.top, 10)
                    // MARK: - DATE PICKER

                    DatePicker(
                        "",
                        selection: $selectedDate,
                        displayedComponents: .date
                    )
                    .labelsHidden()
                    .padding(.horizontal, 12)
                    .padding(.top, -15)
                    .padding(.bottom, 10)

                    // MARK: - JOURNAL CARDS

                    VStack(spacing: 24) {

                        JournalCard(
                            title: "Building Better Habits",
                            date: "10 May 2026",
                            text:
"""
I stayed consistent with my habits today, even when I didn’t feel fully motivated. Small progress is still progress. Drinking more water and staying focused on my goals made me feel productive and balanced.
""",
                            moodImage: "happy"
                        )

                        JournalCard(
                            title: "Staying Present",
                            date: "9 May 2026",
                            text:
"""
Today, I tried to slow down and focus on being present in small moments throughout the day. Taking breaks and avoiding distractions helped me feel calmer and less overwhelmed.
""",
                            moodImage: "neutral"
                        )
                    }

                }
                .padding(.horizontal, 20)
                .padding(.bottom, 80)
            }
            .background(Color("BackgroundCream"))
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    PreviousJournalsView()
}
