//
//  LocationOverlayView.swift
//  TravelPlanner
//
//  Created by ali cihan on 31.07.2025.

//// LocationOverlayView.swift
import UIKit
import AppResources

@MainActor
protocol LocationOverlayViewDelegate: AnyObject {
    func didSelectLocation(_ location: TravelLocation)
}

class LocationOverlayView: UIView {
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: LocationOverlayViewDelegate?
    
    var locations: [TravelLocation] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        addSubview(view)
        
        setupCollectionView()
    }
    
    private func loadViewFromNib() -> UIView? {
        let nibName = String(describing: type(of: self))
        let bundle = Bundle.module
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    private func setupCollectionView() {
        // Register the NIB for the cell
        let cellNib = UINib(nibName: LocationCell.reuseIdentifier, bundle: Bundle.module)
        collectionView.register(cellNib, forCellWithReuseIdentifier: LocationCell.reuseIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Configure layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        collectionView.collectionViewLayout = layout
        
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
    }
}

extension LocationOverlayView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationCell.reuseIdentifier, for: indexPath) as! LocationCell
        cell.configure(with: locations[indexPath.item])
        return cell
    }
}

extension LocationOverlayView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let location = locations[indexPath.item]
        delegate?.didSelectLocation(location)
    }
}

extension LocationOverlayView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Calculate size based on content
        let location = locations[indexPath.item]
        let font = UIFont.systemFont(ofSize: 16, weight: .medium)
        let textWidth = location.name.size(withAttributes: [.font: font]).width
        return CGSize(width: textWidth + 32, height: 40) // Add padding
    }
}
