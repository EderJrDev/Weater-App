//
//  UIView+Extensions.swift
//  Weater App
//
//  Created by Eder Junior Alves Silva on 13/08/25.
//

import Foundation
import UIKit

extension UIView {
    func setConstraintsToParent(_ parent:UIView)
    
    {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: parent.topAnchor),
            self.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: parent.bottomAnchor)
        ])
        
    }
}
