//  Created by Alexander Skorulis on 28/11/2025.

import SwiftUI

struct ContentView: View {
    @State private var scrollOffset: CGPoint = .zero
    
    var body: some View {
        VStack(spacing: 0) {
            // Label showing current scroll offset
            VStack(alignment: .leading, spacing: 8) {
                Text("Scroll Position\nX: \(Int(scrollOffset.x)), Y: \(Int(scrollOffset.y))")
                    .font(.headline)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemGray5))
            
            // ScrollView wrapper with SwiftUI content
            ScrollViewWrapper(
                config: .default,
                scrollOffset: $scrollOffset
            ) { offset in
                ScrollContent(viewPort: offset)
            }
            .ignoresSafeArea()
        }
        .background(Color.black)
    }
}

#Preview {
    ContentView()
}
