// Kevin Li - 11:13 PM - 7/27/20

import Combine
import Foundation

class ColorPaletteManager: ObservableObject {

    @Published var colors: [PaletteColor]
    @Published var selectedColor: PaletteColor?

    var didSelectColor: ((PaletteColor) -> Void)?
    private var cancellables = Set<AnyCancellable>()

    init(colors: [PaletteColor], selectedColor: PaletteColor?) {
        self.colors = colors
        self.selectedColor = selectedColor
    }

    func setSelectedColor(_ color: PaletteColor) {
        didSelectColor?(color)
    }

}
