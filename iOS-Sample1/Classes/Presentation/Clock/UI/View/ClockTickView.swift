import UIKit

final class ClockTickView: UIView {
  private let circleLineWidth: CGFloat = 2.0
  private let rotationDuration: Double = 10.0

  override func draw(_ rect: CGRect) {
    let radius = (min(rect.width, rect.height) - circleLineWidth) / 2

    let circle = UIBezierPath(arcCenter: rect.center,
                              radius: radius,
                              startAngle: calculateAngle(degree: 0.0),
                              endAngle: calculateAngle(degree: 350.0),
                              clockwise: true)
    let color = UIColor.white
    color.setStroke()

    circle.lineWidth = circleLineWidth
    circle.lineCapStyle = .round
    circle.stroke()
  }
}

extension ClockTickView {
  func startAnimation() {
    let animation = CABasicAnimation(keyPath: "transform.rotation")
    animation.isRemovedOnCompletion = true
    animation.fillMode = .forwards
    animation.repeatCount = .infinity
    animation.duration = rotationDuration
    animation.fromValue = 0
    animation.toValue = CGFloat(Double.pi / 180) * 360

    layer.add(animation, forKey: nil)
  }
}

private extension ClockTickView {
  func calculateAngle(degree: CGFloat) -> CGFloat {
    return CGFloat(Double.pi) * 2 * degree / 360.0
  }
}
