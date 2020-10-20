//
//  DetailsViewController.swift
//  Rick and Morty App
//
//  Created by Caio Ortu on 10/19/20.
//

import UIKit

class DetailsViewController: UIViewController, AlertDisplayer {
    
    // MARK: Private attributes
    private let detailsView: DetailsView
    private var viewModel: DetailsViewModelType
    private let imageDowloader: ImageDownloaderType
    
    // MARK: Init
    init(viewModel: DetailsViewModelType, imageDowloader: ImageDownloaderType) {
        self.viewModel = viewModel
        self.detailsView = DetailsView()
        self.imageDowloader = imageDowloader
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life cycle
    override func loadView() {
        view = detailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        viewModel.delegate = self
        viewModel.fetchCharacter()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    // MARK: Private functions
    @objc private func addAsFavorite() {
        viewModel.markAsFavorite()
    }
}

// MARK: DetailsViewModelProtocol
extension DetailsViewController: DetailsViewModelProtocol {
    func didCompleteFetch(with character: Character) {
        detailsView.loadLayout(with: character, imageDownloader: imageDowloader)
    }
    
    func willShowAlert(title: String?, message: String?) {
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        displayAlert(with: title, message: message, actions: [okAction])
    }
    
    func viewShouldLoadFetch(_ loading: Bool) {
        loading ? detailsView.activityIndicator.startAnimating() : detailsView.activityIndicator.stopAnimating()
    }
    
    func popView() {
        navigationController?.popViewController(animated: true)
    }
    
    func didMarkAsFavorite(_ favorite: Bool) {
        let favoriteImage = UIImage(systemName: favorite ? "heart.fill" : "heart")
        
        guard let rightBarButtonItem = navigationItem.rightBarButtonItem else {
            let favotiteButton = UIBarButtonItem(image: favoriteImage,
                                                 style: .done,
                                                 target: self,
                                                 action: #selector(addAsFavorite))
            
            navigationItem.rightBarButtonItem = favotiteButton
            return
        }
        
        rightBarButtonItem.image = favoriteImage
    }
}
