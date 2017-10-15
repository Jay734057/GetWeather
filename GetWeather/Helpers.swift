//
//  Helpers.swift
//  GetWeather
//
//  Created by Jianyu ZHU on 15/10/17.
//  Copyright © 2017 Unimelb. All rights reserved.
//

import UIKit

extension UIColor{
    static func rgb(red:CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIViewController {
    
    func presentFromRight(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        present(viewControllerToPresent, animated: false)
    }
    
    func dismissFromLeft() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false)
    }
}

let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
let APP_ID = "873632816bf31141ec4b238f847667db"


