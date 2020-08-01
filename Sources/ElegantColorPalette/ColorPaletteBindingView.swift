// Kevin Li - 6:20 PM - 7/26/20

import SwiftUI

public struct ColorPaletteBindingView: UIViewRepresentable {

    public typealias UIViewType = ColorPaletteView

    let colors: [PaletteColor]
    @Binding var selectedColor: PaletteColor?

    var didSelectColor: ((PaletteColor) -> Void)?
    var nodeStyle: NodeStyle = DefaultNodeStyle()

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

    private func groupedCallback(_ color: PaletteColor) {
        bindingCallback(color)
        didSelectColor?(color)
    }

    private func bindingCallback(_ color: PaletteColor) {
        DispatchQueue.main.async {
            self.selectedColor = color
        }
    }

    public func updateUIView(_ uiView: ColorPaletteView, context: Context) {
        uiView
            .didSelectColor(groupedCallback)
            .nodeStyle(nodeStyle)
            .update(withColors: colors, selectedColor: selectedColor)
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
    /// - Important: If you want to retain the default styling of the node while adding more on, make sure to apply your styling to  `configuration.defaultStyledNode` in the `makeBody` of your  custom `NodeStyle`.
    /// - Parameter style: the style applied to each node during state changes
    public func nodeStyle(_ style: NodeStyle) -> Self {
        mutating(keyPath: \.nodeStyle, value: style)
    }

}
