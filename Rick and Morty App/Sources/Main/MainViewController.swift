//
//  MainViewController.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/14/20.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: Private attributes
    private let viewModel: MainViewModelType
    private lazy var mainView = MainView()
    
    // MARK: Init
    init(viewModel: MainViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life cycle
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView.dataSource = self
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "rick")
        cell.textLabel?.text = "Hello World!!"
        
        return cell
    }
}
