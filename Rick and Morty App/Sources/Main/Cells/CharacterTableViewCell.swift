//
//  CharacterTableViewCell.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/16/20.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {
    
    // MARK: Private attributes
    private let characterImageView = UIImageView()
    private let nameLabel = UILabel()
    private let locationLabel = UILabel()
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public functions
    func set(character: Character) {
        nameLabel.text = character.name
        locationLabel.attributedText = configAttributedString(firstString: "Last known location:\n",
                                                              lastString: character.location.name)
    }
    
    // MARK: Private functions
    private func setupLayout() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        
        addSubview(stackView)
        stackView.anchorTo(superview: self, topConstant: 20, leftConstant: 20, bottomConstant: 20, rightConstant: 20)
        
        setupLabels()
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(locationLabel)
    }
    
    private func setupLabels() {
        setupNameLabel()
        setupLocationLabel()
    }
    
    private func setupNameLabel() {
        nameLabel.font = .systemFont(ofSize: 22, weight: .bold)
        nameLabel.anchor()
    }
    
    private func setupLocationLabel() {
        locationLabel.numberOfLines = 0
        locationLabel.lineBreakMode = .byWordWrapping
    }
    
    private func configAttributedString(firstString: String, lastString: String) -> NSAttributedString {
        NSAttributedString.highlightOccurrence(of: firstString,
                                               in: firstString + lastString,
                                               highlightAttributes: [.foregroundColor: UIColor.gray,
                                                                     .font: UIFont.systemFont(ofSize: 14, weight: .regular)])
    }
}
