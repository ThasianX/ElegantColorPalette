# ElegantColorPalette

![platforms](https://img.shields.io/badge/platforms-iOS-blue.svg)
[![pod](https://img.shields.io/cocoapods/v/ElegantColorPalette.svg)](https://cocoapods.org/pods/ElegantColorPalette) 
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) 
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![License: MIT](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/ThasianX/ElegantColorPalette/blob/master/LICENSE)

The elegant color picker missed in UIKit and SwiftUI.

<img src="https://github.com/ThasianX/GIFs/blob/master/ElegantColorPalette/demo.gif" width="320"/>

This example GIF is from [ElegantTimeline](https://github.com/ThasianX/ElegantTimeline-SwiftUI). For a simpler demonstration, you can look at either of the 3 demo projects in this repository.

- [Introduction](#introduction)
- [Basic Usage](#basic-usage)
- [Customization](#customization)
- [Demos](#demos)
- [Requirements](#requirements)
- [Installation](#installation)
- [Contributing](#contributing)
- [License](#license)

## Introduction

`ElegantColorPalette` comes with 24 different themes and is inspired by [TimePage](https://us.moleskine.com/timepage/p0486) and is part of a larger repository of elegant demonstrations like this: [TimePage Clone](https://github.com/ThasianX/TimePage-Clone).

The top level view is an `SKView` that presents an `SKScene` of colors nodes. The color nodes are `SKShapeNode` subclasses. When using this library, you are only interacting with the `SKView`: all you have to do is configure the size of the view either through autolayout or size constraints and the view does the rest.

Features
* Dynamic color nodes - passing in a dynamic `UIColor` will allow the color node to properly adjust to light or dark mode
* Extensive node customizability - font name, font color, node color, node radius, and much more 
* Custom node animations - snapping, scaling, fading, highlighting, and much more
* Updating the color palette with new colors
* Portait and landscape support
* Extensively documentation - as you use the library, you'll notice documentation in XCode

## Basic usage

For SwiftUI: 

```swift

import ElegantColorPalette

struct ExampleSwiftUIView: View {

    @State private var selectedColor: PaletteColor = .kiwiGreen

    var body: some View {
        ColorPaletteBindingView(selectedColor: $selectedColor, colors: PaletteColor.allColors)
    }

}
```

For UIKit(programmatically):

```swift

import ElegantColorPalette

struct ExampleUIKitViewController: UIViewController {

    ...

    private lazy var paletteView: ColorPaletteView = {
        let paletteView = ColorPaletteView(colors: PaletteColor.allColors)
        paletteView.translatesAutoresizingMaskIntoConstraints = false
        return paletteView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ...
        
        view.addSubview(paletteView)
        NSLayoutConstraint.activate([
            ...
        ])

        paletteView
            .didSelectColor { [unowned self] color in
                ...
            }
    }

}
```

For UIKit(storyboard and XIB):

```swift

import ElegantColorPalette

struct ExampleUIKitViewController: UIViewController {

    ...
    
    @IBOutlet weak var paletteView: ColorPaletteView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ...
        
        paletteView
            .update(withColors: PaletteColor.allColors)
            .didSelectColor { [unowned self] color in
                ...
            }
    }

}
```

## Customization

### PaletteColor

[PaletteColor](https://github.com/ThasianX/ElegantColorPalette/blob/master/Sources/ElegantColorPalette/Helpers/Models/PaletteColor.swift) represents the color model of a single node.

```swift
public struct PaletteColor: Equatable {

    public let name: String
    public let uiColor: UIColor

    public var color: Color {
        uiColor.asColor
    }

}
```

As you aren't able to get a `UIColor` from a `Color` in iOS 13, you must initialize a `PaletteColor` using a `UIColor`. If you are supporting light and dark color themes, you will want to pass a dynamic `UIColor` either through the asset bundle or other methods like a computed property.

For SwiftUI users, `PaletteColor` exposes a `color` property for your convenience.

### Node Customization

Nodes are easily customizable through a number of [node-modifier functions](https://github.com/ThasianX/ElegantColorPalette/blob/master/Sources/ElegantColorPalette/Helpers/Extensions/ColorNode%2BModifiers.swift) exposed the library itself. You can also make your own node-modifiers through  [`NodeStyle`](https://github.com/ThasianX/ElegantColorPalette/blob/master/Sources/ElegantColorPalette/Helpers/Protocols/NodeStyle.swift) and [`NodeModifier`](https://github.com/ThasianX/ElegantColorPalette/blob/master/Sources/ElegantColorPalette/Helpers/Protocols/NodeModifier.swift), like you would do in SwiftUI with `ButtonStyle` and `ViewModifier`. 

See [NodeConfiguration](https://github.com/ThasianX/ElegantColorPalette/blob/master/Sources/ElegantColorPalette/Helpers/Models/NodeStyleConfiguration.swift) to better understand the various states of a node to determine when best to apply your modifier.

The following example demonstrates making a custom node style that further customizes the default node style. You must apply your custom modifiers to `defaultStyledNode` in order to retain the snap effect, highlighted border, etc you see in the demo gif. However, you are always free to start from scratch and style your own node for different states. 

```swift
struct CustomNodeStyle: NodeStyle {

    func updateNode(configuration: Configuration) -> ColorNode {
        configuration.defaultStyledNode
            .radius(30)
            .font(name: "Thonburi")
    }

}
```

Creating your own node modifiers requires prerequisite knowledge of [`SKNode`](https://developer.apple.com/documentation/spritekit/sknode). Let's take a look at the [`ScaleFadeModifier`](https://github.com/ThasianX/ElegantColorPalette/blob/master/Sources/ElegantColorPalette/Helpers/Modifiers/ScaleFadeModifier.swift). This modifier is responsible for scaling and fading the the node through [`SKActions`](https://developer.apple.com/documentation/spritekit/skaction).

```swift
struct ScaleFadeModifier: NodeModifier {

    let scale: CGFloat
    let opacity: CGFloat
    let animationDuration: TimeInterval

    func body(content: Content) -> ColorNode {
        let scaleAction = SKAction.scale(to: scale, duration: animationDuration)
        let opacityAction = SKAction.fadeAlpha(to: opacity, duration: animationDuration)

        content.run(.group([scaleAction, opacityAction]))

        return content
    }

}
```

To use your custom `NodeStyle`, pass it into the `nodeStyle` modifier:

```swift
// For UIKit
ColorPaletteView(...)
    .nodeStyle(CustomNodeStyle())
     
// For SwiftUI
ColorPaletteBindingView(...)
    .nodeStyle(CustomNodeStyle())
```

### Focus Customization

Use `focus` to customize the location, speed, or smoothing rate of the focus animation.

```swift
// For UIKit
ColorPaletteView(...)
    .focus(location: .zero, focusSpeed: 1600, focusRate: 0.2)
     
// For SwiftUI
ColorPaletteBindingView(...)
    .focus(location: .zero, focusSpeed: 1600, focusRate: 0.2)
```

### Events

Use `didSelectColor` to react to any change of the selected palette color:

```swift
// For UIKit
ColorPaletteView(...)
     .didSelectColor { paletteColor in
         // do something
     }
     
// For SwiftUI
ColorPaletteBindingView(...)
     .didSelectColor { paletteColor in
         // do something
     }
```

## Demos

There are 3 different demos, covering UIKit storyboards, XIBs and programmatic instantiation, and SwiftUI.

## Requirements

* iOS 13+([Statistics](https://gs.statcounter.com/os-version-market-share/ios/mobile-tablet/worldwide) show that 90% of users are on iOS 13)
* Xcode 11+
* Swift 5.1+

## Installation

`ElegantColorPalette` doesn't contain any external dependencies.

These are currently the supported installation options:

### Manual

Inside `Sources`, drag the `ElegantColorPalette` folder into your project.

### [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

```ruby
# Podfile
use_frameworks!

target 'YOUR_TARGET_NAME' do
    pod 'ElegantColorPalette', '~> 1.0'
end
```

Replace `YOUR_TARGET_NAME` and then, in the `Podfile` directory, type:

```bash
$ pod install
```

### [Carthage](https://github.com/Carthage/Carthage)

Add this to `Cartfile`

```
github "ThasianX/ElegantColorPalette" ~> 1.0.0
```

```bash
$ carthage update
```

### [Swift Package Manager](https://github.com/apple/swift-package-manager)

Using Xcode 11, go to `File -> Swift Packages -> Add Package Dependency` and enter https://github.com/ThasianX/ElegantColorPalette

If you are using `Package.swift`, you can also add `ElegantColorPalette` as a dependency easily.

```swift
// swift-tools-version:5.1

import PackageDescription

let package = Package(
  name: "TestProject",
  dependencies: [
    .package(url: "https://github.com/ThasianX/ElegantColorPalette", from: "1.0.0")
  ],
  targets: [
    .target(name: "TestProject", dependencies: ["ElegantColorPalette"])
  ]
)
```

```bash
$ swift build
```

## Contributing

If you find a bug, or would like to suggest a new feature or enhancement, it'd be nice if you could [search the issue tracker](https://github.com/ThasianX/ElegantColorPalette/issues) first; while we don't mind duplicates, keeping issues unique helps us save time and considates effort. If you can't find your issue, feel free to [file a new one](https://github.com/ThasianX/ElegantColorPalette/issues/new).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
