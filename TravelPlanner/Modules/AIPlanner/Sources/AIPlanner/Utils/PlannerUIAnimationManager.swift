//
//  File.swift
//  AIPlanner
//
//  Created by ali cihan on 27.08.2025.
//

import UIKit

@MainActor
protocol PlannerUIAnimationManagerProtocol {
    func expandTextField()
    func collapseTextField()
    func showPromptTextField()
}

final class PlannerUIAnimationManager {
    private weak var promptTextField: UITextField?
    private weak var promptTextFieldWidthConstraint: NSLayoutConstraint?
    private weak var containerView: UIView?
    
    init(promptTextField: UITextField, promptTextFieldWidthConstraint: NSLayoutConstraint, containerView: UIView) {
        self.promptTextField = promptTextField
        self.promptTextFieldWidthConstraint = promptTextFieldWidthConstraint
        self.containerView = containerView
    }
}

extension PlannerUIAnimationManager: PlannerUIAnimationManagerProtocol {
    func expandTextField() {
        guard let promptTextField = promptTextField,
              let promptTextFieldWidthConstraint = promptTextFieldWidthConstraint,
              let containerView = containerView else { return }
        
        let screenWidth = UIScreen.main.bounds.size.width
        let expandedWidth: CGFloat = screenWidth - 80
        
        promptTextField.alpha = 0
        promptTextFieldWidthConstraint.constant = expandedWidth
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut]) {
            promptTextField.alpha = 1
            containerView.layoutIfNeeded()
        }
        
    }
    
    func collapseTextField() {
        guard let promptTextField = promptTextField,
              let promptTextFieldWidthConstraint = promptTextFieldWidthConstraint,
              let containerView = containerView else { return }
        
        promptTextFieldWidthConstraint.constant = 0
        
        UIView.animate(withDuration: 0.3) {
            promptTextField.alpha = 0
            containerView.layoutIfNeeded()
        }
    }
    
    func showPromptTextField() {
        guard let promptTextField = promptTextField else { return }
        
        promptTextField.isHidden = false
        promptTextField.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut]) {
            promptTextField.alpha = 1
        }
    }
}
