// Kevin Li - 11:13 PM - 7/27/20

import Combine
import Foundation
import UIKit

// TODO: add property here that notifies scene that the color scheme has changed. Right now, once you change the color scheme, it doesn't update the label color or the node color if the UIColor is dynamic
class ColorPaletteManager: ObservableObject {

    @Published var colors: [PaletteColor]
    @Published var selectedColor: PaletteColor?
    var nodeStyle: NodeStyle = DefaultNodeStyle()

    var didSelectColor: ((PaletteColor) -> Void)?
    
    private var cancellable: AnyCancellable?

    init(colors: [PaletteColor], selectedColor: PaletteColor?) {
        self.colors = colors
        self.selectedColor = selectedColor
        
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
