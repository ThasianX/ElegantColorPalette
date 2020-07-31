// Kevin Li - 5:10 PM - 7/30/20

import Combine
import ElegantColorPalette
import UIKit

enum PaletteSelection: Int {
    case color
    case bw

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

    private var buttons = [UIButton]()
    private var selectorView: UIView!

    let selectedPalette = CurrentValueSubject<PaletteSelection, Never>(.color)

    private var cancellable: AnyCancellable?

    init() {
        super.init(frame: .zero)
        setUpView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpView() {
        createButtons()
        configStackView()
    }

    private func createButtons() {
        createButton(for: .color)
        createButton(for: .bw)
    }

    private func createButton(for palette: PaletteSelection) {
        let button = UIButton(type: .system)
        button.contentEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 2, right: 0)
        button.setTitle(palette.name, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.tag = palette.rawValue
        button.addTarget(self, action:#selector(PaletteSegmentedControl.buttonAction), for: .touchUpInside)
        button.setTitleColor(.gray, for: .normal)
        buttons.append(button)
    }

    private func configStackView() {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 16
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }

    func configSelectorView(colorPublisher: AnyPublisher<PaletteColor?, Never>) {
        let selectedWidth = buttons[0].titleLabel!.bounds.size.width
        selectorView = UIView(frame: CGRect(x: buttons[0].titleLabel!.frame.minX, y: frame.height, width: selectedWidth, height: 1))
        addSubview(selectorView)

        buttons[1].alpha = 0.5

        cancellable = colorPublisher.sink { [unowned self] selectedColor in
            self.selectorView.backgroundColor = selectedColor?.uiColor ?? .gray
            self.buttons[self.selectedPalette.value.rawValue].setTitleColor(selectedColor?.uiColor ?? .gray, for: .normal)
        }
    }

    @objc func buttonAction(sender: UIButton) {
        guard let selection = PaletteSelection(rawValue: sender.tag), selection != selectedPalette.value else { return }
        selectedPalette.send(selection)

        switch selectedPalette.value {
        case .color:
            buttons[1].alpha = 0.5
            buttons[0].alpha = 1
            let bwPosition = buttons[0].titleLabel!.frame.minX
            let bwWidth = buttons[0].titleLabel!.frame.width
            UIView.animate(withDuration: 0.3) {
                self.selectorView.frame = CGRect(x: bwPosition, y: self.frame.height, width: bwWidth, height: 1)
                self.buttons[0].setTitleColor(self.buttons[1].titleLabel?.textColor, for: .normal)
                self.buttons[1].setTitleColor(.gray, for: .normal)
            }
        case .bw:
            buttons[0].alpha = 0.5
            buttons[1].alpha = 1
            let bwPosition = buttons[1].frame.minX + buttons[1].titleLabel!.frame.minX
            let bwWidth = buttons[1].titleLabel!.frame.width
            UIView.animate(withDuration: 0.3) {
                self.selectorView.frame = CGRect(x: bwPosition, y: self.frame.height, width: bwWidth, height: 1)
                self.buttons[1].setTitleColor(self.buttons[0].titleLabel?.textColor, for: .normal)
                self.buttons[0].setTitleColor(.gray, for: .normal)
            }
        }
    }

}
