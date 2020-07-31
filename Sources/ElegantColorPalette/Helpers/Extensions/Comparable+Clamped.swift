// Kevin Li - 11:07 PM - 7/28/20

import Foundation

extension Comparable {

    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }

}
