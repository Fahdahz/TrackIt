//
//  JournalHomeView.swift
//  HabitApp
//

import SwiftUI

struct JournalHomeView: View {
    let habits: [Habit]

    @State private var entries: [JournalEntry] = []
    @State private var showAddJournal = false
    @State private var selectedHabit: String = ""
    @State private var selectedDate: Date? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundCream").ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("Your journals")
                            .font(.system(size: 30, weight: .bold, design: .serif))
                            .foregroundColor(.black)
                        Spacer()
                        Button { showAddJournal = true } label: {
                            ZStack {
                                Circle()
                                    .fill(Color("BackgroundCream"))
                                    .frame(width: 64, height: 63)
                                    .overlay(Circle().stroke(Color("PrimaryOrange").opacity(0.23), lineWidth: 1))
                                    .overlay(
                                        Circle()
                                            .stroke(
                                                LinearGradient(
                                                    colors: [
                                                        Color("PrimaryOrange").opacity(0.65),
                                                        Color("PrimaryOrange").opacity(0.18),
                                                        Color("PrimaryOrange").opacity(0.08),
                                                        Color("PrimaryOrange").opacity(0.18)
                                                    ],
                                                    startPoint: .top, endPoint: .bottom
                                                ),
                                                lineWidth: 2.2
                                            )
                                            .blur(radius: 0.6)
                                    )
                                    .shadow(color: Color("PrimaryOrange").opacity(0.18), radius: 9, x: 0, y: 1)
                                Image(systemName: "plus")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(Color("PrimaryOrange"))
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal)
                    .padding(.top)

                    if entries.isEmpty {
                        Spacer()
                        VStack(spacing: 12) {
                            Text("How are you feeling today?")
                                .font(.system(size: 28, weight: .bold, design: .serif))
                            Text("Write about your progress. Small reflections can reveal big patterns.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .frame(width: 260)
                        }
                        Spacer()
                    } else {
                        JournalListView(
                            entries: $entries,
                            habits: habits,
                            selectedHabit: Binding(
                                get: { selectedHabit.isEmpty ? (habits.first?.name ?? "") : selectedHabit },
                                set: { selectedHabit = $0 }
                            ),
                            selectedDate: $selectedDate
                        )
                    }

                    Spacer(minLength: 20)
                }
            }
            .sheet(isPresented: $showAddJournal) {
                AddJournalView(entries: $entries, habits: habits)
            }
        }
    }
}

#Preview {
    JournalHomeView(habits: [
        Habit(name: "Reading", icon: "📚", amountPerDay: 1, targetDate: Date(), remindersOn: false),
        Habit(name: "Running", icon: "🏃🏻‍♀️", amountPerDay: 1, targetDate: Date(), remindersOn: false),
    ])
}
