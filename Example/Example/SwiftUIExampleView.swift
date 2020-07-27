// Kevin Li - 3:00 PM - 7/26/20

import SwiftUI

enum PaletteSelection {
    case color
    case bw
}

struct SwiftUIExampleView: View {

    @State private var paletteSelection: PaletteSelection = .color

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

    private var headerView: some View {
        Text("SwiftUI Example")
            .font(.title)
    }

    private var separatorView: some View {
        Rectangle()
            .fill(Color.gray)
            .frame(height: 0.5)
            .padding(.horizontal, 16)
    }

    private var paletteWithSegmentedView: some View {
        ZStack(alignment: .top) {
            paletteView
            paletteSegmentedView
        }
    }

    private var paletteSegmentedView: some View {
        HStack(spacing: 16) {
            Text("COLOR")
                .foregroundColor(isColorPaletteSelected ? .red : .gray)
                .onTapGesture {
                    self.setSelectedPalette(to: .color)
                }
            Text("B&W")
                .foregroundColor(isColorPaletteSelected ? .gray : .red)
                .onTapGesture {
                    self.setSelectedPalette(to: .bw)
                }
        }
        .font(.subheadline)
    }

    private func setSelectedPalette(to palette: PaletteSelection) {
        paletteSelection = palette
    }

    private var paletteView: some View {
        Group {
            if isColorPaletteSelected {
                ColorPaletteDynamicView()
            } else {
                ColorPaletteDynamicView()
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }

}

struct SwiftUIExampleView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIExampleView()
    }
}

