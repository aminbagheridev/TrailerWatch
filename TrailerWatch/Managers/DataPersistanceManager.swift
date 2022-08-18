//
//  DataPersistanceManager.swift
//  Netflix Clone
//
//  Created by Amin  Bagheri  on 2022-06-22.
//

import Foundation
import UIKit
import CoreData

class DataPersistanceManager {
    static let shared = DataPersistanceManager()
    
    enum DatabaseError: Error {
        case failedToSaveData
        case failedTofetchData
        case failedToDelete

    }
    
    func downloadTitle(with model: Title, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        // creates an item
        let item = TitleItem(context: context)
        // sets the item to be equal to the item we passed in
        item.original_title = model.original_title
        item.id = Int64(model.id)
        item.original_language = model.original_language
        item.poster_path = model.poster_path
        item.media_type = model.media_type
        item.first_air_date = model.first_air_date
        item.vote_count = Int64(model.vote_count ?? 9999)
        item.vote_average = model.vote_average ?? 9.9
        item.overview = model.overview
        item.release_date = model.release_date
        
        do {
            // save the item. SIMPLE!
            try context.save()
            completion(.success(()))
        } catch {
            print(error.localizedDescription)
            completion(.failure(DatabaseError.failedToSaveData))
        }
    }
    
    func fetchingTitlesFromDatabase(completion: @escaping(Result<[TitleItem], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        // we need to create a request that is fetching whatever we pass into <>
        let request: NSFetchRequest<TitleItem>
        
        request = TitleItem.fetchRequest()
        
        do {
            let titles = try context.fetch(request)
            completion(.success(titles))
        } catch {
            completion(.failure(DatabaseError.failedTofetchData))
        }
    }
    
    func deleteTitle(with model: TitleItem, completion: @escaping(Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToDelete))
        }
        
    }
}
