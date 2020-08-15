//
//  TableViewController.swift
//  SnapkitPoc
//
//  Created by Sagar on 14/08/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    var tableView = UITableView()
    var sortTypeLabel = UILabel()
    var selectedType = "All"
    var planningTableVM: TableViewModel {
        return TableViewModel.sharedTableVM
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDetails()
        configureParentView()
        setConstraint()
    }
    
    private func configureParentView() {
        title = StringConstant.kListScreenTitle
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: StringConstant.kSortText, style: .plain, target: self, action: #selector(sortTapped))
        tableView.register(TableViewCell.self, forCellReuseIdentifier: AppConstant.tableViewCellIdentifier)
    }
    
    private func setConstraint() {
        view.addSubview(sortTypeLabel)
        view.addSubview(tableView)
        sortTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(10)
            make.right.equalTo(view).offset(-10)
            make.left.equalTo(view).offset(10)
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(sortTypeLabel.snp.bottom).offset(10)
            make.right.equalTo(view).offset(-10)
            make.bottom.equalTo(view).offset(-10)
            make.left.equalTo(view).offset(10)
        }
    }
    
    @objc func sortTapped(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        let imageAction = UIAlertAction(title: "Sorting By Image", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            self.planningTableVM.setSortedArray(selectedType: "image")
            self.setSelectedSortingLabel("image")
            self.tableView.reloadData()
        })
        let dataAction = UIAlertAction(title: "Sorting By Text", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            self.planningTableVM.setSortedArray(selectedType: "text")
            self.setSelectedSortingLabel("text")
            self.tableView.reloadData()
        })
        let noSortAction = UIAlertAction(title: "All Data", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            self.planningTableVM.setSortedArray(selectedType: "All")
            self.setSelectedSortingLabel("All")
            self.tableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        optionMenu.addAction(imageAction)
        optionMenu.addAction(dataAction)
        optionMenu.addAction(noSortAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func setSelectedSortingLabel(_ type: String) {
        selectedType = type
        sortTypeLabel.text = "Sorting By: \(type)".uppercased()
        sortTypeLabel.textAlignment = .center
        sortTypeLabel.backgroundColor = .red
        sortTypeLabel.textColor = .white
        sortTypeLabel.layer.cornerRadius = 10.0
        sortTypeLabel.layer.masksToBounds = true
    }
    
    func getDetails() {
        if InternetManager.isConnectedToInternet {
            addProgressHud()
            planningTableVM.getDetails { [weak self] (isSuccess, detail, errorModel) in
                DispatchQueue.main.async {
                    hideProgressHud()
                    if isSuccess {
                        self?.setTableView()
                    } else {
                        self?.showErrorAlert(errorModel: errorModel)
                    }
                }
            }
        } else {
            setOfflineMode()
        }
    }
    
    func setTableView() {
        tableView.layer.cornerRadius = 10.0
        tableView.layer.masksToBounds = true
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.borderWidth = 1.0
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        setSelectedSortingLabel(selectedType)
    }
    
    private func setOfflineMode() {
        if let list = planningTableVM.getOfflineData(), !list.isEmpty {
            planningTableVM.prepareData(list)
            setTableView()
        } else {
            showErrorAlert(errorModel: getNoInternetErrorModel())
        }
    }
    
    func showErrorAlert(errorModel: NetworkErrorModel?) {
        let networkErrorModel = errorModel ?? getDefaultErrorModel()
        let network = networkErrorModel.networkStatusType
        let alert = UIAlertController(title: network.errorTitle(), message: network.errorDescription(),
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: StringConstant.kOk,
                                      style: UIAlertAction.Style.default,
                                      handler: { _ in
                                        self.navigationController?.popToRootViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension TableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return planningTableVM.sortedDataList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppConstant.tableViewCellIdentifier)  as? TableViewCell
            else { return UITableViewCell() }
        if let data = planningTableVM.sortedDataList?[indexPath.row] {
            cell.setData(details: data)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let data = planningTableVM.sortedDataList?[indexPath.row] {
            return data.type == "text" ? AppConstant.kTextDataTableRowHeight :  AppConstant.kImageDataTableRowHeight
        }
        return AppConstant.kTextDataTableRowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myDetails = planningTableVM.sortedDataList?[indexPath.row]
        if !(myDetails?.planningData?.isEmpty ?? true) {
            let detailsVC = DetailsViewController()
            detailsVC.details = myDetails
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}

