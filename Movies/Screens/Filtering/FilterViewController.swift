//
//  FilterViewController.swift
//  Movies
//
//  Created by Oleksandr Strelkov on 2023-06-21.
//

import UIKit

protocol FilterViewInterface: AnyObject {
    func updateFilterStatusWithText(_ text: String)
    func update(minPriceText: String, maxPriceText: String)
}

class FilterViewController: UIViewController {
    let viewModel: FilterViewModel

    @IBOutlet weak var minPriceTextField: UITextField!
    @IBOutlet weak var maxPriceTextField: UITextField!
    @IBOutlet weak var filterStatusLabel: UILabel!
    
    init(
        filter: Filter?,
        calculateFilterResultsClosure: CalculateFilterResultsClosure?,
        doneHandler: @escaping FilterDoneClosure
    ) {
        viewModel = FilterViewModel(
            filter: filter,
            calculateFilterResultsClosure: calculateFilterResultsClosure,
            doneHandler: doneHandler
        )
        super.init(nibName: nil, bundle: nil)
        viewModel.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = UINib(nibName: "FilterView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! UIView
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        viewModel.viewDidLoad()
    }

    // MARK: -

    @IBAction func clearFilterButtonAction(_ sender: Any) {
        viewModel.clearFilterAction()
    }

    @IBAction func textFieldDidChange(_ sender: Any) {
        viewModel.textFieldDidChange(minPriceText: minPriceTextField.text ?? "", maxPriceText: maxPriceTextField.text ?? "")
    }

    // MARK: -

    private func setupUI() {
        title = "Filtering"
        let leftBarButtonItem = UIBarButtonItem(systemItem: .cancel, primaryAction: UIAction(handler: { [weak self] action in
            self?.dismiss(animated: true)
        }))

        let rightBarButtonItem = UIBarButtonItem(systemItem: .done, primaryAction: UIAction(handler: { [weak self] action in
            self?.viewModel.doneAction()
            self?.dismiss(animated: true)
        }))
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
}

extension FilterViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let result = viewModel.priceTextFieldWithText(textField.text ?? "", shouldChangeCharactersIn: range, replacementString: string)
        return result
    }
}

extension FilterViewController: FilterViewInterface {
    func updateFilterStatusWithText(_ text: String) {
        filterStatusLabel.text = text
    }
    
    func update(minPriceText: String, maxPriceText: String) {
        minPriceTextField.text = minPriceText
        maxPriceTextField.text = maxPriceText
    }
}
