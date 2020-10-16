//
//  MainView.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/14/20.
//

import UIKit

class MainView: UIView {
    
    //MARK: Public Attributes
    let tableView = UITableView()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Private functions
    private func setUpLayout() {
        backgroundColor = .white
        setUpTableView()
    }
    
    private func setUpTableView() {
        addSubview(tableView)
        
        tableView.anchorTo(superview: self)
    }
    
}
