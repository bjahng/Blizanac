//
//  WikipediaClient.swift
//  Blizanac
//
//  Created by admin on 3/27/18.
//  Copyright © 2018 DoughDoughTech. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WikipediaClient: UIViewController {
    
    static let shared = WikipediaClient()
    
    let wikipediaURl = "https://en.wikipedia.org/w/api.php"
    
    func getWikipediaData(celebName: String, completion: @escaping (_ wikipediaImageURL: String, _ wikipediaDesc: String) -> Void) {
        
        let parameters : [String:String] = [
            "format" : "json",
            "action" : "query",
            "prop" : "extracts|pageimages",
            "exintro" : "",
            "explaintext" : "",
            "titles" : celebName,
            "indexpageids" : "",
            "redirects" : "1",
            "pithumbsize" : "500"
        ]
        

        Alamofire.request(wikipediaURl, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                let wikipediaJSON: JSON = JSON(response.result.value!)
                let wikipediaPageid = wikipediaJSON["query"]["pageids"][0].stringValue
                let wikipediaImageURL = wikipediaJSON["query"]["pages"]["\(wikipediaPageid)"]["thumbnail"]["source"].stringValue
                let wikipediaDesc =  wikipediaJSON["query"]["pages"]["\(wikipediaPageid)"]["extract"].stringValue
                completion(wikipediaImageURL, wikipediaDesc)
            } else {
                self.displayAlert("Error \(response.result.error!)")
            }
        }
        
    }
    
}
