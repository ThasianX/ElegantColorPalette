# ElegantColorPalette

<p align="leading">
    <img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platforms" />
    <img src="https://img.shields.io/badge/Swift-5-orange.svg" />
    <a href="https://github.com/ThasianX/ElegantColorPalette/blob/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" /></a>
</p>

The elegant color picker missed in UIKit and SwiftUI.

<img src="https://github.com/ThasianX/GIFs/blob/master/ElegantColorPalette/demo.gif" width="320"/>

This example GIF is from [ElegantTimeline](https://github.com/ThasianX/ElegantTimeline-SwiftUI). For a simpler demonstration, you can look at either of the 3 demo projects in this repository.

- [Introduction](#introduction)
- [Basic Usage](#basic-usage)
- [Customization](#customization)
- [Demos](#demos)
- [Installation](#installation)
- [Requirements](#requirements)
- [Contributing](#contributing)
- [License](#license)

## Introduction

`ElegantColorPalette` is inspired by [TimePage](https://us.moleskine.com/timepage/p0486) and is part of a larger repository of elegant demonstrations like this: [TimePage Clone](https://github.com/ThasianX/TimePage-Clone).

The top level view is an `SKView` that presents an `SKScene` of colors nodes. The color nodes are `SKShapeNode` subclasses. When using this library, you are only interacting with the `SKView`: all you have to do is configure the size of the view either through autolayout or size constraints and the view does the rest.

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

Documentation coming soon...

## Demos

There are 3 different demos, covering UIKit storyboards, XIBs and programmatic instantiation, and SwiftUI.

## Installation

`ElegantColorPalette` is available using the [Swift Package Manager](https://swift.org/package-manager/):

Using Xcode 11, go to `File -> Swift Packages -> Add Package Dependency` and enter https://github.com/ThasianX/ElegantColorPalette

If you are using `Package.swift`, you can also add `ElegantColorPalette` as a dependency easily.

```swift

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

## Requirements

- iOS 13.0+
- Xcode 11.0+

## Contributing

If you find a bug, or would like to suggest a new feature or enhancement, it'd be nice if you could [search the issue tracker](https://github.com/ThasianX/ElegantColorPalette/issues) first; while we don't mind duplicates, keeping issues unique helps us save time and considates effort. If you can't find your issue, feel free to [file a new one](https://github.com/ThasianX/ElegantColorPalette/issues/new).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
