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
    func getLaunch(index: Int) -> LaunchCell
    func getSortOptions() -> [AlertAction.Button]
    func didSetSort(_ option: String)
}

final class SpaceXViewController: UIViewController, Alertable {
    enum Content {
        static let upperLimit: CGFloat = 50
        static let lowerLimit: CGFloat = -100
        static let changedDuration: CGFloat = 0.2
        static let endedDuration: CGFloat = 0.5
        static let springDamping: CGFloat = 0.7
    }
    enum SpaceXViewString: LocalizedStringType {
        case filter
        case title
        case closeFilter
        case sortTitle
    }
    private let presenter: SpaceXViewToPresenterProtocol
    private var viewTranslationY: CGFloat = 0.0
    private lazy var filterButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: SpaceXViewString.filter.text,
                                     style: .plain,
                                     target: self,
                                     action: #selector(tapFilterButton))
            return button
    }()
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
    @objc func gestureHandler(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            viewTranslationY = sender.translation(in: view).y
            guard viewTranslationY < Content.upperLimit else { return }
            UIView.animate(withDuration: Content.changedDuration,
                           delay: 0,
                           usingSpringWithDamping: Content.springDamping,
                           initialSpringVelocity: 1,
                           options: .curveEaseOut,
                           animations: {
                self.dialogView.transform = CGAffineTransform(translationX: 0, y: self.viewTranslationY)
            })
        case .ended:
            if viewTranslationY > Content.lowerLimit {
                UIView.animate(withDuration: Content.endedDuration,
                               delay: 0,
                               usingSpringWithDamping: Content.springDamping,
                               initialSpringVelocity: 1,
                               options: .curveEaseOut,
                               animations: {
                    self.dialogView.transform = .identity
                })
            } else {
                UIView.animate(withDuration: Content.endedDuration) {
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
        tableView.register(LaunchTableViewCell.self)
    }

    private func initDialogView() {
        dialogView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureHandler)))
        presenter.filterView = dialogView
        dialogView.presenter = presenter
    }

    private func initNavigationBar() {
        title = SpaceXViewString.title.text
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
        guard let cell: LaunchTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath) else {
            return UITableViewCell()
        }

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
        showAlert(style: .actionSheet,
                  title: SpaceXViewString.sortTitle.text,
                  cancel: CommonString.cancel.text,
                  others: buttons) { action in
            guard action.style == .default else { return }
            self.presenter.didSetSort(action.title)
        }
    }

    func showLaunches() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func showError(_ error: Error) {
        showAlert(style: .alert,
                  title: CommonString.error.text,
                  message: error.localizedDescription,
                  cancel: CommonString.confirm.text)
    }

    func didConfirmFilter() {
        hideFilterView()
    }
}
