// Kevin Li - 5:02 PM - 7/27/20

import Foundation
import UIKit

extension CGVector {

    var asUnitVector: CGVector {
        self / magnitude
    }

    var magnitude: CGFloat {
        hypot(dx, dy)
    }

}
