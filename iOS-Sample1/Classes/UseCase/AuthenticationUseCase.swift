import Foundation
import RxSwift

struct AuthenticationUseCase {
  private let accountRepository: AccountRepository

  private let disposeBag = DisposeBag()
  private let ioScheduler = SerialDispatchQueueScheduler(qos: .background)

  init(accountRepository: AccountRepository) {
    self.accountRepository = accountRepository
  }

  func authenticate(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
    accountRepository
      .authenticate(email: email, password: password)
      .subscribeOn(ioScheduler)
      .observeOn(MainScheduler.instance)
      .subscribe { event in
        switch event {
        case .success:
          completion(.success(()))
        case .error(let error):
          completion(.failure(error))
        }
      }
      .disposed(by: disposeBag)
  }
}
