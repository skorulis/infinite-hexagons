//  Created by Alexander Skorulis on 28/11/2025.

import SwiftUI

struct HexagonGridView: View {
    let offset: CGPoint
    let onHexagonTapped: (Hexagon.Index) -> Void
    
    init(offset: CGPoint, onHexagonTapped: @escaping (Hexagon.Index) -> Void) {
        self.offset = offset
        self.onHexagonTapped = onHexagonTapped
    }
    
    var body: some View {
        GeometryReader { geometry in
            let visibleRange = calculateVisibleRange(viewportSize: geometry.size)
            let viewportCenter = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            
            ZStack {
                ForEach(visibleRange.rows, id: \.self) { row in
                    ForEach(visibleRange.columns, id: \.self) { column in
                        let position = hexPosition(row: row, column: column, in: geometry.size)
                        let dimming = calculateDimming(
                            position: position,
                            viewportCenter: viewportCenter,
                            frameSize: geometry.size,
                        )
                        
                        HexagonButton(
                            index: .init(row: row, column: column),
                            dimming: dimming,
                            action: onHexagonTapped,
                        )
                        .position(position)
                    }
                }
            }
        }
    }
    
    // Calculate which hexagons are visible in the viewport
    private func calculateVisibleRange(viewportSize: CGSize) -> Hexagon.VisibleRange {
        let horizontalSpacing = Hexagon.width + Hexagon.spacing
        let verticalSpacing = Hexagon.radius * 1.5 + Hexagon.spacing
        
        // Convert viewport bounds to world coordinates
        let worldFrame = CGRect(
            origin: .init(x: offset.x, y: offset.y),
            size: .init(width: viewportSize.width, height: viewportSize.height),
        )
        // Add extra padding so the edge isn't visible
        .insetBy(dx: -Hexagon.radius, dy: -Hexagon.radius)
        
        // Find the hexagon indices that cover this world coordinate range
        
        let startColumn = pixelToColumn(x: worldFrame.minX, horizontalSpacing: horizontalSpacing)
        let startRow = pixelToRow(y: worldFrame.minY, verticalSpacing: verticalSpacing)
        let endColumn = pixelToColumn(x: worldFrame.maxX, horizontalSpacing: horizontalSpacing) + 1
        let endRow = pixelToRow(y: worldFrame.maxY, verticalSpacing: verticalSpacing) + 1
        
        // Ensure ranges are valid (start <= end)
        let clampedStartColumn = min(startColumn, endColumn)
        let clampedEndColumn = max(startColumn, endColumn)
        let clampedStartRow = min(startRow, endRow)
        let clampedEndRow = max(startRow, endRow)
        
        return .init(
            rows: clampedStartRow..<clampedEndRow,
            columns: clampedStartColumn..<clampedEndColumn
        )
    }
    
    // Convert pixel X position (in world coordinates) to hexagon column index
    private func pixelToColumn(x: CGFloat, horizontalSpacing: CGFloat) -> Int {
        // Account for the initial grid offset
        let adjustedX = x - (Hexagon.width / 2 + Hexagon.spacing / 2)
        return Int(floor(adjustedX / horizontalSpacing))
    }
    
    // Convert pixel Y position (in world coordinates) to hexagon row index
    private func pixelToRow(y: CGFloat, verticalSpacing: CGFloat) -> Int {
        // Account for the initial grid offset
        let adjustedY = y - (Hexagon.radius + Hexagon.spacing / 2)
        return Int(floor(adjustedY / verticalSpacing))
    }
    
    // Calculate position for a hexagon at given row and column, accounting for offset
    private func hexPosition(row: Int, column: Int, in size: CGSize) -> CGPoint {
        // Center-to-center horizontal spacing
        let horizontalSpacing = Hexagon.width + Hexagon.spacing
        // Center-to-center vertical spacing
        let verticalSpacing = Hexagon.radius * 1.5 + Hexagon.spacing
        
        // Start position: account for hexagon radius so first hex doesn't get clipped
        let startX = Hexagon.width / 2 + Hexagon.spacing / 2
        let startY = Hexagon.radius + Hexagon.spacing / 2
        
        // Offset every other row by half the horizontal spacing for proper hex grid
        let xOffset: CGFloat = row % 2 == 0 ? 0 : horizontalSpacing / 2
        
        // Calculate base position
        let baseX = startX + CGFloat(column) * horizontalSpacing + xOffset
        let baseY = startY + CGFloat(row) * verticalSpacing
        
        // Apply the offset to move the grid
        return CGPoint(x: baseX - offset.x, y: baseY - offset.y)
    }
    
    private func calculateDimming(
        position: CGPoint,
        viewportCenter: CGPoint,
        frameSize: CGSize,
    ) -> CGFloat {
        // Calculate distance from center
        let dx = abs(position.x - viewportCenter.x) / frameSize.width
        let dy = abs(position.y - viewportCenter.y) / frameSize.height
        let maxDistance = max(dx, dy)
        
        // Use a smooth curve (ease-in-out) for more natural look
        return maxDistance * maxDistance
    }
}

// MARK: - Previews

#Preview {
    HexagonGridView(offset: .zero) { index in
        print("Tapped hexagon at row: \(index.row), column: \(index.column)")
    }
    .background(Color.black)
}
