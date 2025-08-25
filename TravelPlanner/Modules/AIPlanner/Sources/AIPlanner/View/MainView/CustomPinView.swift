//
//  CustomPinView.swift
//  AIPlanner
//
//  Created by ali cihan on 25.08.2025.
//

import UIKit

final class CustomPinView: UIView {
    private let icon: UIImage?

    init(icon: UIImage?) {
        self.icon = icon
        super.init(frame: CGRect(x: 0, y: 0, width: 40, height: 50)) // size of pin
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let circleRect = CGRect(x: 5, y: 0, width: 30, height: 30)
        
        // Draw circle
        context.setFillColor(UIColor.systemBlue.cgColor)
        context.fillEllipse(in: circleRect)

        // Draw arrowhead (triangle)
        context.move(to: CGPoint(x: rect.midX - 10, y: circleRect.maxY))
        context.addLine(to: CGPoint(x: rect.midX + 10, y: circleRect.maxY))
        context.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        context.closePath()
        context.setFillColor(UIColor.systemBlue.cgColor)
        context.fillPath()

        // Draw center icon
        if let icon = icon {
            let iconSize: CGFloat = 18
            let iconRect = CGRect(
                x: circleRect.midX - iconSize/2,
                y: circleRect.midY - iconSize/2,
                width: iconSize,
                height: iconSize
            )
            icon.withTintColor(.white).draw(in: iconRect)
        }
    }

    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { ctx in
            layer.render(in: ctx.cgContext)
        }
    }
}
