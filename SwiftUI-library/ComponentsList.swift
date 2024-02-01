//
//  ComponentsList.swift
//  SwiftUI-library
//
//  Created by Ehsan Azish on 1.02.2024.
//

import SwiftUI

// Define the categories for your components
enum ComponentCategory: String, CaseIterable {
    case functionality = "Functionality"
    case ui = "UI Components"
    case ux = "UX Enhancements"
    // Add more categories as needed
}

// Component struct to hold the details of each component in your library
struct Component: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let category: ComponentCategory
    let destinationView: AnyView

    // Initializer
    init(title: String, description: String, category: ComponentCategory, destinationView: AnyView) {
        self.title = title
        self.description = description
        self.category = category
        self.destinationView = destinationView
    }
}

// Extension to hold all your components
extension Component {
    static let allComponents: [Component] = [
        Component(
            title: "QR Code Reader",
            description: "Scan QR codes and Code128 barcodes in real-time.",
            category: .functionality,
            destinationView: AnyView(QRCodeReader())
        ),
        // Add more components here
    ]
}

