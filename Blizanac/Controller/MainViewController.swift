//
//  MainViewController.swift
//  Blizanac
//
//  Created by admin on 3/20/18.
//  Copyright © 2018 DoughDoughTech. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let realm = try! Realm()
    var matchList: Results<Match>?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let imagePicker = UIImagePickerController()
    var selfieImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        activityIndicator.stopAnimating()
    }
    
    @IBAction func selfieButtonPressed(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func photoLibraryButtonPressed(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        selfieImage = info[UIImagePickerControllerEditedImage] as? UIImage
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        imagePicker.dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: "goToResultsViewFromMain", sender: self)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "goToResultsViewFromMain" {
            let destinationVC = segue.destination as? ResultsViewController
            destinationVC?.selectedPic = selfieImage
        }
        
        if segue.identifier == "goToRecentView" {
            matchList = realm.objects(Match.self).sorted(byKeyPath: "dateCreated")
            let destinationVC = segue.destination as? RecentViewController
            destinationVC?.matchList = matchList
        }
    }

}
