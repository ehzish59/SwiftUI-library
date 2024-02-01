//
//  QRCodeReader.swift
//  SwiftUI-library
//
//  Created by Ehsan Azish on 1.02.2024.
//

import SwiftUI

/// `QRCodeReader` is a SwiftUI view that presents the QR code scanning interface.
struct QRCodeReader: View {
    // MARK: - Properties
    @State var QRearchtext: String = ""  // State variable to hold the scanned QR code result
    
    // MARK: - Body
    var body: some View {
        QRScanner(result: $QRearchtext)  // QRScanner view that starts the camera session and scans for QR codes. Ensure you request camera permissions by adding the appropriate NSCameraUsageDescription key to your Info.plist file.
            .overlay(
                VStack{
                    Text(QRearchtext) // Display the scanned QR code result
                        .foregroundStyle(.gray)
                    Image(systemName: "viewfinder")  // System image to simulate a viewfinder in the UI
                        .font(.system(size: 320, weight: .ultraLight))
                        .foregroundStyle(.gray)
                        .symbolEffect(.pulse)  // Pulse effect to indicate scanning
                }
            )
            .ignoresSafeArea()  // Ensure the camera view uses the entire screen
    }
}

// MARK: - Preview
struct QRCodeReader_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeReader()  // SwiftUI preview of the QRCodeReader view
    }
}

