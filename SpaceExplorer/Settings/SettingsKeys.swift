//  SettingsKeys.swift
//  SpaceExplorer

//  Created by Sheikh Naim on 2026-07-11.

//  =========================================================================
//  Description: Defines keys and enums for UserDefaults and Settings Bundle.
//  Features: Type-safe settings management with enums.
//  =========================================================================

import SwiftUI

// MARK: - Settings Keys

/// Keys used for UserDefaults storage - matches Settings.bundle Root.plist.
enum SettingsKeys {
    static let themeMode = "theme_mode"
    static let backgroundColour = "background_colour"
}

// MARK: - Theme Mode Enum

/// Theme mode options for the app.
enum ThemeMode: String, CaseIterable {
    case system
    case light
    case dark
}

// MARK: - Background Colour Enum

/// Background color options with display names and color values.
enum BackgroundColour: String, CaseIterable {
    case light
    case blue
    case purple
    case gray
    case dark

    /// Returns the SwiftUI Color for the enum value.
    func colorValue() -> Color {
        switch self {
        case .light:
            return Color(.systemGray6)
        case .blue:
            return Color.blue.opacity(0.10)
        case .purple:
            return Color.purple.opacity(0.10)
        case .gray:
            return Color.gray.opacity(0.10)
        case .dark:
            return Color.black.opacity(0.90)
        }
    }

    /// Returns the user-friendly display name for the color.
    func displayName() -> String {
        switch self {
        case .light:
            return "Light"
        case .blue:
            return "Blue"
        case .purple:
            return "Purple"
        case .gray:
            return "Gray"
        case .dark:
            return "Dark"
        }
    }
}
