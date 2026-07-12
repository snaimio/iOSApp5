//  VideoPlayerView.swift
//  SpaceExplorer

//  Created by Sheikh Naim on 2026-07-11.

//  ============================================================================
//  Description: Plays mission videos with custom controls (no useless icons).
//  Features: AVPlayer, custom controls, mute, share, full screen, progress bar.
//  ============================================================================

import SwiftUI
import AVKit

// MARK: - VideoPlayerView

/// Video player with custom controls including play/pause, stop, mute, share, and full screen.
struct VideoPlayerView: View {

    // MARK: - Properties

    /// Name of the video file to play (without extension).
    let videoName: String

    /// AVPlayer instance for video playback.
    @State private var player: AVPlayer?

    /// Tracks if the video is currently playing.
    @State private var isPlaying = false

    /// Tracks if the video is muted.
    @State private var isMuted = false

    /// Current playback time.
    @State private var currentTime: Double = 0

    /// Total duration of the video.
    @State private var duration: Double = 0

    /// Controls share sheet presentation.
    @State private var isSharing = false

    /// Observer for periodic time updates.
    @State private var timeObserver: Any?

    /// Tracks if the player is in full screen mode.
    @State private var isFullScreen = false

    /// Access to shared settings for background color.
    @EnvironmentObject var settings: Settings

    // MARK: - Body

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Check if video exists in bundle
                if let path = Bundle.main.path(forResource: videoName, ofType: "mp4") {
                    let url = URL(fileURLWithPath: path)

                    // Custom video player with overlay controls
                    ZStack(alignment: .bottom) {
                        // Custom player - hides AirPlay and PiP icons
                        CustomVideoPlayer(player: player)
                            .frame(height: isFullScreen ? UIScreen.main.bounds.height : 300)
                            .onAppear {
                                if player == nil {
                                    player = AVPlayer(url: url)
                                    setupPlayer()
                                }
                                // Auto-play
                                player?.play()
                                isPlaying = true
                            }
                            .onDisappear {
                                player?.pause()
                                player = nil
                                removeTimeObserver()
                                isPlaying = false
                            }

                        // Custom controls overlay
                        VStack(spacing: 8) {
                            // Progress bar
                            VStack(spacing: 2) {
                                Slider(value: $currentTime, in: 0...max(duration, 1), onEditingChanged: { editing in
                                    if !editing {
                                        player?.seek(to: CMTime(seconds: currentTime, preferredTimescale: 600))
                                    }
                                })
                                .accentColor(.white)
                                .disabled(duration == 0)

                                HStack {
                                    Text(formatTime(currentTime))
                                        .font(.caption2)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text(formatTime(duration))
                                        .font(.caption2)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.horizontal, 12)

                            // Control buttons
                            HStack(spacing: 25) {
                                // Mute button
                                Button(action: {
                                    isMuted.toggle()
                                    player?.volume = isMuted ? 0.0 : 1.0
                                }) {
                                    Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.fill")
                                        .font(.system(size: 22))
                                        .foregroundColor(.white)
                                }

                                // Play/Pause button
                                Button(action: {
                                    if isPlaying {
                                        player?.pause()
                                    } else {
                                        player?.play()
                                    }
                                    isPlaying.toggle()
                                }) {
                                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.white)
                                }

                                // Stop button
                                Button(action: {
                                    player?.pause()
                                    player?.seek(to: .zero)
                                    isPlaying = false
                                    currentTime = 0
                                }) {
                                    Image(systemName: "stop.circle.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.white)
                                }

                                // Share button
                                Button(action: {
                                    isSharing = true
                                }) {
                                    Image(systemName: "square.and.arrow.up")
                                        .font(.system(size: 22))
                                        .foregroundColor(.white)
                                }

                                // Full screen toggle
                                Button(action: {
                                    isFullScreen.toggle()
                                }) {
                                    Image(systemName: isFullScreen ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right")
                                        .font(.system(size: 22))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.bottom, 8)
                        }
                        .background(
                            LinearGradient(
                                colors: [Color.black.opacity(0.7), Color.clear],
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                        .frame(height: 100)
                    }
                    .frame(height: isFullScreen ? UIScreen.main.bounds.height : 300)

                    // Video info (hidden in full screen)
                    if !isFullScreen {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(videoName)
                                .font(.title2)
                                .fontWeight(.bold)

                            Text(getVideoSummary(for: videoName))
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.leading)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 16)

                        Spacer()
                    }

                } else {
                    // Video not found
                    VStack(spacing: 20) {
                        Image(systemName: "video.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)

                        Text("Video not found")
                            .font(.headline)
                            .foregroundColor(.gray)

                        Text("\(videoName).mp4")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(settings.getBackgroundColor())
                }
            }
        }
        .navigationTitle(isFullScreen ? "" : videoName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if isFullScreen {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isFullScreen = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .background(settings.getBackgroundColor().ignoresSafeArea())
        .sheet(isPresented: $isSharing) {
            if let path = Bundle.main.path(forResource: videoName, ofType: "mp4") {
                ShareSheet(activityItems: [URL(fileURLWithPath: path)])
            }
        }
        .preferredColorScheme(isFullScreen ? .dark : nil)
        .statusBarHidden(isFullScreen)
    }

    // MARK: - Private Methods

    /// Sets up the player with time observer and end-of-playback notification.
    private func setupPlayer() {
        guard let player = player else { return }

        // Get duration
        if let duration = player.currentItem?.asset.duration {
            self.duration = CMTimeGetSeconds(duration)
        }

        // Add time observer for progress updates
        removeTimeObserver()
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: .main) { time in
            self.currentTime = CMTimeGetSeconds(time)
        }

        // Listen for playback end
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { _ in
            self.isPlaying = false
            self.currentTime = 0
            player.seek(to: .zero)
        }
    }

    /// Removes the time observer to prevent memory leaks.
    private func removeTimeObserver() {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
    }

    /// Returns a unique summary for the video.
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
        default:
            return "Experience this incredible space mission video."
        }
    }

    /// Formats time in MM:SS format.
    private func formatTime(_ time: Double) -> String {
        if time.isNaN || time.isInfinite || time < 0 { return "00:00" }
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - Custom Video Player

/// Custom video player that hides all default controls (AirPlay, PiP, etc.).
struct CustomVideoPlayer: UIViewControllerRepresentable {

    // MARK: - Properties

    let player: AVPlayer?

    // MARK: - UIViewControllerRepresentable

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false          // Hide all default controls
        controller.allowsPictureInPicturePlayback = false // Disable PiP
        controller.updatesNowPlayingInfoCenter = false
        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        uiViewController.player = player
    }
}

// MARK: - Preview

struct VideoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayerView(videoName: "Apollo11")
            .environmentObject(Settings.shared)
    }
}
