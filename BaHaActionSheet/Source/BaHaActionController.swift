//
//  BaHaActionController.swift
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

open class BaHaActionController: BahaActionSheet {
    
    open var safeAreaInsets: UIEdgeInsets {
        if #available(iOS 11, *) {
            return UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
        }
        return .zero
    }
    fileprivate var contentHeight: CGFloat = 0.0
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationCapturesStatusBarAppearance = true
        view.addSubview(backgroundView)
        collectionView.clipsToBounds = false
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureDidRecognize(_:)))
        collectionView.backgroundView = UIView(frame: collectionView.bounds)
        collectionView.backgroundView?.isUserInteractionEnabled = true
        collectionView.backgroundView?.addGestureRecognizer(tapRecognizer)
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        view.addSubview(collectionView)
        collectionView.layoutSubviews()
        
        if let layoutAtts = collectionViewLayout.layoutAttributesForItem(at: IndexPath(item: actions.count - 1, section: 0)) {
            contentHeight = layoutAtts.frame.origin.y + layoutAtts.frame.size.height
        }
        setUpContentInsetForHeight(view.frame.height)
        collectionView.frame = view.bounds
        collectionView.frame.origin.y += contentHeight
    }
    
    @available(iOS 11.0, *)
    open override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        setUpContentInsetForHeight(view.frame.height)
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.setNeedsLayout()
        collectionView.collectionViewLayout.invalidateLayout()
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.setUpContentInsetForHeight(size.height)
            self?.collectionView.reloadData()
            }, completion: { [weak self] _ in
                self?.drawCell()
        })
        collectionView.layoutIfNeeded()
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let referenceWidth = collectionView.bounds.size.width
        let margins = collectionView.contentInset.left + collectionView.contentInset.right
        return CGSize(width: referenceWidth - margins, height: ActionSetting.share.cellHeight)
    }
    
    open override func presentView(_ presentedView: UIView, presentingView: UIView, animationDuration: Double, completion: ((_ completed: Bool) -> Void)?) {
        
        backgroundView.alpha = 0.0
        drawCell()
        collectionView.frame = CGRect(x: view.bounds.minX, y: view.bounds.height, width: view.bounds.width, height: view.bounds.height)
        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        guard let `self` = self else { return }
                        self.backgroundView.alpha = 1.0
                        self.collectionView.frame = self.view.bounds
            },
                       completion: { finished in
                        completion?(finished)
        })
    }
    
    open override func dismissView(_ presentedView: UIView, presentingView: UIView, animationDuration: Double, completion: ((_ completed: Bool) -> Void)?) {
        let upTime = 0.1
        UIView.animate(withDuration: upTime, delay: 0, options: .curveEaseIn, animations: { [weak self] in
            self?.collectionView.frame.origin.y -= 10
            }, completion: { [weak self] (completed) -> Void in
                UIView.animate(withDuration: animationDuration - upTime,
                               delay: 0,
                               usingSpringWithDamping: 1,
                               initialSpringVelocity: 0,
                               options: UIView.AnimationOptions.curveEaseIn,
                               animations: { [weak self] in
                                guard let `self` = self else { return }
                                self.backgroundView.alpha = 0.0
                                self.collectionView.frame.origin.y = self.contentHeight + self.safeAreaInsets.bottom
                    },
                               completion: { _ in
                                completion?(true)
                })
        })
    }
    
    fileprivate func drawCell() {
        
        if let firstCell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) {
            if actions.count == 1 {
                drawSafeArea(cell: firstCell)
                return
            }
        }
        
        if let lastCell = collectionView.cellForItem(at: IndexPath(item: actions.count - 1, section: 0)) {
            drawSafeArea(cell: lastCell)
        }
    }
    
    fileprivate func drawSafeArea(cell: UICollectionViewCell) {
        cell.clipsToBounds = false
        cell.layer.sublayers?.forEach{if $0.name == "shapeLayer"{
                $0.removeFromSuperlayer()
            }
        }
        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "shapeLayer"
        shapeLayer.frame = CGRect(x: 0, y: cell.bounds.height, width: collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right), height: safeAreaInsets.bottom + 20)
        shapeLayer.backgroundColor = ActionSetting.share.backgroundColor.cgColor
        cell.layer.addSublayer(shapeLayer)
    }
    
    fileprivate var initialContentInset: UIEdgeInsets!
    
    fileprivate func setUpContentInsetForHeight(_ height: CGFloat) {
        if initialContentInset == nil {
            initialContentInset = collectionView.contentInset
        }
        var leftInset = initialContentInset.left
        var rightInset = initialContentInset.right
        var bottomInset = initialContentInset.bottom
        var topInset = height - contentHeight - safeAreaInsets.bottom
        
        topInset = max(topInset, 30)
        
        bottomInset += safeAreaInsets.bottom
        leftInset += safeAreaInsets.left
        rightInset += safeAreaInsets.right
        topInset += safeAreaInsets.top
        
        collectionView.contentInset = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        collectionView.contentOffset.y = -height + contentHeight + safeAreaInsets.bottom
        
        collectionView.isScrollEnabled = contentHeight + safeAreaInsets.bottom + safeAreaInsets.top > mainHeight
    }
}
