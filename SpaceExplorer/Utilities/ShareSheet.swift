//  ShareSheet.swift
//  SpaceExplorer

//  Created by Sheikh Naim on 2026-07-11.

//  ==========================================================================
//  Description: UIKit wrapper for UIActivityViewController to enable sharing.
//  Features: UIViewControllerRepresentable for native share sheet.
//  ==========================================================================

import SwiftUI
import UIKit

// MARK: - ShareSheet

/// SwiftUI wrapper for UIActivityViewController.
/// Provides native iOS sharing functionality for media files.
struct ShareSheet: UIViewControllerRepresentable {

    // MARK: - Properties

    /// Items to share (URLs, strings, images, etc.).
    let activityItems: [Any]

    /// Optional custom activities.
    let applicationActivities: [UIActivity]? = nil

    // MARK: - UIViewControllerRepresentable Methods

    /// Creates the UIActivityViewController.
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        return controller
    }

    /// Updates the view controller (no update needed).
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No update needed
    }
}
