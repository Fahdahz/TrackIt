//
//  CustomTabBar.swift
//  HabitApp
//
//  Created by Fahdah Alsamari on 17/12/1447 AH.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedIndex: Int

    var body: some View {
        HStack {
            Spacer()

            Button {
                withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                    selectedIndex = 0
                }
            } label: {
                VStack(spacing: 4) {
                    Image(systemName: selectedIndex == 0 ? "house.fill" : "house")
                        .font(.system(size: 20))
                        .foregroundStyle(selectedIndex == 0 ? Color("PrimaryOrange") : Color.gray.opacity(0.55))
                    Text("Home")
                        .font(.system(size: 11))
                        .foregroundStyle(selectedIndex == 0 ? Color("PrimaryOrange") : Color.gray.opacity(0.55))
                }
            }

            Spacer()

            Button {
                withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                    selectedIndex = 1
                }
            } label: {
                VStack(spacing: 4) {
                    Image(systemName: selectedIndex == 1 ? "chart.bar.fill" : "chart.bar")
                        .font(.system(size: 20))
                        .foregroundStyle(selectedIndex == 1 ? Color("PrimaryOrange") : Color.gray.opacity(0.55))
                    Text("Progress")
                        .font(.system(size: 11))
                        .foregroundStyle(selectedIndex == 1 ? Color("PrimaryOrange") : Color.gray.opacity(0.55))
                }
            }

            Spacer()

            Button {
                withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                    selectedIndex = 2
                }
            } label: {
                VStack(spacing: 4) {
                    Image(systemName: selectedIndex == 2 ? "book.closed.fill" : "book.closed")
                        .font(.system(size: 20))
                        .foregroundStyle(selectedIndex == 2 ? Color("PrimaryOrange") : Color.gray.opacity(0.55))
                    Text("Journals")
                        .font(.system(size: 11))
                        .foregroundStyle(selectedIndex == 2 ? Color("PrimaryOrange") : Color.gray.opacity(0.55))
                }
            }

            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .padding()
    }
}
