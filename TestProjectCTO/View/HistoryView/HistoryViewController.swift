//
//  HistoryViewController.swift
//  TestProjectCTO
//
//  Created by MacMini on 12.05.2022.
//

import UIKit
import Combine

class HistoryViewController: UIViewController {
    
    
    lazy var searchBar : UISearchBar = {
       let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search zip code"
        let bar = UIToolbar()
        let reset = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        bar.items = [reset]
        bar.sizeToFit()
        searchBar.inputAccessoryView = bar
        searchBar.backgroundColor = .systemGroupedBackground
        searchBar.delegate = self
        return searchBar
    }()
    
    lazy var tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        return tableView
        
    }()
    
    lazy var emptyLabel : UILabel = {
       let label = UILabel()
        
       
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "There is no zip code to show here"
        return label
    }()
    
    
    
   
    var cancellables : [AnyCancellable] = []
    
    var viewModel = HistoryViewModel()
    
    var dataSource : UITableViewDiffableDataSource<Int,ZipCodeResponse>!
    var snapShot : NSDiffableDataSourceSnapshot<Int,ZipCodeResponse>!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDataSource()
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel = HistoryViewModel()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.$filteredSearches
            .receive(on: RunLoop.main)
            .sink { models in
                self.applySnapShot(models)
                self.emptyLabel.isHidden = !models.isEmpty
            }
            .store(in: &cancellables)
    }
    
    func setupUI() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        view.backgroundColor = .systemGroupedBackground
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 44),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        
        ])
    }
    
    func setupDataSource() {
        self.dataSource = UITableViewDiffableDataSource<Int,ZipCodeResponse>(tableView: tableView, cellProvider: { tableView, indexPath, model in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            
            var config = cell.defaultContentConfiguration()
            config.text = model.postCode
          
            config.textProperties.font = .systemFont(ofSize: 20, weight: .bold)
            config.textProperties.color = .label
            
            cell.contentConfiguration = config
            
            return cell
        })
        dataSource.defaultRowAnimation = .fade
    }

    
    private func applySnapShot(_ recentSearches : [ZipCodeResponse]) {
        self.snapShot = NSDiffableDataSourceSnapshot<Int,ZipCodeResponse>()
        snapShot.appendSections([0])
        snapShot.appendItems(recentSearches, toSection: 0)
        dataSource.apply(snapShot, animatingDifferences: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
   

}


extension HistoryViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterHistory(with: searchText)
    }
}

extension HistoryViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let response = viewModel.filteredSearches[indexPath.row]
        self.presentResponse(response)
    }
}

extension HistoryViewController : ZipDetailPresentable {}
