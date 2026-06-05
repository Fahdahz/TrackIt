//
//  MoodPicker.swift
//  HabitApp
//
//  Created by Fahdah Alsamari on 17/12/1447 AH.
//

import SwiftUI

struct MoodPicker: View {

    @Binding var selectedMood: Mood

    var body: some View {

        HStack(spacing: 12) {

            ForEach(Mood.allCases, id: \.self) { mood in

                VStack(spacing: 6) {

                    Image(mood.rawValue)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 55, height: 55)
                        .scaleEffect(selectedMood == mood ? 1.1 : 1.0)

                    Text(mood.rawValue.capitalized)
                        .font(.caption)
                        .foregroundColor(.black)
                }
                .onTapGesture {
                    selectedMood = mood
                }
            }
        }
    }
}
