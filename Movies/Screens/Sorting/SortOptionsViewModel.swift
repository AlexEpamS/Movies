//
//  SortOptionsViewModel.swift
//  Movies
//
//  Created by Oleksandr Strelkov on 2023-06-20.
//

import Foundation

typealias SortingDoneClosure = (_ sortOption: SortOption) -> ()

class SortOptionsViewModel {
    weak var view: SortOptionsViewInterface?
    
    private var selectedSortAttributeIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    private var selectedSortOrderIndexPath: IndexPath = IndexPath(row: 0, section: 1)
    let numberOfSections = 2
    private let numberOfSortAttributes = SortAttribute.allCases.count
    private let numberOfSortOrders = SortOrder.allCases.count
    private let doneHandler: SortingDoneClosure

    var sortOption: SortOption {
        didSet {
            view?.reloadData()
        }
    }
    
    init(sortOption: SortOption, doneHandler: @escaping SortingDoneClosure) {
        self.sortOption = sortOption
        self.doneHandler = doneHandler
        selectedSortAttributeIndexPath = IndexPath(row: sortOption.attribute.rawValue, section: 0)
        selectedSortOrderIndexPath = IndexPath(row: sortOption.order.rawValue, section: 1)
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        switch section {
        case 0:
            return numberOfSortAttributes
        case 1:
            return numberOfSortOrders
        default:
            return 0
        }
    }
    
    func cellTextForRowAt(_ indexPath: IndexPath) -> String {
        let result: String
        switch indexPath.section {
        case 0:
            result = sortAttributeTitleForRowAtIndexPath(indexPath)
        case 1:
            result = sortOrderTitleForRowAtIndexPath(indexPath)
        default:
            result = ""
        }
        return result
    }
    
    func isCellCheckedForRowAt(_ indexPath: IndexPath) -> Bool {
        let result: Bool
        switch indexPath.section {
        case 0:
            result = (indexPath == selectedSortAttributeIndexPath)
        case 1:
            result = (indexPath == selectedSortOrderIndexPath)
        default:
            result = false
        }
        return result
    }
    
    func didSelectCellAt(_ indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            view?.updateCheckMark(previousIndexPath: selectedSortAttributeIndexPath, newIndexPath: indexPath)
            selectedSortAttributeIndexPath = indexPath
        case 1:
            view?.updateCheckMark(previousIndexPath: selectedSortOrderIndexPath, newIndexPath: indexPath)
            selectedSortOrderIndexPath = indexPath
        default:
            break
        }
        
        let sortAttribute = SortAttribute(rawValue: selectedSortAttributeIndexPath.row) ?? sortOption.attribute
        let sortOrder = SortOrder(rawValue: selectedSortOrderIndexPath.row) ?? sortOption.order
        sortOption = SortOption(attribute: sortAttribute, order: sortOrder)
    }
    
    func doneButtonAction() {
        doneHandler(sortOption)
    }
    
    // MARK: -

    private func sortAttributeTitleForRowAtIndexPath(_ indexPath: IndexPath) -> String {
        let sortAttribute = SortAttribute(rawValue: indexPath.row)
        let result: String = sortAttribute?.title ?? ""
        return result
    }

    private func sortOrderTitleForRowAtIndexPath(_ indexPath: IndexPath) -> String {
        let sortOrder = SortOrder(rawValue: indexPath.row)
        let result: String = sortOrder?.title ?? ""
        return result
    }
}
