//
//  Question.swift
//  OrienteeringQuiz
//
//  Created by Andreas Kullberg on 2019-04-08.
//  Copyright © 2019 Andreas Kullberg. All rights reserved.
//

import UIKit

class Question {
    
    var question: String = ""
    var answer1: String = ""
    var answerX: String = ""
    var answer2: String = ""
    var answers: [String] = []
    var rightAnswer: String = ""
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    var questionDictionary: [String: Any] = [:]
    var name = ""
    var questionDone = false
    var didAnswerRight = false
    var playersAnswer = ""
    var ID = ""
    
    func shuffleAnswers(){
        answers.shuffle()
        answer1 = answers[0]
        answerX = answers[1]
        answer2 = answers[2]
    }
    
    func initDictionary(){
        questionDictionary = ["question":question, "answer1": answer1, "answerX":answerX,"answer2":answer2, "rightAnswer":rightAnswer, "latitude": latitude, "longitude":longitude]
    }
    init(question:String, answer1:String, answerX:String, answer2:String, rightAnswer:String, latitude:Double, longitude:Double) {
        answers = [answer1, answerX, answer2]
        shuffleAnswers()
        self.question = question
        self.rightAnswer = rightAnswer
        self.latitude = latitude
        self.longitude = longitude
        initDictionary()
    }
    init(data:[String:Any]) {
        self.question = data["question"] as! String
        self.answer1 = data["answe1"] as! String
        self.answerX = data["ansewrX"] as! String
        self.answer2 = data["answer2"] as! String
        self.rightAnswer = data["rightAnswer"] as! String
        self.latitude = data["latitude"] as! Double
        self.longitude = data["longitude"] as! Double
    }
    
    func dictionaryToObject(data:[String:Any]) {
        self.question = data["question"] as! String
        self.answer1  = data["answer1"] as! String
        self.answerX  = data["answerX"] as! String
        self.answer2  = data["answer2"] as! String
        self.rightAnswer = data["rightAnswer"] as! String
        self.latitude = data["latitude"] as! Double
        self.longitude = data["longitude"] as! Double
    }
    
    init() {
        
    }
    
    func setPlayerAnswer(answer:String) {
        self.playersAnswer = answer
        setDidAnswerRight()
    }
    
    func setDidAnswerRight() {
        if (rightAnswer.elementsEqual(playersAnswer)){
            didAnswerRight = true
        }
        questionDone = true
    }
    
}
