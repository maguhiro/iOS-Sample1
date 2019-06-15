import UIKit

final class ClockViewController: UIViewController {
  @IBOutlet private var clockTickView: ClockTickView!

  private lazy var presenter: ClockPresenter = {
    let presenter = ClockPresenter()
    presenter.view = self
    return presenter
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(_: Bool) {
    super.viewWillAppear(true)
    presenter.load()
  }
}

extension ClockViewController: ClockView {
  func succeededLoadIconURLList(_ urlList: [URL]) {
    clockTickView.startAnimation(urlList: urlList)
  }
}
