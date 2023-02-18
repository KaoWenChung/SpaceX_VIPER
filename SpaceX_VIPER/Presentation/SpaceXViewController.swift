//
//  SpaceXViewController.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

import UIKit

protocol SpaceXViewToPresenterProtocol: FilterDialogViewToPresenterProtocol {
    var mainView: SpaceXPresenterToViewProtocol? { get set }
    var filterView: SpaceXPresenterToFilterViewProtocol? { get set }
    func loadLaunches()
    func selectItem(at index: Int)
    func getLaunchesCount() -> Int
    func getLaunch(index: Int) -> LaunchCellModel
    func getSortOptions() -> [AlertAction.Button]
    func didSetSort(_ option: String)
}

final class SpaceXViewController: UIViewController, Alertable {
    enum SpaceXViewString: LocalizedStringType {
        case filter
        case title
        case closeFilter
        case sortTitle
    }
    private let presenter: SpaceXViewToPresenterProtocol
    private var viewTranslationY: CGFloat = 0.0
    private var filterButton: UIBarButtonItem!
    private var isShowFilter: Bool = false

    @IBOutlet weak private var backgroundColorView: UIView!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var dialogView: FilterDialogView!
    
    init(presenter: SpaceXViewToPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationBar()
        presenter.loadLaunches()
        initDialogView()
        initTableView()
        hideFilterView()
    }

    // MARK: - Private functions
    // Set the range user can drag the dialogView/ dismissing the filter dialog view
    @objc func gestureHandler(sender: UIPanGestureRecognizer){
        switch sender.state {
        case .changed:
            viewTranslationY = sender.translation(in: view).y
            guard viewTranslationY < 50 else { return }
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.dialogView.transform = CGAffineTransform(translationX: 0, y: self.viewTranslationY)
            })
        case .ended:
            if viewTranslationY > -100 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.dialogView.transform = .identity
                })
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.hideFilterView()
                }
            }
        default:
            break
        }
    }
    @objc private func tapFilterButton() {
        UIView.animate(withDuration: 0.3) {
            self.isShowFilter ? self.hideFilterView() : self.showFilterView()
        }
    }
    private func initTableView() {
        tableView.register(UINib(nibName: LaunchTableViewCell.name, bundle: nil), forCellReuseIdentifier: LaunchTableViewCell.name)
    }
    private func initDialogView() {
        dialogView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureHandler)))
        presenter.filterView = dialogView
        dialogView.presenter = presenter
    }
    private func initNavigationBar() {
        title = SpaceXViewString.title.text
        filterButton = UIBarButtonItem(title: SpaceXViewString.filter.text, style: .plain, target: self, action: #selector(tapFilterButton))
        navigationItem.rightBarButtonItem = filterButton
    }
    // Hide the filter dialog and change the title of filter button
    private func hideFilterView() {
        isShowFilter = false
        filterButton.title = SpaceXViewString.filter.text
        dialogView.transform = CGAffineTransform(translationX: 0, y: -dialogView.frame.height)
        dialogView.alpha = 0
        backgroundColorView.alpha = 0
    }
    // Show the filter dialog and change the title of filter button
    private func showFilterView() {
        isShowFilter = true
        filterButton.title = SpaceXViewString.closeFilter.text
        dialogView.transform = CGAffineTransform(translationX: 0, y: 0)
        dialogView.alpha = 1
        backgroundColorView.alpha = 1
    }

    private func updateItems() {
        tableView.reloadData()
    }
}

extension SpaceXViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SpaceXViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getLaunchesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LaunchTableViewCell.name, for: indexPath) as? LaunchTableViewCell else { return UITableViewCell() }

        cell.fill(presenter.getLaunch(index: indexPath.row))

        if indexPath.row == presenter.getLaunchesCount() - 1 {
            presenter.loadLaunches()
        }
        return cell
    }
}

extension SpaceXViewController: SpaceXPresenterToViewProtocol {
    func didSelectSort() {
        let buttons = presenter.getSortOptions()
        showAlert(style: .actionSheet, title: SpaceXViewString.sortTitle.text, cancel: CommonString.cancel.text, others: buttons) { action in
            guard action.style == .default else { return }
            self.presenter.didSetSort(action.title)
        }
    }
    
    func showLaunches() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showError(_ error: String) {
        showAlert(style: .alert, title: CommonString.error.text, message: error, cancel: CommonString.ok.text)
    }

    func didConfirmFilter() {
        hideFilterView()
    }
}
