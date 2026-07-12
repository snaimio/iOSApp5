//  Settings.swift
//  SpaceExplorer

//  Created by Sheikh Naim on 2026-07-11.

//  =====================================================================================
//  Description: Manages app settings with UserDefaults persistence.
//  Features: ObservableObject, UserDefaults, ColorScheme integration, singleton pattern.
//  =====================================================================================

import SwiftUI
import Combine

// MARK: - Settings Class

/// Manages app-wide settings including theme and background color.
/// Uses the singleton pattern to ensure only one instance exists.
final class Settings: ObservableObject {

    // MARK: - Singleton

    /// Shared instance for global access.
    static let shared = Settings()

    // MARK: - Published Properties

    /// Currently selected theme mode.
    @Published var themeMode: ThemeMode = .system

    /// Currently selected background color.
    @Published var backgroundColour: BackgroundColour = .light

    // MARK: - Private Properties

    /// UserDefaults instance for persistence.
    private let defaults = UserDefaults.standard

    /// Keys for storing values in UserDefaults.
    private let themeKey = SettingsKeys.themeMode
    private let backgroundKey = SettingsKeys.backgroundColour

    // MARK: - Initializer

    /// Private initializer for singleton pattern.
    private init() {
        load()

        // Observe changes from Settings Bundle (iOS Settings app)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(defaultsChanged),
            name: UserDefaults.didChangeNotification,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Public Methods

    /// Loads settings from UserDefaults.
    func load() {
        // Load theme mode
        if let raw = defaults.string(forKey: themeKey),
           let value = ThemeMode(rawValue: raw) {
            themeMode = value
        } else {
            themeMode = .system
        }

        // Load background color
        if let raw = defaults.string(forKey: backgroundKey),
           let value = BackgroundColour(rawValue: raw) {
            backgroundColour = value
        } else {
            backgroundColour = .light
        }

        // Force UI update on main thread
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }

    /// Saves current settings to UserDefaults.
    func save() {
        defaults.set(themeMode.rawValue, forKey: themeKey)
        defaults.set(backgroundColour.rawValue, forKey: backgroundKey)

        // Force UI update on main thread
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }

    /// Resets all settings to default values.
    func reset() {
        themeMode = .system
        backgroundColour = .light
        save()
    }

    /// Returns the current background color as a SwiftUI Color.
    func getBackgroundColor() -> Color {
        return backgroundColour.colorValue()
    }

    // MARK: - Notification Handler

    /// Called when Settings Bundle changes values (iOS Settings app).
    @objc private func defaultsChanged() {
        DispatchQueue.main.async {
            self.load()
        }
    }
}
