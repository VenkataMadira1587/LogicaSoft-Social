//
//  RoundBtn_Signin.swift
//  logicaSoft-Social
//
//  Created by Venkat Madira on 17/06/2017.
//  Copyright © 2017 Venkat Madira. All rights reserved.
//

import UIKit

class RoundBtn_Signin: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.cornerRadius = 2.0
    }

}
