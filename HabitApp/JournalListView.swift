//
//  JournalListView.swift
//  HabitApp
//

import SwiftUI

struct JournalListView: View {
    @Binding var entries: [JournalEntry]
    let habits: [Habit]
    @Binding var selectedHabit: String
    @Binding var selectedDate: Date?

    @State private var showDatePicker = false

    private var habitNames: [String] { habits.map { $0.name } }

    private var filteredEntries: [JournalEntry] {
        let habitEntries = entries
            .filter { $0.habit == selectedHabit }
            .sorted { $0.date > $1.date }
        guard let selectedDate else { return habitEntries }
        return habitEntries.filter {
            Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
        }
    }

    private var groupedEntries: [(Date, [JournalEntry])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: filteredEntries) { entry in
            let components = calendar.dateComponents([.year, .month], from: entry.date)
            return calendar.date(from: components) ?? entry.date
        }
        return grouped.map { ($0.key, $0.value) }.sorted { $0.0 > $1.0 }
    }

    var body: some View {
        VStack(spacing: 16) {

            // Date filter
            HStack {
                Text("Pick a specific Date")
                    .font(.system(size: 18, weight: .bold, design: .serif))
                Spacer()
                Button { showDatePicker = true } label: {
                    Text(
                        selectedDate == nil
                        ? "All Dates"
                        : selectedDate!.formatted(.dateTime.day().month(.abbreviated).year())
                    )
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 12)
                    .background(RoundedRectangle(cornerRadius: 14).fill(Color.gray.opacity(0.12)))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal)

            // Habit chips — from real habits only
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(habitNames, id: \.self) { habit in
                        Button { selectedHabit = habit } label: {
                            Text(habit)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(selectedHabit == habit ? .white : Color("PrimaryOrange"))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(selectedHabit == habit ? Color("PrimaryOrange") : Color.clear)
                                .overlay(Capsule().stroke(Color("PrimaryOrange"), lineWidth: 1))
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }

            // Journal list
            ScrollView {
                VStack(spacing: 24) {
                    if filteredEntries.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "calendar").font(.largeTitle)
                            Text("No journal entries found.").foregroundStyle(.secondary)
                        }
                        .padding(.top, 80)
                    } else if selectedDate != nil {
                        ForEach(filteredEntries) { entry in
                            NavigationLink { JournalDetailView(entry: entry) } label: { JournalCard(entry: entry) }
                                .buttonStyle(.plain)
                        }
                    } else {
                        ForEach(groupedEntries, id: \.0) { month, monthEntries in
                            VStack(spacing: 16) {
                                Text(month.formatted(.dateTime.month(.wide)).uppercased())
                                    .font(.system(size: 18, weight: .bold, design: .serif))
                                    .foregroundStyle(.secondary)
                                ForEach(monthEntries) { entry in
                                    NavigationLink { JournalDetailView(entry: entry) } label: { JournalCard(entry: entry) }
                                        .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                }
                .padding()
                .padding(.bottom, 100)
            }
        }
        .sheet(isPresented: $showDatePicker) {
            NavigationStack {
                VStack {
                    DatePicker(
                        "Choose Date",
                        selection: Binding(
                            get: { selectedDate ?? Date() },
                            set: { selectedDate = $0 }
                        ),
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    .padding()
                    Spacer()
                }
                .navigationTitle("Choose Date")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Show All") {
                            selectedDate = nil
                            showDatePicker = false
                        }
                    }
                }
            }
        }
    }
}
