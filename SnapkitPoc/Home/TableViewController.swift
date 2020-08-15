//
//  TableViewController.swift
//  LearningSnapKit
//
//  Created by Matías Elorriaga on 8/11/16.
//  Copyright © 2016 melorriaga. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    
    var planningTableVM: TableViewModel {
        return TableViewModel.sharedTableVM
    }

    var tableView = UITableView()
    var sortTypeLabel = UILabel()
    var selectedType = "All"

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(sortTapped))
        setSelectedSortingLabel(selectedType)
        getArticleDetails()
        title = "List"
        view.addSubview(sortTypeLabel)
        view.addSubview(tableView)

        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCellReuseIdentifier")
        
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
    }
    
    func getArticleDetails() {
        if InternetManager.isConnectedToInternet {
            addProgressHud()
            planningTableVM.getArticleDetails { [weak self] (isSuccess, detail, errorModel) in
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
            self.showErrorAlert(errorModel: getNoInternetErrorModel())
        }
    }
    
    func showErrorAlert(errorModel: NetworkErrorModel?) {
        let networkErrorModel = errorModel ?? getDefaultErrorModel()
        let network = networkErrorModel.networkStatusType
        let alert = UIAlertController(title: network.errorTitle(), message: network.errorDescription(),
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: AppConstant.kOk,
                                      style: UIAlertAction.Style.default,
                                      handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        //articleTableView.rowHeight = UITableView.automaticDimension
        //articleTableView.estimatedRowHeight = AppConstant.kDataTableRowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.reloadData()
    }
}

extension TableViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return planningTableVM.sortedDataList?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellReuseIdentifier")  as? TableViewCell
            else { return UITableViewCell() }
        if let data = planningTableVM.sortedDataList?[indexPath.row] {
            cell.setData(details: data)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AppConstant.kDataTableRowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /*func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }*/
}

