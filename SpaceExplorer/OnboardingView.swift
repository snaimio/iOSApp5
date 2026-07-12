//  OnboardingView.swift
//  SpaceExplorer

//  Created by Sheikh Naim on 2026-07-12.

//  ===========================================================================
//  Description: Onboarding screen shown to users on first launch.
//  Features: Page-based onboarding with animations, skip and continue buttons.
//  ===========================================================================

import SwiftUI

// MARK: - OnboardingView

/// Onboarding screen shown on first launch to introduce the app's features.
struct OnboardingView: View {

    // MARK: - Properties

    /// Controls whether onboarding is shown (saved to UserDefaults).
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    /// Current page index.
    @State private var currentPage = 0

    // MARK: - Body

    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.15),
                    Color(red: 0.10, green: 0.02, blue: 0.20)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {
                // Skip button
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            hasSeenOnboarding = true
                        }
                    }) {
                        Text("Skip")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.white.opacity(0.6))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.1))
                            )
                    }
                    .padding(.trailing, 24)
                }
                .padding(.top, 20)

                // TabView for onboarding pages
                TabView(selection: $currentPage) {
                    OnboardingPageView(
                        image: "rocket.fill",
                        title: "Welcome to Space Explorer",
                        description: "Explore the wonders of space through historic mission videos and audio recordings.",
                        index: 0,
                        totalPages: 3
                    )
                    .tag(0)

                    OnboardingPageView(
                        image: "play.rectangle.fill",
                        title: "Watch Mission Videos",
                        description: "View historic space missions with custom video controls including play, pause, mute, and full screen.",
                        index: 1,
                        totalPages: 3
                    )
                    .tag(1)

                    OnboardingPageView(
                        image: "music.note",
                        title: "Listen to Space Audio",
                        description: "Immerse yourself in historic communications, astronaut interviews, and fascinating space facts.",
                        index: 2,
                        totalPages: 3
                    )
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.4), value: currentPage)

                // Continue / Get Started button
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        if currentPage < 2 {
                            currentPage += 1
                        } else {
                            hasSeenOnboarding = true
                        }
                    }
                }) {
                    Text(currentPage < 2 ? "Continue" : "Get Started")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                        .background(
                            LinearGradient(
                                colors: [Color.blue, Color.purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        .shadow(color: Color.purple.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 16)

                // Page indicators
                HStack(spacing: 10) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(index == currentPage ? Color.blue : Color.white.opacity(0.25))
                            .frame(width: 10, height: 10)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                            .scaleEffect(index == currentPage ? 1.2 : 1.0)
                    }
                }
                .padding(.bottom, 40)
            }
        }
    }
}

// MARK: - Onboarding Page View

/// Individual onboarding page with image, title, and description.
struct OnboardingPageView: View {

    // MARK: - Properties

    let image: String
    let title: String
    let description: String
    let index: Int
    let totalPages: Int

    // MARK: - Animation States

    @State private var isAnimating = false

    // MARK: - Body

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            // ✅ Fixed: Icon with gradient background
            ZStack {
                // Outer glow
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.blue.opacity(0.3),
                                Color.purple.opacity(0.1),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 20,
                            endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)

                // Inner circle with gradient
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 140, height: 140)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.4)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
                    .shadow(color: Color.blue.opacity(0.15), radius: 20, x: 0, y: 10)

                // Icon
                Image(systemName: image)
                    .font(.system(size: 50))
                    .foregroundColor(.white)
                    .shadow(color: Color.blue.opacity(0.3), radius: 10)
            }
            .scaleEffect(isAnimating ? 1.0 : 0.8)
            .opacity(isAnimating ? 1.0 : 0.6)
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2)) {
                    isAnimating = true
                }
            }

            // Title
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            // Description
            Text(description)
                .font(.body)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
    }
}

// MARK: - Preview

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
