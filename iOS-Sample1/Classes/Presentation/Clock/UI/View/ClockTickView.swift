import Nuke
import UIKit

final class ClockTickView: UIView {
  private let circleLineWidth: CGFloat = 2.0
  private let rotationDuration: Double = 60.0
  private let imageSize: CGFloat = 50.0

  private var imageViewList = [UIImageView]()

  private var animationStartTime: CFTimeInterval?
  private var startGesturePoint: CGPoint?
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
    updateImageViewListFrame(rect, radius: radius)
    drawCircle(rect, radius: radius)
  }
}

private extension ClockTickView {
  func initializeView() {
    isUserInteractionEnabled = true
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))
    addGestureRecognizer(panGesture)
  }

  func drawCircle(_ rect: CGRect, radius: CGFloat) {
    let circle = UIBezierPath(arcCenter: rect.center,
                              radius: radius,
                              startAngle: CGFloat(Math.radian(from: 0.0)),
                              endAngle: CGFloat(Math.radian(from: 360.0)),
                              clockwise: true)
    let color = UIColor.white
    color.setStroke()

    circle.lineWidth = circleLineWidth
    circle.lineCapStyle = .round
    circle.stroke()
  }

  func addImageView(urlList: [URL]) {
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

  func updateImageViewListFrame(_ rect: CGRect, radius: CGFloat) {
    let imageViewCount = imageViewList.count
    let degreeInterval = 360.0 / Double(imageViewCount)
    let imageViewSize = CGSize(width: imageSize, height: imageSize)

    imageViewList.enumerated().forEach { offset, imageView in
      let degree = degreeInterval * Double(offset)
      let imageCenterPoint = Math.calculatePoint(center: rect.center, radius: Double(radius), degree: degree)
      let rect = CGRect(center: imageCenterPoint, size: imageViewSize)
      imageView.frame = rect
    }
  }

  @objc
  func panAction(_ sender: UIPanGestureRecognizer) {
    switch sender.state {
    case .began:
      startPanGesture(sender.location(in: self))
    case .ended:
      endPanGesture()
    case .changed:
      changePanGesturePoint(sender.location(in: self))
    default:
      break
    }
  }

  func isGestureArea(_ tapPoint: CGPoint) -> Bool {
    let distance = Math.calculateDistance(from: bounds.center, to: tapPoint)
    let radius = Double(min(bounds.width, bounds.height) / 2)
    return distance <= radius
  }

  func startPanGesture(_ startPoint: CGPoint) {
    if !isGestureArea(startPoint) {
      return
    }

    if !pauseFlg {
      startGesturePoint = startPoint
      pauseFlg = true
      stopAnimation()
    }
  }

  func changePanGesturePoint(_ point: CGPoint) {
    guard let startGesturePoint = startGesturePoint else {
      return
    }
    guard let pauseDegree = pauseDegree else {
      return
    }

    let currentDegree = Math.calculateDegree(center: bounds.center, to: point)
    let startDegree = Math.calculateDegree(center: bounds.center, to: startGesturePoint)
    let percentage = convertMovePercentage(panStartDegree: startDegree, panCurrentDegree: currentDegree, animationPauseDegree: pauseDegree)
    moveTransform(percentage: percentage)
  }

  func convertMovePercentage(panStartDegree: Double, panCurrentDegree: Double, animationPauseDegree: Double) -> Double {
    let panDiffDegree: Double = {
      let degree = panCurrentDegree - panStartDegree
      if degree < 0 {
        return degree + 360.0
      }
      return degree
    }()

    let moveDegree: Double = {
      let degree = panDiffDegree + animationPauseDegree
      if degree < 0 {
        return degree + 360.0
      }
      if 360 <= degree {
        return degree - 360.0
      }
      return degree
    }()

    return moveDegree / 360.0 * 100
  }

  func endPanGesture() {
    if pauseFlg {
      startGesturePoint = nil
      pauseFlg = false
      restartAnimation()
    }
  }
}

extension ClockTickView {
  func startAnimation(urlList: [URL]) {
    addImageView(urlList: urlList)
    setNeedsDisplay()

    animationStartTime = layer.convertTime(CACurrentMediaTime(), from: nil)
    startAnimation(view: self)
    imageViewList.forEach { startAnimation(view: $0, isReverse: true) }
  }

  private func startAnimation(view: UIView, isReverse: Bool = false) {
    let animation = AnimationFactory.makeInfinityRotation(duration: rotationDuration, isReverse: isReverse)
    let layer = view.layer
    layer.add(animation, forKey: nil)
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
      return Math.degree(from: Double(atan2(transform.m12, transform.m11)))
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
  func moveTransform(percentage: Double) {
    moveTransform(view: self, percentage: percentage)
    imageViewList.forEach { moveTransform(view: $0, percentage: percentage) }
  }

  func moveTransform(view: UIView, percentage: Double) {
    let layer = view.layer

    // swiftlint:disable force_unwrapping
    let diffTime = rotationDuration * percentage / 100
    layer.timeOffset = animationStartTime! + diffTime
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
