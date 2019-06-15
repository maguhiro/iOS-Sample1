import Foundation
import RxSwift

struct MockClockIconRepositoryImpl: ClockIconRepository {
  // swiftlint:disable force_unwrapping
  private let iconURLList = [
    URL(string: "https://contents.newspicks.us/users/100013/cover?circle=true")!,
    URL(string: "https://contents.newspicks.us/users/100269/cover?circle=true")!,
    URL(string: "https://contents.newspicks.us/users/100094/cover?circle=true")!,
    URL(string: "https://contents.newspicks.us/users/100353/cover?circle=true")!,
    URL(string: "https://contents.newspicks.us/users/100019/cover?circle=true")!,
    URL(string: "https://contents.newspicks.us/users/100529/cover?circle=true")!,
  ]
  // swiftlint:enable force_unwrapping

  func load() -> Single<[URL]> {
    return Single.just(iconURLList)
  }
}
