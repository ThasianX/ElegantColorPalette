// Kevin Li - 11:09 PM - 7/30/20

import ElegantColorPalette
import UIKit

class XIBExampleVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let paletteView = ColorPaletteXIBView()
        paletteView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(paletteView)
        paletteView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        paletteView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        paletteView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        paletteView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

}
