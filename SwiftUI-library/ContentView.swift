//
//  ContentView.swift
//  SwiftUI-library
//
//  Created by Ehsan Azish on 1.02.2024.
//

import SwiftUI

/// `ContentView` serves as the main view for the SwiftUI Library app.
/// It displays a list of components, each leading to a detailed demonstration of that component.
struct ContentView: View {
    // Holds all the components defined in ComponentData.swift
    private let allComponents = Component.allComponents
    
    // Holds the current search text for filtering components
    @State private var searchText = ""
    
    /// Computed property to filter components based on search text.
    /// - Returns all components if search text is empty.
    /// - Returns components whose title contains the search text otherwise.
    private var filteredComponents: [Component] {
        if searchText.isEmpty {
            return allComponents
        } else {
            return allComponents.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            List(filteredComponents) { component in
                NavigationLink(destination: component.destinationView) {
                    VStack(alignment: .leading) {
                        Text(component.title)
                            .font(.headline)
                        Text(component.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Components")
            .searchable(text: $searchText, prompt: "Search Components") // Enables searching through the components list
        }
    }
}


#Preview {
    ContentView()
}
