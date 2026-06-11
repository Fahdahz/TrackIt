//
//  HabitApp.swift
//  HabitApp
//

import SwiftUI

@main
struct HabitApp: App {
    @StateObject private var store = HabitStore()

    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(store)
                .preferredColorScheme(.light)
        }
    }
}
