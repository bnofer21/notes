//
//  NoteCellViewModel.swift
//  notes
//
//  Created by Юрий on 28.02.2023.
//

import Foundation

protocol NoteCellViewModelProtocol {
    var name: String? { get set }
    var text: String? { get set }
    var date: String? { get set }
    var note: Note { get }
}

final class NoteCellViewModel: NoteCellViewModelProtocol {
    var name: String?
    var text: String?
    var date: String?
    var note: Note
    
    init(note: Note) {
        self.note = note
        self.name = note.name
        self.text = note.text?.string
        guard let date = note.date else {
            self.date = "9 Jan 9:41"
            return
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM HH:mm"
        self.date = formatter.string(from: date)
    }
}
