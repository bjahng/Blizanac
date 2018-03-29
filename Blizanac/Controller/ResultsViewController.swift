//
//  ResultsViewController.swift
//  Blizanac
//
//  Created by admin on 3/20/18.
//  Copyright © 2018 DoughDoughTech. All rights reserved.
//

import UIKit
import RealmSwift
import CoreML
import Vision
import SDWebImage

class ResultsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let realm = try! Realm()
    
    var selectedPic: UIImage?
    var fromRecent: Bool = false
    
    @IBOutlet weak var matchLabel: UILabel!
    @IBOutlet weak var selfieImage: UIImageView!
    @IBOutlet weak var celebImage: UIImageView!
    @IBOutlet weak var wikiInfoLabel: UILabel!
    @IBOutlet weak var wikiInfoActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        convertToCIImage(image: selectedPic)
    }
    
    func convertToCIImage(image: UIImage?) {
        if let image = image {
            guard let convertedCIImage = CIImage(image: image) else {
                fatalError("Cannot convert to CIIMage")
            }
            detect(image: convertedCIImage)
        }
    }
    
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: celebface().model) else {
            fatalError("Cannot import model")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            if let classification = request.results?.first as? VNClassificationObservation, classification.confidence > 0.01 {
                let confidenceRating = String(format: "%.2f", (classification.confidence) * 100)
                let celebName = classification.identifier.replacingOccurrences(of: "_", with: " ")

                self.wikiInfoActivityIndicator.isHidden = false
                self.wikiInfoActivityIndicator.startAnimating()
                
                if !self.fromRecent {
                    // Save image to documents directory
                    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let fileName = Date().toString()
                    let fileURL = documentsDirectory.appendingPathComponent(fileName)
                    if let data = UIImageJPEGRepresentation(self.selectedPic!, 1.0),
                        !FileManager.default.fileExists(atPath: fileURL.path) {
                        do {
                            try data.write(to: fileURL)
                        } catch {
                            self.displayAlert("Error saving file")
                        }
                    }
                    
                    // Save to Realm
                    do {
                        try self.realm.write {
                            let newPic = Match()
                            newPic.title = celebName
                            newPic.dateCreated = Date()
                            newPic.backgroundColor = UIColor.flatMagenta.hexValue()
                            self.realm.add(newPic)
                        }
                    } catch {
                        self.displayAlert("Error saving item")
                    }
                }
                
                if Connectivity.isConnectedToInternet {
                    WikipediaClient.shared.getWikipediaData(celebName: classification.identifier, completion: { (wikiURL, wikidesc) in
                        DispatchQueue.main.async {
                            if wikiURL != "" {
                                self.celebImage.sd_setImage(with: URL(string: wikiURL))
                                self.wikiInfoLabel.text = wikidesc
                            } else {
                                self.celebImage.image = #imageLiteral(resourceName: "No_photo_available")
                                self.wikiInfoLabel.text = "No wikipedia entry"
                            }
                            
                            if let selectedPic = self.selectedPic {
                                self.selfieImage.image = selectedPic
                            }
                            self.matchLabel.text = "\(confidenceRating)% match!\r\n\(celebName)"
                            self.matchLabel.isHidden = false
                            self.wikiInfoActivityIndicator.stopAnimating()
                        }
                    })
                } else {
                    self.navigationController?.popViewController(animated: true)
                    self.displayAlert("Can't connect to network.\r\nPlease check connection.")
                }
                
            } else {
                self.navigationController?.popViewController(animated: true)
                self.displayAlert("Match is less than 1%.\r\nPlease try again!")
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        }
        catch {
            displayAlert("\(error)")
        }
        
    }
    
}
