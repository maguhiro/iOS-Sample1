import Foundation

protocol ClockView: AnyObject {
  func succeededLoadIconURLList(_ urlList: [URL])
}

final class ClockPresenter {
  private let usecase = ClockIconUseCase(clockIconRepository: MockClockIconRepositoryImpl())
  var view: ClockView?

  func load() {
    usecase.load { [weak self] result in
      switch result {
      case .success(let value):
        self?.view?.succeededLoadIconURLList(value)
      case .failure:
        break
      }
    }
  }
}
