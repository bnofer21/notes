//
//  Resources.swift
//  notes
//
//  Created by Юрий on 23.12.2022.
//

import Foundation

enum Resources {
    
    enum PhotoType {
        case camera
        case gallery
    }
    
    enum Event {
        case edit
        case back
    }
    
    enum BarEvent: String, CaseIterable {
        case bold = "bold"
        case bigger = "textformat.size.larger"
        case smaller = "textformat.size.smaller"
    }
}
