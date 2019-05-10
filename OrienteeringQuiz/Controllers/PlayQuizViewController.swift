//
//  PlayQuizViewController.swift
//  OrienteeringQuiz
//
//  Created by Andreas Kullberg on 2019-05-01.
//  Copyright © 2019 Andreas Kullberg. All rights reserved.
//

import UIKit
protocol playQuizQuestionProtocol {
    func PlayQuizQuestionSender(question:Question)
}

class PlayQuizViewController: UIViewController {

    var question = Question()
    
    @IBOutlet weak var numberQuestionLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var answerAButtonOutlet: UIButton!
    
    @IBOutlet weak var answerCButtonOutlet: UIButton!
    @IBOutlet weak var answerBButtonOutlet: UIButton!
    var questionDelegate:playQuizQuestionProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpQuestion()
        question.questionDone = true
    }
    
    
    @IBAction func answerAButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        question.setPlayerAnswer(answer: question.answer1)
        questionDelegate!.PlayQuizQuestionSender(question: question)
    }
    
    @IBAction func answerBButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        question.setPlayerAnswer(answer: question.answerX)
        questionDelegate!.PlayQuizQuestionSender(question: question)
    }
    
    @IBAction func answerCButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        question.setPlayerAnswer(answer: question.answer2)
        questionDelegate!.PlayQuizQuestionSender(question: question)
    }
    
    func setUpQuestion(){
        questionLabel.text = "\(question.question)?"
        numberQuestionLabel.text = question.ID
        answerAButtonOutlet.setTitle(question.answer1, for: .normal)
        answerBButtonOutlet.setTitle(question.answerX, for: .normal)
        answerCButtonOutlet.setTitle(question.answer2, for: .normal)
    }
    
    // MARK: - Navigation

 

}
