//
//  AlertSheetViewController.swift
//  BaHaActionSheet
//
//  Created by Wayne on 2018/9/13.
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

class AlertSheetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "AlertSheet"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(rightButtonClick))
    }
    
    @objc func rightButtonClick(_ sender: UIBarButtonItem) {
        let actionController = BahaActionSheet.bulider()
        actionController.addAction(Action(ActionData(title: "Add to Watch Later"), handler: { action in
        }))
        actionController.addAction(Action(ActionData(title: "Add to Playlist..."), handler: { action in
        }))
        actionController.addAction(Action(ActionData(title: "Share..."), handler: { action in
        }))
        actionController.addAction(Action(ActionData(title: "Cancel"), handler: nil))
        
        present(actionController, animated: true, completion: nil)
    }
    
    @IBAction func showActionSheet(_ sender: Any) {
        let actionController = BahaActionSheet.bulider()
        actionController.addAction(Action(ActionData(title: "Add to Watch Later", image: UIImage(named: "yt-add-to-watch-later-icon")!), handler: { action in
        }))
        actionController.addAction(Action(ActionData(title: "Add to Playlist...", image: UIImage(named: "yt-add-to-playlist-icon")!), handler: { action in
        }))
        actionController.addAction(Action(ActionData(title: "Share...", image: UIImage(named: "yt-share-icon")!), handler: { action in
        }))
        actionController.addAction(Action(ActionData(title: "Cancel", image: UIImage(named: "yt-cancel-icon")!), handler: nil))
        
        present(actionController, animated: true, completion: nil)
    }

}
