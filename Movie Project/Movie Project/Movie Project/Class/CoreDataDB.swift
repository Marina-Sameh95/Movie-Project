//
//  CoreDataDB.swift
//  Movie Project
//
//  Created by MacOSSierra on 3/12/20.
//  Copyright © 2020 Marina. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataDB {

    

    func getMovies() -> [Movie] {
        var movieList = [Movie]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let manageContext = appDelegate.persistentContainer.viewContext
      //  let entity = NSEntityDescription.entity(forEntityName: "Movie",in: manageContext)
        let movie = MovieEntity(context: manageContext)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieEntity")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            var moviesArray : [MovieEntity]
            moviesArray = try manageContext.fetch(fetchRequest) as! [MovieEntity]
            
            
            for item in moviesArray{
                if item.title == nil{
                    continue
                }
                var mov = Movie()
                mov.id = item.value(forKey:"id")! as! Int
                mov.title = item.value(forKey:"title")! as! String
                mov.poster = item.value(forKey:"poster")! as! String
                mov.rating = item.value(forKey:"rating")! as! Float
                mov.overview = item.value(forKey:"overview")! as! String
                mov.releaseYear = item.value(forKey:"releaseYear")! as! String
                
                movieList.append(mov)
            }
            
            } catch {}
            return movieList
        }
    
    func saveMovies(movieArray : [Movie]) -> Bool {
        var status : Bool = false
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let manageContext = appDelegate.persistentContainer.viewContext
        for parentItem in movieArray {
            let movie = MovieEntity(context: manageContext)
            movie.id = Int64(Int(parentItem.id))
            movie.poster = parentItem.poster
            movie.title = parentItem.title
            movie.rating = parentItem.rating
            movie.releaseYear = parentItem.releaseYear
        }
        do {
            try manageContext.save()
            status = true
        
        }catch let error{
            print(error)
        }
        return status
    }
    
    func deleteMovies(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let manageContext = appDelegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try manageContext.save()
        }catch let error as NSError{
            print(error)
            
        }
    }
    
    func AddMovieToFavourites(movie : Movie)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let nsContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.insertNewObject(forEntityName: "FavouriteEntity", into:nsContext )
        
        
        entity.setValue(movie.title, forKey: "title")
        entity.setValue(movie.rating, forKey: "rating")
        entity.setValue(movie.poster, forKey: "poster")
        entity.setValue(movie.id, forKey: "id")
        
        do{
            try nsContext.save()
        }
        catch
        {
            
        }
        
    }
    
    func getFavourites()->[Any]
    {
        
        var movies: [Any] = []
        var myMovies  = [FavouriteEntity]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let nsContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteEntity")
        
        myMovies = try! nsContext.fetch(fetchRequest) as![FavouriteEntity]
        for movie in myMovies
        {
            
            
            movies.append(movie)
        }
        
        return movies
    }
    
    func doExist(id : Int)->Bool
    {
        var exist = false
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let nsContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "FavouriteEntity", in: nsContext)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavouriteEntity")
        fetchRequest.entity = entity
        let pred = NSPredicate(format:"id=%d", id)
        fetchRequest.predicate=pred
        do
        {
            let result = try nsContext.fetch(fetchRequest)
            print(result.count)
            if result.count > 0 {
                exist = true
            }
        }
        catch
        {
            
        }
        return exist
    }
    
    func deleteMoviesFromFav(id : Int){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let nsContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "FavouriteEntity", in: nsContext)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavouriteEntity")
        fetchRequest.entity = entity
        let pred = NSPredicate(format:"id=%d", id)
        fetchRequest.predicate=pred
        do
        {
            let result = try nsContext.fetch(fetchRequest)
            print(result.count)
            if result.count > 0 {
                let manage = result[0] as! NSManagedObject
                nsContext.delete(manage)
                try nsContext.save()
            }
        }
        catch
        {
            
        }
        
        
    }
    
}

