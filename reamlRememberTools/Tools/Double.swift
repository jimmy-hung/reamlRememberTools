


import UIKit

extension Double {
    //保留指定位小数，四舍五入
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
