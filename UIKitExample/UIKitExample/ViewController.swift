// Kevin Li - 4:58 PM - 7/30/20

import ElegantColorPalette
import UIKit

class ViewController: UIViewController {

    var segmentedControl: PaletteSegmentedControl!
    var paletteView: ColorPaletteView!
    var selectedColor: PaletteColor?

    override func viewDidLoad() {
        super.viewDidLoad()

        let headerLabel = UILabel.header

        let separator = UIView.separator
        segmentedControl = PaletteSegmentedControl.palettes
        segmentedControl.delegate = self

        paletteView = ColorPaletteView(colors: PaletteColor.allColors)
            .didSelectColor { [unowned self] color in
                self.selectedColor = color
            }
        paletteView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(headerLabel)
        view.addSubview(separator)
        view.addSubview(paletteView)
        view.addSubview(segmentedControl)

        headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true

        separator.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        separator.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        separator.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true

        segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        segmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true

        paletteView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        paletteView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        paletteView.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
        paletteView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

}

extension ViewController: PaletteSegmentedControlDelegate {

    func change(to index: Int) {
        paletteView
            .nodeStyle((index == 0) ? DefaultNodeStyle() : CustomNodeStyle())
            .update(withColors: (index == 0) ? PaletteColor.allColors : PaletteColor.allBwColors, selectedColor: selectedColor)
    }

}

private extension UILabel {

    static var header: UILabel {
        let label = UILabel()
        label.text = "THEMES"
        label.font = .preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

}

private extension UIView {

    static var separator: UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        view.alpha = 0.3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

}

private extension PaletteSegmentedControl {

    static var palettes: PaletteSegmentedControl {
        let control = PaletteSegmentedControl(frame: .zero)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }

}

struct CustomNodeStyle: NodeStyle {

    func apply(configuration: Configuration) -> ColorNode {
        configuration.defaultStyledNode
            .radius(35)
            .font(name: "Thonburi")
    }

}

//struct SwiftUIExampleView: View {
//
//    @State private var selectedPalette: PaletteSelection = .color
//    @State private var selectedColor: PaletteColor? = nil
//
//    var body: some View {
//        VStack(spacing: 0) {
//            headerView
//                .padding(.bottom, 20)
//            separatorView
//            paletteWithSegmentedView
//                .edgesIgnoringSafeArea(.bottom)
//        }
//        .padding(.top, 32)
//    }
//
//}
//
//private extension SwiftUIExampleView {
//
//    var headerView: some View {
//        Text("THEMES")
//            .font(.headline)
//            .tracking(2)
//    }
//
//    var separatorView: some View {
//        Rectangle()
//            .fill(Color.gray)
//            .opacity(0.3)
//            .frame(height: 1)
//            .padding(.horizontal, 32)
//    }
//
//    var paletteWithSegmentedView: some View {
//        ZStack(alignment: .top) {
//            paletteView
//            paletteSegmentedView
//        }
//    }
//
//    var paletteSegmentedView: some View {
//        PaletteSegmentedView(selectedPalette: $selectedPalette,
//                             selectedColor: selectedColor)
//    }
//
//    var paletteView: some View {
//        ColorPaletteDynamicView(
//            colors: isColorPaletteSelected ? PaletteColor.allColors : PaletteColor.allBwColors,
//            selectedColor: $selectedColor)
//            .didSelectColor { print($0) }
//            .nodeStyle(isColorPaletteSelected ? DefaultNodeStyle() : CustomNodeStyle())
//    }
//
//    var isColorPaletteSelected: Bool {
//        selectedPalette == .color
//    }
//
//}
//

//struct PaletteSegmentedView: View {
//
//    @Binding var selectedPalette: PaletteSelection
//    let selectedColor: PaletteColor?
//
//    var body: some View {
//        HStack(spacing: 16) {
//            PaletteView(selectedPalette: $selectedPalette, palette: .color, selectedColor: selectedColor)
//            PaletteView(selectedPalette: $selectedPalette, palette: .bw, selectedColor: selectedColor)
//        }.backgroundPreferenceValue(PalettePreferenceKey.self) { preferences in
//            GeometryReader { geometry in
//                self.createUnderline(geometry, preferences)
//                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
//            }
//        }
//    }
//
//    private func createUnderline(_ geometry: GeometryProxy, _ preferences: [PalettePreferenceData]) -> some View {
//        let p = preferences.first(where: { $0.palette == self.selectedPalette })
//
//        let bounds = p != nil ? geometry[p!.bounds] : .zero
//
//        return Rectangle()
//            .fill(selectedColor?.color ?? .gray)
//            .frame(width: bounds.size.width, height: 1)
//            // offset to maxY to get the underline effect
//            .offset(x: bounds.minX, y: bounds.maxY)
//    }
//
//}
//
//struct PaletteView: View {
//
//    @Binding var selectedPalette: PaletteSelection
//
//    let palette: PaletteSelection
//    let selectedColor: PaletteColor?
//
//    private var isPaletteSelected: Bool {
//        selectedPalette == palette
//    }
//
//    private var paletteColor: Color {
//        isPaletteSelected ? (selectedColor?.color ?? .gray) : .gray
//    }
//
//    var body: some View {
//        Text(palette.rawValue)
//            .font(.system(size: 13, weight: .semibold))
//            .tracking(1)
//            .foregroundColor(paletteColor)
//            .opacity(isPaletteSelected ? 1 : 0.5)
//            .padding(.top, 20)
//            .padding(.bottom, 2)
//            .contentShape(Rectangle())
//            .anchorPreference(
//                key: PalettePreferenceKey.self,
//                value: .bounds,
//                transform: {
//                    [PalettePreferenceData(palette: self.palette,
//                                           bounds: $0)]
//                }
//            )
//            .onTapGesture(perform: setSelectedPalette)
//    }
//
//    private func setSelectedPalette() {
//        withAnimation(.easeInOut) {
//            selectedPalette = palette
//        }
//    }
//
//}
//
//// https://swiftui-lab.com/communicating-with-the-view-tree-part-2/
//struct PalettePreferenceKey: PreferenceKey {
//
//    typealias Value = [PalettePreferenceData]
//
//    static var defaultValue: [PalettePreferenceData] = []
//
//    static func reduce(value: inout [PalettePreferenceData], nextValue: () -> [PalettePreferenceData]) {
//        value.append(contentsOf: nextValue())
//    }
//
//}
//
//struct PalettePreferenceData {
//
//    let palette: PaletteSelection
//    let bounds: Anchor<CGRect>
//
//}
