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
    static var imageHeight: CGFloat = 200
}

final class HomeViewController: UIViewController {
    private var viewModel: HomeViewModel!
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter a picture name"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
        button.setTitle("Confirm", for: .normal)
        button.layer.masksToBounds = true
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
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: HomeAppearance.imageHeight),
            
            textField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            
            submitButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: HomeAppearance.buttonHeight),
            submitButton.widthAnchor.constraint(equalToConstant: HomeAppearance.buttonWidth)
        ])
        
        submitButton.layer.cornerRadius = HomeAppearance.buttonHeight/2
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    private func setupViewModel() {
        viewModel = HomeViewModel()
        
        viewModel.image.bind { [weak self] image in
            self?.imageView.image = image
        }
        
        viewModel.error.bind { [weak self] error in
            if let error = error {
                self?.presentAlert(message: error.localizedDescription)
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
    
    private func presentAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

