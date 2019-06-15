import Foundation
import RxSwift

struct ClockIconUseCase {
  private let clockIconRepository: ClockIconRepository

  private let disposeBag = DisposeBag()
  private let ioScheduler = SerialDispatchQueueScheduler(qos: .background)

  init(clockIconRepository: ClockIconRepository) {
    self.clockIconRepository = clockIconRepository
  }

  func load(completion: @escaping (Result<[URL], Error>) -> Void) {
    clockIconRepository
      .load()
      .subscribeOn(ioScheduler)
      .observeOn(MainScheduler.instance)
      .subscribe { event in
        switch event {
        case .success(let value):
          completion(.success(value))
        case .error(let error):
          completion(.failure(error))
        }
      }
      .disposed(by: disposeBag)
  }
}
