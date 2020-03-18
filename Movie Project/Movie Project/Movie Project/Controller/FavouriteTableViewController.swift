//
//  FavouriteTableViewController.swift
//  Movie Project
//
//  Created by MacOSSierra on 3/6/20.
//  Copyright © 2020 Marina. All rights reserved.
//

import UIKit
import SDWebImage
import Cosmos

class FavouriteTableViewController: UITableViewController {
    var movieList : [FavouriteEntity]?
    var coredata : CoreDataDB?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Favourite Movies"
        let coredata = CoreDataDB()
        movieList = coredata.getFavourites() as! [FavouriteEntity]
        self.tableView.reloadData()

    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        let coredata = CoreDataDB()
//        movieList = coredata.getFavourites() as? [FavouriteEntity]
//
//
//    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movieList!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FavouriteTableViewCell
        cell.titleTxt.text = movieList![indexPath.row].title
        
cell.posterImg.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w185/" + movieList![indexPath.row].poster!), placeholderImage: nil)
//         cell.posterImg.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w185" + movieList![indexPath.row].poster!), placeholderImage: UIImage(named: "placeholder.png"))
        cell.rateView.settings.updateOnTouch = false
        cell.rateView.settings.fillMode = .precise
        cell.rateView.rating = Double(movieList![indexPath.row].rating/2)
        

        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130 
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        coredata?.deleteMoviesFromFav(id: Int(movieList![indexPath.row].id))
        
        self.tableView.reloadData()
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
