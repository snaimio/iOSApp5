//  SpaceAudio.swift
//  SpaceExplorer

//  Created by Sheikh Naim on 2026-07-11.

//  =================================================================================
//  Description: Data model for space audio clips.
//  Features: Identifiable protocol for list views, contains metadata for each audio.
//  =================================================================================

import Foundation

// MARK: - SpaceAudio Model

/// Represents a space audio clip with its metadata.
struct SpaceAudio: Identifiable {

    // MARK: - Properties

    /// Unique identifier for SwiftUI list rendering.
    let id = UUID()

    /// Display name of the audio (e.g., "Mission Control").
    let name: String

    /// Name of the audio file in app bundle (e.g., "MissionControl.mp3").
    let fileName: String

    /// Duration string in MM:SS format.
    let duration: String

    /// A brief summary/description of the audio content.
    let summary: String

    // MARK: - Initializer

    /// Creates a new space audio clip with all required metadata.
    init(name: String, fileName: String, duration: String, summary: String) {
        self.name = name
        self.fileName = fileName
        self.duration = duration
        self.summary = summary
    }
}
