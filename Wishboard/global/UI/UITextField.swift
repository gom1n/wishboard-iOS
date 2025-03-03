//
//  UITextField.swift
//  Wishboard
//
//  Created by gomin on 2022/09/06.
//

import Foundation
import UIKit
import SnapKit

extension UITextField {
    // MARK: TextField 왼쪽 Padding
    func addLeftPadding(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
