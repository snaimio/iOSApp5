//  SpaceExplorerApp.swift
//  SpaceExplorer

//  Created by Sheikh Naim on 2026-07-11.

//  ====================================================================================
//  Description: Main app entry point. Sets up the app's root view and injects the shared
//  Settings object into the environment so all child views can access app-wide settings.
//  Features: @main entry point, @StateObject for settings, environmentObject injection.
//  ====================================================================================


import SwiftUI

// MARK: - Main App Entry Point

/// The main entry point for the Space Explorer app.
/// This struct conforms to the `App` protocol and defines the app's window group.
@main
struct SpaceExplorerApp: App {

    // MARK: - Properties

    /// Shared settings object that persists across the app lifecycle.
    /// `@StateObject` ensures the object is created once and retained.
    @StateObject private var settings = Settings.shared

    // MARK: - Body

    /// Defines the main scene of the app.
    /// The window group contains the root `ContentView` with the settings injected as an environment object.
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
        }
    }
}
