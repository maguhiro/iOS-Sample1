import Nuke
import UIKit

final class ClockTickView: UIView {
  private let circleLineWidth: CGFloat = 2.0
  private let rotationDuration: Double = 10.0
  private let imageSize: CGFloat = 50.0

  private var imageViewList = [UIImageView]()

  private var startTime: CFTimeInterval?
  private var firstTapPoint: CGPoint?
  private var pauseFlg = false
  private var pauseDegree: Double?

  override init(frame: CGRect) {
    super.init(frame: frame)
    initializeView()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initializeView()
  }

  override func draw(_ rect: CGRect) {
    if imageViewList.isEmpty {
      return
    }

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
                              startAngle: calculateRadian(degree: 0.0),
                              endAngle: calculateRadian(degree: 360.0),
                              clockwise: true)
    let color = UIColor.white
    color.setStroke()

    circle.lineWidth = circleLineWidth
    circle.lineCapStyle = .round
    circle.stroke()
  }
}

private extension ClockTickView {
  func initializeView() {
    isUserInteractionEnabled = true
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))
    addGestureRecognizer(panGesture)
  }

  @objc
  func panAction(_ sender: UIPanGestureRecognizer) {
    switch sender.state {
    case .began:
      let firstTapPoint = sender.location(in: self)
      self.firstTapPoint = firstTapPoint
      if !isGestureArea(firstTapPoint) {
        return
      }

      if !pauseFlg {
        pauseFlg = true
        stopAnimation()
      }
    case .ended:
      if pauseFlg {
        pauseFlg = false
        restartAnimation()
      }
    case .changed:
      if let firstTapPoint = firstTapPoint {
        let currentPoint = sender.location(in: self)
        let currentDegree = calculateDegree(from: bounds.center, to: currentPoint)
        let firstDegree = calculateDegree(from: bounds.center, to: firstTapPoint)
        moveTransform(degree: currentDegree - firstDegree)
      }
    default:
      break
    }
  }

  func isGestureArea(_ tapPoint: CGPoint) -> Bool {
    let centerPoint = bounds.center

    let distance = calculateDistance(from: centerPoint, to: tapPoint)
    let radius = Double(min(bounds.width, bounds.height) / 2)

    return distance <= radius
  }

  // 点A(x1, y1)から点B(x2, y2)間の距離
  // 計算式 : ((x2 - x1)^2 + (y2 - y1)^2) の平方根
  func calculateDistance(from centerPoint: CGPoint, to targetPoint: CGPoint) -> Double {
    let x = Double(targetPoint.x - centerPoint.x)
    let y = Double(targetPoint.y - centerPoint.y)

    return sqrt(pow(x, 2.0) + pow(y, 2.0))
  }

  func calculateRadian(from centerPoint: CGPoint, to targetPoint: CGPoint) -> Double {
    return atan2(Double(targetPoint.y - centerPoint.y), Double(targetPoint.x - centerPoint.y))
  }

  func calculateDegree(from centerPoint: CGPoint, to targetPoint: CGPoint) -> Double {
    let radian = calculateRadian(from: centerPoint, to: targetPoint)
    return radian * 180.0 / Double.pi
  }

  func calculatePoint(from centerPoint: CGPoint, radius: Double, degree: Double) -> CGPoint {
    let radian = degree * Double.pi / 180.0

    let x = (sin(radian) * radius) + Double(centerPoint.x)
    let y = (cos(radian) * radius) + Double(centerPoint.y)
    return CGPoint(x: x, y: y)
  }

  func calculateRadian(degree: CGFloat) -> CGFloat {
    return degree * CGFloat(Double.pi) / 180.0
  }

  func calculateDegree(radian: CGFloat) -> CGFloat {
    return radian * 180.0 / CGFloat(Double.pi)
  }
}

extension ClockTickView {
  func startAnimation(urlList: [URL]) {
    addIcon(urlList: urlList)
    setNeedsDisplay()

    startTime = layer.convertTime(CACurrentMediaTime(), from: nil)
    startCircleAnimation()
    imageViewList.forEach { startImageAnimation($0) }
  }

  func addIcon(urlList: [URL]) {
    let options = ImageLoadingOptions(transition: .fadeIn(duration: 0.5))
    urlList.forEach { url in
      let imageView = UIImageView(frame: .zero)
      imageView.backgroundColor = UIColor.gray
      Nuke.loadImage(with: url, options: options, into: imageView)
      imageView.clipsToBounds = true
      imageView.layer.cornerRadius = imageSize / 2.0
      addSubview(imageView)

      imageViewList.append(imageView)
    }
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
  func stopAnimation() {
    pauseDegree = getCurrentRotateDegree()
    stopAnimation(view: self)
    imageViewList.forEach { stopAnimation(view: $0) }
  }

  func getCurrentRotateDegree() -> Double? {
    if let transform = layer.presentation()?.transform {
      let degree = calculateDegree(radian: atan2(transform.m12, transform.m11))
      log.i(degree)
      return Double(degree)
    }

    return nil
  }

  func stopAnimation(view: UIView) {
    let layer = view.layer
    let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
    layer.timeOffset = pausedTime
    layer.speed = 0.0
  }
}

private extension ClockTickView {
  func moveTransform(degree: Double) {
    guard let pauseDegree = pauseDegree else {
      return
    }

    let tmpDegree: Double = {
      if degree < 0 {
        return degree + 360.0
      }
      return degree
    }()

    moveTransform(view: self, degree: tmpDegree + pauseDegree)
    imageViewList.forEach { moveTransform(view: $0, degree: tmpDegree + pauseDegree) }
  }

  func moveTransform(view: UIView, degree: Double) {
    let layer = view.layer

    let tmpDegree: Double = {
      if degree < 0 {
        return degree + 360.0
      }
      if 360 <= degree {
        return degree - 360.0
      }
      return degree
    }()

    let percentage = tmpDegree / 360.0 * 100
    let diffTime = Double(percentage) / rotationDuration
    // swiftlint:disable force_unwrapping
    layer.timeOffset = startTime! + diffTime
    // swiftlint:enable force_unwrapping
  }
}

private extension ClockTickView {
  func restartAnimation() {
    restartAnimation(view: self)
    imageViewList.forEach { restartAnimation(view: $0) }
  }

  func restartAnimation(view: UIView) {
    let layer = view.layer
    let pausedTime = layer.timeOffset

    layer.speed = 1.0
    layer.timeOffset = 0.0
    layer.beginTime = 0.0

    let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
    layer.beginTime = timeSincePause
  }
}
