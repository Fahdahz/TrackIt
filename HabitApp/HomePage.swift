//
//  HomePage.swift
//  HabitApp
//
//  Created by Fahdah Alsamari on 30/11/1447 AH.
//

import SwiftUI

struct HomePage: View {

    var body: some View {

        VStack(alignment: .leading, spacing: 16) {

            HStack {

                Text("Journal")
                    .font(
                        .system(
                            size: 24,
                            weight: .semibold,
                            design: .serif
                        )
                    )
                    .bold()

                Spacer()

                Button(action: {

                }) {

                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color("PrimaryBlue"))
                        .clipShape(Circle())
                }
            }

            Text("Today's Journal")
                .font(
                    .system(
                        size: 22,
                        weight: .semibold,
                        design: .serif
                    )
                )
                .bold()

            VStack(alignment: .leading, spacing: 14) {

                HStack {

                    Text("Building Better Habits")
                        .font(
                            .system(
                                size: 20,
                                weight: .semibold,
                                design: .serif
                            )
                        )
                        .bold()

                    Spacer()

                    Text("10 May 2026")
                        .font(.headline)
                }

                Text("""
I stayed consistent with my habits today, even when I didn’t feel fully motivated. Small progress is still progress.
""")
                .font(.body)

                HStack(spacing: 8) {

                    Text("Feeling")

                    Image("happy")
                        .resizable()
                        .frame(width: 35, height: 35)

                    Text("This Day!")
                }
                .font(.headline)
                .frame(maxWidth: .infinity)

            }
            .padding()
            .background(Color.white)
            .cornerRadius(18)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 2)
            )

        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    HomePage()
}
