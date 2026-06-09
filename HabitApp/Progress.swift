//
//  Progress.swift
//  HabitApp
//

import SwiftUI

struct Progress: View {
    let habits: [Habit]

    var body: some View {
        TrackProgressView(habits: habits)
            .background(AppTheme.bg.ignoresSafeArea())
    }
}

// MARK: - Main View

private struct TrackProgressView: View {
    let habits: [Habit]

    @State private var selectedFilter: String = ""
    @State private var currentMonth: Date = .now
    @State private var achievementHabit: Habit? = nil

    private var filters: [String] { habits.map { $0.name } }

    private var selectedHabit: Habit? {
        habits.first { $0.name == selectedFilter } ?? habits.first
    }

    // Most consistent = highest completion ratio
    private var mostConsistent: Habit? {
        habits.filter { !$0.isFrozen }.max { a, b in
            (Double(a.completed) / Double(max(a.amountPerDay, 1))) <
            (Double(b.completed) / Double(max(b.amountPerDay, 1)))
        }
    }

    // Needs attention = lowest completion ratio (not frozen, not 0 progress)
    private var needsAttention: Habit? {
        habits.filter { !$0.isFrozen }.min { a, b in
            (Double(a.completed) / Double(max(a.amountPerDay, 1))) <
            (Double(b.completed) / Double(max(b.amountPerDay, 1)))
        }
    }

    // Completed habits (100%)
    private var completedHabits: [Habit] {
        habits.filter { $0.completed >= $0.amountPerDay && !$0.isFrozen }
    }

    // Completion data for selected habit (mock: completed days = completed count from today back)
    private var completedDays: Set<Int> {
        guard let habit = selectedHabit else { return [] }
        let today = Calendar.current.component(.day, from: Date())
        let count = min(habit.completed, today)
        guard count > 0 else { return [] }
        return Set((today - count + 1)...today)
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {

                Text("Track Your Progress")
                    .font(.system(size: 28, weight: .semibold, design: .serif))
                    .foregroundStyle(AppTheme.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 16)

                if habits.isEmpty {
                    emptyProgressView
                } else {
                    // Summary Cards
                    GeometryReader { proxy in
                        let spacing: CGFloat = 12
                        let totalWidth = proxy.size.width
                        let columnWidth = (totalWidth - spacing) / 2

                        HStack(alignment: .top, spacing: spacing) {
                            // Left: first completed habit or placeholder
                            if let first = completedHabits.first {
                                CompletedCard(habit: first) {
                                    achievementHabit = first
                                }
                                .frame(width: columnWidth)
                            } else {
                                NoCompletedCard()
                                    .frame(width: columnWidth)
                            }

                            VStack(spacing: spacing) {
                                if let mc = mostConsistent {
                                    MostConsistentCard(habit: mc)
                                        .frame(maxWidth: .infinity)
                                        .frame(maxHeight: .infinity)
                                }
                                if let na = needsAttention, na.id != mostConsistent?.id {
                                    NeedsAttentionCard(habit: na)
                                        .frame(maxWidth: .infinity)
                                        .frame(maxHeight: .infinity)
                                }
                            }
                            .frame(width: columnWidth)
                        }
                        .frame(width: totalWidth, alignment: .topLeading)
                    }
                    .frame(height: 210)
                    .padding(.bottom, 4)

                    // Filter Chips
                    if !filters.isEmpty {
                        FilterChipsView(filters: filters, selected: Binding(
                            get: { selectedFilter.isEmpty ? (habits.first?.name ?? "") : selectedFilter },
                            set: { selectedFilter = $0 }
                        ))
                    }

                    // Calendar
                    CalendarContainer(
                        currentMonth: $currentMonth,
                        completedDays: completedDays
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
        .background(AppTheme.bg)
        .sheet(item: $achievementHabit) { habit in
            AchievementView(habit: habit)
        }
        .onAppear {
            if selectedFilter.isEmpty { selectedFilter = habits.first?.name ?? "" }
        }
    }

    // MARK: - Empty state
    var emptyProgressView: some View {
        VStack(spacing: 16) {
            Spacer().frame(height: 60)
            Text("📊")
                .font(.system(size: 60))
            Text("No habits yet!")
                .font(.system(size: 22, weight: .bold, design: .serif))
                .foregroundColor(AppTheme.textPrimary)
            Text("Add habits from the home tab\nto start tracking your progress.")
                .font(.system(size: 15))
                .foregroundColor(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 40)
    }
}

// MARK: - Cards

private struct CompletedCard: View {
    let habit: Habit
    let onViewAchievement: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("🎉")
                .font(.system(size: 32))
                .frame(maxWidth: .infinity, alignment: .center)

            Text("HABIT COMPLETED!")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(AppTheme.orange)
                .frame(maxWidth: .infinity, alignment: .center)

            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text(habit.icon).font(.system(size: 18))
                Text(habit.name)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(AppTheme.textPrimary)
                    .lineLimit(1)
                Spacer(minLength: 0)
            }

            Text("\(habit.completed) of \(habit.amountPerDay) daily goal")
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(AppTheme.textSecondary)

            Button(action: onViewAchievement) {
                Text("View achievement")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(AppTheme.orange, in: Capsule())
                    .shadow(color: AppTheme.orange.opacity(0.25), radius: 6, y: 3)
            }
            .padding(.top, 2)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.white)
                .shadow(color: AppTheme.shadow, radius: 10, y: 6)
        )
    }
}

private struct NoCompletedCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("💪")
                .font(.system(size: 32))
                .frame(maxWidth: .infinity, alignment: .center)
            Text("KEEP GOING!")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(AppTheme.orange)
                .frame(maxWidth: .infinity, alignment: .center)
            Text("Complete a habit\nto earn your badge")
                .font(.system(size: 13))
                .foregroundStyle(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
        .padding(16)
        .frame(maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.white)
                .shadow(color: AppTheme.shadow, radius: 10, y: 6)
        )
    }
}

private struct MostConsistentCard: View {
    let habit: Habit
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("MOST CONSISTENT")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(AppTheme.grey)

            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text(habit.icon).font(.system(size: 16))
                Text(habit.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(AppTheme.textPrimary)
                    .lineLimit(1)
                Spacer()
            }

            Text("\(habit.completed) completed today")
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(AppTheme.textSecondary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.white)
                .shadow(color: AppTheme.shadow, radius: 10, y: 6)
        )
    }
}

private struct NeedsAttentionCard: View {
    let habit: Habit
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("NEEDS ATTENTION")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(AppTheme.grey)

            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text(habit.icon).font(.system(size: 16))
                Text(habit.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(AppTheme.textPrimary)
                    .lineLimit(1)
                Spacer()
            }

            let remaining = habit.amountPerDay - habit.completed
            Text(remaining > 0 ? "\(remaining) left today" : "All done!")
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(AppTheme.textSecondary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.white)
                .shadow(color: AppTheme.shadow, radius: 10, y: 6)
        )
    }
}

// MARK: - Filter Chips

private struct FilterChipsView: View {
    let filters: [String]
    @Binding var selected: String

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(filters, id: \.self) { item in
                    let isSelected = item == selected
                    Button { selected = item } label: {
                        Text(item)
                            .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                            .foregroundStyle(isSelected ? .white : AppTheme.textSecondary)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 9)
                            .background(Capsule().fill(isSelected ? AppTheme.orange : .white))
                            .overlay(Capsule().stroke(isSelected ? AppTheme.orange : AppTheme.orange.opacity(0.4), lineWidth: 1.5))
                    }
                    .animation(.easeInOut(duration: 0.18), value: isSelected)
                }
            }
            .padding(.vertical, 2)
        }
    }
}

// MARK: - Calendar

private struct CalendarContainer: View {
    @Binding var currentMonth: Date
    let completedDays: Set<Int>
    @State private var selectedDate: Date? = nil

    private var monthTitle: String {
        let f = DateFormatter()
        f.dateFormat = "LLLL yyyy"
        return f.string(from: currentMonth).uppercased()
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Button {
                    withAnimation(.easeInOut) {
                        currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(AppTheme.orange)
                        .font(.system(size: 16, weight: .semibold))
                        .padding(4)
                }
                Spacer()
                Text(monthTitle)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(AppTheme.textPrimary)
                Spacer()
                Button {
                    withAnimation(.easeInOut) {
                        currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(AppTheme.orange)
                        .font(.system(size: 16, weight: .semibold))
                        .padding(4)
                }
            }
            .padding(.horizontal, 4)

            HStack {
                ForEach(["MON","TUE","WED","THU","FRI","SAT","SUN"], id: \.self) { weekday in
                    Text(weekday)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(AppTheme.textSecondary)
                        .frame(maxWidth: .infinity)
                }
            }

            CalendarGrid(currentMonth: currentMonth, completedDays: completedDays, selectedDate: $selectedDate)
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.white)
                .shadow(color: AppTheme.shadow, radius: 10, y: 6)
        )
    }
}

private struct CalendarGrid: View {
    let currentMonth: Date
    let completedDays: Set<Int>
    @Binding var selectedDate: Date?

    var body: some View {
        let days = makeMonthDays(for: currentMonth)
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7), spacing: 6) {
            ForEach(days, id: \.id) { day in
                DayCell(
                    day: day,
                    isDone: day.number.map { completedDays.contains($0) } ?? false,
                    isSelected: isSelected(day),
                    isToday: isToday(day)
                )
                .onTapGesture {
                    guard let date = day.date else { return }
                    withAnimation(.easeInOut(duration: 0.15)) { selectedDate = date }
                }
            }
        }
        .padding(.bottom, 4)
    }

    private func isSelected(_ day: MonthDay) -> Bool {
        guard let selected = selectedDate, let date = day.date else { return false }
        return Calendar.current.isDate(selected, inSameDayAs: date)
    }

    private func isToday(_ day: MonthDay) -> Bool {
        guard let date = day.date else { return false }
        return Calendar.current.isDateInToday(date)
    }

    private func makeMonthDays(for date: Date) -> [MonthDay] {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        let range = calendar.range(of: .day, in: .month, for: date)!
        let comps = calendar.dateComponents([.year, .month], from: date)
        let firstOfMonth = calendar.date(from: comps)!
        let firstWeekdayIndex = (calendar.component(.weekday, from: firstOfMonth) + 5) % 7

        var result: [MonthDay] = []
        for _ in 0..<firstWeekdayIndex { result.append(MonthDay(number: nil, date: nil)) }
        for day in range {
            var dc = DateComponents()
            dc.year = comps.year; dc.month = comps.month; dc.day = day
            result.append(MonthDay(number: day, date: calendar.date(from: dc)))
        }
        while result.count % 7 != 0 { result.append(MonthDay(number: nil, date: nil)) }
        return result
    }
}

private struct DayCell: View {
    let day: MonthDay
    let isDone: Bool
    let isSelected: Bool
    let isToday: Bool

    var body: some View {
        VStack(spacing: 4) {
            if let n = day.number {
                ZStack {
                    if isToday && !isSelected {
                        Circle().stroke(AppTheme.orange.opacity(0.5), lineWidth: 1).frame(width: 28, height: 28)
                    }
                    if isSelected {
                        Circle().fill(AppTheme.orange.opacity(0.15)).frame(width: 28, height: 28)
                            .overlay(Circle().stroke(AppTheme.orange, lineWidth: 1.5))
                    }
                    Text("\(n)")
                        .font(.system(size: 14, weight: isToday ? .bold : .medium))
                        .foregroundStyle(isToday ? AppTheme.orange : AppTheme.textPrimary)
                }
                .frame(height: 30)

                ZStack {
                    if isDone {
                        Circle().fill(AppTheme.green).frame(width: 12, height: 12)
                        Image(systemName: "checkmark").font(.system(size: 7, weight: .bold)).foregroundStyle(.white)
                    } else {
                        Circle().fill(Color(red: 0.88, green: 0.86, blue: 0.84)).frame(width: 12, height: 12)
                    }
                }
                .shadow(color: isDone ? AppTheme.green.opacity(0.3) : .clear, radius: 2, y: 1)
            } else {
                Spacer().frame(height: 30)
                Spacer().frame(height: 12)
            }
        }
        .frame(height: 50)
        .frame(maxWidth: .infinity)
    }
}

private struct MonthDay: Identifiable {
    let id = UUID()
    let number: Int?
    let date: Date?
}

#Preview {
    Progress(habits: [
        Habit(name: "Reading", icon: "📚", amountPerDay: 1, targetDate: Date(), remindersOn: false, completed: 1),
        Habit(name: "Drinking water", icon: "💧", amountPerDay: 8, targetDate: Date(), remindersOn: false, completed: 5),
        Habit(name: "Running", icon: "🏃🏻‍♀️", amountPerDay: 1, targetDate: Date(), remindersOn: false, completed: 0),
    ])
}
