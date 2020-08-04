// Kevin Li - 7:36 PM - 8/3/20

import UIKit

struct FocusSettings {

    let location: CGPoint
    let speed: CGVector
    let smoothingRate: CGFloat
    
}

extension FocusSettings {

    static let `default` = FocusSettings(location: .zero,
                                         speed: CGVector(dx: 1200, dy: 1200),
                                         smoothingRate: 0.8)

}
