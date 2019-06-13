//
//  BaHaCell.swift
//  BaHaActionSheet
//
//  Created by Wayne on 2018/9/12.
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

import UIKit

class BaHaCell: UICollectionViewCell {

    open lazy var customBackgroundView: UIView = { [weak self] in
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.08)
        return view
    }()
    
    open lazy var actionTitleLabel = UILabel()
    open lazy var actionImageView = UIImageView()
    open lazy var separatorView = UIView()
    fileprivate var imageRightConstraint: NSLayoutConstraint?
    fileprivate var titleLeftConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(actionImageView)
        actionImageView.translatesAutoresizingMaskIntoConstraints = false
        actionImageView.widthAnchor.constraint(equalToConstant: ActionSetting.share.imageSize).isActive = true
        actionImageView.heightAnchor.constraint(equalToConstant: ActionSetting.share.imageSize).isActive = true
        actionImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        actionImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24).isActive = true
        contentView.addSubview(actionTitleLabel)
        actionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageRightConstraint = actionTitleLabel.leadingAnchor.constraint(equalTo: actionImageView.trailingAnchor, constant: 16)
        actionTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        actionTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 16).isActive = true
        titleLeftConstraint = actionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        contentView.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        backgroundView.addSubview(customBackgroundView)
        selectedBackgroundView = backgroundView
        
        backgroundColor = ActionSetting.share.backgroundColor
        separatorView.backgroundColor = ActionSetting.share.separatorColor
        actionTitleLabel.textColor = ActionSetting.share.titleColor
        actionTitleLabel.font = ActionSetting.share.titleTextFont
        actionImageView.contentMode = ActionSetting.share.imageContentMode
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func setup(data: ActionData) {
        actionTitleLabel.text = data.title
        if let image = data.image {
            actionImageView.image = image
            actionImageView.isHidden = false
            imageRightConstraint?.isActive = true
            titleLeftConstraint?.isActive = false
        } else {
            actionImageView.isHidden = true
            imageRightConstraint?.isActive = false
            titleLeftConstraint?.isActive = true
        }
        switch data.type {
        case .cancel:
            actionTitleLabel.textColor = ActionSetting.share.cancelColor
            actionImageView.image = actionImageView.image?.withRenderingMode(.alwaysTemplate)
            actionImageView.tintColor = ActionSetting.share.cancelColor
        default:
            break
        }
    }
    
    open override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                customBackgroundView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            } else {
                customBackgroundView.backgroundColor = customBackgroundView.backgroundColor?.withAlphaComponent(0.0)
            }
        }
    }
}
