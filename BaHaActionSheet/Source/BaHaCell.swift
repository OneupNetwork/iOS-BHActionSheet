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
    
    open lazy var animateSelectBackgroundView: UIView = { [weak self] in
        let view = UIView()
        return view
    }()

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
        actionImageView.contentMode = .scaleAspectFit
        actionImageView.widthAnchor.constraint(equalToConstant: ActionSetting.share.imageSize).isActive = true
        actionImageView.heightAnchor.constraint(equalToConstant: ActionSetting.share.imageSize).isActive = true
        actionImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        actionImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        contentView.addSubview(actionTitleLabel)
        actionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageRightConstraint = actionTitleLabel.leadingAnchor.constraint(equalTo: actionImageView.trailingAnchor, constant: 16)
        actionTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        actionTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 16).isActive = true
        titleLeftConstraint = actionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        contentView.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorView.leadingAnchor.constraint(equalTo: actionTitleLabel.leadingAnchor, constant: 0).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        backgroundView.addSubview(customBackgroundView)
        backgroundView.addSubview(animateSelectBackgroundView)
        selectedBackgroundView = backgroundView
        
        backgroundColor = ActionSetting.share.backgroundColor
        separatorView.backgroundColor = ActionSetting.share.separatorColor
        actionTitleLabel.textColor = ActionSetting.share.titleColor
        actionTitleLabel.font = UIFont.systemFont(ofSize: ActionSetting.share.titleTextSize)
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
    }
    
    open override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                customBackgroundView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
                animateSelectBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
                animateSelectBackgroundView.frame = CGRect(x: 0, y: 0, width: 30, height: frame.height)
                animateSelectBackgroundView.center = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
                
                UIView.animate(withDuration: 0.5) { [weak self] in
                    guard let `self`  = self else {
                        return
                    }
                    
                    self.animateSelectBackgroundView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
                    self.animateSelectBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.08)
                }
            } else {
                animateSelectBackgroundView.backgroundColor = animateSelectBackgroundView.backgroundColor?.withAlphaComponent(0.0)
                customBackgroundView.backgroundColor = customBackgroundView.backgroundColor?.withAlphaComponent(0.0)
            }
        }
    }
}
