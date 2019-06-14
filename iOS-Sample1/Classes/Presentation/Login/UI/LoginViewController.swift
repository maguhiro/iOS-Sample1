import RxCocoa
import RxSwift
import UIKit

final class LoginViewController: UIViewController {
  @IBOutlet private var emailTextField: UITextField!
  @IBOutlet private var passwordTextField: UITextField!
  @IBOutlet private var loginButton: UIButton!

  private let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupBinding()
  }
}

// MARK: Viewのレイアウト

private extension LoginViewController {
  func setupBinding() {
    let emailObservable = emailTextField.rx.text.orEmpty.asDriver().asObservable()
    let passwordObservable = passwordTextField.rx.text.orEmpty.asDriver().asObservable()

    Observable
      .combineLatest(emailObservable, passwordObservable)
      .map { email, password -> Bool in
        !email.isEmpty && !password.isEmpty
      }
      .bind(to: loginButton.rx.isEnabled)
      .disposed(by: disposeBag)
  }
}

// MARK: ユーザーアクション

private extension LoginViewController {
  @IBAction func tapLoginButton(_: UIButton) {
    log.d("clicked Log In Button")
  }
}
