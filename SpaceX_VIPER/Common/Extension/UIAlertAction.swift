//
//  UIAlertAction.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

import UIKit

extension UIAlertAction {

    convenience init(index: Int,
                     title: String?,
                     style: AlertAction.Style,
                     handler: ((AlertAction) -> Void)?) {
        self.init(title: title, style: style.describe) { (aAlertAction: UIAlertAction) in
            let alertAction = AlertAction(index: index, title: title ?? "", style: style)
            handler?(alertAction)
        }
    }

}
