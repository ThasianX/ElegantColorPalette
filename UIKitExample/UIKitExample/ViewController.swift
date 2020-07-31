// Kevin Li - 4:58 PM - 7/30/20

import Combine
import ElegantColorPalette
import UIKit

class ViewController: UIViewController {

    var segmentedControl: PaletteSegmentedControl!
    var paletteView: ColorPaletteView!
    var selectedColor = CurrentValueSubject<PaletteColor?, Never>(nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        let headerLabel = UILabel.header

        let separator = UIView.separator
        segmentedControl = PaletteSegmentedControl()
        segmentedControl.delegate = self

        paletteView = ColorPaletteView(colors: PaletteColor.allColors)
            .didSelectColor { [unowned self] color in
                self.selectedColor.send(color)
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

        segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true

        paletteView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        paletteView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        paletteView.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
        paletteView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        segmentedControl.configSelectorView(colorPublisher: selectedColor.eraseToAnyPublisher())
    }

}

extension ViewController: PaletteSegmentedControlDelegate {

    func paletteSelectionChanged(to selection: PaletteSelection) {
        paletteView
            .nodeStyle((selection == .color) ? DefaultNodeStyle() : CustomNodeStyle())
            .update(withColors: (selection == .color) ? PaletteColor.allColors : PaletteColor.allBwColors, selectedColor: selectedColor.value)
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

struct CustomNodeStyle: NodeStyle {

    func apply(configuration: Configuration) -> ColorNode {
        configuration.defaultStyledNode
            .radius(35)
            .font(name: "Thonburi")
    }

}
