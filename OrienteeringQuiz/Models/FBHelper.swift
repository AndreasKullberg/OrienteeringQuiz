//
//  FBHelper.swift
//  OrienteeringQuiz
//
//  Created by Andreas Kullberg on 2019-04-08.
//  Copyright © 2019 Andreas Kullberg. All rights reserved.
//

import UIKit
import Firebase
protocol FBListenerProtocol {
    func addQuizzes(quizzes:[Quiz])
    func addQuiz(quiz:Quiz)
    
    
}

class FBHelper {
    var ref: DatabaseReference!
    var quizzesDelegate:FBListenerProtocol?
    var createQuiz = Quiz()
    
    func addQuestionToDatabase() {
        ref = Database.database().reference()
        for i in 0...createQuiz.questions.count-1 {
            
            self.ref.child("Quizzes").child(createQuiz.ID).child("Question \(i+1)").setValue(createQuiz.questions[i].questionDictionary)
        }
        createQuiz.questions.removeAll()
    }
    
    func addQuizToDatabase()  {
        
        createQuiz.initDictionary()
        ref = Database.database().reference().child("Quizzes").childByAutoId()
        self.ref.setValue(createQuiz.quizDictionary){
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                
                self.createQuiz.ID = ref.key as! String
                
                self.addQuestionToDatabase()
                
            }
        }
    }
   
    func readQuizFromDatabase()   {
        
        var quizzes:[Quiz] = []
        
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
                
               
                
            }
            
            self.quizzesDelegate!.addQuizzes(quizzes: quizzes)
            
            
        }
        
        
    }
    
    func readQuestionsFromDatabase(childKey:String)  {
        let quiz = Quiz()
        ref = Database.database().reference()
        var count = 0
        
        ref.child("Quizzes").child(childKey).observe(.value) { snapshot in
            for child in snapshot.children {
                
                
                
                    let snap = child as! DataSnapshot
                    let question = Question()
                    let key = snap.key
                
                    question.ID = key
                    if let value = snap.value as? NSDictionary{
                        question.dictionaryToObject(data: value as! [String : Any])
                    }
                print(question.answer1)
                if(!question.answer1.elementsEqual("")){
                    quiz.questions.append(question)
                }
                
                count += 1
            }
            self.quizzesDelegate!.addQuiz(quiz: quiz)
        }
        
        
        
        }


    }

