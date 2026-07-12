//  VideoListView.swift
//  SpaceExplorer

//  Created by Sheikh Naim on 2026-07-11.

//  ===================================================================================
//  Description: Displays space videos in a professional card-based list.
//  Features: ScrollView, LazyVStack, card design, hover effects, navigation to player.
//  ===================================================================================

import SwiftUI

// MARK: - VideoListView

/// Displays a list of space mission videos with thumbnails, summaries, and durations.
struct VideoListView: View {

    // MARK: - Properties

    /// Loads video data from the app bundle.
    @StateObject private var videoLoader = VideoLoader()

    /// Access to shared settings for background color.
    @EnvironmentObject var settings: Settings

    // MARK: - Body

    var body: some View {
        ZStack {
            // Background color
            settings.getBackgroundColor()
                .ignoresSafeArea()

            ScrollView {
                LazyVStack(spacing: 16) {
                    // Header
                    HeaderView(title: "Mission Videos", subtitle: "Explore historic space missions")

                    // Check if videos are loaded
                    if videoLoader.videos.isEmpty {
                        EmptyStateView(
                            icon: "play.slash",
                            title: "No Videos Found",
                            message: "Add .mp4 files to your app bundle"
                        )
                    } else {
                        // Display each video as a card
                        ForEach(videoLoader.videos) { video in
                            NavigationLink(
                                destination: VideoPlayerView(videoName: video.name)
                            ) {
                                VideoCardView(video: video)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            videoLoader.loadVideos()
            settings.load()
        }
    }
}

// MARK: - Video Card View

/// A single video card with thumbnail, title, summary, and duration.
struct VideoCardView: View {

    // MARK: - Properties

    /// The video data to display.
    let video: SpaceVideo

    /// State for hover effect (macOS) or tap feedback.
    @State private var isHovered = false

    // MARK: - Body

    var body: some View {
        HStack(spacing: 14) {
            // Thumbnail with play overlay
            ZStack {
                if let thumbnail = video.thumbnail {
                    Image(uiImage: thumbnail)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 110, height: 70)
                        .cornerRadius(8)
                        .clipped()
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 110, height: 70)
                        .cornerRadius(8)
                        .overlay(
                            Image(systemName: "play.slash")
                                .foregroundColor(.gray)
                        )
                }

                // Play button overlay
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 4)
            }

            // Video information
            VStack(alignment: .leading, spacing: 4) {
                Text(video.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(1)

                Text(video.summary)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text(video.duration)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
        .scaleEffect(isHovered ? 1.01 : 1.0)
        .animation(.spring(response: 0.3), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

// MARK: - Header View

/// Reusable header with title and subtitle.
struct HeaderView: View {

    // MARK: - Properties

    let title: String
    let subtitle: String

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
    }
}

// MARK: - Empty State View

/// Displayed when no videos are found in the app bundle.
struct EmptyStateView: View {

    // MARK: - Properties

    let icon: String
    let title: String
    let message: String

    // MARK: - Body

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 50))
                .foregroundColor(.secondary)

            Text(title)
                .font(.headline)
                .foregroundColor(.primary)

            Text(message)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

// MARK: - Preview

struct VideoListView_Previews: PreviewProvider {
    static var previews: some View {
        VideoListView()
            .environmentObject(Settings.shared)
    }
}
