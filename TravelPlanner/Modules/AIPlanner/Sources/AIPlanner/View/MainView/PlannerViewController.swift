//
//  PlannerViewController.swift
//  TravelPlanner
//
//  Created by ali cihan on 23.07.2025.
//
// PlannerViewController.swift
import UIKit
import MapKit
import AppResources


@objc(PlannerViewController)
class PlannerViewController: UIViewController {
    @IBOutlet weak var promptTextField: UITextField!
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationOverlayView: LocationOverlayView!
    @IBOutlet weak var promptTextFieldWidthConstraint: NSLayoutConstraint!
    var presenter: PlannerPresenterProtocol!
    
    public init() {
        let bundle = Bundle.module
        print("Loading XIB from bundle: \(bundle)")
        super.init(nibName: "PlannerViewController", bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
          super.init(coder: coder)
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad called, view: \(String(describing: view))")
        setupUI()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        title = "Travel Planner"
        
        // Add logout button for testing coordinator navigation
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
        let settingsButton = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsTapped))
        let navigateToUserProfile = UIBarButtonItem(title: "UserProfile", style: .plain, target: self, action: #selector(userProfileTapped))
        
        navigationItem.leftBarButtonItem = logoutButton
//        navigationItem.rightBarButtonItem = settingsButton
        navigationItem.rightBarButtonItems = [settingsButton, navigateToUserProfile]
    }
    
    @objc private func logoutTapped() {
        presenter.didRequestLogout()
    }
    
    @objc private func settingsTapped() {
        presenter.didRequestSettings()
    }
    @objc private func userProfileTapped() {
        presenter.didRequestUserProfile()
    }
    
    private func setupUI() {
        guard let generateButton = generateButton,
              let locationOverlayView = locationOverlayView,
              let mapView = mapView,
              let promptTextField = promptTextField,
              let promptTextFieldWidthConstraint = promptTextFieldWidthConstraint else {
            print("ERROR: One or more IBOutlets are nil. Check XIB connections.")
            return
        }
        
        generateButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        locationOverlayView.delegate = self
        locationOverlayView.isHidden = true
        mapView.delegate = self
        
        promptTextField.alpha = 0
        promptTextFieldWidthConstraint.constant = 0
        view.layoutIfNeeded()
    }
    
    @objc private func sendTapped() {
        if promptTextFieldWidthConstraint.constant == 0 {
            expandTextFieldAnimated()
        } else {
            presenter.didTapSend(prompt: promptTextField.text ?? "")
        }
    }
    
    private func showLocationOverlay(with locations: [TravelLocation]) {
        locationOverlayView.locations = locations
        locationOverlayView.isHidden = false
        view.bringSubviewToFront(locationOverlayView)
    }
    
    private func showPromptTextFieldAnimated() {
        promptTextField.isHidden = false
        promptTextField.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut], animations: {
            self.promptTextField.alpha = 1
        })
    }
    
    private func expandTextFieldAnimated() {
        let screenWidth = UIScreen.main.bounds.size.width
        let expandedWidth: CGFloat = screenWidth - 80

        promptTextField.alpha = 0
        promptTextFieldWidthConstraint.constant = expandedWidth

        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut], animations: {
            self.promptTextField.alpha = 1
            self.view.layoutIfNeeded()
        })
    }
    
    private func collapseTextFieldAnimated() {
        promptTextFieldWidthConstraint.constant = 0

        UIView.animate(withDuration: 0.3, animations: {
            self.promptTextField.alpha = 0
            self.view.layoutIfNeeded()
        })
    }
}

extension PlannerViewController: LocationOverlayViewDelegate {
    func didSelectLocation(_ location: TravelLocation) {
        presenter.didSelectLocation(location)
    }
}

extension PlannerViewController: PlannerViewProtocol {
    func showLocations(_ locations: [TravelLocation]) {
        mapView.removeAnnotations(mapView.annotations)
        
        var coordinates: [CLLocationCoordinate2D] = []
        
        for location in locations {
            let annotation = CustomAnnotation(
                title: location.name,
                subtitle: location.description,
                coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude),
                imageName: location.symbol
            )
            
            mapView.addAnnotation(annotation)
            coordinates.append(annotation.coordinate)
        }
        
        // Focus the map on the shown locations
        if !coordinates.isEmpty {
            var minLat = coordinates[0].latitude
            var maxLat = coordinates[0].latitude
            var minLon = coordinates[0].longitude
            var maxLon = coordinates[0].longitude
            
            for coord in coordinates {
                minLat = min(minLat, coord.latitude)
                maxLat = max(maxLat, coord.latitude)
                minLon = min(minLon, coord.longitude)
                maxLon = max(maxLon, coord.longitude)
            }
            
            let span = MKCoordinateSpan(
                latitudeDelta: (maxLat - minLat) * 1.5,
                longitudeDelta: (maxLon - minLon) * 1.5
            )
            let center = CLLocationCoordinate2D(
                latitude: (minLat + maxLat) / 2,
                longitude: (minLon + maxLon) / 2
            )
            let region = MKCoordinateRegion(center: center, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func updateState(_ state: PlannerViewState) {
        switch state {
        case .idle:
            generateButton.isEnabled = true
        case .loading:
            generateButton.isEnabled = false
        case .success(let locations):
            generateButton.isEnabled = true
            showLocations(locations)
            showLocationOverlay(with: locations)
            collapseTextFieldAnimated()
        case .failure(let error):
            generateButton.isEnabled = true
            showError(error.localizedDescription)
        }
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func focusMapOn(_ location: TravelLocation) {
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
}

extension PlannerViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let customAnnotation = annotation as? CustomAnnotation else { return nil }
        
        let identifier = "CustomAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: customAnnotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = customAnnotation
        }
        
        annotationView?.image = UIImage(systemName: customAnnotation.imageName)
        
        return annotationView
    }
}


