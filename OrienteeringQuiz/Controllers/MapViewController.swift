//
//  MapViewController.swift
//  OrienteeringQuiz
//
//  Created by Andreas Kullberg on 2019-04-09.
//  Copyright © 2019 Andreas Kullberg. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation

class MapViewController: UIViewController, FBListenerProtocol, MKMapViewDelegate, questionProtocol, playQuizQuestionProtocol {
    func PlayQuizQuestionSender(question: Question) {
        playQuiz.setQuestion(question: question)
        if(playQuiz.isQuizDone()){
            removeAnnotations()
            fbHelper.readQuizFromDatabase()
            isPlayingQuiz = false
            setUpStartButtons(bool: false)
            setUpQuizDonePopupView(bool: true)
            playQuizDone()
            
        }
    }
    
    func addQuiz(quiz: Quiz) {
        removeAnnotations()
        addAnnotationsForQuestions(quiz: quiz)
    }
    
    func questionSender(question: Question) {
        print(question.question)
        fbHelper.createQuiz.questions.append(question)
    }
    
    func addQuizzes(quizzes: [Quiz]) {
        addAnnotionsForQuizzes(quizzes: quizzes)
    }
    
    let locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "location-arrow-flat").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(locationButtonHandler), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var popupView: UIView!
    @IBOutlet weak var nameQuizTextField: UITextField!
    @IBOutlet var nameQuizPopupView: UIView!
    @IBOutlet weak var inProgressView: UIView!
    @IBOutlet weak var popupLabel: UILabel!
    
    @IBOutlet var startGamePopupView: UIView!
    @IBOutlet weak var startQuizOutlet: UIButton!
    @IBOutlet weak var startQuestionOutlet: UIButton!
    @IBOutlet weak var answerStatusLabel: UILabel!
    @IBOutlet weak var rightAnswerLabel: UILabel!
    @IBOutlet var finishedQuestionPopupView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet var quizDonePopupView: UIView!
    @IBOutlet weak var saveButtonOutlet: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var startQuizLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    let fbHelper = FBHelper()
    var quizzes: [Quiz] = []
    var longPressRecogniser = UILongPressGestureRecognizer()
    var isCreateQuiz = false
    var isPlayingQuiz = false
    var coordinate = CLLocationCoordinate2D()
    
    var question = Question()
    var quizAnnotation = QuizAnnotation()
    var questionAnnotation = QuestionAnnotation()
    var playQuiz = Quiz()
    var questionNumber = 0
    let meters = 1000.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationButton()
        checkLocationservices()
        setTitle()
        setUpLongPressRecogniser()
        fbHelper.quizzesDelegate = self
        fbHelper.readQuizFromDatabase()
        hideKeyboard()
       
    }
    
    // buttons and taps
    @IBAction func yesButton(_ sender: Any) {
        popupView.removeFromSuperview()
        isCreateQuiz = false
        removeAnnotations()
        isCreateQuiz = true
        createAnnotation()
        createQuizInProgress()
    }
    
    @IBAction func noButton(_ sender: Any) {
        popupView.removeFromSuperview()
        isCreateQuiz = false
    }
    
    @IBAction func okButton(_ sender: Any) {
        finishedQuestionPopupView.removeFromSuperview()
    }
    
    @IBAction func quizDoneOkButton(_ sender: Any) {
        setUpQuizDonePopupView(bool: false)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        if(isPlayingQuiz){
            isPlayingQuiz = false
            removeAnnotations()
            fbHelper.readQuizFromDatabase()
            playQuizDone()
            setUpStartButtons(bool: false)
        }
        else{
            isCreateQuiz = false
            removeAnnotations()
            fbHelper.readQuizFromDatabase()
            createQuizDone()
            questionNumber = 0
        }
        
    }
    @IBAction func startGamePopupCancelButton(_ sender: Any) {
        startGamePopupView.removeFromSuperview()
    }
    
    @IBAction func saveButton(_ sender: Any) {
        setupNameQuizPopupView()
        createQuizDone()
    }
    
    @IBAction func doneButton(_ sender: Any) {
        fbHelper.createQuiz.name = nameQuizTextField.text!
        fbHelper.createQuiz.latitude = fbHelper.createQuiz.questions[0].latitude
        fbHelper.createQuiz.longitude = fbHelper.createQuiz.questions[0].longitude
        fbHelper.addQuizToDatabase()
        nameQuizPopupView.removeFromSuperview()
        isCreateQuiz = false
        removeAnnotations()
        fbHelper.readQuizFromDatabase()
        questionNumber = 0
        
    }
  
    @IBAction func startQuizButton(_ sender: Any) {
        playQuizInProgress()
        if(!isPlayingQuiz){
            fbHelper.readQuestionsFromDatabase(childKey: quizAnnotation.quiz.ID)
            isPlayingQuiz = true
            setUpStartButtons(bool: true)
        }
        startGamePopupView.removeFromSuperview()
        
    }
    
    @IBAction func startQuestionButton(_ sender: Any) {
        startGamePopupView.removeFromSuperview()
    }
    
    @objc func handleTap(_ gestureReconizer: UILongPressGestureRecognizer)
    {
        if (gestureReconizer.state == .began) {
            if(!isPlayingQuiz){
                setupPopupView()
                setUpPopupLabel()
                coordinate = mapView.convert(gestureReconizer.location(in: mapView),toCoordinateFrom: mapView)
                isCreateQuiz = true
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if(!isCreateQuiz){
            if(!isPlayingQuiz) {
                quizAnnotation = view.annotation as! QuizAnnotation
                startQuizLabel.text = quizAnnotation.quiz.name
                playQuiz = quizAnnotation.quiz
                checkDistanceToAnnotation()
                setupstartGamePopupView()
            }
            else{
                questionAnnotation = view.annotation as! QuestionAnnotation
                question = questionAnnotation.question
                if (playQuiz.isQuestionDone(question: questionAnnotation.question)){
                    setupFinishedQuestionPopupView(didAnswerRight: question.didAnswerRight)
                    
                }
                else{
                    startQuizLabel.text = view.annotation!.title as? String
                    checkDistanceToAnnotation()
                    
                    setupstartGamePopupView()
                }
            }
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createQuestion" {
            let destinationVC = segue.destination as! CreateQuizViewController
            questionNumber += 1
            destinationVC.longitude = coordinate.longitude
            destinationVC.latitude = coordinate.latitude
            destinationVC.questionNumber = questionNumber
            destinationVC.questionDelegate = self

        }
        
        else if segue.identifier == "startQuestion" {
            
            let destinationVC = segue.destination as! PlayQuizViewController
            destinationVC.questionDelegate = self
            destinationVC.question = question
            
        }
    }
    
    func checkDistanceToAnnotation() {
        var annotationLocation = CLLocation()
        if let myLocation = locationManager.location {
            if(!isPlayingQuiz){
            annotationLocation = CLLocation(latitude: quizAnnotation.coordinate.latitude,longitude: quizAnnotation.coordinate.longitude)
            }
            else{
                annotationLocation = CLLocation(latitude: questionAnnotation.coordinate.latitude,longitude: questionAnnotation.coordinate.longitude)
            }
            let distance = myLocation.distance(from: annotationLocation)
            setDistance(distance: distance)
            if (distance < 20.0) {
                
                startQuestionOutlet.alpha = 1.0
                startQuestionOutlet.isUserInteractionEnabled = true
                startQuizOutlet.alpha = 1.0
                startQuizOutlet.isUserInteractionEnabled = true
            }
            else{
                startQuestionOutlet.alpha = 0.5
                startQuizOutlet.alpha = 0.5
                startQuestionOutlet.isUserInteractionEnabled = false
                startQuizOutlet.isUserInteractionEnabled = false
            }
        }
    }
    
    func setDistance(distance:Double)  {
        let newDistance = distance - 20.0
        
        if(newDistance < 0.0){
            distanceLabel.text = "Distance: \(0.0)"
        }
        else{
        distanceLabel.text = "Distance: \(newDistance.rounded(toDecimalPlaces: 1))"
        }
    }
    
    func setupLocationButton()  {
        
        view.addSubview(locationButton)
        locationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84).isActive = true
        locationButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        locationButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        locationButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        locationButton.layer.cornerRadius = 50 / 2
        
    }
    
    func setupLoccationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationservices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLoccationManager()
            checkLocationAuthorization()
        }
        else{
            // Säg åt användaren att sätta på locations i settings
        }
    }
    
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate{ // coordinate longitud och latitud
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: meters, longitudinalMeters: meters)
            mapView.setRegion(region, animated: true)
        }
        
    }
    
    func checkLocationAuthorization()  {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            break
        case .notDetermined:
            //(locationManeger.requestAlwaysAuthorization() eventuellt använda denna
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            break
        case .authorizedAlways:
            // Får tillgång till platsinformation när appen är stängd, kan behövas om man ska få notis.
            break
        }
    }
    
    func setUpLongPressRecogniser() {
        self.longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        longPressRecogniser.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPressRecogniser)
    }
    
    @objc func locationButtonHandler() {
        centerViewOnUserLocation()
    }
    
    func createQuizInProgress()  {
        self.title = "Create quiz"
        inProgressView.isHidden = false
    }
    
    func playQuizInProgress() {
        self.title = "Play quiz"
        inProgressView.isHidden = false
        saveButtonOutlet.isHidden = true
    }
    
    func playQuizDone()  {
        setTitle()
        inProgressView.isHidden = true
        saveButtonOutlet.isHidden = false
    }
    
    func setTitle()  {
        self.title = "OrienteeringQuiz"
    }
    func createQuizDone()  {
        setTitle()
        inProgressView.isHidden = true
        
        
    }
    
    func setupFinishedQuestionPopupView(didAnswerRight:Bool)  {
        self.view.addSubview(finishedQuestionPopupView)
        finishedQuestionPopupView.center = mapView.center
        if (didAnswerRight){
            answerStatusLabel.text = "Answer was right!"
        }
        else{
            answerStatusLabel.text = "Answer was wrong!"
        }
        rightAnswerLabel.text = "Right answer: " + question.rightAnswer
    }
    
    func setUpStartButtons(bool:Bool)  {
        if (bool){
            startQuizOutlet.isHidden = true
            startQuestionOutlet.isHidden = false
        }
        else {
            startQuizOutlet.isHidden = false
            startQuestionOutlet.isHidden = true
        }
    }
    
    func setupstartGamePopupView() {
        self.view.addSubview(startGamePopupView)
        startGamePopupView.center = mapView.center
        
    }
    
    func setUpQuizDonePopupView(bool:Bool)  {
        
        if(bool){
            self.view.addSubview(quizDonePopupView)
            quizDonePopupView.center = mapView.center
            resultLabel.text = "Score: \(playQuiz.rightanswers) of \(playQuiz.questions.count)"
        }
        else{
            quizDonePopupView.removeFromSuperview()
        }
        
    }
    
    func setupPopupView() {
        self.view.addSubview(popupView)
        popupView.center = mapView.center
    }
    
    func setupNameQuizPopupView() {
        self.view.addSubview(nameQuizPopupView)
        nameQuizPopupView.center = mapView.center
    }
    
    func setUpPopupLabel()  {
        if(isCreateQuiz){
            popupLabel.text = "Do you want to add another question?"
        }
        else {
            popupLabel.text = "Do you want to create a new quiz?"
        }
    }
    // annotation functions
    func createAnnotation()  {
        if (isCreateQuiz) {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            print("Latitude: \(annotation.coordinate.latitude) Longitude:  \(annotation.coordinate.longitude)")
            mapView.addAnnotation(annotation)
        }
    }
    func addAnnotationsForQuestions(quiz:Quiz)  {
        for i in 0...quiz.questions.count-1 {
            print(i)
            
            let questionAnnotation = QuestionAnnotation()
            questionAnnotation.question = quiz.questions[i]
            questionAnnotation.coordinate = CLLocationCoordinate2DMake(quiz.questions[i].latitude , quiz.questions[i].longitude)
            questionAnnotation.title = "Question \(i+1)"
            playQuiz.questions.append(quiz.questions[i])
            
            mapView.addAnnotation(questionAnnotation)
        }
    }
    func addAnnotionsForQuizzes(quizzes: [Quiz]) {
       
        if(!isCreateQuiz){
            for quiz in quizzes {
                
                let quizAnnotation = QuizAnnotation()
                quizAnnotation.quiz = quiz
                quizAnnotation.coordinate = CLLocationCoordinate2DMake(quiz.latitude , quiz.longitude )
               
                quizAnnotation.title = quiz.name
                
                
                mapView.addAnnotation(quizAnnotation)
            }
        }
    }
    
    fileprivate func removeAnnotations() {
        if(!isCreateQuiz){
            let annotationsToRemove = mapView.annotations.filter { $0 !== mapView.userLocation }
            mapView.removeAnnotations( annotationsToRemove )
        }
    }

}

extension MapViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
//        guard let location = locations.last else {return}
//
//        let centre = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion.init(center: centre, latitudinalMeters: meters, longitudinalMeters: meters)
//        mapView.setRegion(region, animated: true)
        
        
        
        checkDistanceToAnnotation()
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        checkLocationAuthorization()
    }
    
    func hideKeyboard() {
        let Tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(Tap)
    }
    @objc func dismissKeyboard()  {
        view.endEditing(true)
    }
    
    
}
