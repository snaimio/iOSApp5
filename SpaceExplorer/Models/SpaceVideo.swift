//  SpaceVideo.swift
//  SpaceExplorer

//  Created by Sheikh Naim on 2026-07-11.

//  =================================================================================
//  Description: Data model for space mission videos.
//  Features: Identifiable protocol for list views, contains metadata for each video.
//  =================================================================================

import Foundation
import UIKit

// MARK: - SpaceVideo Model

/// Represents a space mission video with its metadata.
struct SpaceVideo: Identifiable {

    // MARK: - Properties

    /// Unique identifier for SwiftUI list rendering.
    let id = UUID()

    /// Display name of the video (e.g., "Apollo 11").
    let name: String

    /// Name of the video file in app bundle (e.g., "Apollo11.mp4").
    let fileName: String

    /// Generated thumbnail image for the video.
    let thumbnail: UIImage?

    /// Duration string in MM:SS format (e.g., "02:30").
    let duration: String

    /// A brief summary/description of the video content.
    let summary: String

    // MARK: - Initializer

    /// Creates a new space video with all required metadata.
    init(name: String, fileName: String, thumbnail: UIImage?, duration: String, summary: String) {
        self.name = name
        self.fileName = fileName
        self.thumbnail = thumbnail
        self.duration = duration
        self.summary = summary
    }
}
