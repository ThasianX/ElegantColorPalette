// Kevin Li - 2:46 PM - 7/26/20

import SpriteKit
import UIKit

public class ColorPaletteView: SKView {

    @objc lazy var paletteView: ColorPaletteScene = { [unowned self] in
        let scene = ColorPaletteScene(size: self.bounds.size)
        scene.scaleMode = .resizeFill
        scene.anchorPoint = .init(x: 0.5, y: 0.5)
        self.presentScene(scene)
        return scene
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)

        sharedInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)

        sharedInit()
    }

    func sharedInit() {
        _ = paletteView
    }

    // TODO: add support for dynamic sizing. look at Magnetic for howto
    public override func layoutSubviews() {
        super.layoutSubviews()
    }

}
