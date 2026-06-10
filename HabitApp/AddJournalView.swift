//
//  AddJournalView.swift
//  HabitApp
//

import SwiftUI

struct AddJournalView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var entries: [JournalEntry]
    let habits: [Habit]

    @State private var selectedHabit = ""
    @State private var selectedMood: Mood = .happy
    @State private var journalText = ""
    @State private var selectedDate = Date()
    @State private var showHabitPicker = false
    @State private var showDatePicker = false

    private var habitNames: [String] { habits.map { $0.name } }

    init(entries: Binding<[JournalEntry]>, habits: [Habit]) {
        self._entries = entries
        self.habits = habits
        _selectedHabit = State(initialValue: habits.first?.name ?? "")
    }

    var body: some View {
        ZStack {
            Color("BackgroundCream").ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 28) {

                    // Header
                    HStack {
                        Button { dismiss() } label: {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.black)
                        }
                        Spacer()
                        Button { showDatePicker = true } label: {
                            Text(selectedDate.formatted(.dateTime.day().month(.wide).year()))
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                                .padding(.horizontal, 18)
                                .padding(.vertical, 12)
                                .background(RoundedRectangle(cornerRadius: 14).fill(Color.gray.opacity(0.15)))
                        }
                    }

                    // Habit picker
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Choose the habit")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color("PrimaryOrange"))

                        Button { showHabitPicker = true } label: {
                            HStack {
                                Text(selectedHabit.isEmpty ? "Select a habit" : selectedHabit)
                                    .font(.system(size: 18))
                                    .foregroundColor(.gray)
                                Spacer()
                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.title3)
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal, 24)
                            .frame(height: 72)
                            .background(RoundedRectangle(cornerRadius: 22).fill(Color("PrimaryOrange").opacity(0.08)))
                            .overlay(RoundedRectangle(cornerRadius: 22).stroke(Color.black.opacity(0.05), lineWidth: 1))
                            .shadow(color: .black.opacity(0.05), radius: 6, y: 2)
                        }
                        .buttonStyle(.plain)
                    }

                    // Mood
                    VStack(alignment: .leading, spacing: 16) {
                        Text("How did you feel today?")
                            .font(.system(size: 18))
                            .foregroundColor(Color("PrimaryOrange"))

                        HStack {
                            ForEach(Mood.allCases, id: \.self) { mood in
                                VStack(spacing: 6) {
                                    Text(mood.emoji)
                                        .font(.system(size: 36))
                                        .scaleEffect(selectedMood == mood ? 1.15 : 1)
                                        .animation(.spring(response: 0.3), value: selectedMood)
                                    Text(mood.title)
                                        .font(.caption)
                                        .foregroundColor(selectedMood == mood ? Color("PrimaryOrange") : .gray)
                                }
                                .frame(maxWidth: .infinity)
                                .onTapGesture { selectedMood = mood }
                            }
                        }
                    }

                    // Journal text
                    VStack(alignment: .leading, spacing: 12) {
                        Text("I feel today...")
                            .font(.system(size: 18))
                            .foregroundColor(Color("PrimaryOrange"))

                        TextEditor(text: $journalText)
                            .scrollContentBackground(.hidden)
                            .padding(12)
                            .frame(height: 260)
                            .background(RoundedRectangle(cornerRadius: 24).fill(Color("PrimaryOrange").opacity(0.08)))
                    }

                    // Save
                    Button {
                        guard !journalText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                        entries.append(JournalEntry(
                            habit: selectedHabit,
                            mood: selectedMood,
                            date: selectedDate,
                            text: journalText
                        ))
                        dismiss()
                    } label: {
                        Text("Done")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 58)
                            .background(Color("PrimaryOrange"))
                            .cornerRadius(30)
                    }

                    Spacer(minLength: 30)
                }
                .padding(24)
            }
        }
        .sheet(isPresented: $showHabitPicker) {
            NavigationStack {
                List {
                    ForEach(habitNames, id: \.self) { habit in
                        Button {
                            selectedHabit = habit
                            showHabitPicker = false
                        } label: {
                            HStack {
                                Text(habit)
                                Spacer()
                                if selectedHabit == habit {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Choose Habit")
            }
        }
        .sheet(isPresented: $showDatePicker) {
            NavigationStack {
                VStack {
                    DatePicker("Choose Date", selection: $selectedDate, displayedComponents: .date)
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
    AddJournalView(entries: .constant([]), habits: [
        Habit(name: "Reading", icon: "📚", amountPerDay: 1, targetDate: Date(), remindersOn: false),
    ])
}
