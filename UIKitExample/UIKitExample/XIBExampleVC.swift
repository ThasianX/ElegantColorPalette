// Kevin Li - 11:09 PM - 7/30/20

import ElegantColorPalette
import UIKit

class XIBExampleVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let paletteView = ColorPaletteXIBView()
        view.addSubview(paletteView)
        
        paletteView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            paletteView.topAnchor.constraint(equalTo: view.topAnchor),
            paletteView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            paletteView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            paletteView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

}
