//
//  UIFont+Extension.swift
//  notes
//
//  Created by Юрий on 24.12.2022.
//

import UIKit

extension UIFont {
    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }
}


