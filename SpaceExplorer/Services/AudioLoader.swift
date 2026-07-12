//  AudioLoader.swift
//  SpaceExplorer

//  Created by Sheikh Naim on 2026-07-11.

//  ======================================================================
//  Description: Loads and processes space audio from the app bundle.
//  Features: FileManager, AVAsset, duration extraction, unique summaries.
//  ======================================================================

import Foundation
import AVFoundation
import Combine

// MARK: - AudioLoader Class

/// Loads audio files from the app bundle and creates SpaceAudio objects with metadata.
final class AudioLoader: ObservableObject {

    // MARK: - Published Properties

    /// Array of loaded space audio clips - updates UI when changed.
    @Published var audioFiles: [SpaceAudio] = []

    // MARK: - Initializer

    init() {
        loadAudioFiles()
    }

    // MARK: - Public Methods

    /// Loads all audio files from the app bundle.
    func loadAudioFiles() {
        let fileManager = FileManager.default

        // Get the app bundle resource path
        guard let bundlePath = Bundle.main.resourcePath else {
            print("❌ Error: Could not find resource path")
            return
        }

        do {
            // Get all files in the bundle
            let items = try fileManager.contentsOfDirectory(atPath: bundlePath)

            // Filter for audio files only (.mp3 and .wav)
            let audioFiles = items.filter {
                $0.hasSuffix(".mp3") || $0.hasSuffix(".wav")
            }

            // Convert each audio file to a SpaceAudio object
            self.audioFiles = audioFiles.map { file in
                let nameWithoutExtension = (file as NSString).deletingPathExtension
                let audioURL = URL(fileURLWithPath: bundlePath).appendingPathComponent(file)
                let duration = getAudioDuration(for: audioURL)
                let summary = getAudioSummary(for: nameWithoutExtension)

                return SpaceAudio(
                    name: nameWithoutExtension,
                    fileName: file,
                    duration: duration,
                    summary: summary
                )
            }

            print("✅ Loaded \(audioFiles.count) audio files")

        } catch {
            print("❌ Error loading audio files: \(error)")
        }
    }

    // MARK: - Private Helper Methods

    /// Gets audio duration using AVAsset.
    /// - Parameter url: The audio file URL.
    /// - Returns: Duration string in MM:SS format.
    private func getAudioDuration(for url: URL) -> String {
        let asset = AVURLAsset(url: url)
        let duration = asset.duration.seconds

        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    /// Returns a unique summary for each audio based on its name.
    /// - Parameter name: The audio name (without extension).
    /// - Returns: A descriptive summary string.
    private func getAudioSummary(for name: String) -> String {
        switch name.lowercased() {
        case "missioncontrol":
            return "Listen to the historic communications between Mission Control and astronauts."
        case "rocketcountdown":
            return "The thrilling final countdown before a rocket launch into space."
        case "astronautinterview":
            return "Exclusive interview with astronauts sharing their space experiences."
        case "spacefacts":
            return "Fascinating facts about space, planets, and the universe."
        case "interview":
            return "In-depth conversation with space explorers and scientists."
        case "control":
            return "Behind-the-scenes audio from NASA's Mission Control Center."
        default:
            return "Immerse yourself in this space audio recording."
        }
    }
}
