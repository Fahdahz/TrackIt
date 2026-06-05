//
//  HabitChip.swift
//  HabitApp
//
//  Created by Fahdah Alsamari on 17/12/1447 AH.
//

import SwiftUI

struct HabitChip: View {

    let title: String

    var selected = false

    var body: some View {

        Text(title)

            .font(.caption)

            .foregroundStyle(
                selected
                ? .white
                : .orange
            )

            .padding(.horizontal, 20)
            .padding(.vertical, 10)

            .background(
                selected
                ? Color.orange
                : Color.clear
            )

            .overlay {

                Capsule()
                    .stroke(Color.orange)
            }

            .clipShape(Capsule())
    }
}
