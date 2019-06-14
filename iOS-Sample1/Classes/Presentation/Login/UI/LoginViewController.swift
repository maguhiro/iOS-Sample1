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
    let emailObservable = emailTextField.rx.text.orEmpty.distinctUntilChanged()
    let passwordObservable = passwordTextField.rx.text.orEmpty.distinctUntilChanged()

    let tappableObservable = Observable
      .combineLatest(emailObservable, passwordObservable)
      .map { email, password -> Bool in
        log.i("\(email) : \(password)")
        return !email.isEmpty && !password.isEmpty
      }
      .share()

    tappableObservable
      .bind(to: loginButton.rx.isEnabled)
      .disposed(by: disposeBag)

    tappableObservable
      .map { tappable -> UIColor in
        tappable ? UIColor.orange : UIColor.darkGray
      }
      .bind(to: loginButton.rx.backgroundColor)
      .disposed(by: disposeBag)
  }
}

// MARK: ユーザーアクション

private extension LoginViewController {
  @IBAction func tapLoginButton(_: UIButton) {
    log.d("clicked Log In Button")
  }
}
