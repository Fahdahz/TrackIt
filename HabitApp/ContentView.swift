//
//  ContentView.swift
//  HabitApp
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: HabitStore
    @State private var openedMenuID: UUID? = nil
    @State private var selectedCard = 0
    @State private var showAddHabit = false
    @State private var editingHabit: Habit? = nil
    @State private var selectedTab = 0

    var body: some View {
        ZStack {
            // Tab content
            Group {
                if selectedTab == 0 {
                    homeView
                } else if selectedTab == 1 {
                    Progress(habits: store.habits)
                } else {
                    JournalHomeView(habits: store.habits)
                }
            }

            // Dim + menu overlay
            if openedMenuID != nil {
                Color.black.opacity(0.12)
                    .ignoresSafeArea()
                    .onTapGesture { openedMenuID = nil }

                if let id = openedMenuID {
                    HabitMenu(
                        onFreeze: {
                            store.toggleFreeze(id: id)
                            openedMenuID = nil
                        },
                        onEdit: {
                            editingHabit = store.habits.first(where: { $0.id == id })
                            openedMenuID = nil
                        },
                        onDelete: {
                            store.delete(id: id)
                            if selectedCard >= store.habits.count {
                                selectedCard = max(0, store.habits.count - 1)
                            }
                            openedMenuID = nil
                        },
                        isFrozen: store.habits.first(where: { $0.id == id })?.isFrozen ?? false
                    )
                }
            }

            // Tab bar
            VStack {
                Spacer()
                CustomTabBar(selectedIndex: $selectedTab)
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .sheet(isPresented: $showAddHabit) {
            AddHabitSheet { newHabit in
                store.add(newHabit)
                selectedCard = store.habits.count - 1
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.hidden)
        }
        .sheet(item: $editingHabit) { habit in
            AddHabitSheet(editingHabit: habit) { updated in
                store.update(updated)
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.hidden)
        }
    }

    // MARK: - Home View
    var homeView: some View {
        ZStack(alignment: .topLeading) {
            Color("BackgroundCream").ignoresSafeArea()

            VStack(alignment: .leading, spacing: 8) {
                Text("DAILY HABITS")
                    .font(.system(size: 16, weight: .regular, design: .serif))
                    .foregroundColor(Color("PrimaryOrange"))
                Text("KEEP GOING!🔥")
                    .font(.system(size: 25, weight: .bold, design: .serif))
                    .foregroundColor(.black)
            }
            .padding(.top, 25)
            .padding(.leading, 28)
            .blur(radius: openedMenuID == nil ? 0 : 6)

            VStack {
                HStack {
                    Spacer()
                    Button { showAddHabit = true } label: {
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
                }
                Spacer()
            }
            .padding(.top, 32)
            .padding(.trailing, 28)
            .blur(radius: openedMenuID == nil ? 0 : 6)

            VStack {
                Spacer().frame(height: 250)
                if store.habits.isEmpty {
                    Text("No habits yet!\nTap + to add one.")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 18, weight: .medium, design: .serif))
                        .foregroundColor(Color("PrimaryOrange").opacity(0.6))
                        .frame(maxWidth: .infinity)
                } else {
                    HabitCarousel(
                        habits: $store.habits,
                        selectedCard: $selectedCard,
                        openedMenuID: $openedMenuID,
                        onIncrement: { id in store.incrementCompleted(id: id) }
                    )
                    .blur(radius: openedMenuID == nil ? 0 : 6)
                }
            }
        }
    }
}

// MARK: - Carousel

struct HabitCarousel: View {
    @Binding var habits: [Habit]
    @Binding var selectedCard: Int
    @Binding var openedMenuID: UUID?
    var onIncrement: (UUID) -> Void

    var body: some View {
        VStack(spacing: 22) {
            GeometryReader { geo in
                ZStack {
                    ForEach(Array(habits.enumerated()), id: \.element.id) { index, _ in
                        carouselCard(index: index)
                    }
                }
                .frame(width: geo.size.width, height: 360)
                .gesture(
                    DragGesture().onEnded { value in
                        if value.translation.width < -40 && selectedCard < habits.count - 1 {
                            withAnimation(.easeInOut(duration: 0.25)) { selectedCard += 1 }
                        }
                        if value.translation.width > 40 && selectedCard > 0 {
                            withAnimation(.easeInOut(duration: 0.25)) { selectedCard -= 1 }
                        }
                    }
                )
            }
            .frame(height: 360)

            HStack(spacing: 14) {
                ForEach(0..<habits.count, id: \.self) { i in
                    Circle()
                        .fill(selectedCard == i ? Color.black : Color.gray.opacity(0.55))
                        .frame(width: 12, height: 12)
                }
            }
        }
    }

    func carouselCard(index: Int) -> some View {
        let isSelected = selectedCard == index
        let cardGap: CGFloat = 30
        let selectedWidth: CGFloat = 250
        let smallWidth: CGFloat = 120
        let xOffset = CGFloat(index - selectedCard) * ((selectedWidth / 2) + (smallWidth / 2) + cardGap)

        return HabitCard(
            habit: $habits[index],
            isSelected: isSelected,
            onMenuTap: { openedMenuID = habits[index].id }
        )
        .frame(width: isSelected ? 250 : 120, height: isSelected ? 330 : 300)
        .offset(x: xOffset, y: isSelected ? -8 : 12)
        .zIndex(isSelected ? 2 : 1)
        .animation(.easeInOut(duration: 0.25), value: selectedCard)
        .onTapGesture {
            if isSelected {
                onIncrement(habits[index].id)
            } else {
                withAnimation(.easeInOut(duration: 0.25)) { selectedCard = index }
            }
        }
    }
}

// MARK: - Habit Card

struct HabitCard: View {
    @Binding var habit: Habit
    let isSelected: Bool
    let onMenuTap: () -> Void

    var progress: Double {
        guard habit.amountPerDay > 0 else { return 0 }
        return Double(habit.completed) / Double(habit.amountPerDay)
    }
    var isCompleted: Bool { habit.completed >= habit.amountPerDay }

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: { if isSelected { onMenuTap() } }) {
                    Text("•••")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.gray)
                        .padding(.trailing, 14)
                        .padding(.top, 12)
                }
                .disabled(!isSelected)
            }

            Text(habit.name)
                .font(.system(size: 20, weight: .bold, design: .serif))
                .foregroundColor(habit.isFrozen ? .gray : .black)
                .padding(.top, 2)
                .lineLimit(1)

            Spacer().frame(height: 36)

            ZStack {
                Circle().stroke(Color.gray.opacity(0.20), lineWidth: 4).frame(width: 95, height: 95)
                Circle()
                    .trim(from: 0, to: habit.isFrozen ? 0 : progress)
                    .stroke(Color("PrimaryOrange"), style: StrokeStyle(lineWidth: 4, lineCap: .butt))
                    .frame(width: 95, height: 95)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut(duration: 0.3), value: progress)
                if habit.isFrozen {
                    Text("❄️").font(.system(size: 36))
                } else {
                    Text(habit.icon).font(.system(size: 36))
                }
            }

            Spacer().frame(height: 28)

            if habit.isFrozen {
                Text("Frozen")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.gray)
                    .padding(.top, 8)
            } else if isCompleted {
                Text("Completed")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.top, 18)
            } else {
                Circle()
                    .fill(habit.completed > 0 ? Color("PrimaryOrange") : Color.clear)
                    .frame(width: 50, height: 50)
                    .overlay(Circle().stroke(Color("PrimaryOrange"), lineWidth: 2))
                    .overlay(Group {
                        if habit.completed > 0 {
                            Image(systemName: "checkmark")
                                .font(.system(size: 26, weight: .regular))
                                .foregroundColor(.white)
                        }
                    })
                Text("\(habit.completed) out of \(habit.amountPerDay)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.top, 8)
            }
            Spacer()
        }
        .background(Color(red: 255/255, green: 254/255, blue: 248/255))
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black.opacity(0.08), lineWidth: 0.8))
        .shadow(color: Color.black.opacity(0.12), radius: 14, x: 5, y: 6)
        .opacity(habit.isFrozen ? 0.75 : 1)
        .clipped()
    }
}

// MARK: - Habit Menu

struct HabitMenu: View {
    let onFreeze: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    let isFrozen: Bool

    var body: some View {
        VStack(spacing: 0) {
            MenuRow(title: isFrozen ? "Unfreeze" : "Freeze", icon: "snowflake", color: .black, action: onFreeze)
            Divider()
            MenuRow(title: "Edit", icon: "pencil", color: .black, action: onEdit)
            Divider()
            MenuRow(title: "Delete", icon: "trash", color: .red, action: onDelete)
        }
        .frame(width: 230)
        .background(.ultraThinMaterial)
        .cornerRadius(22)
        .shadow(color: .black.opacity(0.12), radius: 18, x: 0, y: 8)
    }
}

struct MenuRow: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title).font(.system(size: 20, weight: .regular)).foregroundColor(color)
                Spacer()
                Image(systemName: icon).font(.system(size: 20, weight: .regular)).foregroundColor(color)
            }
            .padding(.horizontal, 24)
            .frame(height: 56)
        }
    }
}

#Preview {
    ContentView().environmentObject(HabitStore())
}
