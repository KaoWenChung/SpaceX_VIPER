//
//  FilterDialogView.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

import MultiSlider
import UIKit

protocol FilterDialogViewDelegate: AnyObject {
    func confirmUpdateInteractor(_ interactor: FilterDialogInteractor)
}

final class FilterDialogView: BaseXibView {
    @IBOutlet weak private var sliderBar: MultiSlider!
    @IBOutlet weak private var lowLabel: UILabel!
    @IBOutlet weak private var topLabel: UILabel!
    @IBOutlet weak private var sortButton: UIButton!
    @IBOutlet weak private var showSuccessfulLaunchingSwitch: UISwitch!
    weak var delegate: FilterDialogViewDelegate?
    private var interactor: FilterDialogInteractor!

    func fillView(_ interactor: FilterDialogInteractor) {
        accessibilityIdentifier = AccessibilityIdentifier.filterDialogView
        self.interactor = interactor
        let maxValue = CGFloat(interactor.staticMaxYear)
        let minValue = CGFloat(interactor.staticMinYear)
        let topValue = interactor.maxYear
        let lowValue = interactor.minYear
        setMoney(lowYear: lowValue, topYear: topValue)
        sliderBar.minimumValue = minValue
        sliderBar.maximumValue = maxValue
        sliderBar.value = [CGFloat(lowValue), CGFloat(topValue)]
        showSuccessfulLaunchingSwitch.isOn = interactor.isPresentSuccessfulLaunchingOnly
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
        interactor.minYear = lowValue
        interactor.maxYear = topValue
    }
    
    @IBAction private func tapSortButton(_ sender: Any) {
        interactor.isAscending.toggle()
        let title = interactor.isAscending ? "Sort Ascending" : "Sort Descending"
        sortButton.setTitle(title, for: .normal)
    }

    @IBAction private func tapConfirm() {
        interactor.setYearIsChanged()
        delegate?.confirmUpdateInteractor(interactor)
    }

    @IBAction private func tapShowSuccessfulLaunching(_ sender: UISwitch) {
        interactor.toggleSuccess(sender.isOn)
    }
}
