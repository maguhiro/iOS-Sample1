import UIKit

final class ClockViewController: UIViewController {
  @IBOutlet private var clockTickView: ClockTickView!

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(_: Bool) {
    super.viewWillAppear(true)
    clockTickView.startAnimation()
  }
}
