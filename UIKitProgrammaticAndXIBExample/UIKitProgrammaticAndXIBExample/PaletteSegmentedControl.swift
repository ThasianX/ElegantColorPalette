// Kevin Li - 5:10 PM - 7/30/20

import Combine
import ElegantColorPalette
import UIKit

enum PaletteSelection: Int {
    case color = 4
    case bw = 5

    var name: String {
        switch self {
        case .color:
            return "COLOR"
        case .bw:
            return "B&W"
        }
    }
}

class PaletteSegmentedControl: UIView {

    private lazy var segmentedStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [button(for: .color), button(for: .bw)])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private func button(for palette: PaletteSelection) -> UIButton {
        let button = UIButton(type: .system)
        button.contentEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 2, right: 0)
        button.setTitle(palette.name, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.tag = palette.rawValue
        button.addTarget(self, action:#selector(paletteTapped), for: .touchUpInside)
        button.setTitleColor(.gray, for: .normal)
        return button
    }

    private var selectorView = UIView()

    let selectedPalette = CurrentValueSubject<PaletteSelection, Never>(.color)

    private var cancellable: AnyCancellable?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .clear
        addSubview(selectorView)
        configureSegmentedStack()
    }

    private func configureSegmentedStack() {
        addSubview(segmentedStack)
        segmentedStack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        segmentedStack.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        segmentedStack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        segmentedStack.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }

    func bind(to colorPublisher: AnyPublisher<PaletteColor?, Never>) {
        selectionChanged(.bw, .color, animated: false)
        cancellable = colorPublisher.sink { [unowned self] selectedColor in
            self.updateSelectedButtonAndSelectorColor(selectedColor?.uiColor ?? .gray)
        }
    }

    private func updateSelectedButtonAndSelectorColor(_ color: UIColor) {
        selectorView.backgroundColor = color
        if let selectedButton = viewWithTag(selectedPalette.value.rawValue) as? UIButton {
            selectedButton.setTitleColor(color, for: .normal)
        }
    }

    @objc private func paletteTapped(sender: UIButton) {
        guard let selection = PaletteSelection(rawValue: sender.tag),
            selection != selectedPalette.value
        else { return }

        selectionChanged(selectedPalette.value, selection)
        selectedPalette.send(selection)
    }

    private func selectionChanged(_ oldSelection: PaletteSelection, _ newSelection: PaletteSelection, animated: Bool = true) {
        guard let previousButton = segmentedStack.viewWithTag(oldSelection.rawValue) as? UIButton else { return }
        guard let selectedButton = segmentedStack.viewWithTag(newSelection.rawValue) as? UIButton else { return }

        let newPosition = selectedButton.frame.minX + selectedButton.titleLabel!.frame.minX
        let newWidth = selectedButton.titleLabel!.frame.width

        let action = { [unowned self] in
            previousButton.alpha = 0.5
            selectedButton.alpha = 1

            self.selectorView.frame = CGRect(x: newPosition, y: self.frame.height, width: newWidth, height: 1)
            selectedButton.setTitleColor(previousButton.titleLabel!.textColor, for: .normal)
            previousButton.setTitleColor(.gray, for: .normal)
        }

        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: action)
        } else {
            action()
        }
    }

}
