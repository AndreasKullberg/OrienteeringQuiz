//
//  CreateQuizViewController.swift
//  OrienteeringQuiz
//
//  Created by Andreas Kullberg on 2019-04-29.
//  Copyright © 2019 Andreas Kullberg. All rights reserved.
//

import UIKit
import MapKit
protocol questionProtocol {
    func questionSender(question:Question)
}

class CreateQuizViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var optionalAnwerB: UITextField!
    @IBOutlet weak var rightAnswerTextfield: UITextField!
    @IBOutlet weak var optionalAnswerA: UITextField!
    @IBOutlet weak var questionTextfield: UITextField!
    
    
    var longitude = 0.0
    var latitude = 0.0
    var questionDelegate:questionProtocol?
    var questionNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.isOpaque = false
        questionLabel.text = "Question \(questionNumber)"
        hideKeyboard()
        
    }
    
    @IBAction func questionDone(_ sender: Any) {
        print("\(longitude)  \(latitude)")
       let question = Question(question: questionTextfield.text!, answer1: rightAnswerTextfield.text! , answerX: optionalAnswerA.text!, answer2: optionalAnwerB.text!, rightAnswer: rightAnswerTextfield.text!, latitude: latitude, longitude: longitude)
        questionDelegate!.questionSender(question: question)
        dismiss(animated: true, completion: nil)
        
    }
    
    func hideKeyboard() {
        let Tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(Tap)
    }
    @objc func dismissKeyboard()  {
        view.endEditing(true)
    }
    
  

}
