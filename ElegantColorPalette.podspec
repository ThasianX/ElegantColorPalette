Pod::Spec.new do |s|
  s.name             = 'ElegantColorPalette'
  s.version          = '1.0.0'
  s.summary          = 'The elegant color picker missed in UIKit and SwiftUI'
 
  s.description      = <<-DESC
`ElegantColorPalette` is inspired by [TimePage](https://us.moleskine.com/timepage/p0486) and is part of a larger repository of elegant demonstrations like this: [TimePage Clone](https://github.com/ThasianX/TimePage-Clone).

The top level view is an `SKView` that presents an `SKScene` of colors nodes. The color nodes are `SKShapeNode` subclasses. When using this library, you are only interacting with the `SKView`: all you have to do is configure the size of the view either through autolayout or size constraints and the view does the rest.
                       DESC
 
  s.homepage         = 'https://github.com/ThasianX/ElegantColorPalette'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Kevin Li' => 'kevinli29033@gmail.com' }
  s.source           = { :git => 'https://github.com/ThasianX/ElegantColorPalette.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '13.0'
  s.swift_version = '5.1'

  s.source_files = 'Sources/**/*.swift'
 
end
