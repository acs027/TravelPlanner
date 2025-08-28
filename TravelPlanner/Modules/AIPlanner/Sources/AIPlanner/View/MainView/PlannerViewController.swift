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

@MainActor
protocol PlannerViewMapManagerProtocol {
    func focusMapOn(_ location: TravelLocation)
    func showLocations(_ locations: [TravelLocation])
}

@MainActor
protocol PlannerViewProtocol: AnyObject, PlannerViewMapManagerProtocol {
    func setGenerateButtonEnabled(isEnabled: Bool)
    func showLocationOverlay(with locations: [TravelLocation])
    func collapseTextFieldAnimated()
}

@objc(PlannerViewController)
class PlannerViewController: UIViewController {
    @IBOutlet weak var promptTextField: UITextField!
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationOverlayView: LocationOverlayView!
    @IBOutlet weak var promptTextFieldWidthConstraint: NSLayoutConstraint!
    var presenter: PlannerPresenterProtocol!

    private var animationManager: PlannerUIAnimationManagerProtocol?
    private var mapManager: PlannerMapManagerProtocol?
    
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
        
        animationManager = PlannerUIAnimationManager(promptTextField: promptTextField, promptTextFieldWidthConstraint: promptTextFieldWidthConstraint, containerView: view)
        
        mapManager = PlannerMapManager(mapView: mapView, delegate: self)
        
        generateButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        locationOverlayView.delegate = self
        locationOverlayView.isHidden = true
    }
    
    @objc private func sendTapped() {
        if promptTextFieldWidthConstraint.constant == 0 {
            expandTextFieldAnimated()
        } else {
            presenter.didTapSend(prompt: promptTextField.text ?? "")
        }
    }
    
    private func showPromptTextFieldAnimated() {
        animationManager?.showPromptTextField()
    }
    
    private func expandTextFieldAnimated() {
        animationManager?.expandTextField()
    }
}

extension PlannerViewController: PlannerViewProtocol {
    func showLocationOverlay(with locations: [TravelLocation]) {
        locationOverlayView.locations = locations
        locationOverlayView.isHidden = false
        view.bringSubviewToFront(locationOverlayView)
    }
    
    func setGenerateButtonEnabled(isEnabled: Bool) {
        generateButton.isEnabled = isEnabled
    }
    
    func collapseTextFieldAnimated() {
        animationManager?.collapseTextField()
    }
}

//MARK: - PlannerViewMapManagerProtocol
extension PlannerViewController: PlannerViewMapManagerProtocol {
    func showLocations(_ locations: [TravelLocation]) {
        mapManager?.showLocations(locations)
    }
    
    func focusMapOn(_ location: TravelLocation) {
        mapManager?.focusOn(location)
    }
}

//MARK: - LocationOverlayViewDelegate
extension PlannerViewController: LocationOverlayViewDelegate {
    func didSelectLocation(_ location: TravelLocation) {
        presenter.didSelectLocation(location)
    }
}

extension PlannerViewController: PlannerMapManagerDelegate {
}
