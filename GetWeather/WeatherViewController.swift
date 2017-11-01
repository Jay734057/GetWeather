//
//  ViewController.swift
//  GetWeather
//
//  Created by Jianyu ZHU on 13/10/17.
//  Copyright © 2017 Unimelb. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import SVProgressHUD

class WeatherViewController: UIViewController {
    
    let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "background")
        iv.contentMode = .scaleToFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let changeCityButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "switch"), for: .normal)
        button.setTitleShadowColor(UIColor.rgb(red: 128, green: 128, blue: 128), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handleSwitch), for: .touchUpInside)
        return button
    }()
    
    let weatherContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 100)
        label.textColor =  UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var weatherConditionImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(updateWeather)))
        iv.isUserInteractionEnabled = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let cityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 33)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkIfNeedToUpdateWeather), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func checkIfNeedToUpdateWeather( _sender: AnyObject) {
        if switchedCity == nil {
            updateWeather()
        }
    }

    func updateWeather() {
        SVProgressHUD.show()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupView() {
        setupBackgroundView()
        setupSwitchButton()
        setupWeatherContainerView()
    }

    func setupBackgroundView() {
        view.addSubview(backgroundImageView)
        
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
    }
    
    func setupSwitchButton() {
        view.addSubview(changeCityButton)
        
        changeCityButton.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor, constant: 20).isActive = true
        changeCityButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        changeCityButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        changeCityButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
    }
    
    func setupWeatherContainerView() {
        view.addSubview(weatherContainerView)
        
        weatherContainerView.heightAnchor.constraint(equalToConstant: 480).isActive = true
        weatherContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        weatherContainerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        weatherContainerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        
        weatherContainerView.addSubview(temperatureLabel)
        
        temperatureLabel.topAnchor.constraint(equalTo: weatherContainerView.topAnchor).isActive = true
        temperatureLabel.heightAnchor.constraint(equalToConstant: 128).isActive = true
        temperatureLabel.widthAnchor.constraint(equalToConstant: 268).isActive = true
        temperatureLabel.rightAnchor.constraint(equalTo: weatherContainerView.rightAnchor, constant: -16).isActive = true
        
        
        weatherContainerView.addSubview(cityLabel)
        
        cityLabel.bottomAnchor.constraint(equalTo: weatherContainerView.bottomAnchor).isActive = true
        cityLabel.heightAnchor.constraint(equalToConstant: 96).isActive = true
        cityLabel.leftAnchor.constraint(equalTo: weatherContainerView.leftAnchor, constant: 16).isActive = true
        cityLabel.rightAnchor.constraint(equalTo: weatherContainerView.rightAnchor, constant: -16).isActive = true
        
        
        weatherContainerView.addSubview(weatherConditionImageView)
        
        weatherConditionImageView.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 2).isActive = true
        weatherConditionImageView.bottomAnchor.constraint(equalTo: cityLabel.topAnchor, constant: -2).isActive = true
        weatherConditionImageView.leftAnchor.constraint(equalTo: weatherContainerView.leftAnchor, constant: 16).isActive = true
        weatherConditionImageView.rightAnchor.constraint(equalTo: weatherContainerView.rightAnchor, constant: -16).isActive = true
    }
    
    let locationManager = CLLocationManager()
    let weatherData = WeatherData()
    
    
    //MARK: - Location manager
    /***************************************************************/
    func setupLocationManager() {
        SVProgressHUD.show()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    //MARK: - Networking
    /***************************************************************/
    func getWeatherData(url: String, parameters: [String : String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherData(data: weatherJSON)
                SVProgressHUD.dismiss()
            } else {
                print("Error \(response.result.error!)")
                self.cityLabel.text = "Connection Issues"
                SVProgressHUD.dismiss()
            }
        }
    }

    
    //MARK: - JSON Parsing
    /***************************************************************/
    func updateWeatherData(data : JSON) {
        if let temperature = data["main"]["temp"].double {
            weatherData.temperature = Int(temperature - 273.15)
            weatherData.city = data["name"].stringValue
            weatherData.condition = data["weather"][0]["id"].intValue
            weatherData.weatherIconName = weatherData.updateWeatherIcon(condition: weatherData.condition)
            updateUIWithWeatherData()
        } else {
            cityLabel.text = "Weather Unavailable"
        }
    }
    
    //MARK: - UI Updates
    /***************************************************************/
    func updateUIWithWeatherData() {
        cityLabel.text = weatherData.city
        temperatureLabel.text = "\(weatherData.temperature)℃"
        weatherConditionImageView.image = UIImage(named: weatherData.weatherIconName)
        
    }

    var switchedCity: String?
    
    func handleSwitch() {
        let switchCityViewController = SwitchCityViewController()
        switchCityViewController.switchCitydelegate = self
        
        presentFromRight(switchCityViewController)
    }
}

extension WeatherViewController : CLLocationManagerDelegate {
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let coordinate : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
        SVProgressHUD.dismiss()
    }
}

extension WeatherViewController : ChangeCityDelegate {
    //MARK: - Change City Delegate methods
    /***************************************************************/
    func userEnterNewCityName(city: String) {
        SVProgressHUD.show()
        switchedCity = city
        let params : [String : String] = ["q" : city, "appid" : APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
        SVProgressHUD.dismiss()
    }

}

