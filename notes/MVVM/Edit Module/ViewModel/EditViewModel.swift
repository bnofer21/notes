//
//  EditViewModel.swift
//  notes
//
//  Created by Юрий on 28.02.2023.
//

import Foundation

protocol EditViewModelProtocol {
    var text: NSAttributedString? { get }
    var name: String? { get }
    
    func saveNote(text: NSAttributedString, completion: @escaping (String?) -> Void)
}

final class EditViewModel: EditViewModelProtocol, Coordinating {
    
    var coordinator: Coordinator?
    var dataManager: DataManagerInterface?
    
    var note: Note?
    
    var name: String?
    var text: NSAttributedString?
    
    init(note: Note?) {
        guard let note = note else {
            return
        }
        self.note = note
        self.name = note.name ?? ""
        self.text = note.text ?? NSAttributedString(string: "")
    }
    
    func saveNote(text: NSAttributedString, completion: @escaping (String?) -> Void) {
        if let note = note {
            note.text = text
            note.name = String(text.string.prefix(15))
            dataManager?.saveNote(note: note, completion: { [weak self] error in
                if let error = error {
                    completion(error)
                } else {
                    self?.coordinator?.eventOccured(event: .back, note: nil)
                    completion(nil)
                }
            })
        } else {
            dataManager?.saveNewNote(text: text, completion: { [weak self] error in
                if let error = error {
                    completion(error)
                } else {
                    self?.coordinator?.eventOccured(event: .back, note: nil)
                    completion(nil)
                }
            })
        }
    }
}
