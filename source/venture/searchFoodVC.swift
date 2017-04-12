//
//  searchFoodVC.swift
//  venture
//
//  Created by Connie Liu on 4/10/17.
//  Copyright © 2017 Group1. All rights reserved.
//

import UIKit
import YelpAPI
import BrightFutures

class searchFoodVC: UIViewController {
    
    var restaurants = [Restauraunt]()

    @IBOutlet weak var addressTxt: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search for Food"
        //addressTxt.attributedPlaceholder = NSAttributedString(string: "address", attributes: [NSForegroundColorAttributeName:UIColor.lightGray])

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

/*
    @IBAction func searchFood(_ sender: Any) {
        myRequest.enter()
        let appId = "7MvZ6dze7A0CJ7LnQqzeeA"
        let appSecret = "NqyyQzN25eWVlUhAa5SCius0uNNqd3DS2DDDBUwrQLd3dftFnwr3BySJXBZr7KzA"
        
        // Search for 3 dinner restaurants in user-defined location
        let query = YLPQuery(location: addressTxt.text!)
        query.term = "food"
        query.limit = 3
        var businessName:String?
        
        YLPClient.authorize(withAppId: appId, secret: appSecret).flatMap { client in
            client.search(withQuery: query)
            }.onSuccess { search in
                if let topBusiness = search.businesses.first {
                    businessName = topBusiness.name
                    print("Top business: \(topBusiness.name)")
                    self.myRequest.leave()
                } else {
                    businessName = "none found"
                    print("None found")
                }
                //exit(EXIT_SUCCESS)
            }.onFailure { error in
                print("Search errored: \(error)")
                //exit(EXIT_FAILURE)
        }
        
        myRequest.notify(queue: DispatchQueue.main, execute: {
            print("Finished all requests.")
            self.restaurants.append(businessName!)
            self.segueToTable()
        })
    }
    
*/
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
