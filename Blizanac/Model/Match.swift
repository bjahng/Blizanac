//
//  Match.swift
//  Blizanac
//
//  Created by admin on 3/20/18.
//  Copyright © 2018 DoughDoughTech. All rights reserved.
//

import Foundation
import RealmSwift

class Match: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var dateCreated: Date?
    @objc dynamic var backgroundColor: String = ""
    @objc dynamic var imagePath: String = ""
    
}
