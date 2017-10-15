//
//  SwitchCityViewController.swift
//  GetWeather
//
//  Created by Jianyu ZHU on 13/10/17.
//  Copyright © 2017 Unimelb. All rights reserved.
//

import UIKit

protocol ChangeCityDelegate {
    func userEnterNewCityName(city : String)
}

class SwitchCityViewController: UIViewController, UITextFieldDelegate {
    
    let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "cityBackground")
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    let inputContainerView: UIView = {
        let view = UIView()
        //        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "left"), for: .normal)
        //        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleShadowColor(UIColor.rgb(red: 128, green: 128, blue: 128), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handleBackButtonPress), for: .touchUpInside)
        return button
    }()
    
    let getWeatherButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get Weather", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 28)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleShadowColor(UIColor.rgb(red: 128, green: 128, blue: 128), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handleGetWeatherButtonPress), for: .touchUpInside)
        return button
    }()
    
    let weatherInputTextView: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter City Name"
        tf.textAlignment = .center
        tf.backgroundColor = UIColor.white
        tf.borderStyle = .roundedRect
        tf.minimumFontSize = 17
        tf.adjustsFontSizeToFitWidth = true
        tf.font = UIFont.systemFont(ofSize: 32)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherInputTextView.delegate = self
        weatherInputTextView.becomeFirstResponder()
        
        setupView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupView() {
        setupBackgroundView()
        setupInputContainerView()
    }
    
    func setupBackgroundView() {
        view.addSubview(backgroundImageView)
        
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
    }
    
    func setupInputContainerView() {
        view.addSubview(inputContainerView)
        
        inputContainerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        inputContainerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        inputContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        inputContainerView.heightAnchor.constraint(equalToConstant: 221).isActive = true
        
        
        inputContainerView.addSubview(getWeatherButton)
        
        getWeatherButton.bottomAnchor.constraint(equalTo: inputContainerView.bottomAnchor).isActive = true
        getWeatherButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        getWeatherButton.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor,constant: 12).isActive = true
        getWeatherButton.rightAnchor.constraint(equalTo: inputContainerView.rightAnchor, constant: -12).isActive = true
        
        
        inputContainerView.addSubview(backButton)
        
        backButton.topAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: 20).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        backButton.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 16).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        
        inputContainerView.addSubview(weatherInputTextView)
        
        weatherInputTextView.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor).isActive = true
        weatherInputTextView.bottomAnchor.constraint(equalTo: getWeatherButton.topAnchor, constant: -20).isActive = true
        weatherInputTextView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        weatherInputTextView.widthAnchor.constraint(equalToConstant: 270).isActive = true
        
    }
    
    var switchCitydelegate : ChangeCityDelegate?
    
    func handleBackButtonPress() {
        dismissFromLeft()
    }
    
    func handleGetWeatherButtonPress() {
        if let delegate = switchCitydelegate, let text = weatherInputTextView.text {
            delegate.userEnterNewCityName(city: text)
            dismissFromLeft()
        } else {
            dismissFromLeft()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleGetWeatherButtonPress()
        return true
    }
}
