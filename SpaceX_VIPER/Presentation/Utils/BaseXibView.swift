//
//  Created by wyn on 2023/1/17.
//

import UIKit

@IBDesignable
class BaseXibView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }

    func xibSetup() {
        let boundle = Bundle(for: classForCoder)
        let nibName = String(describing: classForCoder)
        let nib = UINib(nibName: nibName, bundle: boundle)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            view.frame = self.bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(view)
        } else {
            fatalError("nib (\(String(describing: nibName)))")
        }
    }
}
