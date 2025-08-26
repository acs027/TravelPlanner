//
//  FoldersViewController.swift
//  AIPlanner
//
//  Created by ali cihan on 26.08.2025.
//

import UIKit
import AppResources

@MainActor
protocol FoldersViewDelegate: AnyObject {
    func createFolder(name: String)
    func add(location: TravelLocation, to folder: Folder)
    func delete(folder: Folder)
}

class FoldersViewController: UIViewController {
    private var folders: [Folder] = []
    private let collectionView: UICollectionView
    private let createFolderButton: UIButton =  {
        let button = UIButton(type: .system)
        button.setTitle("Create new folder", for: .normal)
        return button
    }()
    weak var delegate: FoldersViewDelegate?
    var location: TravelLocation?
    
    // MARK: - Init
    init() {
        // Create a grid layout
        let layout = UICollectionViewFlowLayout()
        let itemWidth = UIScreen.main.bounds.width / 3 - 20 // 3 columns with spacing
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 20, left: 12, bottom: 20, right: 12)
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Dim background
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        // Configure collection view
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 12
        collectionView.register(FolderCell.self, forCellWithReuseIdentifier: "FolderCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        collectionView.addGestureRecognizer(longPress)
        
        
        createFolderButton.addTarget(self, action: #selector(createFolderButtonTapped), for: .touchUpInside)
        createFolderButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(createFolderButton)
        
        // Layout
        NSLayoutConstraint.activate([
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.heightAnchor.constraint(equalToConstant: 300),
            createFolderButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            createFolderButton.widthAnchor.constraint(equalToConstant: 100),
            createFolderButton.heightAnchor.constraint(equalToConstant: 100)
            
        ])
    }
    
    func configure(folders: [Folder]) {
        self.folders = folders
        self.collectionView.reloadData()
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createFolderButtonTapped() {
        let alertController = UIAlertController(
                title: "Create new folder",
                message: nil,
                preferredStyle: .alert
            )
            
            alertController.addTextField { textField in
                textField.placeholder = "Folder name"
            }
            
            let createAction = UIAlertAction(title: "Create", style: .default) { [weak self] _ in
                if let folderName = alertController.textFields?.first?.text, !folderName.isEmpty {
                    self?.delegate?.createFolder(name: folderName)
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            alertController.addAction(createAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true)
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        
        let point = gesture.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: point) {
            let folder = folders[indexPath.item]
            
            let alert = UIAlertController(
                title: "Delete Folder",
                message: "Are you sure you want to delete '\(folder.name)'?",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                // Remove from local list
                let folder = self.folders[indexPath.item]
                self.folders.remove(at: indexPath.item)
                self.collectionView.deleteItems(at: [indexPath])
                self.delegate?.delete(folder: folder)
            })
            
            present(alert, animated: true)
        }
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension FoldersViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        folders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FolderCell", for: indexPath) as! FolderCell
        cell.configure(with: folders[indexPath.item].name)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let folder = folders[indexPath.item]
        print("Selected folder: \(folder)")
        if let location = location {
            self.delegate?.add(location: location, to: folder)
        }
        
        // Call your logic to save the location to this folder
        dismiss(animated: true)
    }
}


