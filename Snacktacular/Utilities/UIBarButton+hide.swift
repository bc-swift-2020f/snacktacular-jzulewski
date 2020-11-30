//
//  UIBarButton+hide.swift
//  Snacktacular
//
//  Created by John Zulewski on 11/16/20.
//

import UIKit

extension UIBarButtonItem {
    func hide() {
        self.isEnabled = false
        self.tintColor = .clear
    }
}
