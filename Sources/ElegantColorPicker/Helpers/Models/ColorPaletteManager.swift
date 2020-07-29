// Kevin Li - 11:13 PM - 7/27/20

import Foundation
import UIKit

class ColorPaletteManager: ObservableObject {

    @Published var colors: [PaletteColor]
    @Published var selectedColor: PaletteColor?

    var didSelectColor: ((PaletteColor) -> Void)?

    init(colors: [PaletteColor], selectedColor: PaletteColor?) {
        self.colors = colors
        self.selectedColor = selectedColor
    }

    func setSelectedColor(_ color: PaletteColor) {
        didSelectColor?(color)
    }

}
