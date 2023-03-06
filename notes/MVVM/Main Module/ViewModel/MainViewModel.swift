//
//  MainViewModel.swift
//  notes
//
//  Created by Юрий on 28.02.2023.
//

import Foundation

protocol MainViewModelInput {
    var sections: [SectionViewModelProtocol]! { get }
    var notesCount: Int! { get }
    func loadNotes(completion: @escaping (String?) -> Void)
}

protocol MainViewModelOutput {
    func didTapNew()
    func didSelect(index: Int)
    func deleteAt(at index: Int, completion: @escaping (String?) -> Void)
}

typealias MainViewModelType = MainViewModelInput & MainViewModelOutput

final class MainViewModel: Coordinating, MainViewModelType {
    
    var coordinator: Coordinator?
    var dataManager: DataManagerInterface?
    
    var sections: [SectionViewModelProtocol]!
    var notes: [Note]?
    
    var notesCount: Int!
    
    func loadNotes(completion: @escaping (String?) -> Void) {
        sections = []
        var cells = [NoteCellViewModelProtocol]()
        dataManager?.loadNotes { [weak self] notes, error in
            if let error = error {
                completion(error)
                return
            } else if let notes = notes {
                self?.notes = notes
                self?.notesCount = notes.count
                notes.forEach{
                    cells.append(NoteCellViewModel(note: $0))
                }
                self?.sections.append(SectionViewModel(cells: cells))
                completion(nil)
            } else {
                completion("Error loadding notes")
            }
        }
    }
    
    func didSelect(index: Int) {
        guard let note = sections.first?.cells?[index].note else { return }
        coordinator?.eventOccured(event: .edit, note: note)
    }
    
    func deleteAt(at index: Int, completion: @escaping (String?) -> Void) {
        guard let notes = notes else {
            completion("Notes are nil")
            return
        }
        dataManager?.deleteNote(notes[index], completion: { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        })
        
    }
    
    func didTapNew() {
        coordinator?.eventOccured(event: .edit, note: nil)
    }
    
    
}
