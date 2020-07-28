// Kevin Li - 2:37 PM - 7/26/20

import SwiftUI
import UIKit

public struct PaletteColor: Equatable {

    public let name: String
    public let uiColor: UIColor

    public init(name: String, uiColor: UIColor) {
        self.name = name
        self.uiColor = uiColor
    }

    // TODO: add support for SwiftUI `Color`?

}

public extension PaletteColor {

    static let allColors: [PaletteColor] = [
        .antwerpBlue,
        .arcticBlue,
        .bonoboGreen,
        .brilliantViolet,
        .cadiumOrange,
        .fluorescentPink,
        .kiwiGreen,
        .kraftBrown,
        .mauvePurple,
        .orangeYellow,
        .oxideGreen,
        .peachBlossomPink,
        .red,
        .royalBlue,
        .scarletRed,
        .skyBlue,
        .sunflowerYellow,
        .underwaterBlue,
        .wednesdayPink,
    ]

    static let allBwColors: [PaletteColor] = [
        .bonoboGrey,
        .lunaBlack,
        .pebbleGrey,
        .white
    ]

}

public extension PaletteColor {

    static let antwerpBlue = PaletteColor(name: "Antwerp Blue", uiColor: .antwerpBlue)
    static let arcticBlue = PaletteColor(name: "Arctic Blue", uiColor: .arcticBlue)
    static let bonoboGreen = PaletteColor(name: "Bonobo Green", uiColor: .bonoboGreen)
    static let brilliantViolet = PaletteColor(name: "Brilliant Violet", uiColor: .brilliantViolet)
    static let cadiumOrange = PaletteColor(name: "Cadium Orange", uiColor: .cadiumOrange)
    static let fluorescentPink = PaletteColor(name: "Fluorescent Pink", uiColor: .fluorescentPink)
    static let kiwiGreen = PaletteColor(name: "Kiwi Green", uiColor: .kiwiGreen)
    static let kraftBrown = PaletteColor(name: "Kraft Brown", uiColor: .kraftBrown)
    static let mauvePurple = PaletteColor(name: "Mauve Purple", uiColor: .mauvePurple)
    static let orangeYellow = PaletteColor(name: "Orange Yellow", uiColor: .orangeYellow)
    static let oxideGreen = PaletteColor(name: "Oxide Green", uiColor: .oxideGreen)
    static let peachBlossomPink = PaletteColor(name: "Peach Blossom Pink", uiColor: .peachBlossomPink)
    static let red = PaletteColor(name: "Red", uiColor: .red)
    static let royalBlue = PaletteColor(name: "Royal Blue", uiColor: .royalBlue)
    static let scarletRed = PaletteColor(name: "Scarlet Red", uiColor: .scarletRed)
    static let seaweedGreen = PaletteColor(name: "Seaweed Green", uiColor: .seaweedGreen)
    static let skyBlue = PaletteColor(name: "Sky Blue", uiColor: .skyBlue)
    static let sunflowerYellow = PaletteColor(name: "Sunflower Yellow", uiColor: .sunflowerYellow)
    static let underwaterBlue = PaletteColor(name: "Underwater Blue", uiColor: .underwaterBlue)
    static let wednesdayPink = PaletteColor(name: "Wednesday Pink", uiColor: .wednesdayPink)

    static let bonoboGrey = PaletteColor(name: "Bonobo Grey", uiColor: .bonoboGrey)
    static let lunaBlack = PaletteColor(name: "Luna Black", uiColor: .lunaBlack)
    static let pebbleGrey = PaletteColor(name: "Pebble Grey", uiColor: .pebbleGrey)
    static let white = PaletteColor(name: "White", uiColor: .white)

}

private extension UIColor {

    static let antwerpBlue = UIColor(red: 17, green: 110, blue: 176)
    static let arcticBlue = UIColor(red: 149, green: 174, blue: 200)
    static let bonoboGreen = UIColor(red: 24, green: 147, blue: 120)
    static let brilliantViolet = UIColor(red: 69, green: 58, blue: 146)
    static let cadiumOrange = UIColor(red: 208, green: 64, blue: 24)
    static let fluorescentPink = UIColor(red: 185, green: 22, blue: 77)
    static let kiwiGreen = UIColor(red: 117, green: 142, blue: 41)
    static let kraftBrown = UIColor(red: 168, green: 136, blue: 99)
    static let mauvePurple = UIColor(red: 148, green: 42, blue: 115)
    static let orangeYellow = UIColor(red: 219, green: 135, blue: 41)
    static let oxideGreen = UIColor(red: 22, green: 128, blue: 83)
    static let peachBlossomPink = UIColor(red: 177, green: 131, blue: 121)
    static let red = UIColor(red: 177, green: 32, blue: 28)
    static let royalBlue = UIColor(red: 24, green: 83, blue: 149)
    static let scarletRed = UIColor(red: 149, green: 3, blue: 42)
    static let seaweedGreen = UIColor(red: 80, green: 127, blue: 129)
    static let skyBlue = UIColor(red: 72, green: 147, blue: 175)
    static let sunflowerYellow = UIColor(red: 196, green: 151, blue: 51)
    static let underwaterBlue = UIColor(red: 25, green: 142, blue: 152)
    static let wednesdayPink = UIColor(red: 179, green: 102, blue: 159)

    static let bonoboGrey = UIColor(red: 40, green: 66, blue: 73)
    static let lunaBlack = UIColor(red: 24, green: 29, blue: 32)
    static let pebbleGrey = UIColor(red: 140, green: 140, blue: 122)
    static let white = UIColor(red: 245, green: 250, blue: 250)

}

fileprivate extension UIColor {

    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }

}
