// Kevin Li - 3:00 PM - 7/26/20

import ElegantColorPalette
import SwiftUI

enum PaletteSelection: String {
    case color = "COLOR"
    case bw = "B&W"
}

struct SwiftUIExampleView: View {

    @State private var selectedPalette: PaletteSelection = .color
    @State private var selectedColor: PaletteColor? = nil

    var body: some View {
        VStack(spacing: 0) {
            headerView
                .padding(.bottom, 20)
            separatorView
            paletteWithSegmentedView
                .edgesIgnoringSafeArea(.bottom)
        }
        .padding(.top, 32)
    }

}

private extension SwiftUIExampleView {

    var headerView: some View {
        Text("THEMES")
            .font(.headline)
            .tracking(2)
    }

    var separatorView: some View {
        Rectangle()
            .fill(Color.gray)
            .opacity(0.3)
            .frame(height: 1)
            .padding(.horizontal, 32)
    }

    var paletteWithSegmentedView: some View {
        ZStack(alignment: .top) {
            paletteView
            paletteSegmentedView
        }
    }

    var paletteSegmentedView: some View {
        PaletteSegmentedView(selectedPalette: $selectedPalette,
                             selectedColor: selectedColor)
    }

    var paletteView: some View {
        ColorPaletteBindingView(
            selectedColor: $selectedColor,
            colors: isColorPaletteSelected ? PaletteColor.allColors : PaletteColor.allBwColors)
            .didSelectColor { print($0.name) }
            .nodeStyle(isColorPaletteSelected ? DefaultNodeStyle() : CustomNodeStyle())
    }

    var isColorPaletteSelected: Bool {
        selectedPalette == .color
    }

}

struct CustomNodeStyle: NodeStyle {

    func updateNode(configuration: Configuration) -> ColorNode {
        configuration.defaultStyledNode
            .radius(30)
            .font(name: "Thonburi")
    }

}

struct SwiftUIExampleView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIExampleView()
    }
}
