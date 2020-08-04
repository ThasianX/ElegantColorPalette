// Kevin Li - 11:13 PM - 7/27/20

import Combine
import Foundation
import UIKit

typealias ColorScheme = UIUserInterfaceStyle

class ColorPaletteManager: ObservableObject {

    @Published var colors: [PaletteColor]
    @Published var selectedColor: PaletteColor?
    @Published var activeColorScheme: ColorScheme = .unspecified

    var nodeStyle: NodeStyle = DefaultNodeStyle()
    var focusSettings: FocusSettings = .default

    var didSelectColor: ((PaletteColor) -> Void)?
    
    private var cancellable: AnyCancellable?

    init(colors: [PaletteColor], selectedColor: PaletteColor?) {
        self.colors = colors
        
        resetSelectedColorBinding(selectedColor)
    }
    
    func resetSelectedColorBinding(_ selectedColor: PaletteColor?) {
        cancellable?.cancel()
        
        self.selectedColor = selectedColor
        cancellable = $selectedColor
            .dropFirst()
            .compactMap { $0 }
            .sink { [unowned self] color in
                self.didSelectColor?(color)
            }
    }

}
