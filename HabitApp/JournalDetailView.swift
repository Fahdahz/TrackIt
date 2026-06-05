//
//  JournalDetailView.swift
//  HabitApp
//
//  Created by Fahdah Alsamari on 17/12/1447 AH.
//

import SwiftUI

struct JournalDetailView: View {

    let entry: JournalEntry

    var body: some View {

        ZStack {

            Color(
                red: 0.96,
                green: 0.94,
                blue: 0.92
            )
            .ignoresSafeArea()

            VStack(alignment: .leading) {

                HStack {

                    Spacer()

                    Text(
                        entry.date.formatted(
                            date: .abbreviated,
                            time: .omitted
                        )
                    )
                    .padding(8)
                    .background(
                        Color.gray.opacity(0.15)
                    )
                    .cornerRadius(8)
                }

                Text("I feel today...")
                    .foregroundStyle(.orange)

                Text(entry.text)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
                    .background(
                        Color.orange.opacity(0.08)
                    )
                    .cornerRadius(20)

                Spacer()
            }
            .padding()
        }
    }
}
