//
//  FlowController.swift
//  ForumApp
//
//  Created by moshiko elkalay on 26/02/2020.
//  Copyright © 2020 moshiko. All rights reserved.
//

import UIKit
import FirebaseAuth

//1.
class FlowController {
    
    //A. reference to root UI
    weak var window : UIWindow?
    
    //B. shared instance make this accssible from anywhere
    static let shared = FlowController()
    
    //C. didLogin
    private var didLogin : Bool {
        return Auth.auth().currentUser != nil
        //TODO: next add firebase code
        
    }
    
    //call this method to refresh application root UI (main / login)
    func determineRoot() {
        //A. Validate Main Thread
        guard Thread.isMainThread else {
            //fallback to main thread if not
            DispatchQueue.main.async {
                FlowController.shared.determineRoot()
            }
            return
        }
        
        //B. create storyboard instance -> didLogin = firebase code
        let storyboard = UIStoryboard(name: didLogin ? "Post" : "Main", bundle: nil)
        
        //C. generate initial (->) view controller
        let initialVC = storyboard.instantiateInitialViewController()
        
        //D. update main UI
        window?.rootViewController = initialVC
    
    }
    
}







