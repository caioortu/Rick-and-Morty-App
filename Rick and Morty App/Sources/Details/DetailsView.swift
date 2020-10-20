//
//  DetailsView.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/19/20.
//

import UIKit

class DetailsView: UIView {

    // MARK: Public Attributes
    let stackView = UIStackView()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: Private Attributes
    private let imageView = UIImageView()
    private let imageActivityIndicator = UIActivityIndicatorView()
    private let nameLabel = UILabel()
    private let statusSpeciesLabel = UILabel()
    private let originLabel = UILabel()
    private let locationLabel = UILabel()
    private lazy var labels = [nameLabel, statusSpeciesLabel, originLabel, locationLabel]
    
    private var imageDownloader: ImageDownloaderType?
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public functions
    func loadLayout(with character: Character, imageDownloader: ImageDownloaderType) {
        self.imageDownloader = imageDownloader
        
        loadImage(url: character.image)
        nameLabel.text = character.name
        statusSpeciesLabel.text = "\(character.status) - \(character.species)"
        originLabel.attributedText = configAttributedString(firstString: "Originally from:\n",
                                                            lastString: character.origin.name)
        locationLabel.attributedText = configAttributedString(firstString: "Last known location:\n",
                                                              lastString: character.location.name)
    }
    
    // MARK: Private functions
    private func loadImage(url: String) {
        imageActivityIndicator.startAnimating()
        imageDownloader?.loadImage(url: url) { [weak self] result in
            self?.imageActivityIndicator.stopAnimating()
            
            switch result {
            case .success(let image):
                self?.imageView.image = image
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
                .font: UIFont.systemFont(ofSize: 16, weight: .regular)
            ]
        )
    }
    
    private func setupLayout() {
        backgroundColor = .systemBackground
        setupActivityIndicator()
        setupVerticalStackView()
    }
    
    private func setupActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        
        addSubview(activityIndicator)
        activityIndicator.anchorCenterSuperview()
    }
    
    private func setupVerticalStackView() {
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .top
        stackView.distribution = .fill
        
        addSubview(stackView)
        stackView.anchor(top: safeAreaLayoutGuide.topAnchor,
                         left: safeAreaLayoutGuide.leftAnchor,
                         right: safeAreaLayoutGuide.rightAnchor,
                         topConstant: 20,
                         leftConstant: 20,
                         rightConstant: 20)
        
        setupImageView()
        setupNameLabel()
        setupLabel()
    }
    
    private func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 145),
            imageView.heightAnchor.constraint(equalToConstant: 145)
        ])
        
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        
        stackView.addArrangedSubview(imageView)
        
        imageView.addSubview(imageActivityIndicator)
        imageActivityIndicator.anchorCenterSuperview()
        
        imageActivityIndicator.hidesWhenStopped = true
    }
    
    private func setupNameLabel() {
        nameLabel.font = .systemFont(ofSize: 28, weight: .bold)
    }
    
    private func setupLabel() {
        labels.forEach { label in
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            
            stackView.addArrangedSubview(label)
        }
    }
}
