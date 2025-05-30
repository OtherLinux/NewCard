//
//  NewCardApp.swift
//  NewCard
//
//  Created by Marek Polame on 30.05.2025.
//

import SwiftUI
import SwiftData

@main
struct NewCardApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [
                    Card.self
                ])
        }
    }
}
