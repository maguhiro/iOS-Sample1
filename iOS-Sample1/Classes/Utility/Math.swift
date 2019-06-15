import Foundation
import UIKit

enum Math {
  static func radian(from degree: Double) -> Double {
    return degree * Double.pi / 180.0
  }

  static func degree(from radian: Double) -> Double {
    return radian * 180.0 / Double.pi
  }

  static func calculateRadian(center centerPoint: CGPoint, to targetPoint: CGPoint) -> Double {
    return atan2(Double(targetPoint.y - centerPoint.y), Double(targetPoint.x - centerPoint.y))
  }

  static func calculateDegree(center centerPoint: CGPoint, to targetPoint: CGPoint) -> Double {
    let radian = calculateRadian(center: centerPoint, to: targetPoint)
    return degree(from: radian)
  }

  static func calculatePoint(center centerPoint: CGPoint, radius: Double, degree: Double) -> CGPoint {
    let radian = degree * Double.pi / 180.0

    let x = (sin(radian) * radius) + Double(centerPoint.x)
    let y = (cos(radian) * radius) + Double(centerPoint.y)
    return CGPoint(x: x, y: y)
  }

  // 点A(x1, y1)から点B(x2, y2)間の距離
  // 計算式 : ((x2 - x1)^2 + (y2 - y1)^2) の平方根
  static func calculateDistance(from sourcePoint: CGPoint, to targetPoint: CGPoint) -> Double {
    let x = Double(targetPoint.x - sourcePoint.x)
    let y = Double(targetPoint.y - sourcePoint.y)

    return sqrt(pow(x, 2.0) + pow(y, 2.0))
  }
}
