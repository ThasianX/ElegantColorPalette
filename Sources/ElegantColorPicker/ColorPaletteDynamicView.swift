// Kevin Li - 6:20 PM - 7/26/20

import SwiftUI

public struct ColorPaletteDynamicView: UIViewRepresentable {

    public typealias UIViewType = ColorPaletteView

    let colors: [PaletteColor]
    @Binding var selectedColor: PaletteColor?

    var didSelectColor: ((PaletteColor) -> Void)?

    public init(colors: [PaletteColor], selectedColor: Binding<PaletteColor?> = .constant(nil)) {
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
            .update(withColors: colors, selectedColor: selectedColor)
    }

}

extension ColorPaletteDynamicView: Buildable {

    public func didSelectColor(_ callback: ((PaletteColor) -> Void)?) -> Self {
        mutating(keyPath: \.didSelectColor, value: callback)
    }

}
