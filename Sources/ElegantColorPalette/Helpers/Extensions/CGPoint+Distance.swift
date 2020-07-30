// Kevin Li - 10:38 PM - 7/26/20

import Foundation
import UIKit

extension CGPoint {

    func distance(from point: CGPoint) -> CGFloat {
        hypot(point.x - x, point.y - y)
    }

}
