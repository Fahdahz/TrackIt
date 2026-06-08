//
//  EmptyStateView.swift
//  HabitApp
//

import SwiftUI

struct EmptyStateView: View {
    var onAddHabit: () -> Void

    let orange = Color(red: 0.949, green: 0.553, blue: 0.373)
    let bg     = Color(red: 0.992, green: 0.973, blue: 0.961)
    let ink    = Color(red: 0.11,  green: 0.10,  blue: 0.09)
    let muted  = Color(red: 0.55,  green: 0.51,  blue: 0.47)

    var body: some View {
        ZStack(alignment: .bottom) {
            bg.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                Text("DAILY HABIT")
                    .font(.system(size: 28, weight: .black))
                    .foregroundColor(ink)
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .padding(.bottom, 8)

                emptyState
            }

            addButton
                .padding(.bottom, 36)
        }
        .ignoresSafeArea(edges: .bottom)
    }

    // MARK: - Empty State

    var emptyState: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {

                ZStack {
                    DemoCard(title: "Meditation", emoji: "🧘‍♀️",
                             progress: 0, badge: .count("0 out of 1"))
                        .rotationEffect(.degrees(-14))
                        .offset(x: -110, y: 18)
                        .zIndex(1)

                    DemoCard(title: "Drinking water", emoji: "💧",
                             progress: 0.75, badge: .check)
                        .rotationEffect(.degrees(4))
                        .offset(x: 0, y: -26)
                        .zIndex(3)

                    DemoCard(title: "Reading", emoji: "📚",
                             progress: 1.0, badge: .label("Completed"))
                        .rotationEffect(.degrees(3))
                        .offset(x: 110, y: -14)
                        .zIndex(2)

                    AddDemoCard()
                        .rotationEffect(.degrees(-3))
                        .offset(x: 8, y: 130)
                        .zIndex(4)
                }
                .frame(width: geo.size.width, height: geo.size.height * 0.58)
                .padding(.top, 12)

                VStack(spacing: 8) {
                    Text("No habits yet!")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(ink)

                    Text("Each card represents a habit. Add yours!")
                        .font(.system(size: 14))
                        .foregroundColor(muted)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 20)

                Spacer()
            }
        }
    }

    // MARK: - Add Button

    var addButton: some View {
        Button(action: onAddHabit) {
            HStack(spacing: 6) {
                Text("Add First Habit")
                    .font(.system(size: 17, weight: .medium))
                Text("+")
                    .font(.system(size: 20, weight: .medium))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(orange)
            .clipShape(Capsule())
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - Demo Card Badge

enum DemoBadge {
    case check
    case count(String)
    case label(String)
}

// MARK: - Demo Card

struct DemoCard: View {
    let title: String
    let emoji: String
    let progress: Double
    let badge: DemoBadge

    let orange = Color(red: 0.949, green: 0.553, blue: 0.373)
    let ink    = Color(red: 0.11,  green: 0.10,  blue: 0.09)
    let muted  = Color(red: 0.55,  green: 0.51,  blue: 0.47)

    var body: some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(ink)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            ZStack {
                Circle()
                    .stroke(orange.opacity(0.2), lineWidth: 4.5)
                    .frame(width: 72, height: 72)

                if progress > 0 {
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(orange, style: StrokeStyle(lineWidth: 4.5, lineCap: .round))
                        .frame(width: 72, height: 72)
                        .rotationEffect(.degrees(-90))
                }

                Text(emoji).font(.system(size: 32))
            }

            badgeView
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 16)
        .frame(width: 130, height: 180)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.07), radius: 10, x: 0, y: 4)
    }

    @ViewBuilder
    var badgeView: some View {
        switch badge {
        case .check:
            ZStack {
                Circle().fill(orange).frame(width: 32, height: 32)
                Image(systemName: "checkmark")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)
            }
        case .count(let text):
            VStack(spacing: 4) {
                Circle()
                    .stroke(orange.opacity(0.35), lineWidth: 1.5)
                    .frame(width: 32, height: 32)
                Text(text)
                    .font(.system(size: 11))
                    .foregroundColor(muted)
            }
        case .label(let text):
            Text(text)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(ink)
        }
    }
}

// MARK: - Add Demo Card

struct AddDemoCard: View {
    let orange = Color(red: 0.949, green: 0.553, blue: 0.373)
    let ink    = Color(red: 0.11,  green: 0.10,  blue: 0.09)

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .stroke(orange.opacity(0.5), lineWidth: 2)
                    .frame(width: 72, height: 72)
                Image(systemName: "plus")
                    .font(.system(size: 26, weight: .medium))
                    .foregroundColor(orange)
            }
            Text("Add new habit!")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(ink)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 16)
        .frame(width: 130, height: 180)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.07), radius: 10, x: 0, y: 4)
    }
}

#Preview {
    EmptyStateView(onAddHabit: {})
}
