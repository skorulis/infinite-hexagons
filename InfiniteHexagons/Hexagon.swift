//  Created by Alexander Skorulis on 28/11/2025.

import Foundation
import SwiftUI

struct Hexagon {
    
    struct Index: Hashable {
        let row: Int
        let column: Int
    }
    
    // Visible range of hexagons
    struct VisibleRange {
        let rows: Range<Int>
        let columns: Range<Int>
    }
    
    // Radius of each hexagon (center to vertex)
    static let radius: CGFloat = 30
    
    static let width = Hexagon.radius * sqrt(3)
    
    // Space between hexagons
    static let spacing: CGFloat = 6
    
    private static let colors: [Color] = [
        .red, .orange, .yellow, .green, .mint, .teal, .cyan, .blue, .indigo, .purple, .pink, .brown
    ]
    
    static func color(index: Hexagon.Index) -> Color {
        let hash = index.hashValue
        if hash < 0 { return .gray }
        let colorIndex = hash % Self.colors.count
        return Self.colors[colorIndex]
    }
}
