//
//  Achievementview.swift
//  HabitApp
//
//  Created by rawan alkhaldi  on 23/12/1447 AH.
//

//
//  AchievementView.swift
//  HabitApp
//

import SwiftUI

struct AchievementView: View {
    let habit: Habit
    @Environment(\.dismiss) private var dismiss

    let brandOrange = Color("PrimaryOrange")
    let bg          = Color("BackgroundCream")
    let ink         = Color(red: 0.18, green: 0.15, blue: 0.12)
    let muted       = Color(red: 0.45, green: 0.41, blue: 0.37)

    private var daysDiff: Int {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: Date())
        let end   = calendar.startOfDay(for: habit.targetDate)
        return max(0, calendar.dateComponents([.day], from: start, to: end).day ?? 0)
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            bg.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer().frame(height: 60)

                // Trophy + confetti area
                ZStack {
                    Circle()
                        .fill(brandOrange.opacity(0.08))
                        .frame(width: 180, height: 180)

                    Circle()
                        .fill(brandOrange.opacity(0.13))
                        .frame(width: 130, height: 130)

                    VStack(spacing: 6) {
                        Text("🏆")
                            .font(.system(size: 64))
                        Text(habit.icon)
                            .font(.system(size: 28))
                    }
                }
                .padding(.bottom, 28)

                // Habit name
                Text(habit.name)
                    .font(.system(size: 30, weight: .bold, design: .serif))
                    .foregroundColor(ink)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Text("COMPLETED!")
                    .font(.system(size: 14, weight: .black))
                    .foregroundColor(brandOrange)
                    .kerning(3)
                    .padding(.top, 6)

                Spacer().frame(height: 40)

                // Stats row
                HStack(spacing: 0) {
                    StatBlock(value: "\(habit.amountPerDay)", label: "Daily goal", orange: brandOrange, ink: ink, muted: muted)
                    Divider().frame(height: 50)
                    StatBlock(value: "\(habit.completed)", label: "Completed", orange: brandOrange, ink: ink, muted: muted)
                    Divider().frame(height: 50)
                    StatBlock(value: daysDiff == 0 ? "🎯" : "\(daysDiff)d", label: daysDiff == 0 ? "Goal met!" : "Days left", orange: brandOrange, ink: ink, muted: muted)
                }
                .padding(.vertical, 20)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(.white)
                        .shadow(color: .black.opacity(0.07), radius: 10, y: 4)
                )
                .padding(.horizontal, 28)

                Spacer().frame(height: 32)

                // Message
                Text("You built a great habit.\nKeep the streak going! 🔥")
                    .font(.system(size: 16))
                    .foregroundColor(muted)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Spacer()

                // Done button
                Button { dismiss() } label: {
                    Text("Done")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 50, style: .continuous)
                                .fill(brandOrange)
                        )
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 40)
            }

            // Close button
            Button { dismiss() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(ink.opacity(0.5))
                    .padding(10)
                    .background(Circle().fill(Color.black.opacity(0.06)))
            }
            .padding(.top, 16)
            .padding(.trailing, 20)
        }
    }
}

private struct StatBlock: View {
    let value: String
    let label: String
    let orange: Color
    let ink: Color
    let muted: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(orange)
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(muted)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    AchievementView(habit: Habit(
        name: "Reading",
        icon: "📚",
        amountPerDay: 1,
        targetDate: Date(),
        remindersOn: false,
        completed: 1
    ))
}
