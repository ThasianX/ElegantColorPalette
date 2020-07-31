// Kevin Li - 2:46 PM - 7/26/20

import SpriteKit
import UIKit

public class ColorPaletteView: SKView {

    private lazy var paletteScene: ColorPaletteScene = {
        let scene = ColorPaletteScene(paletteManager: paletteManager)
        scene.scaleMode = .resizeFill
        scene.anchorPoint = .init(x: 0.5, y: 0.5)
        presentScene(scene)
        return scene
    }()

    private let paletteManager: ColorPaletteManager

    public init(colors: [PaletteColor]) {
        paletteManager = ColorPaletteManager(colors: colors, selectedColor: nil)
        super.init(frame: .zero)
        commonInit()
    }

    public init(colors: [PaletteColor], selectedColor: PaletteColor?) {
        paletteManager = ColorPaletteManager(colors: colors, selectedColor: selectedColor)
        super.init(frame: .zero)
        commonInit()
    }

    override init(frame: CGRect) {
        paletteManager = ColorPaletteManager(colors: [], selectedColor: nil)
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        paletteManager = ColorPaletteManager(colors: [], selectedColor: nil)
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        allowsTransparency = true
        backgroundColor = .clear
    }

    // https://stackoverflow.com/questions/728372/when-is-layoutsubviews-called
    public override func layoutSubviews() {
        super.layoutSubviews()

        _ = paletteScene
    }

    /// Use if you want to update the colors being shown in the view.
    public func update(withColors colors: [PaletteColor], selectedColor: PaletteColor? = nil) {
        guard paletteManager.colors != colors else { return }

        paletteManager.resetSelectedColorBinding(selectedColor)
        paletteManager.colors = colors
    }

}

public extension ColorPaletteView {

    @discardableResult
    func didSelectColor(_ callback: ((PaletteColor) -> Void)?) -> Self {
        paletteManager.didSelectColor = callback
        return self
    }

    @discardableResult
    func nodeStyle(_ style: NodeStyle) -> Self {
        paletteManager.nodeStyle = style
        return self
    }

}
