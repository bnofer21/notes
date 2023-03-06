//
//  EditViewModel.swift
//  notes
//
//  Created by Юрий on 28.02.2023.
//

import Foundation
import UIKit

protocol EditViewModelProtocol {
    var text: NSAttributedString? { get }
    var name: String? { get set }
    var attributesChanged: Bool { get set }
    
    func saveNote(text: NSAttributedString, completion: @escaping (String?) -> Void)
    func changeAttributes(type: Int, range: NSRange, completion: @escaping (String?) -> Void)
}

final class EditViewModel: EditViewModelProtocol, Coordinating {
    
    var coordinator: Coordinator?
    var dataManager: DataManagerInterface?
    
    var note: Note?
    
    var name: String?
    var text: NSAttributedString?
    var attributesChanged = false
    
    init(note: Note?) {
        guard let note = note else {
            return
        }
        self.note = note
        self.name = note.name ?? ""
        self.text = note.text ?? NSAttributedString(string: "")
    }
    
    func saveNote(text: NSAttributedString, completion: @escaping (String?) -> Void) {
        attributesChanged.toggle()
            if let note = self.note {
                note.text = text
                note.name = String(text.string.prefix(15))
                self.dataManager?.saveNote(note: note, completion: { [weak self] error in
                    if let error = error {
                        completion(error)
                    } else {
                        self?.coordinator?.eventOccured(event: .back, note: nil)
                        completion(nil)
                    }
                })
            } else {
                self.dataManager?.saveNewNote(text: text, completion: { [weak self] error in
                    if let error = error {
                        completion(error)
                    } else {
                        self?.coordinator?.eventOccured(event: .back, note: nil)
                        self?.attributesChanged.toggle()
                        completion(nil)
                    }
                })
            }
        }
    
    func changeAttributes(type: Int, range: NSRange, completion: @escaping (String?) -> Void) {
        guard let text = text else {
            completion("Note is empty")
            return }
        let string = NSMutableAttributedString(attributedString: text)
        let attribute = string.attribute(.font, at: range.location, longestEffectiveRange: nil, in: range) as! UIFont
        let newAttribute: [NSAttributedString.Key: Any]!
        switch type {
        case 0:
            if attribute.isBold {
                newAttribute = [.font: UIFont.systemFont(ofSize: attribute.pointSize)]
            } else {
                newAttribute = [.font: UIFont.boldSystemFont(ofSize: attribute.pointSize)]
            }
        case 1:
            newAttribute = [.font: UIFont.systemFont(ofSize: attribute.pointSize+1)]
        default:
            newAttribute = [.font: UIFont.systemFont(ofSize: attribute.pointSize-1)]
        }
        string.addAttributes(newAttribute, range: range)
        self.text = string
        attributesChanged = true
        completion(nil)
    }
    
}
