//
//  Created by wyn on 2023/1/17.
//

import UIKit

final class LaunchTableViewCell: UITableViewCell {
    enum LaunchTableViewCellString: LocalizedStringType {
        case launchSuccess
        case launchFail
        case notLaunchYet
    }
    @IBOutlet weak private(set) var missionImageView: UIImageView!
    @IBOutlet weak private(set) var missionLabel: UILabel!
    @IBOutlet weak private(set) var dateLabel: UILabel!
    @IBOutlet weak private(set) var rocketLabel: UILabel!
    @IBOutlet weak private(set) var daysLabel: UILabel!
    @IBOutlet weak private(set) var launchStatusLabel: UILabel!
    private var imageLoadTask: CancellableType?

    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoadTask?.cancel()
        missionImageView.image = nil
        missionLabel.text = nil
        dateLabel.text = nil
        rocketLabel.text = nil
        daysLabel.text = nil
    }

    func fill(_ interactor: LaunchCellModel) {
        missionLabel.text = interactor.name
        dateLabel.text = interactor.date
        rocketLabel.text = interactor.rocket
        daysLabel.text = interactor.days
        let task = Task {
            await missionImageView.downloaded(imageLoader: interactor.imageRepository, from: interactor.imageURL)
        }
        imageLoadTask = task
        let status: String
        switch interactor.isSuccess {
        case .some(true):
            status = LaunchTableViewCellString.launchSuccess.text
        case .some(false):
            status = LaunchTableViewCellString.launchFail.text
        case nil:
            status = LaunchTableViewCellString.notLaunchYet.text
        }
        launchStatusLabel.text = status
    }
}
