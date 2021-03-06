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

    public lazy var paletteScene: ColorPaletteScene = {
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
        isUserInteractionEnabled = true
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

// MARK: Public Methods
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

    /// Configures the focus settings.
    ///
    /// Focusing is when a node is tapped and snapped towards a certain location.
    ///
    /// - Parameter location: the location to focus to. (0, 0) represents the center of your view.
    /// - Parameter speed: the speed the node should travel to its focused location
    /// - Parameter rate: the smoothing rate of the focus animation. 1 -> entirely responsive.
    ///     0 -> entirely unresponsive. This has to be a value between 0 and 1.
    @discardableResult
    func focus(location: CGPoint = .zero, speed: CGFloat = 1200, rate: CGFloat = 0.8) -> Self {
        paletteManager.focusSettings = FocusSettings(location: location,
                                                     speed: CGVector(dx: speed, dy: speed),
                                                     smoothingRate: rate)
        return self
    }

    /// Configures whether the focused node can be moved or not.
    ///
    /// - Parameter canMove: moveable or not - nodes that collide with the focused node will not move it either
    @discardableResult
    func canMoveFocusedNode(_ canMove: Bool) -> Self {
        paletteManager.canMoveFocusedNode = canMove
        return self
    }

    /// Configures the default spawn configuration settings.
    ///
    /// - Parameter widthRatio: the ratio of the scene width that a node should be able to spawn on. Value between 0-1
    /// - Parameter heightRatio: the ratio of the scene height that a node should be able to spawn on. Value between 0-1
    @discardableResult
    func spawnConfiguration(widthRatio: CGFloat = 1, heightRatio: CGFloat = 0.65) -> Self {
        paletteManager.spawnConfiguration = SpawnConfiguration(widthRatio: widthRatio, heightRatio: heightRatio)
        return self
    }

    /// Configures the default rotation multiplier of the nodes around the focus location.
    ///
    /// - Parameter multiplier: the factor by which the nodes should speed up their rotation. The higher, the faster.
    @discardableResult
    func rotation(multiplier: CGFloat = 1) -> Self {
        paletteManager.rotationMultiplier = multiplier
        return self
    }

}

// MARK: Internal Methods
extension ColorPaletteView {

    @discardableResult
    func focus(settings: FocusSettings) -> Self {
        paletteManager.focusSettings = settings
        return self
    }

    @discardableResult
    func spawnConfiguration(_ config: SpawnConfiguration) -> Self {
        paletteManager.spawnConfiguration = config
        return self
    }

}
