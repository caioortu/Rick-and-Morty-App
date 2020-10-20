//
//  CharactersView.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/14/20.
//

import UIKit

class CharactersView: UIView {
    
    // MARK: Public Attributes
    let tableView = UITableView()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private functions
    private func setUpLayout() {
        backgroundColor = .systemBackground
        setupTableView()
        setupActivityIndicator()
    }
    
    private func setupTableView() {
        addSubview(tableView)
        
        tableView.anchorTo(superview: self)
    }
    
    private func setupActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        
        addSubview(activityIndicator)
        activityIndicator.anchorCenterSuperview()
    }
}

extension CharactersView {
    func registerCells() {
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: CharacterTableViewCell.identifier)
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}
