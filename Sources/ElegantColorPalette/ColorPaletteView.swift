// Kevin Li - 2:46 PM - 7/26/20

import SpriteKit
import UIKit

/// `ColorPaletteView` is a view built on top of SpriteKit. Given a `selectedColor` and some `PaletteColors`,
/// this view will create a scene to display a handful of nodes representing colors. The nodes are easily customizable through `NodeStyle`.
///
/// # Example #
///
///     ColorPaletteView(
///        colors: PaletteColor.allColors,
///        selectedColor: selectedColor)
///         .didSelectColor { self.selectedColor = $0 }
///         .nodeStyle(CustomNodeStyle())
///
public class ColorPaletteView: SKView {

    private lazy var paletteScene: ColorPaletteScene = {
        let scene = ColorPaletteScene(paletteManager: paletteManager)
        scene.scaleMode = .resizeFill
        scene.anchorPoint = .init(x: 0.5, y: 0.5)
        presentScene(scene)
        return scene
    }()

    private let paletteManager: ColorPaletteManager

    /// Initializes a new `ColorPaletteView`.
    ///
    /// - Parameter colors: Array of `PaletteColor` to populate the view.
    /// - Parameter selectedColor: The initial selected `PaletteColor`.
    public init(colors: [PaletteColor], selectedColor: PaletteColor? = nil) {
        paletteManager = ColorPaletteManager(colors: colors, selectedColor: selectedColor)
        super.init(frame: .zero)
        commonInit()
    }

    /// Initializes an empty `ColorPaletteView`.
    ///
    /// Make sure to call `update(colors:selectedColor)` to populate the view with colors before showing it.
    /// - Parameter frame: The frame rectangle for the view, measured in points.
    override init(frame: CGRect) {
        paletteManager = ColorPaletteManager(colors: [], selectedColor: nil)
        super.init(frame: frame)
        commonInit()
    }

    /// Initializes an empty `ColorPaletteView`.
    ///
    /// Make sure to call `update(colors:selectedColor)` to populate the view with colors before showing it.
    /// - Parameter coder: The unarchiver object.
    required init?(coder: NSCoder) {
        paletteManager = ColorPaletteManager(colors: [], selectedColor: nil)
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        allowsTransparency = true
        backgroundColor = .clear
        isExclusiveTouch = true
//        gestureRecognizers?.forEach { $0.cancelsTouchesInView = false }
    }

    // https://stackoverflow.com/questions/728372/when-is-layoutsubviews-called
    public override func layoutSubviews() {
        super.layoutSubviews()

        _ = paletteScene
    }

    /// Updates the current view with new colors.
    ///
    /// - Warning: This will cause a total refresh meaning that all existing nodes will be removed and new nodes will be added.
    /// - Parameter colors: Array of `PaletteColor` to populate the view.
    /// - Parameter selectedColor: The initial selected `PaletteColor`.
    public func update(withColors colors: [PaletteColor], selectedColor: PaletteColor? = nil) {
        guard paletteManager.colors != colors else { return }

        paletteManager.resetSelectedColorBinding(selectedColor)
        paletteManager.colors = colors
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        paletteManager.activeColorScheme = traitCollection.userInterfaceStyle
    }

}

public extension ColorPaletteView {

    /// Adds a callback to react to whenever a new color is selected
    ///
    /// Use this if you want to track the `selectedColor` or execute other actions whenever a new color is selected.
    /// - Parameter callback: block to be called when `selectedColor` changes
    @discardableResult
    func didSelectColor(_ callback: ((PaletteColor) -> Void)?) -> Self {
        paletteManager.didSelectColor = callback
        return self
    }

    /// Configures the style of each node.
    ///
    /// Use this if you want to further customize the node.
    /// - Important: If you want to retain the default styling of the node while adding more on, make sure to apply your styling to  `configuration.defaultStyledNode` in the `updateNode` of your  custom `NodeStyle`.
    /// - Parameter style: the style applied to each node during state changes
    @discardableResult
    func nodeStyle(_ style: NodeStyle) -> Self {
        paletteManager.nodeStyle = style
        return self
    }

}
