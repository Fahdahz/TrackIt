//
//  WriteJournalView.swift
//  HabitApp
//
//  Created by Fahdah Alsamari on 30/11/1447 AH.
//

import SwiftUI

struct WriteJournalView: View {

    // MARK: - STATES

    @State private var title = ""
    @State private var text = ""

    @State private var selectedMood = "happy"

    @State private var selectedDate = Date()

    // MARK: - BODY

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(alignment: .leading, spacing: 22) {

                    // MARK: - TITLE

                    Text("Write your Journal")
                        .font(
                            .system(
                                size: 28,
                                weight: .semibold,
                                design: .serif
                            )
                        )
                        .padding(.top, 10)
                        .padding(.horizontal,45)

                    // MARK: - MOOD TITLE

                    Text("How are you Feeling Today?")
                        .font(
                            .system(
                                size: 20,
                                weight: .semibold,
                                design: .serif
                            )
                        )
                        .padding(.horizontal,45)


                    // MARK: - MOOD SECTION

                    HStack(spacing: 18) {

                        moodButton(
                            image: "angry",
                            title: "Angry"
                        )

                        moodButton(
                            image: "sad",
                            title: "Sad"
                        )

                        moodButton(
                            image: "stressed",
                            title: "Stress"
                        )

                        moodButton(
                            image: "neutral",
                            title: "Neutral"
                        )

                        moodButton(
                            image: "happy",
                            title: "Happy"
                        )
                    }
                    .frame(maxWidth: .infinity)

                    // MARK: - WRITE HEADER

                    
                    Spacer()
                    HStack {

                        Text("Write it out")
                            .font(
                                .system(
                                    size: 20,
                                    weight: .semibold,
                                    design: .serif
                                )
                            )
                            .padding(.top, -10)
                            .padding(.bottom, -15)

                        Spacer()

                        DatePicker(
                            "",
                            selection: $selectedDate,
                            displayedComponents: .date
                        )
                        .labelsHidden()
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .cornerRadius(14)
                    }

                    // MARK: - JOURNAL BOX

                    VStack(alignment: .leading, spacing: 14) {

                        TextField(
                            "Title",
                            text: $title
                        )
                        .font(
                            .system(
                                size: 22,
                                weight: .semibold,
                                design: .serif
                            )
                        )

                        Divider()

                        TextEditor(text: $text)
                            .font(.system(size: 17))
                            .frame(height: 260)
                            .scrollContentBackground(.hidden)
                    }
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(
                                Color("CardBorder"),
                                lineWidth: 8.5
                            )
                    )

                    // MARK: - DONE BUTTON

                    Button(action: {

                    }) {

                        Text("Done")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color("PrimaryBlue"))
                            .cornerRadius(30)
                    }
                    .padding(.top, 10)

                }
                .padding(.horizontal, 24)
                .padding(.bottom, 80)
            }
            .background(Color("BackgroundCream"))
            .navigationBarHidden(true)
        }
    }

    // MARK: - MOOD BUTTON

    @ViewBuilder
    func moodButton(
        image: String,
        title: String
    ) -> some View {

        VStack(spacing: 10) {

            Image(image)
                .resizable()
                .frame(width: 64, height: 64)
                .scaleEffect(
                    selectedMood == image
                    ? 1.08
                    : 1.0
                )

            Text(title)
                .font(
                    .system(
                        size: 16,
                        weight: .semibold,
                        design: .serif
                    )
                )
        }
        .padding(-5)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(
                    selectedMood == image
                    ? Color.white.opacity(0.9)
                    : Color.clear
                )
        )
        .animation(
            .easeInOut(duration: 0.2),
            value: selectedMood
        )
        .onTapGesture {

            UIImpactFeedbackGenerator(
                style: .light
            ).impactOccurred()

            selectedMood = image
        }
    }
}

#Preview {
    WriteJournalView()
}
