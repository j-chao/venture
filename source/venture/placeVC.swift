//
//  placeVC.swift
//  venture
//
//  Created by Julianne Crea on 4/8/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit

class placeVC: UIViewController {
    
    var eventDate:Date!

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var catLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var reviewCountLbl: UILabel!
    @IBOutlet weak var placeImg: UIImageView!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var zipLbl: UILabel!
    @IBOutlet weak var streetLbl: UILabel!
    
    var nameStr:String?
    var catStr:String?
    var ratingStr:String?
    var reviewStr:String?
    var imgStr:URL?
    var addressStr:String?
    var zipStr:String?
    var streetStr:String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let nameStr = nameStr {
            nameLbl.text = nameStr
        }
        if let catStr = catStr {
            catLbl.text = catStr
        }
        if let ratingStr = ratingStr {
            ratingLbl.text = ratingStr
        }
        if let reviewStr = reviewStr {
            reviewCountLbl.text = reviewStr
        }
        if let imgStr = imgStr {
            let imgString = "\(imgStr)"
            get_image(imgString, placeImg)
        }
        if let addressStr = addressStr {
            addressLbl.text = addressStr
        }
        if let zipStr = zipStr {
            zipLbl.text = zipStr
        }
        if let streetStr = streetStr {
            streetLbl.text = streetStr
        }
    }

    override func viewDidLoad() {
        self.setBackground()
        super.viewDidLoad()
        self.title = "Place"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func get_image(_ url_str:String, _ imageView:UIImageView) {
        let url:URL = URL(string: url_str)!
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if data != nil {
                let image = UIImage(data: data!)
                if (image != nil) {
                    DispatchQueue.main.async(execute: {
                        imageView.image = image
                    })
                }
            }
        })
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEventfromPlaces"{
            if let destinationVC = segue.destination as? AddEventVC {
                destinationVC.fromFoodorPlace = true
                destinationVC.eventDate = self.eventDate as Date!
                destinationVC.eventDescStr = nameStr!
            //    destinationVC.eventLocStr = addressStr!
                destinationVC.eventLocStr = "\(streetStr!) \(addressStr!)"
                
            }
        }
    }

}
