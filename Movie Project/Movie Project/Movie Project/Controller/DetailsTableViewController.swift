//
//  DetailsTableViewController.swift
//  Movie Project
//
//  Created by MacOSSierra on 3/6/20.
//  Copyright © 2020 Marina. All rights reserved.
//

import UIKit
import CoreData
import Cosmos
import SDWebImage
import youtube_ios_player_helper
import Alamofire
import SwiftyJSON
import Reachability

class DetailsTableViewController: UITableViewController, ReviewsProtocol {
   
    func getReviews(reviewsList: [MovieReview]) {
        reviewsArray = reviewsList
        self.view.layoutIfNeeded()
    }
    
    @IBOutlet weak var favBtnOutlet: UIButton!
    
    @IBOutlet weak var trailerView: YTPlayerView!
    
    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var releaseYearLbl: UILabel!
    @IBOutlet weak var overViewTxt: UITextView!
//    var revVc = ReviewTableViewController()
    @IBAction func reviewBtn(_ sender: Any) {
    let revVC  : ReviewTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "reviewVC") as! ReviewTableViewController
        
         revVC.reviewsArray = self.reviewsArray
       
    self.navigationController?.pushViewController(revVC, animated: true)
        
    }

    @IBOutlet weak var posterImg: UIImageView!
    
    var mov : Movie!
    var filmId:String = ""
    var trailersArray:[String] = []
    var isFavourite : Bool!
    var fav : Bool!
    var id : Int!
    var Poster : String!
    var rate : Float!
    var Title : String!
    var coredata : CoreDataDB!
    var reviewsArray = [MovieReview]()
    let reachability = try! Reachability()
    var detailedMovie = Movie()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Movie Details"
        isFavourite = false
        titleLbl.text=mov.title
        releaseYearLbl.text=mov.releaseYear
        overViewTxt.text=mov.overview
        filmId = String(mov.id)
        rateView.rating = Double (mov.rating)/2
        rateView.settings.updateOnTouch = false
        rateView.settings.fillMode = .precise
        posterImg.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w185/" + mov.poster), placeholderImage: UIImage (named:"placeholder.png"))
        getTrailers(id: String(mov.id!))
        
         coredata = CoreDataDB()
//      // isFavourite = coredata!.doExist(id : detailedMovie.id!)
//
//        if(isFavourite == true)
//        {
//            favBtnOutlet.setImage(UIImage(named: "favOn.png"), for: .normal)
//        }
//        else
//        {
//            favBtnOutlet.setImage(UIImage(named: "favOff.png"), for: .normal)
//        }

//        let networkRev = Network(getReviews :self)
//            networkRev.getReviewsFromAPI(movieID: detailedMovie.id!)
              
    }
    
   
    
      @IBAction func favBtn(_ sender: Any) {
          if(isFavourite){
            isFavourite=false;
          favBtnOutlet.setImage(UIImage(named: "favOff.png"), for: [])
          favBtnOutlet.tintColor = UIColor.red
          coredata.deleteMoviesFromFav(id: detailedMovie.id!)
    
    
            
        } else{
           isFavourite=true;
           var movie = detailedMovie
            favBtnOutlet.setImage(UIImage(named: "favOn.png"), for: [])
            favBtnOutlet.tintColor = UIColor.red
            coredata!.AddMovieToFavourites(movie: movie)
    
            
        }
              }
     func setFavBtn    (){
        let favBtn = UIButton(type: .custom)
        favBtn.setImage(UIImage(named: "favOn.png"), for: [])
        isFavourite=true
        coredata.doExist(id: id!)

    }
    
    func getTrailers(id:String){
        let url = "https://api.themoviedb.org/3/movie/"+id+"/videos?api_key=0f6963deb33263bc64efce4c7b4345a5";                   Alamofire.request(url, method: .get).validate().responseJSON() {
             response in
               if response.result.isSuccess {
                print("Success! Got the data")
                let dataJSON : JSON = JSON(response.result.value!)
                var trailerArray: [String]=[]
                    for i in 0..<dataJSON["results"].count {                               trailerArray.append(dataJSON["results"][i]["key"].stringValue)
                    
                }
                print(trailerArray)
                self.trailerView.load(withVideoId: trailerArray[0])
                
            }
            
        }
        
    }
    
}

