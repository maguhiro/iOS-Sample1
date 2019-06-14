import RxSwift

protocol AccountRepository {
  func authenticate(email: String, password: String) -> Single<Void>
}
