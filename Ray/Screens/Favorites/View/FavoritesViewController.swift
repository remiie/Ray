//
//  FavoritesViewController.swift
//  Ray
//
//  Created by Роман Васильев on 11.05.2023.
//

import UIKit

final class FavoritesViewController: UIViewController {
    private var viewModel: FavoritesViewModel!
  
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.identifier)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupViewModel()
        setupSwipeToDelete()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadFavoriteItems()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    
    private func setupSwipeToDelete() {
         tableView.delegate = self
         
         tableView.allowsMultipleSelectionDuringEditing = false
         tableView.setEditing(true, animated: false)
     }
    
    private func setupViewModel() {
        viewModel = FavoritesViewModel()
        
        viewModel.favoriteItems.bind(observer: { [weak self] _ in
            self?.tableView.reloadData()
        })
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favoriteItems.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.identifier, for: indexPath) as? FavoriteCell else {
            return UITableViewCell()
        }
        let item = viewModel.favoriteItems.value[indexPath.row]
        cell.configure(withImage: item.image, description: item.description)
        return cell
    }
}

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeFavoriteItem(indexPath.row)
        }
    }
}


