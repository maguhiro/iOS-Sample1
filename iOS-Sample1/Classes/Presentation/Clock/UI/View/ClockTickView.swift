import UIKit

final class ClockTickView: UIView {
  private let circleLineWidth: CGFloat = 2.0
  private let rotationDuration: Double = 10.0
  private let imageSize: CGFloat = 50.0

  private let imageView = UIImageView()

  override init(frame: CGRect) {
    super.init(frame: frame)
    initializeView()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initializeView()
  }

  override func draw(_ rect: CGRect) {
    let radius = (min(rect.width, rect.height) - imageSize) / 2

    let imageViewRect = CGRect(x: rect.center.x - imageSize / 2, y: 0, width: imageSize, height: imageSize)
    imageView.frame = imageViewRect

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

extension ClockTickView {
  func startAnimation() {
    startCircleAnimation()
    startImageAnimation(imageView)
  }

  private func startCircleAnimation() {
    let animation = CABasicAnimation(keyPath: "transform.rotation")
    animation.isRemovedOnCompletion = true
    animation.fillMode = .forwards
    animation.repeatCount = .infinity
    animation.duration = rotationDuration
    animation.fromValue = 0
    animation.toValue = CGFloat(Double.pi / 180) * 360

    layer.add(animation, forKey: nil)
  }

  private func startImageAnimation(_ imageView: UIImageView) {
    let animation = CABasicAnimation(keyPath: "transform.rotation")
    animation.isRemovedOnCompletion = true
    animation.fillMode = .forwards
    animation.repeatCount = .infinity
    animation.duration = rotationDuration
    animation.fromValue = CGFloat(Double.pi / 180) * 360
    animation.toValue = 0

    imageView.layer.add(animation, forKey: nil)
  }
}

private extension ClockTickView {
  func initializeView() {
    imageView.image = UIImage(named: "Baby")
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = imageSize / 2.0
    addSubview(imageView)
  }

  func calculateAngle(degree: CGFloat) -> CGFloat {
    return CGFloat(Double.pi) * 2 * degree / 360.0
  }
}
