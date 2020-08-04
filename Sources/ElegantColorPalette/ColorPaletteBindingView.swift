// Kevin Li - 6:20 PM - 7/26/20

import SwiftUI

/// `ColorPaletteBindingView` is a SwiftUI wrapper view of `ColorPaletteView`. Given a `selectedColor` and some `PaletteColors`,
/// this view will create a scene to display a handful of nodes representing colors. The nodes are easily customizable through `NodeStyle`.
///
/// # Example #
///
///     ColorPaletteBindingView(
///         selectedColor: $selectedColor,
///         colors: PaletteColor.allColors)
///         .didSelectColor { print($0) }
///         .nodeStyle(CustomNodeStyle())
///
public struct ColorPaletteBindingView: UIViewRepresentable {

    public typealias UIViewType = ColorPaletteView

    let colors: [PaletteColor]
    @Binding var selectedColor: PaletteColor?

    var didSelectColor: ((PaletteColor) -> Void)?
    var nodeStyle: NodeStyle = DefaultNodeStyle()
    var focusSettings: FocusSettings = .default

    /// Initializes a new `ColorPaletteBindingView`.
    ///
    /// - Parameter selectedColor: Binding to the selected `PaletteColor`
    /// - Parameter colors: Array of `PaletteColor` to populate the view
    public init(selectedColor: Binding<PaletteColor?>, colors: [PaletteColor]) {
        self.colors = colors
        self._selectedColor = selectedColor
    }

    public func makeUIView(context: Context) -> ColorPaletteView {
        ColorPaletteView(colors: colors, selectedColor: selectedColor)
    }

    public func updateUIView(_ uiView: ColorPaletteView, context: Context) {
        uiView
            .didSelectColor(groupedCallback)
            .nodeStyle(nodeStyle)
            .focus(settings: focusSettings)
            .update(withColors: colors, selectedColor: selectedColor)
    }

    private func groupedCallback(_ color: PaletteColor) {
        bindingCallback(color)
        didSelectColor?(color)
    }

    private func bindingCallback(_ color: PaletteColor) {
        DispatchQueue.main.async {
            self.selectedColor = color
        }
    }

}

extension ColorPaletteBindingView: Buildable {

    /// Adds a callback to react to whenever a new color is selected
    ///
    /// Use this if you want to execute other actions whenever a new color is selected.
    /// The `selectedColor` binding will still be updated with new colors.
    /// - Parameter callback: block to be called when `selectedColor` changes
    public func didSelectColor(_ callback: ((PaletteColor) -> Void)?) -> Self {
        mutating(keyPath: \.didSelectColor, value: callback)
    }

    /// Configures the style of each node.
    ///
    /// Use this if you want to further customize the node.
    /// - Important: If you want to retain the default styling of the node while adding more on, make sure to apply your styling to  `configuration.defaultStyledNode` in the `updateNode` of your  custom `NodeStyle`.
    /// - Parameter style: the style applied to each node during state changes
    public func nodeStyle(_ style: NodeStyle) -> Self {
        mutating(keyPath: \.nodeStyle, value: style)
    }

    /// Configures the focus settings.
    ///
    /// Focusing is when a node is tapped and snapped towards a certain location.
    ///
    /// - Parameter location: the location to focus to. (0, 0) represents the center of your view.
    /// - Parameter focusSpeed: the speed the node should travel to its focused location
    /// - Parameter focusRate: the smoothing rate of the focus animation. 1 -> entirely responsive.
    ///     0 -> entirely unresponsive. This has to be a value between 0 and 1.
    @discardableResult
    public func focus(location: CGPoint = .zero, focusSpeed: CGFloat = 1200, focusRate: CGFloat = 0.8) -> Self {
        mutating(keyPath: \.focusSettings,
                 value: FocusSettings(location: location,
                                      speed: CGVector(dx: focusSpeed, dy: focusSpeed),
                                      smoothingRate: focusRate))
    }

}
