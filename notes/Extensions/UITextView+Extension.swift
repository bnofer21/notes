//
//  UITextView+Extension.swift
//  notes
//
//  Created by Юрий on 04.03.2023.
//

import UIKit

extension UITextView {
    
    var lineSpacing: CGFloat {
        get {
            if let style = typingAttributes[NSAttributedString.Key.paragraphStyle] {
                return (style as! NSMutableParagraphStyle).lineSpacing
            }
            return 0
        }
        set {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = newValue
            let attributes = [
                NSAttributedString.Key.paragraphStyle: style,
                NSAttributedString.Key.foregroundColor: textColor,
                NSAttributedString.Key.font: font
            ]
            typingAttributes = attributes as [NSAttributedString.Key : Any]
        }
    }
}
