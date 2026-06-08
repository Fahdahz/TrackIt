import SwiftUI

struct Progress: View {
    var body: some View {
        MainTabScaffold()
    }
}

// MARK: - Scaffold

private struct MainTabScaffold: View {
    @State private var selectedTab: Int = 1

    var body: some View {
        TrackProgressView()
            .safeAreaInset(edge: .bottom) {
                CustomTabBar(selectedIndex: $selectedTab)
                    .background(.clear)
            }
            .background(AppTheme.bg.ignoresSafeArea())
    }
}

// MARK: - Main View

private struct TrackProgressView: View {
    @State private var selectedFilter: String = "Drinking water"
    @State private var currentMonth: Date = .now

    private let filters = ["Drinking water", "Running", "Reading"]

    // Sample completion data per habit: Set of day numbers completed this month
    private let completionData: [String: Set<Int>] = [
        "Drinking water": [1, 2, 3, 4, 5, 6, 7],
        "Running":        [1, 3, 5, 7],
        "Reading":        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
                           11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
                           21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
    ]

    private var completedDays: Set<Int> {
        completionData[selectedFilter] ?? []
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {

                // Title
                Text("Track Your Progress")
                    .font(.system(size: 28, weight: .semibold, design: .serif))
                    .foregroundStyle(AppTheme.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 16)

                // Summary Cards
                GeometryReader { proxy in
                    let spacing: CGFloat = 12
                    let totalWidth = proxy.size.width
                    let columnWidth = (totalWidth - spacing) / 2

                    HStack(alignment: .top, spacing: spacing) {
                        CompletedCard()
                            .frame(width: columnWidth)

                        VStack(spacing: spacing) {
                            MostConsistentCard()
                                .frame(maxWidth: .infinity)
                                .frame(maxHeight: .infinity)
                            NeedsAttentionCard()
                                .frame(maxWidth: .infinity)
                                .frame(maxHeight: .infinity)
                        }
                        .frame(width: columnWidth)
                    }
                    .frame(width: totalWidth, alignment: .topLeading)
                }
                .frame(height: 210)
                .padding(.bottom, 4)

                // Filter Chips
                FilterChipsView(filters: filters, selected: $selectedFilter)

                // Calendar
                CalendarContainer(
                    currentMonth: $currentMonth,
                    completedDays: completedDays
                )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .background(AppTheme.bg)
    }
}

// MARK: - Cards

private struct CompletedCard: View {
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
                Text("📚")
                    .font(.system(size: 18))
                Text("Reading")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(AppTheme.textPrimary)
                Spacer(minLength: 0)
            }

            Text("30 days . Goal reached")
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(AppTheme.textSecondary)

            Button {
                // Action
            } label: {
                Text("View achievment")
                    .font(.system(size: 14, weight: .semibold))
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

private struct MostConsistentCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("MOST CONSISTENT")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(AppTheme.grey)

            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text("💧")
                    .font(.system(size: 16))
                Text("Drinking water")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppTheme.textPrimary)
                Spacer()
            }

            Text("14 days streak")
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
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("NEEDS ATTENTION")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(AppTheme.grey)

            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text("🏃🏻‍♂️")
                    .font(.system(size: 16))
                Text("Running")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppTheme.textPrimary)
                Spacer()
            }

            Text("missed 3 days")
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
                    Button {
                        selected = item
                    } label: {
                        Text(item)
                            .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                            .foregroundStyle(isSelected ? .white : AppTheme.textSecondary)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 9)
                            .background(
                                Capsule()
                                    .fill(isSelected ? AppTheme.orange : .white)
                            )
                            .overlay(
                                Capsule()
                                    .stroke(isSelected ? AppTheme.orange : AppTheme.orange.opacity(0.4), lineWidth: 1.5)
                            )
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
            // Month header
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

            // Weekday headers
            HStack {
                ForEach(["MON","TUE","WED","THU","FRI","SAT","SUN"], id: \.self) { weekday in
                    Text(weekday)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(AppTheme.textSecondary)
                        .frame(maxWidth: .infinity)
                }
            }

            // Grid
            CalendarGrid(
                currentMonth: currentMonth,
                completedDays: completedDays,
                selectedDate: $selectedDate
            )
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
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7),
            spacing: 6
        ) {
            ForEach(days, id: \.id) { day in
                DayCell(
                    day: day,
                    isDone: day.number.map { completedDays.contains($0) } ?? false,
                    isSelected: isSelected(day),
                    isToday: isToday(day)
                )
                .onTapGesture {
                    guard let date = day.date else { return }
                    withAnimation(.easeInOut(duration: 0.15)) {
                        selectedDate = date
                    }
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
        for _ in 0..<firstWeekdayIndex {
            result.append(MonthDay(number: nil, date: nil))
        }
        for day in range {
            var dc = DateComponents()
            dc.year = comps.year
            dc.month = comps.month
            dc.day = day
            result.append(MonthDay(number: day, date: calendar.date(from: dc)))
        }
        while result.count % 7 != 0 {
            result.append(MonthDay(number: nil, date: nil))
        }
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
                // Day number
                ZStack {
                    if isToday && !isSelected {
                        Circle()
                            .stroke(AppTheme.orange.opacity(0.5), lineWidth: 1)
                            .frame(width: 28, height: 28)
                    }
                    if isSelected {
                        Circle()
                            .fill(AppTheme.orange.opacity(0.15))
                            .frame(width: 28, height: 28)
                            .overlay(Circle().stroke(AppTheme.orange, lineWidth: 1.5))
                    }
                    Text("\(n)")
                        .font(.system(size: 14, weight: isToday ? .bold : .medium))
                        .foregroundStyle(isToday ? AppTheme.orange : AppTheme.textPrimary)
                }
                .frame(height: 30)

                // Completion indicator
                ZStack {
                    if isDone {
                        Circle()
                            .fill(AppTheme.green)
                            .frame(width: 12, height: 12)
                        Image(systemName: "checkmark")
                            .font(.system(size: 7, weight: .bold))
                            .foregroundStyle(.white)
                    } else {
                        Circle()
                            .fill(Color(red: 0.88, green: 0.86, blue: 0.84))
                            .frame(width: 12, height: 12)
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

// MARK: - Models

private struct MonthDay: Identifiable {
    let id = UUID()
    let number: Int?
    let date: Date?
}

#Preview {
    Progress()
}
