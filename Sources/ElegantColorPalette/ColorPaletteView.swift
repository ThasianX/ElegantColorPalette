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
        paletteManager = ColorPaletteManager(colors: colors, selectedColor: nil, nodeStyle: DefaultNodeStyle())
        super.init(frame: .zero)
    }

    public init(colors: [PaletteColor], selectedColor: PaletteColor?) {
        paletteManager = ColorPaletteManager(colors: colors, selectedColor: selectedColor, nodeStyle: DefaultNodeStyle())
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // https://stackoverflow.com/questions/728372/when-is-layoutsubviews-called
    public override func layoutSubviews() {
        super.layoutSubviews()

        _ = paletteScene
    }

    /// Use if you want to update the colors being shown in the view.
    public func update(withColors colors: [PaletteColor], selectedColor: PaletteColor? = nil) {
        guard paletteManager.colors != colors else { return }

        paletteManager.selectedColor = selectedColor
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