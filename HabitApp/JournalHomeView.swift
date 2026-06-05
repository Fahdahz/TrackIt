//
//  JournalHomeView.swift
//  HabitApp
//
//  Created by Fahdah Alsamari on 17/12/1447 AH.
//

import SwiftUI

struct JournalHomeView: View {

    @State private var entries: [JournalEntry] = []

    @State private var showAddJournal = false

    @State private var selectedHabit = "Reading"

    @State private var selectedDate: Date? = nil

    var body: some View {

        NavigationStack {

            ZStack {

                Color("BackgroundCream")
                    .ignoresSafeArea()

                VStack(spacing: 0) {

                    // MARK: Header

                    HStack {

                        Text("Your journals")
                            .font(.nyBold(30))
                            .foregroundColor(.black)

                        Spacer()

                        Button {

                            showAddJournal = true

                        } label: {

                            ZStack {

                                Circle()
                                    .fill(
                                        Color("BackgroundCream")
                                    )
                                    .frame(
                                        width: 64,
                                        height: 63
                                    )

                                    .overlay(

                                        Circle()
                                            .stroke(
                                                Color("PrimaryOrange")
                                                    .opacity(0.23),
                                                lineWidth: 1
                                            )
                                    )

                                    .overlay(

                                        Circle()
                                            .stroke(

                                                LinearGradient(
                                                    colors: [

                                                        Color("PrimaryOrange")
                                                            .opacity(0.65),

                                                        Color("PrimaryOrange")
                                                            .opacity(0.18),

                                                        Color("PrimaryOrange")
                                                            .opacity(0.08),

                                                        Color("PrimaryOrange")
                                                            .opacity(0.18)
                                                    ],
                                                    startPoint: .top,
                                                    endPoint: .bottom
                                                ),
                                                lineWidth: 2.2
                                            )
                                            .blur(radius: 0.6)
                                    )

                                    .shadow(
                                        color: Color("PrimaryOrange")
                                            .opacity(0.18),
                                        radius: 9,
                                        x: 0,
                                        y: 1
                                    )

                                Image(systemName: "plus")
                                    .font(
                                        .system(
                                            size: 32,
                                            weight: .bold
                                        )
                                    )
                                    .foregroundColor(
                                        Color("PrimaryOrange")
                                    )
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal)
                    .padding(.top)

                    // MARK: Empty State

                    if entries.isEmpty {

                        Spacer()

                        VStack(spacing: 12) {

                            Text("How are you feeling today?")
                                .font(.nyBold(28))

                            Text(
                                "Write about your progress. Small reflections can reveal big patterns."
                            )
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .frame(width: 260)
                        }

                        Spacer()

                    } else {

                        JournalListView(
                            entries: $entries,
                            selectedHabit: $selectedHabit,
                            selectedDate: $selectedDate
                        )
                    }

                    Spacer(minLength: 20)
                }
            }
            .sheet(isPresented: $showAddJournal) {

                AddJournalView(
                    entries: $entries
                )
            }
        }
    }
}

#Preview {
    JournalHomeView()
}
