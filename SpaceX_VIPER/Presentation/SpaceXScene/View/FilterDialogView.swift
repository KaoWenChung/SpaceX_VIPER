//
//  FilterDialogView.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

import MultiSlider
import UIKit

protocol FilterDialogViewDelegate: AnyObject {
    func confirmUpdateViewModel(_ viewModel: FilterDialogViewModel)
}

final class FilterDialogView: BaseXibView {
    @IBOutlet weak private var sliderBar: MultiSlider!
    @IBOutlet weak private var lowLabel: UILabel!
    @IBOutlet weak private var topLabel: UILabel!
    @IBOutlet weak private var sortButton: UIButton!
    @IBOutlet weak private var showSuccessfulLaunchingSwitch: UISwitch!
    weak var delegate: FilterDialogViewDelegate?
    private var viewModel: FilterDialogViewModel!

    func fillView(_ viewModel: FilterDialogViewModel) {
        accessibilityIdentifier = AccessibilityIdentifier.filterDialogView
        self.viewModel = viewModel
        let maxValue = CGFloat(viewModel.staticMaxYear)
        let minValue = CGFloat(viewModel.staticMinYear)
        let topValue = viewModel.maxYear
        let lowValue = viewModel.minYear
        setMoney(lowYear: lowValue, topYear: topValue)
        sliderBar.minimumValue = minValue
        sliderBar.maximumValue = maxValue
        sliderBar.value = [CGFloat(lowValue), CGFloat(topValue)]
        showSuccessfulLaunchingSwitch.isOn = viewModel.isPresentSuccessfulLaunchingOnly
    }
    // MARK: - Private functions

    private func setMoney(lowYear: Int, topYear: Int) {
        lowLabel.text = lowYear.description
        topLabel.text = topYear.description
    }

    // MARK: IBAction
    @IBAction private func onSliderChanged(_ sender: MultiSlider) {
        var lowValue: Int = Int(sender.value.first!)
        var topValue: Int = Int(sender.value.last!)
        let maxValue: Int = Int(sliderBar.maximumValue)
        let minValue: Int = Int(sliderBar.minimumValue)
        if topValue < lowValue {
            topValue = lowValue
        }
        if Double(topValue - lowValue) / Double(maxValue - minValue) <= 0.001 {
            lowValue = topValue
        }
        setMoney(lowYear: lowValue, topYear: topValue)
        viewModel.minYear = lowValue
        viewModel.maxYear = topValue
    }
    
    @IBAction private func tapSortButton(_ sender: Any) {
        viewModel.isAscending.toggle()
        let title = viewModel.isAscending ? "Sort Ascending" : "Sort Descending"
        sortButton.setTitle(title, for: .normal)
    }

    @IBAction private func tapConfirm() {
        viewModel.setYearIsChanged()
        delegate?.confirmUpdateViewModel(viewModel)
    }

    @IBAction private func tapShowSuccessfulLaunching(_ sender: UISwitch) {
        viewModel.toggleSuccess(sender.isOn)
    }
}
