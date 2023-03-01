//
//  Created by wyn on 2023/1/17.
//

import MultiSlider
import UIKit

protocol FilterDialogViewToPresenterProtocol: AnyObject {
    func didConfirmFilter(_ model: FilterDialogModel)
    func didSelectSort()
}

final class FilterDialogView: BaseXibView {
    @IBOutlet weak private(set) var sliderBar: MultiSlider!
    @IBOutlet weak private(set) var lowLabel: UILabel!
    @IBOutlet weak private(set) var topLabel: UILabel!
    @IBOutlet weak private(set) var sortButton: UIButton!
    @IBOutlet weak private(set) var showSuccessfulLaunchingSwitch: UISwitch!
    weak var presenter: FilterDialogViewToPresenterProtocol?
    
    private func fillView(_ model: FilterDialogModel) {
        accessibilityIdentifier = AccessibilityIdentifier.filterDialogView
        let maxValue = CGFloat(model.staticMaxYear)
        let minValue = CGFloat(model.staticMinYear)
        let topValue = model.maxYear
        let lowValue = model.minYear
        setMoney(lowYear: lowValue, topYear: topValue)
        sliderBar.minimumValue = minValue
        sliderBar.maximumValue = maxValue
        sliderBar.value = [CGFloat(lowValue), CGFloat(topValue)]
        showSuccessfulLaunchingSwitch.isOn = model.isOnlySuccessfulLaunching
    }
    // MARK: - Private functions

    private func setMoney(lowYear: Int, topYear: Int) {
        lowLabel.text = lowYear.description
        topLabel.text = topYear.description
    }

    // MARK: IBAction
    @IBAction private func onSliderChanged(_ sender: MultiSlider) {
        var lowValue: Int = Int(sender.value.first ?? 0)
        var topValue: Int = Int(sender.value.last ?? 0)
        let maxValue: Int = Int(sliderBar.maximumValue)
        let minValue: Int = Int(sliderBar.minimumValue)
        if topValue < lowValue {
            topValue = lowValue
        }
        if Double(topValue - lowValue) / Double(maxValue - minValue) <= 0.001 {
            lowValue = topValue
        }
        setMoney(lowYear: lowValue, topYear: topValue)
    }
    
    @IBAction private func tapSortButton(_ sender: UIButton) {
        presenter?.didSelectSort()
    }

    @IBAction private func tapConfirm() {
        let maxValue = Int(sliderBar.maximumValue)
        let minValue = Int(sliderBar.minimumValue)
        let lowValue = Int(sliderBar.value.first ?? 0)
        let topValue = Int(sliderBar.value.last ?? 0)
        let model = FilterDialogModel(isOnlySuccessfulLaunching: showSuccessfulLaunchingSwitch.isOn,
                                      sorting: sortButton.title(for: .normal),
                                      staticMaxYear: maxValue,
                                      staticMinYear: minValue,
                                      maxYear: topValue,
                                      minYear: lowValue)
        presenter?.didConfirmFilter(model)
    }
}

extension FilterDialogView: SpaceXPresenterToFilterViewProtocol {
    func updateSort(_ option: String) {
        sortButton.setTitle(option, for: .normal)
    }
    
    func updateFilterView(_ model: FilterDialogModel) {
        DispatchQueue.main.async {
            self.fillView(model)
        }
    }
}
