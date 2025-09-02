//
//  FoldersViewController.swift
//  AIPlanner
//
//  Created by ali cihan on 26.08.2025.
//

import UIKit
import AppResources

@MainActor
protocol FoldersViewProtocol: AnyObject {
    func update()
}

final class FoldersViewController: UIViewController {
    var presenter: FoldersPresenterProtocol!
    
    private let collectionView: UICollectionView
    private let createFolderButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.systemBlue
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 32, weight: .bold)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        return button
    }()
    
    init() {
        let layout = UICollectionViewFlowLayout()
        let padding: CGFloat = 16
        let itemWidth = (UIScreen.main.bounds.width - (padding * 4)) / 3
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        // Collection View
        collectionView.backgroundColor = .systemBackground
        collectionView.layer.cornerRadius = 16
        collectionView.register(FolderCell.self, forCellWithReuseIdentifier: "FolderCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        collectionView.addGestureRecognizer(longPress)
        
        
        // Create Folder Button
        createFolderButton.addTarget(self, action: #selector(createFolderButtonTapped), for: .touchUpInside)
        createFolderButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(createFolderButton)
        
        // Layout
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            
            createFolderButton.widthAnchor.constraint(equalToConstant: 60),
            createFolderButton.heightAnchor.constraint(equalToConstant: 60),
            createFolderButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            createFolderButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }

    
    override func viewWillAppear(_ animated: Bool) {
        presenter.didRequestFetchFolders()
    }
    
    @objc private func closeTapped() {
        presenter.didRequestDismiss()
    }
    
    @objc private func createFolderButtonTapped() {
        presenter.didRequestCreateFolder()
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        let point = gesture.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: point) {
            self.presenter.didRequestDelete(at: indexPath.item)
        }
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension FoldersViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.foldersCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FolderCell", for: indexPath) as! FolderCell
        cell.configure(with: presenter.folder(at: indexPath.item).name)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let folder = presenter.folder(at: indexPath.item)
        print("Selected folder: \(folder)")
        presenter.didSelectFolder(folder: folder)
    }
}

extension FoldersViewController: FoldersViewProtocol {
    func update() {
        self.collectionView.reloadData()
    }
}

