//  AudioPlayerView.swift
//  SpaceExplorer

//  Created by Sheikh Naim on 2026-07-11.

//  ========================================================================================
//  Description: Plays space audio with play/pause/stop/mute controls and visual feedback.
//  Features: AVAudioPlayer, play/pause/stop controls, mute, share, progress bar, auto-play.
//  ========================================================================================

import SwiftUI
import AVFoundation

// MARK: - AudioPlayerView

/// Audio player with custom controls and visual feedback.
struct AudioPlayerView: View {

    // MARK: - Properties

    /// Name of the audio file to play.
    let fileName: String

    /// AVAudioPlayer instance for audio playback.
    @State private var player: AVAudioPlayer?

    /// URL of the audio file.
    @State private var audioURL: URL?

    /// Controls share sheet presentation.
    @State private var showingShareSheet = false

    /// Tracks if the audio is currently playing.
    @State private var isPlaying = false

    /// Tracks if the audio is muted.
    @State private var isMuted = false

    /// Current playback time.
    @State private var currentTime: TimeInterval = 0

    /// Total duration of the audio.
    @State private var totalDuration: TimeInterval = 0

    /// Timer for updating progress.
    @State private var timer: Timer?

    /// Access to shared settings for background color.
    @EnvironmentObject var settings: Settings

    // MARK: - Body

    var body: some View {
        let audioName = (fileName as NSString).deletingPathExtension

        VStack(spacing: 25) {
            // Animated audio icon
            ZStack {
                Circle()
                    .fill(Color.purple.opacity(0.1))
                    .frame(width: 100, height: 100)

                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 100, height: 100)
                    .scaleEffect(isPlaying ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 1).repeatForever(), value: isPlaying)

                Image(systemName: isPlaying ? "music.note.list" : "music.note")
                    .font(.system(size: 40))
                    .foregroundColor(isPlaying ? .purple : .gray)
            }

            // Title
            Text(audioName)
                .font(.title)
                .fontWeight(.bold)

            // Summary
            Text(getAudioSummary(for: audioName))
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // Progress bar
            VStack(spacing: 6) {
                Slider(value: $currentTime, in: 0...totalDuration, onEditingChanged: { editing in
                    if !editing {
                        player?.currentTime = currentTime
                    }
                })
                .disabled(totalDuration == 0)
                .accentColor(.purple)

                HStack {
                    Text(formatTime(currentTime))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(formatTime(totalDuration))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal)

            // Control buttons
            HStack(spacing: 35) {
                // Mute button
                Button(action: {
                    isMuted.toggle()
                    player?.volume = isMuted ? 0.0 : 1.0
                }) {
                    Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.fill")
                        .font(.system(size: 24))
                        .foregroundColor(isMuted ? .red : .blue)
                }

                // Play button
                Button(action: playAudio) {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 55))
                        .foregroundColor(.green)
                        .scaleEffect(isPlaying ? 1.05 : 1.0)
                        .animation(.spring(), value: isPlaying)
                }

                // Pause button
                Button(action: pauseAudio) {
                    Image(systemName: "pause.circle.fill")
                        .font(.system(size: 55))
                        .foregroundColor(.orange)
                }

                // Stop button
                Button(action: stopAudio) {
                    Image(systemName: "stop.circle.fill")
                        .font(.system(size: 55))
                        .foregroundColor(.red)
                }
            }

            // Now Playing indicator
            if isPlaying {
                HStack(spacing: 6) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(Color.purple)
                            .frame(width: 6, height: 6)
                            .opacity(0.3)
                            .animation(
                                .easeInOut(duration: 0.6)
                                    .repeatForever()
                                    .delay(Double(index) * 0.2),
                                value: isPlaying
                            )
                    }
                    Text("Now Playing")
                        .font(.caption)
                        .foregroundColor(.purple)
                        .padding(.leading, 4)
                }
            }

            // Share button
            Button {
                showingShareSheet = true
            } label: {
                Label("Share Audio", systemImage: "square.and.arrow.up")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .disabled(audioURL == nil)

            Spacer()
        }
        .padding()
        .navigationTitle(audioName)
        .navigationBarTitleDisplayMode(.inline)
        .background(settings.getBackgroundColor().ignoresSafeArea())
        .onAppear {
            setupAudioPlayer()
            // Auto-play after 0.5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if let player = player, !isPlaying {
                    player.play()
                    isPlaying = true
                    startTimer()
                }
            }
        }
        .onDisappear {
            stopAudio()
            timer?.invalidate()
        }
        .sheet(isPresented: $showingShareSheet) {
            if let audioURL {
                ShareSheet(activityItems: [audioURL])
            }
        }
    }

    // MARK: - Private Methods

    /// Returns a unique summary for the audio.
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
        default:
            return "Immerse yourself in this space audio recording."
        }
    }

    /// Initializes the audio player with the selected file.
    private func setupAudioPlayer() {
        guard let path = Bundle.main.path(forResource: fileName, ofType: nil) else {
            print("❌ Audio file not found: \(fileName)")
            return
        }

        let url = URL(fileURLWithPath: path)
        audioURL = url

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            totalDuration = player?.duration ?? 0
            print("✅ Audio loaded: \(fileName)")
        } catch {
            print("❌ Error loading audio: \(error)")
        }
    }

    /// Plays the audio from the beginning or current position.
    private func playAudio() {
        guard let player = player else { return }
        if !isPlaying {
            player.play()
            isPlaying = true
            startTimer()
        }
    }

    /// Pauses the audio at the current position.
    private func pauseAudio() {
        guard let player = player else { return }
        player.pause()
        isPlaying = false
        timer?.invalidate()
    }

    /// Stops the audio and resets to the beginning.
    private func stopAudio() {
        guard let player = player else { return }
        player.stop()
        player.currentTime = 0
        isPlaying = false
        currentTime = 0
        timer?.invalidate()
    }

    /// Starts a timer to update the progress bar.
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            guard let player = self.player else { return }
            self.currentTime = player.currentTime
            if !player.isPlaying {
                self.isPlaying = false
                self.timer?.invalidate()
            }
        }
    }

    /// Formats time in MM:SS format.
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - Preview

struct AudioPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        AudioPlayerView(fileName: "MissionControl.mp3")
            .environmentObject(Settings.shared)
    }
}
