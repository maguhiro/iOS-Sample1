import UIKit

final class ClockTickView: UIView {
  private let circleLineWidth: CGFloat = 2.0
  private let rotationDuration: Double = 10.0
  private let imageSize: CGFloat = 50.0

  private let imageViewList = [UIImageView(), UIImageView(), UIImageView(), UIImageView(), UIImageView(), UIImageView()]

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

    let imageViewCount = imageViewList.count
    let angleInterval = 360.0 / Double(imageViewCount)
    let imageViewSize = CGSize(width: imageSize, height: imageSize)

    imageViewList.enumerated().forEach { offset, imageView in
      let degree = angleInterval * Double(offset)
      let imageCenterPoint = calculatePoint(from: rect.center, radius: Double(radius), degree: degree)
      let rect = CGRect(center: imageCenterPoint, size: imageViewSize)
      imageView.frame = rect
    }

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
    imageViewList.forEach { startImageAnimation($0) }
  }

  private func startCircleAnimation() {
    let animation = CABasicAnimation(keyPath: "transform.rotation")
    animation.isRemovedOnCompletion = true
    animation.fillMode = .forwards
    animation.repeatCount = .infinity
    animation.duration = rotationDuration
    animation.fromValue = calculateRadian(degree: 0.0)
    animation.toValue = calculateRadian(degree: 360.0)

    layer.add(animation, forKey: nil)
  }

  private func startImageAnimation(_ imageView: UIImageView) {
    let animation = CABasicAnimation(keyPath: "transform.rotation")
    animation.isRemovedOnCompletion = true
    animation.fillMode = .forwards
    animation.repeatCount = .infinity
    animation.duration = rotationDuration
    animation.fromValue = calculateRadian(degree: 360.0)
    animation.toValue = calculateRadian(degree: 0.0)

    imageView.layer.add(animation, forKey: nil)
  }
}

private extension ClockTickView {
  func initializeView() {
    imageViewList.forEach { imageView in
      imageView.image = UIImage(named: "Baby")
      imageView.clipsToBounds = true
      imageView.layer.cornerRadius = imageSize / 2.0
      addSubview(imageView)
    }
  }

  func calculatePoint(from centerPoint: CGPoint, radius: Double, degree: Double) -> CGPoint {
    let radian = degree * Double.pi / 180.0

    let x = (sin(radian) * radius) + Double(centerPoint.x)
    let y = (cos(radian) * radius) + Double(centerPoint.y)
    return CGPoint(x: x, y: y)
  }

  func calculateAngle(degree: CGFloat) -> CGFloat {
    return CGFloat(Double.pi) * 2 * degree / 360.0
  }

  func calculateRadian(degree: CGFloat) -> CGFloat {
    return degree * CGFloat(Double.pi) / 180.0
  }
}
