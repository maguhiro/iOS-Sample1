import UIKit

extension CGRect {
  var center: CGPoint {
    let centerX = origin.x + size.width / 2
    let centerY = origin.y + size.height / 2
    return CGPoint(x: centerX, y: centerY)
  }
}
