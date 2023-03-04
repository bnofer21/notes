//
//  MainSectionViewModel.swift
//  notes
//
//  Created by Юрий on 28.02.2023.
//

import Foundation


protocol SectionViewModelProtocol {
    var cells: [NoteCellViewModelProtocol]? { get }
}


final class SectionViewModel: SectionViewModelProtocol {
    
    var cells: [NoteCellViewModelProtocol]?
    
    init(cells: [NoteCellViewModelProtocol]) {
        self.cells = cells
    }
    
}
