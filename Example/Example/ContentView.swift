// Kevin Li - 3:00 PM - 7/26/20

import SwiftUI

struct ContentView: View {
    var body: some View {
        ElegantPaletteDynamicView()
            .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ElegantPaletteDynamicView: View {

    var body: some View {
        GeometryReader { geometry in
            ElegantPaletteWrapper(frame: geometry.frame(in: .global))
        }
    }

}

struct ElegantPaletteWrapper: UIViewRepresentable {

    typealias UIViewType = ColorPaletteView

    let frame: CGRect

    func makeUIView(context: Context) -> ColorPaletteView {
        ColorPaletteView(frame: frame)
    }

    func updateUIView(_ uiView: ColorPaletteView, context: Context) {

    }

}
