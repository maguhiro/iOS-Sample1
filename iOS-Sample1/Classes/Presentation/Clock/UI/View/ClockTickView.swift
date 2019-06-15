import UIKit

final class ClockTickView: UIView {
  private let circleLineWidth: CGFloat = 2.0

  override func draw(_ rect: CGRect) {
    let radius = (min(rect.width, rect.height) - circleLineWidth) / 2

    let circle = UIBezierPath(arcCenter: rect.center,
                              radius: radius,
                              startAngle: calculateAngle(degree: 0.0),
                              endAngle: calculateAngle(degree: 360.0),
                              clockwise: true)
    let color = UIColor.white
    color.setStroke()

    circle.lineWidth = circleLineWidth
    circle.lineCapStyle = .round
    circle.stroke()
  }
}

private extension ClockTickView {
  func calculateAngle(degree: CGFloat) -> CGFloat {
    return CGFloat(Double.pi) * 2 * degree / 360.0
  }
}
