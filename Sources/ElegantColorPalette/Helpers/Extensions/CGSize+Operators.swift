// Kevin Li - 10:39 PM - 7/26/20

import Foundation
import UIKit

// https://gist.github.com/gurgeous/bc0c3d2e748c3b6fe7f2

func -(l: CGSize, r: CGSize) -> CGSize { return CGSize(width: l.width - r.width, height: l.height - r.height) }
func +(l: CGSize, r: CGSize) -> CGSize { return CGSize(width: l.width + r.width, height: l.height + r.height) }
func *(l: CGSize, r: CGSize) -> CGSize { return CGSize(width: l.width * r.width, height: l.height * r.height) }
func /(l: CGSize, r: CGSize) -> CGSize { return CGSize(width: l.width / r.width, height: l.height / r.height) }

func -(l: CGSize, r: CGFloat) -> CGSize { return CGSize(width: l.width - r, height: l.height - r) }
func +(l: CGSize, r: CGFloat) -> CGSize { return CGSize(width: l.width + r, height: l.height + r) }
func *(l: CGSize, r: CGFloat) -> CGSize { return CGSize(width: l.width * r, height: l.height * r) }
func /(l: CGSize, r: CGFloat) -> CGSize { return CGSize(width: l.width / r, height: l.height / r) }

func -=( l: inout CGSize, r: CGSize) { l = l - r }
func +=( l: inout CGSize, r: CGSize) { l = l + r }
func *=( l: inout CGSize, r: CGSize) { l = l * r }
func /=( l: inout CGSize, r: CGSize) { l = l / r }

func -=( l: inout CGSize, r: CGFloat) { l = l - r }
func +=( l: inout CGSize, r: CGFloat) { l = l + r }
func *=( l: inout CGSize, r: CGFloat) { l = l * r }
func /=( l: inout CGSize, r: CGFloat) { l = l / r }

extension CGSize {
    
    func with(width: CGFloat)  -> CGSize { return CGSize(width: width, height: height) }

    func with(height: CGFloat) -> CGSize { return CGSize(width: width, height: height) }

    func ceil()  -> CGSize { return CGSize(width: CoreGraphics.ceil(width),  height: CoreGraphics.ceil(height))  }

    func floor() -> CGSize { return CGSize(width: CoreGraphics.floor(width), height: CoreGraphics.floor(height)) }

    func round() -> CGSize { return CGSize(width: CoreGraphics.round(width), height: CoreGraphics.round(height)) }

    func point() -> CGPoint {
        return CGPoint(x: width, y: height)
    }

    func toInts() -> (width: Int, height: Int) {
        return (width: Int(width), height: Int(height))
    }

}
