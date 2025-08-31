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
    private let createFolderButton: UIButton =  {
        let button = UIButton(type: .contactAdd)
        button.setTitle("Create new folder", for: .normal)
        return button
    }()
    
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
        
//        modalPresentationStyle = .fullScreen
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
//            collectionView.heightAnchor.constraint(equalToConstant: 300),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: createFolderButton.topAnchor),
            createFolderButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            createFolderButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            createFolderButton.widthAnchor.constraint(equalToConstant: 100),
            createFolderButton.heightAnchor.constraint(equalToConstant: 100)
            
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

