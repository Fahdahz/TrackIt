//
//  AddJournalView.swift
//  HabitApp
//
//  Created by Fahdah Alsamari on 17/12/1447 AH.
//

import SwiftUI

struct AddJournalView: View {

    @Environment(\.dismiss) private var dismiss

    @Binding var entries: [JournalEntry]

    @State private var selectedHabit = "Reading"
    @State private var selectedMood: Mood = .happy
    @State private var journalText = ""
    @State private var selectedDate = Date()

    @State private var showHabitPicker = false
    @State private var showDatePicker = false

    let habits = [
        "Reading",
        "Running",
        "Drinking Water"
    ]

    var body: some View {

        ZStack {

            Color("BackgroundCream")
                .ignoresSafeArea()

            ScrollView {

                VStack(
                    alignment: .leading,
                    spacing: 28
                ) {

                    // MARK: Header

                    HStack {

                        Button {
                            dismiss()
                        } label: {

                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.black)
                        }

                        Spacer()

                        Button {

                            showDatePicker = true

                        } label: {

                            Text(
                                selectedDate.formatted(
                                    .dateTime
                                        .day()
                                        .month(.wide)
                                        .year()
                                )
                            )
                            .font(.nyRegular(18))
                            .foregroundColor(.gray)

                            .padding(.horizontal, 18)
                            .padding(.vertical, 12)

                            .background(
                                RoundedRectangle(
                                    cornerRadius: 14
                                )
                                .fill(
                                    Color.gray.opacity(0.15)
                                )
                            )
                        }
                    }

                    // MARK: Habit

                    VStack(
                        alignment: .leading,
                        spacing: 14
                    ) {

                        Text("Choose the habit")
                            .font(.nyBold(20))
                            .foregroundColor(
                                Color("PrimaryOrange")
                            )

                        Button {

                            showHabitPicker = true

                        } label: {

                            HStack {

                                Text(selectedHabit)
                                    .font(.nyRegular(18))
                                    .foregroundColor(.gray)

                                Spacer()

                                Image(
                                    systemName:
                                        "chevron.up.chevron.down"
                                )
                                .font(.title3)
                                .foregroundColor(.gray)
                            }
                            .padding(.horizontal, 24)
                            .frame(height: 72)

                            .background(
                                RoundedRectangle(
                                    cornerRadius: 22
                                )
                                .fill(
                                    Color("PrimaryOrange")
                                        .opacity(0.08)
                                )
                            )

                            .overlay {

                                RoundedRectangle(
                                    cornerRadius: 22
                                )
                                .stroke(
                                    Color.black.opacity(0.05),
                                    lineWidth: 1
                                )
                            }

                            .shadow(
                                color: .black.opacity(0.05),
                                radius: 6,
                                y: 2
                            )
                        }
                        .buttonStyle(.plain)
                    }

                    // MARK: Mood

                    VStack(
                        alignment: .leading,
                        spacing: 16
                    ) {

                        Text("How did you feel today?")
                            .font(.nyRegular(18))
                            .foregroundColor(
                                Color("PrimaryOrange")
                            )

                        HStack {

                            ForEach(
                                Mood.allCases,
                                id: \.self
                            ) { mood in

                                VStack(spacing: 6) {

                                    Image(mood.rawValue)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(
                                            width: 52,
                                            height: 52
                                        )
                                        .scaleEffect(
                                            selectedMood == mood
                                            ? 1.08
                                            : 1
                                        )

                                    Text(mood.title)
                                        .font(.caption)
                                }
                                .frame(maxWidth: .infinity)
                                .onTapGesture {

                                    selectedMood = mood
                                }
                            }
                        }
                    }

                    // MARK: Journal

                    VStack(
                        alignment: .leading,
                        spacing: 12
                    ) {

                        Text("I feel today...")
                            .font(.nyRegular(18))
                            .foregroundColor(
                                Color("PrimaryOrange")
                            )

                        TextEditor(
                            text: $journalText
                        )
                        .scrollContentBackground(.hidden)
                        .padding(12)
                        .frame(height: 260)

                        .background(
                            RoundedRectangle(
                                cornerRadius: 24
                            )
                            .fill(
                                Color("PrimaryOrange")
                                    .opacity(0.08)
                            )
                        )
                    }

                    // MARK: Save

                    Button {

                        guard !journalText
                            .trimmingCharacters(
                                in: .whitespacesAndNewlines
                            )
                            .isEmpty else {
                            return
                        }

                        let entry = JournalEntry(
                            habit: selectedHabit,
                            mood: selectedMood,
                            date: selectedDate,
                            text: journalText
                        )

                        entries.append(entry)

                        dismiss()

                    } label: {

                        Text("Done")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 58)

                            .background(
                                Color("PrimaryOrange")
                            )

                            .cornerRadius(30)
                    }

                    Spacer(minLength: 30)
                }
                .padding(24)
            }
        }

        // MARK: Habit Picker Sheet

        .sheet(isPresented: $showHabitPicker) {

            NavigationStack {

                List {

                    ForEach(
                        habits,
                        id: \.self
                    ) { habit in

                        Button {

                            selectedHabit = habit
                            showHabitPicker = false

                        } label: {

                            HStack {

                                Text(habit)

                                Spacer()

                                if selectedHabit == habit {

                                    Image(
                                        systemName:
                                            "checkmark"
                                    )
                                }
                            }
                        }
                    }
                }
                .navigationTitle(
                    "Choose Habit"
                )
            }
        }

        // MARK: Date Picker Sheet

        .sheet(isPresented: $showDatePicker) {

            NavigationStack {

                VStack {

                    DatePicker(
                        "Choose Date",
                        selection: $selectedDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    .padding()

                    Spacer()
                }
                .navigationTitle("Choose Date")
            }
        }
    }
}

#Preview {

    AddJournalView(
        entries: .constant([])
    )
}
