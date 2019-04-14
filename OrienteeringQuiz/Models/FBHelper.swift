//
//  FBHelper.swift
//  OrienteeringQuiz
//
//  Created by Andreas Kullberg on 2019-04-08.
//  Copyright © 2019 Andreas Kullberg. All rights reserved.
//

import UIKit
import Firebase
protocol fbListenerProtocol {
    func addQuizzes(quizzes: [Quiz])
    
}

class FBHelper {
    var ref: DatabaseReference!
    var quizzesDelegate:fbListenerProtocol?
    
    
    
    

    func addQuestionToDatabase(/*quiz: Quiz*/) {
        let question = Question(question: "Vad heter Jag?", answer1: "Andreas", answerX: "Patrik", answer2: "Fredrik", rightAnswer: "Andreas", yPosition: 5.0, xPosition: 6.0)
        
        ref = Database.database().reference()
        self.ref.child("Quizzes").child("Quiz").child("question2").setValue(question.questionDictionary)
    }
    
    func addQuizToDatabase()  {
        let quiz = Quiz(name: "Ängspromenaden", latitude: 26.09384, longitude: 2.09842)
        quiz.initDictionary()
        ref = Database.database().reference()
        self.ref.child("Quizzes").childByAutoId().setValue(quiz.quizDictionary){
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
            }
        }
    }
   
    func readQuizFromDatabase()   {
        
        var quizzes:[Quiz] = []
        var count = 0
        ref = Database.database().reference()
  
        ref.child("Quizzes").observe(.value) { snapshot in
            for child in snapshot.children {
                
                let snap = child as! DataSnapshot
                let key = snap.key
                let quiz = Quiz()
                
                quiz.ID = key
                if let value = snap.value as? NSDictionary{
                    quiz.dictionaryToObject(data: value as! [String : Any])
                }
                
                quizzes.append(quiz)
                print("ID \(quizzes[count].ID)")
                count+=1
                
            }
            
            self.quizzesDelegate!.addQuizzes(quizzes: quizzes)
            
            
        }
        
        
    }
    
//    func readDataFromDatabase()-> Quiz {
//        let quiz = Quiz()
//
//
//        return quiz
//    }

}
