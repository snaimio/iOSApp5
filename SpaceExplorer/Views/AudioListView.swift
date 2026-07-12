//  AudioListView.swift
//  SpaceExplorer

//  Created by Sheikh Naim on 2026-07-11.

//  ===================================================================================
//  Description: Displays space audio in a professional card-based list.
//  Features: ScrollView, LazyVStack, card design, hover effects, navigation to player.
//  ===================================================================================

import SwiftUI

// MARK: - AudioListView

/// Displays a list of space audio clips with summaries and durations.
struct AudioListView: View {

    // MARK: - Properties

    /// Loads audio data from the app bundle.
    @StateObject private var audioLoader = AudioLoader()

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
                    HeaderView(title: "Space Audio", subtitle: "Listen to historic space communications")

                    // Check if audio files are loaded
                    if audioLoader.audioFiles.isEmpty {
                        EmptyStateView(
                            icon: "music.note.slash",
                            title: "No Audio Found",
                            message: "Add .mp3 files to your app bundle"
                        )
                    } else {
                        // Display each audio as a card
                        ForEach(audioLoader.audioFiles) { audio in
                            NavigationLink(
                                destination: AudioPlayerView(fileName: audio.fileName)
                            ) {
                                AudioCardView(audio: audio)
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
            audioLoader.loadAudioFiles()
            settings.load()
        }
    }
}

// MARK: - Audio Card View

/// A single audio card with icon, title, summary, and duration.
struct AudioCardView: View {

    // MARK: - Properties

    /// The audio data to display.
    let audio: SpaceAudio

    /// State for hover effect (macOS) or tap feedback.
    @State private var isHovered = false

    // MARK: - Body

    var body: some View {
        HStack(spacing: 14) {
            // Audio icon
            ZStack {
                Circle()
                    .fill(Color.purple.opacity(0.12))
                    .frame(width: 50, height: 50)

                Image(systemName: "music.note")
                    .font(.title2)
                    .foregroundColor(.purple)
            }

            // Audio information
            VStack(alignment: .leading, spacing: 4) {
                Text(audio.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(1)

                Text(audio.summary)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text(audio.duration)
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

// MARK: - Preview

struct AudioListView_Previews: PreviewProvider {
    static var previews: some View {
        AudioListView()
            .environmentObject(Settings.shared)
    }
}
