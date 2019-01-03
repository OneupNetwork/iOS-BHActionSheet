# iOS-BHActionSheet

## Demo
### Alert Sheet
<table>
 <tr>
  <td>
    <img src="Media/demo1.gif" width="300"/>
  </td>
  <td>
    <img src="Media/demo2.gif" width="300"/>
  </td>
 </tr>
</table>

### Popover
<table>
 <tr>
   <td>
    <img src="Media/demo3.gif" width="300"/>
   </td>
   <td>
    <img src="Media/demo4.gif" width="300"/>
   </td>
 </tr>
</table>

## Usage
Easy uses and similar UIAlertController

Basic usage

    let actionSheet = BahaActionSheet.bulider()
    actionSheet.addAction(Action(ActionData(title: "add to cart"), handler: { (action) in
            //Action is tapped
    }))
    present(actionSheet, animated: true, completion: nil)

Popover view

    BahaActionSheet.bulider(sourceView: button)
    
Also can use point

    BahaActionSheet.bulider(point: CGPoint(x: 30,y: 30))

## Installation
### CocoaPods
Check out [Get Started](http://cocoapods.org/) tab on [cocoapods.org](http://cocoapods.org/).
To use BaHaActionSheet in your project add the following 'Podfile' to your project

    pod 'BaHaActionSheet'
   
## Requirements
* Xcode 9
* Swift 4
* iOS 9.0+

## License
BaHaActionSheet is available under the MIT license. See the LICENSE file for more info.
