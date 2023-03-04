//
//  ScrollViewModel.swift
//  notes
//
//  Created by Юрий on 22.12.2022.
//

import Foundation

struct ScrollViewModel {
    
    private var count: Int
    
    var notesCount: Int {
        return count
    }
    
    init(count: Int) {
        self.count = count
    }
}
