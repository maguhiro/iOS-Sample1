import UIKit

enum AnimationFactory {
  static func makeInfinityRotation(duration: TimeInterval, isReverse: Bool = false) -> CABasicAnimation {
    let animation = CABasicAnimation(keyPath: "transform.rotation")
    animation.isRemovedOnCompletion = true
    animation.fillMode = .forwards
    animation.repeatCount = .infinity
    animation.duration = duration
    animation.fromValue = isReverse ? Math.radian(from: 360.0) : Math.radian(from: 0.0)
    animation.toValue = isReverse ? Math.radian(from: 0.0) : Math.radian(from: 360.0)
    return animation
  }
}
