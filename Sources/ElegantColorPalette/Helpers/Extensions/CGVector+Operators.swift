// Kevin Li - 5:01 PM - 7/27/20

import Foundation
import UIKit

// https://gist.github.com/rnapier/75983a0f8c9267094eddad3c2f056d94

// Vectors can be inverted
prefix func - (operand: CGVector) -> CGVector {
    return CGVector(dx: -operand.dx, dy: -operand.dy)
}

// Vectors can be added and subtracted
func + (lhs: CGVector, rhs: CGVector) -> CGVector {
    return CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
}
func - (lhs: CGVector, rhs: CGVector) -> CGVector {
    return lhs + (-rhs)
}

// Points can be offset by vectors (commutative)
func + (lhs: CGPoint, rhs: CGVector) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
}
func + (lhs: CGVector, rhs: CGPoint) -> CGPoint {
    return rhs + lhs
}
func - (lhs: CGPoint, rhs: CGVector) -> CGPoint {
    return lhs + (-rhs)
}

// The difference between a point and a point is a vector.
func - (lhs: CGPoint, rhs: CGPoint) -> CGVector {
    return CGVector(dx: lhs.x - rhs.x, dy: lhs.y - rhs.y)
}

// Vectors can be scaled by a scalar (commutative)
func * (lhs: CGFloat, rhs: CGVector) -> CGVector {
    return CGVector(dx: rhs.dx * lhs, dy: rhs.dy * lhs)
}
func * (lhs: CGVector, rhs: CGFloat) -> CGVector {
    return rhs * lhs
}

// Vectors can be scaled by the reciprocal of a scalar
func / (lhs: CGVector, rhs: CGFloat) -> CGVector {
    return 1.0/rhs * lhs
}

// Points can be scaled by a scalar (commutative). (FIXME: Is this really true?)
func * (lhs: CGFloat, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: rhs.x * lhs, y: rhs.y * lhs)
}
func * (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
    return rhs * lhs
}

// Points can be scaled by the reciprocol of a scalar
func / (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
    return 1.0/rhs * lhs
}
