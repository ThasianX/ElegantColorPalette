// Kevin Li - 3:00 PM - 7/26/20

import SwiftUI

enum PaletteSelection {
    case color
    case bw
}

struct SwiftUIExampleView: View {

    @State private var paletteSelection: PaletteSelection = .color
    @State private var selectedColor: PaletteColor? = nil

    private var isColorPaletteSelected: Bool {
        paletteSelection == .color
    }

    var body: some View {
        VStack {
            headerView
            separatorView
            paletteWithSegmentedView
        }
        .padding(.top, 32)
    }

}

private extension SwiftUIExampleView {

    var headerView: some View {
        Text("SwiftUI Example")
            .font(.title)
    }

    var separatorView: some View {
        Rectangle()
            .fill(Color.gray)
            .frame(height: 0.5)
            .padding(.horizontal, 16)
    }

    var paletteWithSegmentedView: some View {
        ZStack(alignment: .top) {
            paletteView
            paletteSegmentedView
        }
    }

    // TODO: add the underline effect that also switches depending on which is selected. use geometryreader
    var paletteSegmentedView: some View {
        HStack(spacing: 16) {
            Text("COLOR")
                .foregroundColor(isColorPaletteSelected ? selectedColor?.uiColor.asColor ?? .gray : .gray)
                .onTapGesture {
                    self.setSelectedPalette(to: .color)
                }
            Text("B&W")
                .foregroundColor(isColorPaletteSelected ? .gray : selectedColor?.uiColor.asColor ?? .gray)
                .onTapGesture {
                    self.setSelectedPalette(to: .bw)
                }
        }
        .font(.subheadline)
    }

    func setSelectedPalette(to palette: PaletteSelection) {
        paletteSelection = palette
    }

    // TODO: make this view match timepage
    var paletteView: some View {
        ColorPaletteDynamicView(colors: colors, selectedColor: $selectedColor)
            .edgesIgnoringSafeArea(.bottom)
    }

    var colors: [PaletteColor] {
        isColorPaletteSelected ? PaletteColor.allColors : PaletteColor.allBwColors
    }

}

struct SwiftUIExampleView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIExampleView()
    }
}
