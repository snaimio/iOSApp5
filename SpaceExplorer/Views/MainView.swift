//  MainView.swift
//  SpaceExplorer

//  Created by Sheikh Naim on 2026-07-11.

//  ==========================================================================
//  Description: Main tab-based navigation for the app.
//  Features: TabView, NavigationView, EnvironmentObject, scenePhase handling.
//  ==========================================================================

import SwiftUI

// MARK: - MainView

/// The main view containing the tab bar navigation.
/// Provides tabs for Videos, Audio, and Settings.
struct MainView: View {

    // MARK: - Properties

    /// Access to shared settings.
    @EnvironmentObject var settings: Settings

    /// Tracks app lifecycle phase to reload settings when app becomes active.
    @Environment(\.scenePhase) private var scenePhase

    /// Currently selected tab index.
    @State private var selectedTab = 0

    // MARK: - Body

    var body: some View {
        TabView(selection: $selectedTab) {
            // Tab 1: Videos
            NavigationView {
                VideoListView()
            }
            .tabItem {
                Label("Videos", systemImage: "play.rectangle")
            }
            .tag(0)

            // Tab 2: Audio
            NavigationView {
                AudioListView()
            }
            .tabItem {
                Label("Audio", systemImage: "music.note")
            }
            .tag(1)

            // Tab 3: Settings
            NavigationView {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            .tag(2)
        }
        .accentColor(.blue)
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                settings.load()
            }
        }
        .onAppear {
            settings.load()
        }
    }
}

// MARK: - Preview

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(Settings.shared)
    }
}
