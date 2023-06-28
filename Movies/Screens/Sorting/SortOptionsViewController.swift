//
//  SortOptionsViewController.swift
//  Movies
//
//  Created by Oleksandr Strelkov on 2023-06-20.
//

import UIKit

protocol SortOptionsViewInterface: AnyObject {
    func reloadData()
    func updateCheckMark(previousIndexPath: IndexPath, newIndexPath: IndexPath)
}

class SortOptionsViewController: UITableViewController {
    private static let cellReuseId = "SortOptionCellId"
    
    let viewModel: SortOptionsViewModel
    
    init(sortOption: SortOption, doneHandler: @escaping SortingDoneClosure) {
        viewModel = SortOptionsViewModel(sortOption: sortOption, doneHandler: doneHandler)
        super.init(style: .grouped)
        viewModel.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellReuseId, for: indexPath)
        configureCell(cell, at: indexPath)
        return cell
    }
    
    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectCellAt(indexPath)
    }
    
    // MARK: -

    private func setupUI() {
        title = "Sorting"

        let cellsNib = UINib(nibName: "SortCells", bundle: nil)
        tableView.register(cellsNib, forCellReuseIdentifier: Self.cellReuseId)
        
        let leftBarButtonItem = UIBarButtonItem(systemItem: .cancel, primaryAction: UIAction(handler: { [weak self] action in
            self?.dismiss(animated: true)
        }))

        let rightBarButtonItem = UIBarButtonItem(systemItem: .done, primaryAction: UIAction(handler: { [weak self] action in
            self?.viewModel.doneButtonAction()
            self?.dismiss(animated: true)
        }))
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    private func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        cell.textLabel?.text = viewModel.cellTextForRowAt(indexPath)
        cell.accessoryType = viewModel.isCellCheckedForRowAt(indexPath) ? .checkmark : .none
    }
}

extension SortOptionsViewController: SortOptionsViewInterface {
    func reloadData() {
        tableView.reloadData()
    }
    
    func updateCheckMark(previousIndexPath: IndexPath, newIndexPath: IndexPath) {
        let previousCell = tableView.cellForRow(at: previousIndexPath)
        previousCell?.accessoryType = .none
        let newCell = tableView.cellForRow(at: newIndexPath)
        newCell?.accessoryType = .checkmark
    }
}
