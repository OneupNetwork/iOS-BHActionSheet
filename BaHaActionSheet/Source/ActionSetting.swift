//
//  ActionSetting.swift
//  ActionSheet
//
//  Created by Wayne on 2018/9/14.
//  Copyright © 2018年 Bahamut. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import UIKit

enum ThemeStyle {
    case light, dark
}

class ActionSetting {
    
    static let share = ActionSetting()
    
    private init() {
    }
    
    var style: ThemeStyle = .light {
        didSet {
            switch style {
            case .light:
                backgroundColor = UIColor.white
                separatorColor = UIColor(white: 204 / 255, alpha: 0.5)
            case .dark:
                backgroundColor = UIColor(white: 60 / 255, alpha: 1)
                separatorColor = UIColor(white: 133 / 255, alpha: 0.5)
            }
        }
    }
    var backgroundColor: UIColor = UIColor.white
    var separatorColor: UIColor = UIColor(white: 204 / 255, alpha: 0.5)
    var titleColor: UIColor = UIColor(white: 111 / 255, alpha: 1)
    var cellHeight: CGFloat = 48
    var imageSize: CGFloat = 24
    var animationDuration = 0.4
}
