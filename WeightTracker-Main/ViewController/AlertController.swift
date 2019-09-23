//
//  AlertController.swift
//  SavingMoneyPlanning
//
//  Created by Phan Nhat Dang on 8/29/18.
//  Copyright © 2018 Phan Nhat Dang. All rights reserved.
//

import UIKit

class AlertController {
    static func showAlert(inController:UIViewController, tilte:String, message:String) {
        let alert = UIAlertController(title: tilte, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        inController.present(alert, animated: true, completion: nil)
    }
}

