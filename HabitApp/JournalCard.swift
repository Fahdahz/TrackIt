//
//  JournalCard.swift
//  HabitApp
//
//  Created by Fahdah Alsamari on 30/11/1447 AH.
//

import SwiftUI

struct JournalCard: View {

    var title: String
    var date: String
    var text: String
    var moodImage: String

    var body: some View {

        VStack(alignment: .leading, spacing: 18) {

            // MARK: - TOP ROW

            HStack(alignment: .top) {

                Text(title)
                    .font(
                        .system(
                            size: 22,
                            weight: .bold,
                            design: .serif
                        )
                    )

                Spacer()

                Text(date)
                    .font(.system(size: 17, weight: .semibold))
            }

            // MARK: - JOURNAL TEXT

            Text(text)
                .font(.system(size: 17))
                .lineSpacing(5)

            // MARK: - MOOD ROW

            HStack(spacing: 8) {

                Spacer()

                Text("Feeling")
                    .font(
                        .system(
                            size: 18,
                            weight: .bold,
                            design: .serif
                        )
                    )

                Image(moodImage)
                    .resizable()
                    .frame(width: 34, height: 34)

                Text("This Day!")
                    .font(
                        .system(
                            size: 18,
                            weight: .bold,
                            design: .serif
                        )
                    )

                Spacer()
            }
            .padding(.top, 4)

        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(
                    Color("CardBorder"),
                    lineWidth: 1.5
                )
        )
    }
}

#Preview {
    JournalCard(
        title: "Building Better Habits",
        date: "10 May 2026",
        text: "Sample journal text.",
        moodImage: "happy"
    )
}
