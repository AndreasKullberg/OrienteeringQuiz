//
//  Quiz.swift
//  OrienteeringQuiz
//
//  Created by Andreas Kullberg on 2019-04-08.
//  Copyright © 2019 Andreas Kullberg. All rights reserved.
//

import Foundation
import UIKit

class Quiz {
    
    var questions: [Question] = []
    var name = ""
    let userID = ""
    var longitude = 0.0
    var latitude = 0.0
    let rate = 0.0
    let numberOfRates = 0
    var quizDictionary: [String: Any] = [:]
    var ID = ""
    
    init(name:String, latitude:Double, longitude:Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func initDictionary()  {
        quizDictionary = ["name":name, "latitude":latitude, "longitude": longitude,
                          "ID":ID]
    }
    
    func dictionaryToObject(data:[String:Any]) {
        self.name = data["name"] as! String
        self.latitude = data["latitude"] as! Double
        self.longitude = data["longitude"] as! Double

    }
    init() {
        
    }
    
    
}
