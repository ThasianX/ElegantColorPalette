// Kevin Li - 3:00 PM - 7/26/20

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
            .frame(height: 0.5)
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
        ColorPaletteDynamicView(
            colors: (selectedPalette == .color) ? PaletteColor.allColors : PaletteColor.allBwColors,
            selectedColor: $selectedColor)
    }

}

struct SwiftUIExampleView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIExampleView()
    }
}
