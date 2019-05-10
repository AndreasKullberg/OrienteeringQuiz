//
//  designModel.swift
//  OrienteeringQuiz
//
//  Created by Andreas Kullberg on 2019-05-08.
//  Copyright © 2019 Andreas Kullberg. All rights reserved.
//


import UIKit

class popupViews: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    func setUpView()  {
        let cornerRadius: CGFloat = 15.0
        layer.cornerRadius = cornerRadius
        
        setShadow()
    }
    
    func setShadow()  {
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOffset  = CGSize(width: 0.0, height: 6.0)
        layer.shadowRadius  = 8
        layer.shadowOpacity = 0.5
        clipsToBounds       = true
        layer.masksToBounds = false
    }
    
}

class myButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    func setUpView()  {
        setTitleColor(.white, for: .normal)
        setShadow()
        let cornerRadius: CGFloat = 20.0
        layer.cornerRadius = cornerRadius
        backgroundColor = .gray
        
        
    }
    
    func setShadow()  {
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOffset  = CGSize(width: 0.0, height: 6.0)
        layer.shadowRadius  = 4
        layer.shadowOpacity = 0.3
        clipsToBounds       = true
        layer.masksToBounds = false
    }
    
}

class yesNoButton:UIButton{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    func setUpView()  {
        layer.borderWidth = 0.4
        layer.borderColor = UIColor.lightGray.cgColor
    }
}

class myTextfield: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    func setUpView()  {
        let cornerRadius: CGFloat = 5.0
        layer.cornerRadius = cornerRadius
    }
}
