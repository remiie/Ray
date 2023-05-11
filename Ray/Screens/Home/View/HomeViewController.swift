//
//  HomeViewController.swift
//  Ray
//
//  Created by Роман Васильев on 11.05.2023.
//

import UIKit

struct HomeAppearance {
    static var buttonWidth: CGFloat = 120
    static var buttonHeight: CGFloat = 40
    static var imageHeight: CGFloat = 400
}

final class HomeViewController: UIViewController {
    private var viewModel: HomeViewModel!
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Favorite", for: .normal)
        button.backgroundColor = .white
        button.tintColor = .black
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.withAlphaComponent(0.7).cgColor
        button.layer.masksToBounds = true
        button.accessibilityIdentifier = "FavoriteButton"
        button.translatesAutoresizingMaskIntoConstraints = false
       
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.accessibilityIdentifier = "ImageView"
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter a picture name"
        textField.borderStyle = .roundedRect
        textField.accessibilityIdentifier = "SearchTextField"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
        button.setTitle("Search", for: .normal)
        button.layer.masksToBounds = true
        button.accessibilityIdentifier = "SubmitButton"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupViewModel()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        view.addSubview(textField)
        view.addSubview(submitButton)
        view.addSubview(favoriteButton)
        imageView.addSubview(activityIndicator)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        view.addGestureRecognizer(tapGesture)

        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 100),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: HomeAppearance.imageHeight),
            
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            textField.widthAnchor.constraint(equalToConstant: 260),
            
            submitButton.topAnchor.constraint(equalTo: textField.topAnchor, constant: 0),
            submitButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: HomeAppearance.buttonHeight),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            submitButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 10),
            
            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),

            favoriteButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: -25),
            favoriteButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -10),
            favoriteButton.widthAnchor.constraint(equalToConstant: 80),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40)
        ])
       
        submitButton.layer.cornerRadius = HomeAppearance.buttonHeight/2
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func setupViewModel() {
        viewModel = HomeViewModel()
        
        viewModel.image.bind { [weak self] image in
            self?.imageView.image = image
            self?.favoriteButton.isHidden = image == nil ? true : false
        }
        
        viewModel.error.bind { [weak self] error in
            if let error = error {
                self?.presentAlert(message: error.localizedDescription)
            }
        }
        
        viewModel.isLoading.bind { [weak self] isLoading in
            if isLoading {
                self?.activityIndicator.startAnimating()
            } else {
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    @objc private func submitButtonTapped() {
        guard let query = textField.text, !query.isEmpty else {
            presentAlert(message: "Please enter the query")
            return
        }
        viewModel.fetchImage(withQuery: query)
    }
    
    @objc private func favoriteButtonTapped() {
        let color = favoriteButton.tintColor
        favoriteButton.tintColor = color == .black ? .gray : .black
        favoriteButton.isHidden = true
        if let image = imageView.image {
            viewModel.addToFavorites(image: image)
        }
        
     }
    
    private func presentAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

