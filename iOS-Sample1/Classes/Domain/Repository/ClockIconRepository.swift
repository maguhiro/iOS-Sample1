import Foundation
import RxSwift

protocol ClockIconRepository {
  func load() -> Single<[URL]>
}
