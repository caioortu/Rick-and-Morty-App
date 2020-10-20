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
    private let imageStackView = UIStackView()
    private let stackView = UIStackView()
    private let activityIndicator = UIActivityIndicatorView()
    private let imageActivityIndicator = UIActivityIndicatorView()
    
    private var imageDowloader: ImageDownloaderType?
    private var character: Character?
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        characterImageView.image = nil
        nameLabel.text = nil
        locationLabel.text = nil
    }
    
    // MARK: Public functions
    func set(character: Character?, imageDowloader: ImageDownloaderType) {
        guard let character = character else {
            activityIndicator.startAnimating()
            return
        }
        
        self.imageDowloader = imageDowloader
        self.character = character
        
        activityIndicator.stopAnimating()
        nameLabel.text = character.name
        locationLabel.attributedText = configAttributedString(firstString: "Last known location:\n",
                                                              lastString: character.location.name)
        loadImage(url: character.image)
    }
    
    // MARK: Private functions
    private func loadImage(url: String?) {
        let characterId = character?.id
        
        imageActivityIndicator.startAnimating()
        imageDowloader?.loadImage(url: url ?? "") { [weak self] result in
            self?.imageActivityIndicator.stopAnimating()
            
            switch result {
            case .success(let image):
                if characterId == self?.character?.id {
                    self?.characterImageView.image = image
                }
            case .failure:
                break
            }
        }
    }
    
    private func configAttributedString(firstString: String, lastString: String) -> NSAttributedString {
        NSAttributedString.highlightOccurrence(
            of: firstString,
            in: firstString + lastString,
            highlightAttributes: [
                .foregroundColor: UIColor.gray,
                .font: UIFont.systemFont(ofSize: 14, weight: .regular)
            ]
        )
    }
}
    
// MARK: Layout
private extension CharacterTableViewCell {
    
    func setupLayout() {
        selectionStyle = .none
        
        setupImageStack()
        setupStack()
        
        activityIndicator.hidesWhenStopped = true
        addSubview(activityIndicator)
        activityIndicator.anchorCenterSuperview()
    }
    
    func setupImageStack() {
        imageStackView.axis = .horizontal
        imageStackView.spacing = 10
        imageStackView.alignment = .center
        imageStackView.distribution = .fillProportionally
        
        addSubview(imageStackView)
        imageStackView.anchorTo(superview: self, topConstant: 20, leftConstant: 20, bottomConstant: 20, rightConstant: 20)
        
        setupImage()
        imageStackView.addArrangedSubview(characterImageView)
    }
    
    func setupStack() {
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        
        imageStackView.addArrangedSubview(stackView)
        
        setupLabels()
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(locationLabel)
    }
    
    func setupImage() {
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            characterImageView.widthAnchor.constraint(equalToConstant: 85),
            characterImageView.heightAnchor.constraint(equalToConstant: 85)
        ])
        
        characterImageView.contentMode = .scaleAspectFit
        characterImageView.layer.cornerRadius = 15
        characterImageView.clipsToBounds = true
        
        characterImageView.addSubview(imageActivityIndicator)
        imageActivityIndicator.anchorCenterSuperview()
        
        imageActivityIndicator.hidesWhenStopped = true
    }
    
    func setupLabels() {
        setupNameLabel()
        setupLocationLabel()
    }
    
    func setupNameLabel() {
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        
        nameLabel.font = .systemFont(ofSize: 22, weight: .bold)
    }
    
    func setupLocationLabel() {
        locationLabel.numberOfLines = 0
        locationLabel.lineBreakMode = .byWordWrapping
    }
}
