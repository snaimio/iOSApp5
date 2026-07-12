//  VideoLoader.swift
//  SpaceExplorer

//  Created by Sheikh Naim on 2026-07-11.

//  ============================================================================================
//  Description: Loads and processes space videos from the app bundle.
//  Features: FileManager, AVAsset, thumbnail generation, duration extraction, unique summaries.
//  ============================================================================================

import Foundation
import AVFoundation
import UIKit
import Combine

// MARK: - VideoLoader Class

/// Loads video files from the app bundle and creates SpaceVideo objects with metadata.
final class VideoLoader: ObservableObject {

    // MARK: - Published Properties

    /// Array of loaded space videos - updates UI when changed.
    @Published var videos: [SpaceVideo] = []

    // MARK: - Initializer

    init() {
        loadVideos()
    }

    // MARK: - Public Methods

    /// Loads all videos from the app bundle.
    func loadVideos() {
        let fileManager = FileManager.default

        // Get the app bundle resource path
        guard let bundlePath = Bundle.main.resourcePath else {
            print("❌ Error: Could not find resource path")
            return
        }

        do {
            // Get all files in the bundle
            let items = try fileManager.contentsOfDirectory(atPath: bundlePath)

            // Filter for video files only (.mp4 and .m4v)
            let videoFiles = items.filter {
                $0.hasSuffix(".mp4") || $0.hasSuffix(".m4v")
            }

            // Convert each video file to a SpaceVideo object
            videos = videoFiles.map { file in
                let nameWithoutExtension = (file as NSString).deletingPathExtension
                let videoURL = URL(fileURLWithPath: bundlePath).appendingPathComponent(file)
                let thumbnail = generateThumbnail(for: videoURL)
                let duration = getVideoDuration(for: videoURL)
                let summary = getVideoSummary(for: nameWithoutExtension)

                return SpaceVideo(
                    name: nameWithoutExtension,
                    fileName: file,
                    thumbnail: thumbnail,
                    duration: duration,
                    summary: summary
                )
            }

            print("✅ Loaded \(videos.count) videos")

        } catch {
            print("❌ Error loading videos: \(error)")
        }
    }

    // MARK: - Private Helper Methods

    /// Gets video duration using AVAsset.
    /// - Parameter url: The video file URL.
    /// - Returns: Duration string in MM:SS format.
    private func getVideoDuration(for url: URL) -> String {
        let asset = AVURLAsset(url: url)
        let duration = asset.duration.seconds

        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    /// Generates a thumbnail at the 1-second mark of the video.
    /// - Parameter url: The video file URL.
    /// - Returns: UIImage thumbnail or nil if generation fails.
    private func generateThumbnail(for url: URL) -> UIImage? {
        let asset = AVURLAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.maximumSize = CGSize(width: 120, height: 68)

        // Capture frame at 1 second
        let time = CMTime(seconds: 1, preferredTimescale: 600)

        do {
            let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            print("❌ Error generating thumbnail: \(error)")
            return nil
        }
    }

    /// Returns a unique summary for each video based on its name.
    /// - Parameter name: The video name (without extension).
    /// - Returns: A descriptive summary string.
    private func getVideoSummary(for name: String) -> String {
        switch name.lowercased() {
        case "apollo11":
            return "Apollo 11 was the first crewed mission to land on the Moon on July 20, 1969."
        case "marsrover":
            return "NASA's Mars rovers have been exploring the Red Planet's surface since 2004."
        case "spacexlaunch":
            return "SpaceX revolutionized space travel with reusable rockets and commercial missions."
        case "iss":
            return "The International Space Station has been continuously occupied since November 2000."
        case "rocketlaunch":
            return "Witness the incredible power of modern rocket launches and space exploration."
        case "moonlanding":
            return "The historic moment when humanity first set foot on another celestial body."
        case "saturn":
            return "Explore the ringed giant Saturn, the second-largest planet in our solar system."
        case "jupiter":
            return "Discover Jupiter, the largest planet in our solar system with its Great Red Spot."
        default:
            return "Experience this incredible space mission video."
        }
    }
}
