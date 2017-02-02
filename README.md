![VKPopupView banner](Assets/banner.png?raw=true)
## Description
**VKPopupView** is lightweight and easy to use blurred popup view written in Swift. You will find it very similar to your iOS folders at Springboard (Home screen).

## Installation
You can install **VKPopupView** manually only. Just add content of the `VKPopupView` folder into your project.

## Example project and Live Demo
**Example project** shows how to you use **VKPopupView** in a different ways.
To test it it, clone the repo and run it from the `VKPopupViewExample` directory. 

**Live demo** is available at [appetize.io](https://appetize.io/app/kybzph99cmrnwkk8k5q2c0cy3m)

## Usage
When I'm saying it is easy to use - it is always true. Please take a look on it:
```swift
//// Step 1: Prepare all the staff
// 1.a Init popup
let popup = VKPopupView()

// 1.b Prepare your content
let contentView = UIView(...)

// 1.c Specify initial frame. `VKPopupView` will start appearance from this frame
let rect = CGRect(...)

//// Step 2: Just show it
popup.show(contentView: contentView, withTitle: "My cool title", fromRect: rect)
//// Profit!
```
You can easily set blur styles for your **VKPopupView**. Just these two properties in order to get what you need:

```swift
var backgroundBlurStyle: UIBlurEffectStyle  = .light
var contentViewBlurStyle: UIBlurEffectStyle = .extraLight
```

## VKPopupViewDelegate
You can handle all stages of **VKPopupView** appearance with **VKPopupViewDelegate**. It provides next functions:
```swift
@objc optional func popupViewWillShow(_ popupView: VKPopupView)
@objc optional func popupViewDidShow(_ popupView: VKPopupView)
@objc optional func popupViewWillHide(_ popupView: VKPopupView)
@objc optional func popupViewDidHide(_ popupView: VKPopupView)
```

## TODO
* Customization of the title label
* Add full-size support for iPad

## Author
Vladislav Kovalyov, http://woopss.com/

## License
**VKPopupView** is available under the MIT License. See the LICENSE file for more info.
