//
//  SaveButton.swift
//  notes
//
//  Created by Юрий on 24.12.2022.
//

import Foundation
import UIKit

class SaveButton: UIButton {
    
    var indicator: UIActivityIndicatorView!
    var buttonText: String?
    var buttonImage: UIImage?
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.25, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                self.alpha = self.isHighlighted ? 0.5 : 1
            }, completion: nil)
        }
    }
    
    func showLoading() {
        buttonText = self.titleLabel?.text
        if let image = imageView?.image {
            buttonImage = image
        }
        setImage(nil, for: .normal)
        setTitle("", for: .normal)
        if indicator == nil {
            indicator = createIndicator()
        }
        showSpinning()
    }
    
    func hideLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.setTitle(self.buttonText, for: .normal)
            if let image = self.buttonImage {
                self.setImage(image, for: .normal)
            }
            self.indicator.stopAnimating()
        }
    }
    
    private func createIndicator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.color = .black
        return indicator
    }
    
    private func showSpinning() {
        self.addView(indicator)
        indicator.center = self.center
        centerIndicatorInButton()
        indicator.startAnimating()
    }
    
    private func centerIndicatorInButton() {
        let xCenter = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: indicator, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(xCenter)
        
        let yCenter = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: indicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenter)
    }
}
