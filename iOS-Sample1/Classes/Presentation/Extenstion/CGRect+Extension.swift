import UIKit

extension CGRect {
  init(center: CGPoint, size: CGSize) {
    self.init(x: center.x - size.width / 2, y: center.y - size.height / 2, width: size.width, height: size.height)
  }

  var center: CGPoint {
    let centerX = origin.x + size.width / 2
    let centerY = origin.y + size.height / 2
    return CGPoint(x: centerX, y: centerY)
  }
}
