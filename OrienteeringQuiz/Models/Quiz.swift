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
    var rightanswers = 0
    
    init(name:String, latitude:Double, longitude:Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func initDictionary()  {
        quizDictionary = ["name":name, "latitude":latitude, "longitude": longitude]
    }
    
    func dictionaryToObject(data:[String:Any]) {
        self.name = data["name"] as! String
        self.latitude = data["latitude"] as! Double
        self.longitude = data["longitude"] as! Double
    }
    init() {
        
    }
    
    func isQuizDone() -> Bool{
        var count = 0
        for i in 0...questions.count-1{
            if (questions[i].questionDone){
                count += 1
            }
            
            if (count == questions.count){
                countRightAnswers()
                return true
            }
        }
        return false
    }
    
    func isQuestionDone(question:Question) -> Bool {
        var bool = false
        for i in 0...questions.count-1{
            if (questions[i].ID.elementsEqual(question.ID)){
                bool = questions[i].questionDone
                
            }
        }
        
        return bool
    }
    
    func setQuestion(question:Question) {
        for i in 0...questions.count-1{
            if (questions[i].ID.elementsEqual(question.ID)){
                questions[i] = question
                print(questions[i].questionDone)
            }
        }
    }
    
    func countRightAnswers()  {
        for i in 0...questions.count-1{
            if (questions[i].didAnswerRight){
               rightanswers += 1
            }
        }
    }
    
}
