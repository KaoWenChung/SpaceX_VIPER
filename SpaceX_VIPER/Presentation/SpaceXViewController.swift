//
//  SpaceXViewController.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

import UIKit

class SpaceXViewController: UIViewController {

    private let viewModel: SpaceXViewModelType
    private var launchImagesRepository: LaunchImagesRepositoryType
    private var viewTranslationY: CGFloat = 0.0
    private var filterButton: UIBarButtonItem!
    private var isShowFilter: Bool = false

    @IBOutlet weak private var backgroundColorView: UIView!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var dialogView: FilterDialogView!
    
    init(viewModel: SpaceXViewModelType, launchImagesRepository: LaunchImagesRepositoryType) {
        self.viewModel = viewModel
        self.launchImagesRepository = launchImagesRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationBar()
        viewModel.viewDidLoad()
        bind(to: viewModel)
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
        dialogView.delegate = self
    }
    private func initNavigationBar() {
        title = "SpaceX"
        filterButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(tapFilterButton))
        navigationItem.rightBarButtonItem = filterButton
    }
    // Hide the filter dialog and change the title of filter button
    private func hideFilterView() {
        isShowFilter = false
        filterButton.title = "Filter"
        dialogView.transform = CGAffineTransform(translationX: 0, y: -dialogView.frame.height)
        dialogView.alpha = 0
        backgroundColorView.alpha = 0
    }
    // Show the filter dialog and change the title of filter button
    private func showFilterView() {
        isShowFilter = true
        filterButton.title = "Close Filter"
        dialogView.transform = CGAffineTransform(translationX: 0, y: 0)
        dialogView.alpha = 1
        backgroundColorView.alpha = 1
    }

    private func bind(to viewModel: SpaceXViewModelType) {
        viewModel.launches.observe(on: self) { [weak self] _ in self?.updateItems() }
        viewModel.dialogViewModel.observe(on: self) { [weak self] _ in self?.updateDialogView() }
    }

    private func updateItems() {
        tableView.reloadData()
    }
    
    private func updateDialogView() {
        guard let dialogViewModel = viewModel.dialogViewModel.value else { return }
        dialogView.fillView(dialogViewModel)
    }
}

extension SpaceXViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectItem(at: indexPath.row)
    }
}

extension SpaceXViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.launches.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LaunchTableViewCell.name, for: indexPath) as? LaunchTableViewCell else { return UITableViewCell() }

        cell.fill(viewModel.launches.value[indexPath.row], imageRepository: launchImagesRepository)

        if indexPath.row == viewModel.launches.value.count - 1 {
            viewModel.didLoadNextPage()
        }
        return cell
    }
}

extension SpaceXViewController: FilterDialogViewDelegate {
    func confirmUpdateViewModel(_ dialogViewModel: FilterDialogViewModel) {
        viewModel.didConfirmFilter(dialogViewModel)
        hideFilterView()
    }
}
