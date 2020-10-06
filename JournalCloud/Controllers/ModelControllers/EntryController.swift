//
//  EntryController.swift
//  JournalCloud
//
//  Created by Clarissa Vinciguerra on 10/5/20.
//

import Foundation
import CloudKit

class EntryController {
    
    // MARK: - Properties
    let privateDB = CKContainer.default().publicCloudDatabase
    static let shared = EntryController()
    var entries: [Entry] = []
    
    // MARK: - CRUD
    // Create
    func createEntryWith(title: String, body: String, completion: @escaping(Result<Entry?, EntryError>) -> Void) {
        
        let newEntry = Entry(title: title, body: body)
        let entryRecord = CKRecord(entry: newEntry)
        
        privateDB.save(entryRecord) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion (.failure(.ckError(error)))
            }
            
            guard let record = record, let savedEntry = Entry(ckRecord: record) else { return completion(.failure(.couldNotUnwrap)) }
            print("Saved Entry successfully!")
            self.entries.append(savedEntry)
            completion(.success(savedEntry))
        }
    }
    
    // Save (Update)
    func save(entry: Entry, completion: @escaping (_ result: Result<Entry?, EntryError>) -> Void) {
       
       let entryRecord = CKRecord(entry: entry)
        
        CKContainer.default().privateCloudDatabase.save(entryRecord) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion (.failure(.ckError(error)))
            }
            
            guard let record = record, let savedEntry = Entry(ckRecord: record) else { return completion(.failure(.couldNotUnwrap)) }
            
            print("Saved successfully!")
            // If updating double creates, try deleting this line
            self.entries.append(savedEntry)
            completion(.success(savedEntry))
        }
    }
    
    // Fetch (read)
    func fetchAllEntries(completion: @escaping (Result<[Entry]?, EntryError>) -> Void) {
        
        let fetchAllPredicate = NSPredicate(value: true)
        let query = CKQuery(recordType: EntryConstants.recordTypeKey, predicate: fetchAllPredicate)
        
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.ckError(error)))
            }
            
            guard let records = records else { return completion(.failure(.couldNotUnwrap)) }
            print("Fetched Entries successfully!")
            let fetchedEntries = records.compactMap({ Entry(ckRecord: $0) })
            completion(.success(fetchedEntries))
        }
    }
}
