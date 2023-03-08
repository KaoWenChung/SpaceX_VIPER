//
//  UITableView.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/3/8.
//

import UIKit

extension UITableView {
    func register(_ cell: UITableViewCell.Type) {
        register(UINib(nibName: cell.name, bundle: nil),
                 forCellReuseIdentifier: cell.name)
    }
    func dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T? {
        dequeueReusableCell(withIdentifier: T.name, for: indexPath) as? T
    }
}
