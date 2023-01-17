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

    func fill(_ viewModel: LaunchTableViewModel, imageRepository: LaunchImagesRepositoryType) {
        missionLabel.text = viewModel.mission
        dateLabel.text = viewModel.date
        rocketLabel.text = viewModel.rocket
        daysLabel.text = viewModel.days
        let task = Task {
            await missionImageView.downloaded(imageLoader: imageRepository, from: viewModel.imageURL)
        }
        task.cancel()
        Task.init {
            await task.value
        }
    }
}
