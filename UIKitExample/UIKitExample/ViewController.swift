// Kevin Li - 4:58 PM - 7/30/20

import Combine
import ElegantColorPalette
import UIKit

class ViewController: UIViewController {

    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "THEMES"
        label.font = .preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var separatorView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        view.alpha = 0.3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var segmentedControl: PaletteSegmentedControl = {
        let control = PaletteSegmentedControl(frame: .zero)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    // TODO: should figure out way to use this in storyboard
    private lazy var paletteView: ColorPaletteView = {
        let paletteView = ColorPaletteView(colors: PaletteColor.allColors)
        paletteView.translatesAutoresizingMaskIntoConstraints = false
        return paletteView
    }()

    private let selectedColor = CurrentValueSubject<PaletteColor?, Never>(nil)

    private var cancellable: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()

        paletteView
            .didSelectColor { [unowned self] color in
                self.selectedColor.send(color)
            }

        view.addSubview(headerLabel)
        headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        view.addSubview(separatorView)
        separatorView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20).isActive = true
        separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        view.addSubview(paletteView)
        paletteView.topAnchor.constraint(equalTo: separatorView.bottomAnchor).isActive = true
        paletteView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        paletteView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        paletteView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        view.addSubview(segmentedControl)
        segmentedControl.topAnchor.constraint(equalTo: separatorView.bottomAnchor).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: headerLabel.centerXAnchor).isActive = true

        cancellable = segmentedControl.selectedPalette
            .dropFirst()
            .sink { [unowned self] selection in
                self.updatePaletteView(to: selection)
            }
    }

    private func updatePaletteView(to selection: PaletteSelection) {
        paletteView
            .nodeStyle((selection == .color) ? DefaultNodeStyle() : CustomNodeStyle())
            .update(withColors: (selection == .color) ? PaletteColor.allColors : PaletteColor.allBwColors,
                    selectedColor: selectedColor.value)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        segmentedControl.bind(to: selectedColor.eraseToAnyPublisher())
    }

}

struct CustomNodeStyle: NodeStyle {

    func apply(configuration: Configuration) -> ColorNode {
        configuration.defaultStyledNode
            .radius(35)
            .font(name: "Thonburi")
    }

}
