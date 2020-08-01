// Kevin Li - 8:27 AM - 7/31/20 - macOS 10.15

import Combine
import ElegantColorPalette
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: PaletteSegmentedControl!
    @IBOutlet weak var paletteView: ColorPaletteView!

    private let selectedColor = CurrentValueSubject<PaletteColor?, Never>(nil)

    private var cancellable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paletteView.update(withColors: PaletteColor.allColors)

        paletteView
            .didSelectColor { [unowned self] color in
                self.selectedColor.send(color)
            }
        
        cancellable = segmentedControl.selectedPalette
            .dropFirst()
            .sink { [unowned self] selection in
                self.updatePaletteView(to: selection)
            }
    }

    private func updatePaletteView(to selection: PaletteSelection) {
        paletteView
            .nodeStyle((selection == .color) ? DefaultNodeStyle() : CustomNodeStyle())
            .update(withColors: (selection == .color) ? PaletteColor.allColors : PaletteColor.allBwColors,
                    selectedColor: selectedColor.value)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        segmentedControl.bind(to: selectedColor.eraseToAnyPublisher())
    }

}

struct CustomNodeStyle: NodeStyle {

    func updateNode(configuration: Configuration) -> ColorNode {
        configuration.defaultStyledNode
            .radius(30)
            .font(name: "Thonburi")
    }

}
