// Kevin Li - 10:53 PM - 7/30/20

import ElegantColorPalette
import UIKit

class ColorPaletteXIBView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var paletteView: ColorPaletteView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("ColorPalette", owner: self, options: nil)
        paletteView.update(withColors: PaletteColor.allColors)
        addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }

}
