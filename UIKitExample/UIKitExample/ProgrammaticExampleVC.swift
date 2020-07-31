// Kevin Li - 4:58 PM - 7/30/20

import Combine
import ElegantColorPalette
import UIKit

class ProgrammaticExampleVC: UIViewController {

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

    private lazy var paletteView: ColorPaletteView = {
        let paletteView = ColorPaletteView(colors: PaletteColor.allColors)
        paletteView.translatesAutoresizingMaskIntoConstraints = false
        return paletteView
    }()

    private let selectedColor = CurrentValueSubject<PaletteColor?, Never>(nil)

    private var cancellable: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(separatorView)
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        view.addSubview(paletteView)
        NSLayoutConstraint.activate([
            paletteView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            paletteView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            paletteView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            paletteView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.addSubview(segmentedControl)
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            segmentedControl.centerXAnchor.constraint(equalTo: headerLabel.centerXAnchor)
        ])

        paletteView
            .didSelectColor { [unowned self] color in
                self.selectedColor.send(color)
            }
        
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
