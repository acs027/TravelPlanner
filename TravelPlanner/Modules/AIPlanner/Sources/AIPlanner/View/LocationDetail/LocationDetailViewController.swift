//
//  LocationDetailViewController.swift
//  AIPlanner
//
//  Created by ali cihan on 26.08.2025.
//

import UIKit
import AppResources

@MainActor
protocol LocationDetailViewDelegate: AnyObject {
    func showFolders(for location: TravelLocation)
}

class LocationDetailViewController: UIViewController {
    let location: TravelLocation
    weak var delegate: LocationDetailViewDelegate?

    
    init(location: TravelLocation) {
            self.location = location
            super.init(nibName: nil, bundle: nil)
            modalPresentationStyle = .overFullScreen
            modalTransitionStyle = .crossDissolve
        }
        
        required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.backgroundColor = UIColor.black.withAlphaComponent(0.5) // dim background
            
            let container = UIView()
            container.backgroundColor = .systemBackground
            container.layer.cornerRadius = 16
            container.translatesAutoresizingMaskIntoConstraints = false
            
            let nameLabel = UILabel()
            nameLabel.text = location.name
            nameLabel.font = .boldSystemFont(ofSize: 20)
            nameLabel.textAlignment = .center
            
            let detailsLabel = UILabel()
            detailsLabel.text = location.description
            detailsLabel.textAlignment = .center
            detailsLabel.numberOfLines = 0
            
            let closeButton = UIButton(type: .system)
            closeButton.setTitle("Close", for: .normal)
            closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
            
            let addToMyLocations = UIButton(type: .system)
            addToMyLocations.setTitle("Add to my places", for: .normal)
            addToMyLocations.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
            
            let buttonStack = UIStackView(arrangedSubviews: [ addToMyLocations, closeButton ])
            buttonStack.axis = .horizontal
            buttonStack.spacing = 12
            buttonStack.translatesAutoresizingMaskIntoConstraints = false
            
            let stack = UIStackView(arrangedSubviews: [nameLabel, detailsLabel, buttonStack])
            stack.axis = .vertical
            stack.spacing = 12
            stack.translatesAutoresizingMaskIntoConstraints = false
            
            container.addSubview(stack)
            view.addSubview(container)
            
            NSLayoutConstraint.activate([
                container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                container.widthAnchor.constraint(equalToConstant: 280),
                
                stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 20),
                stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
                stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
                stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20)
            ])
        }
        
        @objc private func closeTapped() {
            dismiss(animated: true)
        }
    
    @objc private func addTapped() {
        delegate?.showFolders(for: location)
    }
}
