//
//  MoodView.swift
//  HabitApp
//
//  Created by Fahdah Alsamari on 30/11/1447 AH.
//

import SwiftUI

struct MoodView: View {

    var image: String
    var title: String
    var isSelected: Bool

    var body: some View {

        VStack(spacing: 10) {

            Image(image)
                .resizable()
                .frame(width: 62, height: 62)
                .scaleEffect(isSelected ? 1.08 : 1.0)

            Text(title)
                .font(.system(size: 16, weight: .semibold, design: .serif))
        }
        .padding(6)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    isSelected
                    ? Color.white.opacity(0.7)
                    : Color.clear
                )
        )
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    MoodView(
        image: "happy",
        title: "Happy",
        isSelected: true
    )
}
