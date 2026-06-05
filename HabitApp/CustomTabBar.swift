//
//  CustomTabBar.swift
//  HabitApp
//
//  Created by Fahdah Alsamari on 17/12/1447 AH.
//

import SwiftUI

struct CustomTabBar: View {

    var body: some View {

        HStack {

            Spacer()

            VStack {

                Image(systemName: "house.fill")
                Text("Home")
            }

            Spacer()

            VStack {

                Image(systemName: "chart.bar.fill")
                Text("Progress")
            }

            Spacer()

            VStack {

                Image(systemName: "book.closed")
                Text("Journals")
            }

            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .padding()
    }
}
