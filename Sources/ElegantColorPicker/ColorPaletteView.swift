// Kevin Li - 2:46 PM - 7/26/20

import SpriteKit
import UIKit

public class ColorPaletteView: SKView {

    @objc lazy var paletteScene: ColorPaletteScene = {
        let scene = ColorPaletteScene(colors: colors)
        scene.scaleMode = .resizeFill
        scene.anchorPoint = .init(x: 0.5, y: 0.5)
        presentScene(scene)
        return scene
    }()

    public let colors: [PaletteColor]

    public init(colors: [PaletteColor]) {
        self.colors = colors
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // https://stackoverflow.com/questions/728372/when-is-layoutsubviews-called
    // TODO: add support for dynamic sizing. look at Magnetic for howto
    public override func layoutSubviews() {
        super.layoutSubviews()

        paletteScene.size = bounds.size
    }

}
