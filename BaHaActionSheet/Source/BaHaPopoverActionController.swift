//
//  BaHaPopoverActionController.swift
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

import Foundation
import UIKit

open class BaHaPopoverActionController: BahaActionSheet {
    
    fileprivate let kPopoverViewMargin: CGFloat = 8
    fileprivate let kPopoverViewArrowHeight: CGFloat = 13
    //箭頭方向 true向上 false向下
    fileprivate var isUpward = true
    
    lazy open var arrowView = UIView()
    
    open var sourceView: UIView? {
        willSet {
            if let sourceView = newValue {
                if let pointViewRect = sourceView.superview?.convert(sourceView.frame, to: UIApplication.shared.keyWindow) {
                    let pointViewUpLength = pointViewRect.minY
                    let pointViewDownLength = mainHeight - pointViewRect.maxY
                    var toPoint = CGPoint(x: pointViewRect.midX, y: 0)
                    if pointViewUpLength > pointViewDownLength {
                        toPoint.y = pointViewUpLength - 5
                    } else {
                        toPoint.y = pointViewRect.maxY + 5
                    }
                    sourcePoint = toPoint
                    isUpward = pointViewUpLength <= pointViewDownLength
                }
            }
        }
    }
    
    open var sourcePoint: CGPoint? {
        willSet {
            if let newValue = newValue {
                isUpward = newValue.y <= mainHeight - newValue.y
            }
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundView)
        collectionView.alwaysBounceVertical = false
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        showToPoint(point: sourcePoint)
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        dismiss()
    }
    
    open func showToPoint(point: CGPoint?) {
        
        var toPoint = point ?? .zero
        
        let cornerRadius: CGFloat = 6
        let arrowWidth: CGFloat = 22
        let minHorizontalEdge =  kPopoverViewMargin + cornerRadius + arrowWidth/2 + 2
        if toPoint.x < minHorizontalEdge {
            toPoint.x = minHorizontalEdge
        }
        
        if mainWidth - toPoint.x < minHorizontalEdge {
            toPoint.x = mainWidth - minHorizontalEdge
        }
        var currentWidth: CGFloat = calculateMaxWidth()
        var currentHeight: CGFloat = ActionSetting.share.cellHeight * CGFloat(actions.count)
        
        if actions.isEmpty {
            currentWidth = 150
            currentHeight = ActionSetting.share.cellHeight
        }
        
        currentHeight += kPopoverViewArrowHeight
        
        var bottomSafeArea: CGFloat = 0
        
        if #available(iOS 11.0, *) {
            bottomSafeArea = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        }
        
        let maxHeight = isUpward ? mainHeight - toPoint.y - kPopoverViewMargin - bottomSafeArea : toPoint.y - UIApplication.shared.statusBarFrame.height
        if currentHeight > maxHeight {
            currentHeight = maxHeight
            collectionView.isScrollEnabled = true
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        }
        
        var currentX = toPoint.x - currentWidth/2
        var currentY = toPoint.y
        
        //視窗靠左
        if toPoint.x <= currentWidth/2 + kPopoverViewMargin {
            currentX = kPopoverViewMargin
        }
        
        //視窗靠右
        if mainWidth - toPoint.x <= currentWidth/2 + kPopoverViewMargin {
            currentX = mainWidth - kPopoverViewMargin - currentWidth
        }
        
        //箭頭向下
        if !isUpward {
            currentY = toPoint.y - currentHeight
        }
        
        arrowView.frame = CGRect(x: currentX, y: currentY, width: currentWidth, height: currentHeight)
        
        let arrowPoint = CGPoint(x: toPoint.x - arrowView.frame.minX, y: isUpward ? 0 : currentHeight)
        let maskTop = isUpward ? kPopoverViewArrowHeight : 0
        let maskBottom = isUpward ? currentHeight : currentHeight - kPopoverViewArrowHeight
        let maskPath = UIBezierPath()
        
        //左上圓角
        maskPath.move(to: CGPoint(x: 0, y: cornerRadius + maskTop))
        maskPath.addArc(withCenter: CGPoint(x: cornerRadius, y: cornerRadius + maskTop), radius: cornerRadius, startAngle: degreesToRadians(angle: 180), endAngle: degreesToRadians(angle: 270), clockwise: true)
        //箭頭向上
        if isUpward {
            maskPath.addLine(to: CGPoint(x: arrowPoint.x - arrowWidth / 2, y: kPopoverViewArrowHeight))
            maskPath.addLine(to: arrowPoint)
            maskPath.addLine(to: CGPoint(x: arrowPoint.x + arrowWidth / 2, y: kPopoverViewArrowHeight))
        }
        //右上圓角
        maskPath.addLine(to: CGPoint(x: currentWidth - cornerRadius, y: maskTop))
        maskPath.addArc(withCenter: CGPoint(x: currentWidth - cornerRadius, y: maskTop + cornerRadius), radius: cornerRadius, startAngle: degreesToRadians(angle: 270), endAngle: degreesToRadians(angle: 0), clockwise: true)
        //右下圓角
        maskPath.addLine(to: CGPoint(x: currentWidth, y: maskBottom - cornerRadius))
        maskPath.addArc(withCenter: CGPoint(x: currentWidth - cornerRadius, y: maskBottom - cornerRadius), radius: cornerRadius, startAngle: degreesToRadians(angle: 0), endAngle: degreesToRadians(angle: 90), clockwise: true)
        //箭頭向下
        if !isUpward {
            maskPath.addLine(to: CGPoint(x: arrowPoint.x + arrowWidth / 2, y: currentHeight - kPopoverViewArrowHeight))
            maskPath.addLine(to: arrowPoint)
            maskPath.addLine(to: CGPoint(x: arrowPoint.x - arrowWidth / 2, y: currentHeight - kPopoverViewArrowHeight))
        }
        //左下圓角
        maskPath.addLine(to: CGPoint(x: cornerRadius, y: maskBottom))
        maskPath.addArc(withCenter: CGPoint(x: cornerRadius, y: maskBottom - cornerRadius), radius: cornerRadius, startAngle: degreesToRadians(angle: 90), endAngle: degreesToRadians(angle: 180), clockwise: true)
        maskPath.close()
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = arrowView.bounds
        maskLayer.path = maskPath.cgPath
        arrowView.layer.mask = maskLayer

        let tempFrame = arrowView.frame
        arrowView.layer.anchorPoint = CGPoint(x: arrowPoint.x / currentWidth, y: isUpward ? 0 : 1)
        arrowView.frame = tempFrame
        collectionView.frame = CGRect(x: arrowView.bounds.minX, y: isUpward ? arrowView.bounds.minY + kPopoverViewArrowHeight : arrowView.bounds.minY, width: arrowView.bounds.width, height: arrowView.bounds.height)
        arrowView.backgroundColor = ActionSetting.share.backgroundColor
        arrowView.addSubview(collectionView)
        view.addSubview(arrowView)
        if !isUpward {
            collectionView.setContentOffset(CGPoint(x: 0, y: ActionSetting.share.cellHeight * CGFloat(actions.count) - currentHeight + 15), animated: false)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let referenceWidth = calculateMaxWidth()
        return CGSize(width: referenceWidth, height: ActionSetting.share.cellHeight)
    }
    
    open override func presentView(_ presentedView: UIView, presentingView: UIView, animationDuration: Double, completion: ((_ completed: Bool) -> Void)?) {
        
        backgroundView.alpha = 0.0
        arrowView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        self?.backgroundView.alpha = 1.0
                        self?.arrowView.transform = .identity
            },
                       completion: { finished in
                        completion?(finished)
        })
    }
    
    open override func dismissView(_ presentedView: UIView, presentingView: UIView, animationDuration: Double, completion: ((_ completed: Bool) -> Void)?) {
        
        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        self?.backgroundView.alpha = 0.0
                        self?.arrowView.alpha = 0.0
            },
                       completion: { [weak self] (_) in
                        self?.arrowView.removeFromSuperview()
                        completion?(true)
        })
    }
    
    fileprivate func calculateMaxWidth() -> CGFloat {
        let margin: CGFloat = 16 + 16 + ActionSetting.share.imageSize + 25
        var maxWidth: CGFloat = margin
        let titleFont = UIFont.systemFont(ofSize: 15, weight: .medium)
        for action in actions {
            var titleWidth: CGFloat = 0
            titleWidth = (action.data.title as NSString).size(withAttributes: [NSAttributedStringKey.font: titleFont]).width
            let contentWidth = titleWidth + margin
            if contentWidth > maxWidth {
                maxWidth = ceil(contentWidth)
            }
        }
        if maxWidth > UIScreen.main.bounds.width {
            maxWidth = UIScreen.main.bounds.width
        }
        return maxWidth
    }
    
    fileprivate func degreesToRadians(angle: CGFloat) -> CGFloat {
        return angle * .pi / 180
    }
}
