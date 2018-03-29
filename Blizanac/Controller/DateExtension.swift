//
//  DateExtension.swift
//  Blizanac
//
//  Created by admin on 3/21/18.
//  Copyright © 2018 DoughDoughTech. All rights reserved.
//

import Foundation

extension Date {
    
    func toString(dateFormat format: String = "MMM dd yyyy HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
