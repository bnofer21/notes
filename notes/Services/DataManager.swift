//
//  DataManager.swift
//  notes
//
//  Created by Юрий on 21.12.2022.
//

import CoreData
import UIKit

protocol DataManagerInterface {
    func saveNote(note: Note, completion: @escaping (String?)->Void)
    func loadNotes(completion: @escaping([Note]?, String?)->Void)
    func deleteNote(_ note: Note, completion: @escaping(String?)->Void)
    func saveNewNote(text: NSAttributedString, completion: @escaping (String?) -> Void)
}

class DataManager: DataManagerInterface {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private func saveChanges(_ context: NSManagedObjectContext, completion: @escaping (String?) -> Void) {
        do {
            try context.save()
            completion(nil)
        } catch let error as NSError{
            context.rollback()
            completion(error.localizedDescription)
        }
    }
    
    func saveNewNote(text: NSAttributedString, completion: @escaping (String?) -> Void) {
        let context = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Note", in: context) else {
            completion("Error creating create new entity")
            return
        }
        let noteObject = Note(entity: entity, insertInto: context)
        noteObject.name = String(text.string.prefix(15))
        noteObject.text = text
        noteObject.date = Date()
        saveChanges(context) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func saveNote(note: Note, completion: @escaping (String?)->Void) {
        let context = appDelegate.persistentContainer.viewContext
        guard let object = context.registeredObject(for: note.objectID) as? Note else {
            completion("Object not found")
            return }
        object.name = note.name
        object.text = note.text
        object.date = Date()
        saveChanges(context) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func loadNotes(completion: @escaping([Note]?, String?)->Void) {
        let context = appDelegate.persistentContainer.viewContext
        var result = [Note]()
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        do {
            result = try context.fetch(fetchRequest)
        } catch let error as NSError {
            completion(nil, error.localizedDescription)
        }
        if result.count == 0 {
            createDefault { note, error in
                if let error = error {
                    completion(nil, error)
                } else if let note = note {
                    result.append(note)
                    completion(result, nil)
                } else {
                    completion(nil, "Error creating default note")
                }
            }
        } else {
            result = result.sorted(by: { $0.date! > $1.date! })
            completion(result, nil)
        }
    }
    
    func deleteNote(_ note: Note, completion: @escaping(String?)->Void) {
        let context = appDelegate.persistentContainer.viewContext
        context.delete(note)
        saveChanges(context) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    private func createDefault(completion: @escaping (Note?, String?)->Void) {
        let context = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Note", in: context) else {
            completion(nil, "Error creating new entity")
            return
        }
        let noteObject = Note(entity: entity, insertInto: context)
        noteObject.name = "Name"
        noteObject.text = NSAttributedString(string: "Text")
        noteObject.date = Date()
        saveChanges(context) { error in
            if let error = error {
                completion(nil, error)
            } else {
                completion(noteObject, nil)
            }
        }
    }
}
