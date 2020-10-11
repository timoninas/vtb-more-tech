import UIKit

extension UIButton {
    func vtbStyleButton() {
        self.backgroundColor = UIColor.appColor(.Blue)
        self.layer.cornerRadius = 8
        self.setTitleColor(UIColor.appColor(.White), for: .normal)
        self.setTitleColor(UIColor.appColor(.Gray), for: .disabled)
    }
}
