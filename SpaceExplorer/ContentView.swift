//  ContentView.swift
//  SpaceExplorer

//  Created by Sheikh Naim on 2026-07-11.

//  ===================================================================================
//  Description: Root view that wraps MainView with background color and theme support.
//  Features: EnvironmentObject, background color application, color scheme handling,
//  onboarding.
//  ===================================================================================

import SwiftUI

// MARK: - ContentView

/// The root view of the application.
/// Applies the selected background color and theme to the entire app.
/// Shows onboarding on first launch.
struct ContentView: View {

    // MARK: - Properties

    /// Access to shared settings for theme and background color.
    @EnvironmentObject var settings: Settings

    /// Tracks whether onboarding has been shown (saved to UserDefaults).
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    // MARK: - Body

    var body: some View {
        ZStack {
            MainView()
                .background(settings.getBackgroundColor())
                .preferredColorScheme(colorScheme(for: settings.themeMode))
                .onAppear {
                    settings.load()
                }

            // Show onboarding if not seen yet
            if !hasSeenOnboarding {
                OnboardingView()
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
    }

    // MARK: - Helper Methods

    /// Maps ThemeMode enum to SwiftUI ColorScheme.
    /// - Parameter mode: The selected theme mode.
    /// - Returns: ColorScheme or nil for system default.
    private func colorScheme(for mode: ThemeMode) -> ColorScheme? {
        switch mode {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Settings.shared)
    }
}
