//  SettingsView.swift
//  SpaceExplorer

//  Created by Sheikh Naim on 2026-07-11.

//  ===================================================================================
//  Description: App settings for theme and background color.
//  Features: Theme switching, background color selection, reset option, about section.
//  ===================================================================================

import SwiftUI

// MARK: - SettingsView

/// In-app settings view for customizing theme and appearance.
struct SettingsView: View {

    // MARK: - Properties

    /// Access to shared settings.
    @EnvironmentObject var settings: Settings

    /// Controls reset alert presentation.
    @State private var showingResetAlert = false

    // MARK: - Body

    var body: some View {
        ZStack {
            // Background color
            settings.getBackgroundColor()
                .ignoresSafeArea()

            Form {
                // Theme Section
                Section(header: Text("Theme")) {
                    Picker("Theme Mode", selection: $settings.themeMode) {
                        ForEach(ThemeMode.allCases, id: \.self) { mode in
                            Text(mode.rawValue.capitalized)
                                .tag(mode)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: settings.themeMode) { oldValue, newValue in
                        settings.save()
                    }
                }

                // Background Color Section
                Section(header: Text("Background Color")) {
                    Picker("Choose Background", selection: $settings.backgroundColour) {
                        ForEach(BackgroundColour.allCases, id: \.self) { color in
                            HStack {
                                Circle()
                                    .fill(color.colorValue())
                                    .frame(width: 20, height: 20)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                                Text(color.displayName())
                                    .foregroundColor(.primary)
                            }
                            .tag(color)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: settings.backgroundColour) { oldValue, newValue in
                        settings.save()
                    }
                }

                // Reset Section
                Section {
                    Button(action: {
                        showingResetAlert = true
                    }) {
                        Text("Reset All Settings")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .alert(isPresented: $showingResetAlert) {
                        Alert(
                            title: Text("Reset Settings"),
                            message: Text("This will reset all settings to their default values."),
                            primaryButton: .destructive(Text("Reset")) {
                                settings.reset()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }

                // About Section
                Section(header: Text("About")) {
                    HStack {
                        Text("App Name")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("Space Explorer")
                            .foregroundColor(.primary)
                    }

                    HStack {
                        Text("Version")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.primary)
                    }

                    HStack {
                        Text("Course")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("iOS Development")
                            .foregroundColor(.primary)
                    }

                    HStack {
                        Text("Assignment")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("Assignment 7")
                            .foregroundColor(.primary)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(settings.getBackgroundColor())
        }
        .navigationTitle("Settings")
        .onAppear {
            settings.load()
        }
    }
}

// MARK: - Preview

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(Settings.shared)
    }
}
