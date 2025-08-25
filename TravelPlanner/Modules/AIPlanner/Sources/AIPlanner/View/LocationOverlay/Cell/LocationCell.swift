//
//  LocationCell.swift
//  TravelPlanner
//
//  Created by ali cihan on 2.08.2025.
//
// LocationCell.swift// LocationCell.swift
import UIKit
import AppResources

class LocationCell: UICollectionViewCell {
    static let reuseIdentifier = "LocationCell"
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var locationSymbol: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        MainActor.assumeIsolated {
            setupUI()
        }
    }
    
    
    private func setupUI() {
        // Style the container view
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 20
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowOpacity = 0.1
        
        // Style the title label
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .darkGray
        titleLabel.textAlignment = .center
    }
    
    func configure(with location: TravelLocation) {
        titleLabel.text = location.name
        locationSymbol.image = UIImage(systemName: location.symbol)
    }
    
    override var isHighlighted: Bool {
        didSet {
            containerView.transform = isHighlighted ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
        }
    }
}
