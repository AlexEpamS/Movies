//
//  FilterViewModel.swift
//  Movies
//
//  Created by Oleksandr Strelkov on 2023-06-22.
//

import Foundation

typealias FilterDoneClosure = (_ filter: Filter?) -> ()
typealias CalculateFilterResultsClosure = (_ filter: Filter?) -> Int

class FilterViewModel {
    weak var view: FilterViewInterface?

    private let doneHandler: FilterDoneClosure
    private var filter: Filter?
    private var calculateFilterResultsClosure: CalculateFilterResultsClosure?

    init(
        filter: Filter?,
        calculateFilterResultsClosure: CalculateFilterResultsClosure?,
        doneHandler: @escaping FilterDoneClosure
    ) {
        self.filter = filter
        self.calculateFilterResultsClosure = calculateFilterResultsClosure
        self.doneHandler = doneHandler
    }
    
    func viewDidLoad() {
        let minPriceText = stringFromPrice(filter?.minPrice)
        let maxPriceText = stringFromPrice(filter?.maxPrice)
        view?.update(minPriceText: minPriceText, maxPriceText: maxPriceText)
        updateFilterStatus()
    }

    func priceTextFieldWithText(_ currentText: String, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        }
        let proposedString = (currentText as NSString).replacingCharacters(in: range, with: string)
        if PriceType(proposedString) != nil {
            return true
        } else {
            return false
        }
    }
    
    func textFieldDidChange(minPriceText: String, maxPriceText: String) {
        updateFilter(minPriceText: minPriceText, maxPriceText: maxPriceText)
    }
    
    func doneAction() {
        doneHandler(filter)
    }
    
    func clearFilterAction() {
        updateFilter(minPriceText: "", maxPriceText: "")
        view?.update(minPriceText: "", maxPriceText: "")
    }
    
    // MARK: -

    private func updateFilter(minPriceText: String, maxPriceText: String) {
        let minPrice = PriceType(minPriceText)
        let maxPrice = PriceType(maxPriceText)
        
        switch (minPrice, maxPrice) {
        case (nil, nil):
            filter = nil
        case let (.some(minPrice), nil):
            filter = Filter(minPrice: minPrice)
        case let (nil, .some(maxPrice)):
            filter = Filter(maxPrice: maxPrice)
        case let (.some(minPrice), .some(maxPrice)):
            filter = Filter(minPrice: minPrice, maxPrice: maxPrice)
        }
        updateFilterStatus()
    }
    
    private func updateFilterStatus() {
        let filterExists = (filter != nil)
        
        if let calculateFilterResultsClosure {
            DispatchQueue.global(qos: .userInitiated).async {
                let numberOfItems = calculateFilterResultsClosure(self.filter)
                DispatchQueue.main.async {
                    self.updateFilterStatus(filterExists: filterExists, itemsCount: numberOfItems)
                }
            }
        } else {
            updateFilterStatus(filterExists: filterExists, itemsCount: nil)
        }
    }
    
    private func updateFilterStatus(filterExists: Bool, itemsCount: Int?) {
        let filterStatus: String
        
        switch (filterExists, itemsCount) {
        case (true, .some(let itemsCount)):
            filterStatus = "Filter results: \(itemsCount) items"
        case (false, .some(let itemsCount)):
            filterStatus = "No Filter (\(itemsCount) items)"
        case (true, .none):
            filterStatus = ""
        case (false, .none):
            filterStatus = "No Filter"
        }
        
        view?.updateFilterStatusWithText(filterStatus)
    }

    private func stringFromPrice(_ price: PriceType?) -> String {
        let result: String
        if let price {
            result = String(price)
        } else {
            result = ""
        }
        return result
    }
}
