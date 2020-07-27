// Kevin Li - 6:20 PM - 7/26/20

import SpriteKit
import SwiftUI

public struct ColorPaletteDynamicView: View {

    public var body: some View {
        GeometryReader { geometry in
            ColorPaletteWrapper(frame: geometry.frame(in: .global))
        }
    }

}

private struct ColorPaletteWrapper: UIViewRepresentable {

    typealias UIViewType = ColorPaletteView

    let frame: CGRect

    func makeUIView(context: Context) -> ColorPaletteView {
        ColorPaletteView(frame: frame)
    }

    func updateUIView(_ uiView: ColorPaletteView, context: Context) {
        // TODO: add logic to update frame in here. important part is adding logic to the actual scene view itself
    }

}
