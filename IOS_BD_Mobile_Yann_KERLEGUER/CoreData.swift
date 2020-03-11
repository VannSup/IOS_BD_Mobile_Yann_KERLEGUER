//
//  CoreData.swift
//  IOS_BD_Mobile_Yann_KERLEGUER
//
//  Created by lpiem on 11/03/2020.
//  Copyright © 2020 lpiem. All rights reserved.
//
import CoreData
import Foundation

class CoreDataManager{
    
    static let shared = CoreDataManager()
    
    var context: NSManagedObjectContext{
        get{
            return persistentContainer.viewContext
        }
    }
    
// MARK: - Factor Predicate
    func searchPredicate(search:String) -> NSPredicate{
        // name contains[cd]
        // c insensible au majuscule
        // d insensible au accessent
        
        // fait un OU entre chaque predicate de l'array de predicate
        // let predicateOr = NSCompoundPredicate(orPredicateWithSubpredicates: [predicate1,predicate2])
        // fait un AND entre chaque predicate de l'array de predicate
        // let predicateAnd = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1,predicate2])
        
        return NSPredicate(format:"name contains[cd] %@",search)
    }
    
// MARK: - Items Manager
    
    init() {
        if let item = loadItems(ascending: false), item.count == 0{
            createRandomItems()
        }
    }
    
    func createRandomItems(){
        
        
        let randomData = ["Veste","Chaussures","Pantalon", "Slip"]
        
        for name in randomData{
            let _ = createItemWithName(name, price: 0.0)
        }
        saveContext()
    }
    
    func createItemWithName (_ name: String, price:Double)-> Item {
        
        let item = Item(context: context)
        item.name = name
        item.price = price

        return item
    }
    
    func loadItems(ascending: Bool,search: String? = nil) -> [Item]? {
        
        let fetchResquest: NSFetchRequest<Item> = Item.fetchRequest()
        
        if (ascending){
            let sortDescriptor = NSSortDescriptor(key: "name",ascending: true)
            fetchResquest.sortDescriptors = [sortDescriptor]
        }
        
        if(search != nil){
            fetchResquest.predicate = searchPredicate(search: search!)
        }
        
        do{
            return try context.fetch(fetchResquest)
        }catch{
            return nil
        }
    }
    
    func changeItemFavoriState(item: Item) {
        (item.isFavorite) ? (item.isFavorite = false) : (item.isFavorite = true)
        saveContext()
    }
    
    
// MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "IOS_BD_Mobile_Yann_KERLEGUER")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

// MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
