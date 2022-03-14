//  VIPER Template created by Vladyslav Vdovychenko
//  
//  ExchangeRateViewController.swift
//  ExchangeRates
//
//  Created by Vladyslav Vdovychenko on 14.03.2022.
//

import UIKit

final class ExchangeRateViewController: BaseStateViewController {
    
    @IBOutlet fileprivate weak var mainView: UIView!
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var dateTextField: UITextField!
    
    var presenter: ExchangeRateViewPresenterOutputProtocol?
    var exchangeList: ExchangeList?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: String(describing: ExchangeRateTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ExchangeRateTableViewCell.self))
        self.setupTextField()
        self.loadRates()
    }
    
    fileprivate func setupTextField() {
        let maximumDate = Date()
        let minimumDate = Calendar.current.date(byAdding: .year, value: -3, to: maximumDate)
        self.dateTextField.text = maximumDate.stringWithFormat(kUserInterfaceDateFormat)
        self.dateTextField.setInputViewDatePicker(target: self, selector: #selector(didTapOnDoneOnDateTextField), minimumDate: minimumDate, maximumDate: maximumDate, dateFormat: kUserInterfaceDateFormat)
    }
    
    fileprivate func loadRates() {
        let date = self.dateTextField.text?.convertToDate(withFormat: kUserInterfaceDateFormat) ?? Date()
        self.presenter?.loadRates(for: date)
        self.changeState(.loading)
    }
    
    @objc
    fileprivate func didTapOnDoneOnDateTextField() {
        guard let datePicker = self.dateTextField.inputView as? UIDatePicker else { return }
        defer { self.dateTextField.resignFirstResponder() }
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = kUserInterfaceDateFormat
        self.dateTextField.text = dateformatter.string(from: datePicker.date)
        self.loadRates()
    }
    
    override func contentView() -> UIView {
        return self.mainView
    }
    
    override func didTapOnReloadContentViewButton(_ view: ReloadContentView, sender: UIButton) {
        self.loadRates()
    }

}

extension ExchangeRateViewController: ExchangeRateViewPresenterInputProtocol {
    
    func didReceive(list: ExchangeList) {
        self.exchangeList = list
        self.tableView.reloadData()
        self.changeState(.content)
    }
    
    func didReceive(error: NSError?) {
        self.changeState(.error)
        self.handleError(error)
    }

}

extension ExchangeRateViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exchangeList?.exchangeRateObjects.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ExchangeRateTableViewCell.self)) as? ExchangeRateTableViewCell else { return UITableViewCell() }
        if let object = self.exchangeList?.exchangeRateObjects[safe: indexPath.row] {
            cell.setupCell(with: object)
        }
        return cell
    }

}
