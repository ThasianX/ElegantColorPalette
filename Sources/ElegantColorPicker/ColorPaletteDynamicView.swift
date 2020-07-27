// Kevin Li - 6:20 PM - 7/26/20

import SwiftUI

public struct ColorPaletteDynamicView: UIViewRepresentable {

    public typealias UIViewType = ColorPaletteView

    // TODO: add like @state options or create a `View` to uses this wrapper

    public let colors: [PaletteColor]

    public init(colors: [PaletteColor]) {
        self.colors = colors
    }

    public func makeUIView(context: Context) -> ColorPaletteView {
        ColorPaletteView(colors: colors)
    }

    public func updateUIView(_ uiView: ColorPaletteView, context: Context) {}

}
