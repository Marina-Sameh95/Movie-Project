//
//  Network.swift
//  Movie Project
//
//  Created by MacOSSierra on 3/6/20.
//  Copyright © 2020 Marina. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class Network {
    var movielist = [Movie]()
    var displayRef : DataDisplay!
    var reviewsArray = [MovieReview]()
    var getReviewsVar : ReviewsProtocol!
   
   
  
    init(displayRef : DataDisplay) {
        self.displayRef = displayRef
    }
    
    init(getReviews : ReviewsProtocol) {
        self.getReviewsVar = getReviews
    }
    
   
    var url:String="https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=0f6963deb33263bc64efce4c7b4345a5"
    
    func getData()  {
        Alamofire.request(url,method:.get).responseJSON
            
            { response in
                
                
                var json:JSON=JSON(response.result.value!)
                
//                let json  dataJSON(response.data)
               print(json)
                
                for i in 0..<json["results"].count{
                    let mov = Movie()
                    mov.poster = json["results"][i]["poster_path"].stringValue
                    mov.title = json["results"][i]["title"].stringValue
                    mov.id = json["results"][i]["id"].intValue
                    mov.rating = json["results"][i]["vote_average"].floatValue
                    mov.overview = json["results"][i]["overview"].stringValue
                    mov.releaseYear = json["results"][i]["release_date"].stringValue
                    //append in Array
                    self.movielist.append(mov)
                }
               
                let cdDB = CoreDataDB()
                cdDB.deleteMovies()
                cdDB.saveMovies(movieArray: self.movielist)
                self.displayRef.fetchData(movieArr: self.movielist)
        }
    }
  
    func getReviewsFromAPI(movieID: Int)-> [MovieReview] {
        Alamofire.request("https://api.themoviedb.org/3/movie/\(movieID) /reviews?api_key=0f6963deb33263bc64efce4c7b4345a5").validate().responseJSON
            
            { response in
                
                var json:JSON=JSON(response.result.value!)
                
                for i in 0..<json["results"].count{
                    var re = MovieReview()
                    re.author = json["results"][i]["author"].stringValue
                    re.content = json["results"][i]["content"].stringValue
                   
                    self.reviewsArray.append(re)
                }
                
                
                self.getReviewsVar.getReviews(reviewsList: self.reviewsArray)
                
                
                
        }
        
     return reviewsArray
    }
    
   
}

