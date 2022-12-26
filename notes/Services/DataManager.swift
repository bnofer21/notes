//
//  DataManager.swift
//  notes
//
//  Created by Юрий on 21.12.2022.
//

import CoreData
import UIKit

struct DataManager {
    
    static let shared = DataManager()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func saveNote(isNew: Bool, note: Note, completion: ()->Void) {
        let context = appDelegate.persistentContainer.viewContext
        if isNew {
            guard let entity = NSEntityDescription.entity(forEntityName: "Note", in: context) else { return }
            let noteObject = Note(entity: entity, insertInto: context)
            noteObject.name = note.name
            noteObject.text = note.text
            noteObject.date = note.date
        }
        do {
            try context.save()
        } catch let error as NSError{
            print(error.localizedDescription)
        }
        completion()
    }
    
    func loadNotes(completion: @escaping([Note])->Void) {
        let context = appDelegate.persistentContainer.viewContext
        var result = [Note]()
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        do {
          result = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error.localizedDescription)")
        }
        result = result.sorted(by: { $0.date! > $1.date! })
        completion(result)
    }
    
    func deleteNote(note: Note, completion: ()->Void) {
        let context = appDelegate.persistentContainer.viewContext
        context.delete(note)
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        completion()
    }
}
