//
//  LaunchTableViewCell.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

import UIKit

final class LaunchTableViewCell: UITableViewCell {
    @IBOutlet weak private(set) var missionImageView: UIImageView!
    @IBOutlet weak private(set) var missionLabel: UILabel!
    @IBOutlet weak private(set) var dateLabel: UILabel!
    @IBOutlet weak private(set) var rocketLabel: UILabel!
    @IBOutlet weak private(set) var daysLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        missionImageView.image = nil
        missionLabel.text = nil
        dateLabel.text = nil
        rocketLabel.text = nil
        daysLabel.text = nil
    }

    func fill(_ interactor: LaunchCellModel, imageRepository: LaunchImageRepositoryType) {
        missionLabel.text = interactor.mission
        dateLabel.text = interactor.date
        rocketLabel.text = interactor.rocket
        daysLabel.text = interactor.days
        let task = Task {
            await missionImageView.downloaded(imageLoader: imageRepository, from: interactor.imageURL)
        }
        task.cancel()
        Task.init {
            await task.value
        }
    }
}
