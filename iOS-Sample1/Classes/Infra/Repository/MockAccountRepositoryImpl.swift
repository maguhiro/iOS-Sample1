import Foundation
import RxSwift

enum AuthenticateError: Error {
  case invalidData
}

struct MockAccountRepositoryImpl: AccountRepository {
  private let validEmail = "hoge@gmail.com"
  private let validPassword = "123456"
  private let disposeBag = DisposeBag()

  func authenticate(email: String, password: String) -> Single<Void> {
    return Single.create { observer in
      sleep(3)

      do {
        try self.validate(email: email, password: password)
        observer(.success(()))
      } catch {
        observer(.error(error))
      }

      return Disposables.create()
    }
  }
}

private extension MockAccountRepositoryImpl {
  func validate(email: String, password: String) throws {
    if email != validEmail {
      throw AuthenticateError.invalidData
    }
    if password != validPassword {
      throw AuthenticateError.invalidData
    }
  }
}
