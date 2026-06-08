//
//  SplashView.swift
//  HabitApp
//

import SwiftUI

struct SplashView: View {
    @State private var showSplash = true
    @State private var showAddHabit = false
    @State private var habits: [Habit] = []
    @State private var goToMain = false

    // For new users — in a real app you'd persist this with @AppStorage
    // Set to true if user has never added a habit
    @AppStorage("isNewUser") private var isNewUser: Bool = true

    var body: some View {
        Group {
            if showSplash {
                SplashScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            withAnimation(.easeInOut(duration: 0.6)) {
                                showSplash = false
                            }
                        }
                    }
            } else if isNewUser && !goToMain {
                EmptyStateView {
                    showAddHabit = true
                }
                .transition(.opacity)
            } else {
                ContentView(initialHabits: habits)
                    .transition(.opacity)
            }
        }
        .sheet(isPresented: $showAddHabit) {
            AddHabitSheet { newHabit in
                habits.append(newHabit)
                isNewUser = false
                withAnimation(.easeInOut(duration: 0.5)) {
                    goToMain = true
                }
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.hidden)
        }
    }
}

// MARK: - Splash Screen

private struct SplashScreenView: View {

    @State private var iconScale: CGFloat = 0.4
    @State private var iconOpacity: Double = 0
    @State private var iconRotation: Double = -15
    @State private var pathProgress: CGFloat = 0
    @State private var smallDotOffset: CGFloat = 0
    @State private var nameOpacity: Double = 0
    @State private var nameOffset: CGFloat = 20

    var body: some View {
        ZStack {
            Color("BackgroundCream")
                .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                ZStack {
                    OrbitPath(progress: pathProgress)
                        .stroke(
                            Color("PrimaryOrange").opacity(0.25),
                            style: StrokeStyle(lineWidth: 1.5, dash: [4, 6])
                        )
                        .frame(width: 220, height: 120)

                    OrbitingDot(progress: pathProgress)
                        .frame(width: 220, height: 120)

                    Image("icon_track_it_")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 130, height: 130)
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        .shadow(color: Color("PrimaryOrange").opacity(0.3), radius: 20, y: 8)
                        .scaleEffect(iconScale)
                        .opacity(iconOpacity)
                        .rotationEffect(.degrees(iconRotation))
                }

                HStack(spacing: 0) {
                    Text("Track")
                        .font(.system(size: 38, weight: .bold, design: .serif))
                        .foregroundColor(Color(red: 0.18, green: 0.15, blue: 0.12))
                    Text("It")
                        .font(.system(size: 38, weight: .bold, design: .serif))
                        .foregroundColor(Color("PrimaryOrange"))
                }
                .opacity(nameOpacity)
                .offset(y: nameOffset)

                Spacer()
            }
        }
        .onAppear { startAnimations() }
    }

    private func startAnimations() {
        withAnimation(.spring(response: 0.7, dampingFraction: 0.6).delay(0.2)) {
            iconScale = 1.0
            iconOpacity = 1.0
            iconRotation = 0
        }
        withAnimation(.easeInOut(duration: 1.8).delay(0.5)) {
            pathProgress = 1.0
        }
        withAnimation(.easeInOut(duration: 2.0).delay(0.6)) {
            smallDotOffset = 1.0
        }
        withAnimation(.easeOut(duration: 0.7).delay(1.6)) {
            nameOpacity = 1.0
            nameOffset = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                iconScale = 1.05
            }
        }
    }
}

// MARK: - Orbit Path

private struct OrbitPath: Shape {
    var progress: CGFloat
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    func path(in rect: CGRect) -> Path {
        Path { p in p.addEllipse(in: rect) }.trimmedPath(from: 0, to: progress)
    }
}

// MARK: - Orbiting Dot

private struct OrbitingDot: View {
    var progress: CGFloat
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let angle = progress * 2 * .pi - .pi / 2
            let x = w / 2 + (w / 2) * cos(angle)
            let y = h / 2 + (h / 2) * sin(angle)
            Circle()
                .fill(Color("PrimaryOrange"))
                .frame(width: 10, height: 10)
                .position(x: x, y: y)
                .opacity(progress > 0.05 ? 1 : 0)
        }
    }
}

#Preview {
    SplashView()
}
