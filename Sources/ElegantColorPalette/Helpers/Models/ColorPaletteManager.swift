// Kevin Li - 11:13 PM - 7/27/20

import Foundation
import UIKit

class ColorPaletteManager: ObservableObject {

    @Published var colors: [PaletteColor]
    @Published var selectedColor: PaletteColor?
    @Published var nodeStyle: NodeStyle

    var didSelectColor: ((PaletteColor) -> Void)?

    init(colors: [PaletteColor], selectedColor: PaletteColor?, nodeStyle: NodeStyle) {
        self.colors = colors
        self.selectedColor = selectedColor
        self.nodeStyle = nodeStyle
    }

    func setSelectedColor(_ color: PaletteColor) {
        didSelectColor?(color)
    }

}
