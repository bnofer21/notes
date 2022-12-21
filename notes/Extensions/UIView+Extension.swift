//
//  UIView+Extension.swift
//  notes
//
//  Created by Юрий on 21.12.2022.
//

import UIKit

extension UIView {
    func addView(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
    }
}
