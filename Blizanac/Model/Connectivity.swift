//
//  Connectivity.swift
//  Blizanac
//
//  Created by admin on 3/28/18.
//  Copyright © 2018 DoughDoughTech. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    class var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
