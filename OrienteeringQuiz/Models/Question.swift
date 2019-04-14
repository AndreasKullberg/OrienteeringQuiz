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
    var yPosition:Double = 0.0
    var xPosition:Double = 0.0
    var questionDictionary: [String: Any] = [:]
    
    func shuffleAnswers(){
        answers.shuffle()
        answer1 = answers[0]
        answerX = answers[1]
        answer2 = answers[2]
    }
    
    func initDictionary(){
        questionDictionary = ["question":question, "answer1": answer1, "answerX":answerX,"answer2":answer2, "rightAnswer":rightAnswer, "yPosition": yPosition, "xPosition":xPosition]
    }
    init(question:String, answer1:String, answerX:String, answer2:String, rightAnswer:String, yPosition:Double, xPosition:Double) {
        answers = [answer1, answerX, answer2]
        shuffleAnswers()
        self.question = question
        self.rightAnswer = rightAnswer
        self.yPosition = yPosition
        self.xPosition = xPosition
        initDictionary()
    }
    init(data:[String:Any]) {
        self.question = data["question"] as! String
        self.answer1 = data["answe1"] as! String
        self.answerX = data["ansewrX"] as! String
        self.answer2 = data["answer2"] as! String
        self.rightAnswer = data["rightAnswer"] as! String
        self.yPosition = data["yPosition"] as! Double
        self.xPosition = data["xPosition"] as! Double
    }
    
}
