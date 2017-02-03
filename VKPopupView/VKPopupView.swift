//
//  VKPopupView.swift
//  VKPopupViewExample
//
//  Created by Vladislav Kovalyov on 3/1/17.
//  Copyright © 2017 WOOPSS.com http://woopss.com/ All rights reserved.
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
//

import UIKit

/// Simple popup view class.
/// It looks like folders on your Springboard *(iOS Home screen)*
open class VKPopupView: NSObject
{
    // MARK: Public properties
    
    /// Title of the `VKPopupView`. Appears above the contentView
    open var title: String?
    
    /// Content you want to display inside popup
    /// - Important: Max size of the contentView is `300x300`.
    /// - requires: `VKPopupView` will reset backgroundColor to `UIColor.clear`. It is done in order to match Apple's style
    open var contentView: UIView?
        {
        didSet
        {
            if let oldContent = oldValue
            {
                oldContent.removeFromSuperview()
            }
            
            if contentView != nil
            {
                self.adoptContentView()
            }
        }
    }
    
    /// Set background blur style
    /// - Note: Default is `UIBlurEffectStyle.light`
    open var backgroundBlurStyle: UIBlurEffectStyle  = .light
        {
        didSet
        {
            self.viewOverlay.effect = UIBlurEffect(style: backgroundBlurStyle)
        }
    }
    
    /// Set popup blur style
    /// - Note: Default is `UIBlurEffectStyle.extraLight`
    open var contentViewBlurStyle: UIBlurEffectStyle = .extraLight
        {
        didSet
        {
            self.containerView.effect = UIBlurEffect(style: contentViewBlurStyle)
        }
    }
    
    
    /// Delegate of the VKPopupView
    open var delegate: VKPopupViewDelegate?
    
    /// Set the animation duration for show and hide
    /// - Note: Default is `0.4` seconds
    open var animationSpeed: TimeInterval = 0.4
    
    /// Constant of the content frame
    /// - Attention: Please use it as constant for all your content views
    open static let contentFrame = CGRect(x: 0, y: 0, width: 300, height: 300)
    
    // MARK: Private properties
    // Views
    
    /// Background overlay view
    fileprivate var viewOverlay     = UIVisualEffectView()
    
    /// Container of the content view
    fileprivate var containerView   = UIVisualEffectView()
    
    /// Title label
    /// - Note: It will not show up in `title` is `nil`
    fileprivate var labelTitle      = UILabel()
    
    // Sizes
    /// Initial frame from where `VKPopupView` will fade in and fade out
    fileprivate var initialFrame: CGRect!
    
    /// Default frame which is used when `initialFrame` is `nil`
    fileprivate var zeroFrame = CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 0, height: 0)
    
    /// Frame used when `VKPopupView` is shown
    fileprivate lazy var finalFrame: CGRect =
        {
            var size: CGFloat = 300
            let x: CGFloat = self.viewOverlay.bounds.midX - size / 2
            let y: CGFloat = self.viewOverlay.bounds.midY - size / 2
            
            return CGRect(x: x, y: y, width: size, height: size)
    }()
    
    // MARK: Init
    
    /// Init VKPopupView and set 'backgrundStyle' and 'contentViewStyle' properties
    ///
    /// - Parameters:
    ///   - backgroundStyle: Set 'backgroundStyle' value
    ///   - contentViewStyle: Set 'contentViewStyle' value
    ///
    /// Example:
    ///
    ///     let popup = VKPopup(backgroundStyle: .dark, contentViewStyle: .light)
    /// ___
    public convenience init(backgroundStyle: UIBlurEffectStyle = .light, contentViewStyle: UIBlurEffectStyle = .extraLight)
    {
        self.init()
        self.backgroundBlurStyle  = backgroundStyle
        self.contentViewBlurStyle = contentViewStyle
    }
}

// MARK: - Public
extension VKPopupView
{
    /// Set popup's content, title and show it from the specific frame
    ///
    /// - Parameters:
    ///   - contentView: `UIView` object which must be shown. See `conntentView` for more info
    ///   - title: Title of the popup
    ///   - rect: Initial frame
    /// - Note: Popup will be shown from the center of the screen
    /// if `rect` is `nil`. See `zeroFrame` value.
    open func show(contentView: UIView? = nil, withTitle title: String? = nil, fromRect rect: CGRect? = nil)
    {
        self.delegate?.popupViewWillShow(self)
        
        self.setupViews()
        
        self.initialFrame        = rect != nil ? rect : self.zeroFrame
        self.contentView         = contentView
        self.containerView.frame = self.initialFrame
        
        self.title              = title
        self.labelTitle.text    = self.title
        
        self.containerView.alpha = 1
        VKPopupView.animate(duration: self.animationSpeed, animations:
            {
                self.viewOverlay.alpha   = 1
                self.containerView.frame = self.finalFrame
        })
        {
            if self.title != nil
            {
                UIView.animate(withDuration: 0.2, animations:
                    {
                        self.labelTitle.alpha = 1
                })
            }
            
            self.delegate?.popupViewDidShow(self)
        }
    }
    
    /// Dismiss popup view
    open func dismiss()
    {
        self.delegate?.popupViewWillHide(self)
        
        VKPopupView.animate(duration: self.animationSpeed, animations:
            {
                self.viewOverlay.alpha   = 0
                self.labelTitle.alpha    = 0
                self.containerView.alpha = 0
                self.containerView.frame = self.initialFrame
        })
        {
            self.containerView.removeFromSuperview()
            self.viewOverlay.removeFromSuperview()
            self.labelTitle.removeFromSuperview()
            
            self.delegate?.popupViewDidHide(self)
        }
    }
}

// MARK: - Private
extension VKPopupView
{
    // MARK: GUI
    /// Adopt `contentView` in order to fit `containerView` and match Apple's style
    fileprivate func adoptContentView()
    {
        self.contentView?.frame = self.containerView.bounds
        self.contentView?.center = CGPoint(x: self.containerView.bounds.size.width / 2, y: self.containerView.bounds.size.height / 2)
        self.contentView?.backgroundColor = .clear
        self.contentView?.translatesAutoresizingMaskIntoConstraints = false
        self.contentView?.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        self.containerView.addSubview(contentView!)
    }
    
    /// Setup all views of the `VKPopupView`:
    /// + `viewOverlay`
    /// + `containerView`
    /// + 'labelTitle'
    ///
    /// Also here is added `UITapGestureRecognizer` for `viewOverlay`
    fileprivate func setupViews()
    {
        // Overlay
        self.viewOverlay.effect     = UIBlurEffect(style: self.backgroundBlurStyle)
        self.viewOverlay.frame      = UIScreen.main.bounds
        self.viewOverlay.alpha      = 0
        self.viewOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        UIApplication.shared.vkpv_mostTopViewController()?.view.addSubview(self.viewOverlay)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(VKPopupView.onBackgroundTap(_:)))
        self.viewOverlay.addGestureRecognizer(tapGesture)
        
        // Container
        self.containerView.effect = UIBlurEffect(style: self.contentViewBlurStyle)
        self.containerView.frame  = self.finalFrame
        self.containerView.alpha = 0
        self.containerView.layer.cornerRadius  = self.containerView.bounds.size.height * 0.1
        self.containerView.layer.masksToBounds = true
        self.viewOverlay.addSubview(self.containerView)
        
        // Title
        let height: CGFloat = 60
        let contentPadding: CGFloat = 12
        
        self.labelTitle.alpha           = 0
        self.labelTitle.textColor       = .white
        self.labelTitle.textAlignment   = .center
        self.labelTitle.font            = .systemFont(ofSize: 27)
        self.labelTitle.frame           = CGRect(x: contentPadding, y: self.finalFrame.minY - height - contentPadding, width: self.viewOverlay.bounds.size.width - contentPadding * 2, height: height)
        self.viewOverlay.addSubview(self.labelTitle)
        
        if self.contentView != nil
        {
            self.adoptContentView()
        }
    }
    
    // MARK: Gesture recognition
    
    /// Handle tap on `viewOverlay`
    ///
    /// - Parameter gesture: Recognized tap gesture
    @objc private func onBackgroundTap(_ gesture: UITapGestureRecognizer)
    {
        if gesture.state == .ended
        {
            self.dismiss()
        }
    }
    
    // MARK: Animation
    
    /// Simple helper which is used for show/hide animation
    /// - Parameters:
    ///     - duration: Animation duration
    ///     - animations: Animations block
    ///     - completion: Completion block. Called when all animations are finished
    fileprivate static func animate(duration: TimeInterval, animations: (() -> Void)!, withComplection completion: (() -> Void)! = {})
    {
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.8, options: [.curveEaseInOut], animations:
            {
                animations()
        },
                       completion:
            {
                finished in
                completion()
        })
    }
}

/// Protocol which will help you to catch show/hide progress of the `VKPopupView`
public protocol VKPopupViewDelegate
{
    /// Called when `VKPopupView` is preparing to show
    ///
    /// - Parameter popupView: `VKPopupView` owner
    func popupViewWillShow(_ popupView: VKPopupView)
    
    /// Called when `VKPopupView` is shown and completed all animations
    ///
    /// - Parameter popupView: `VKPopupView` owner
    func popupViewDidShow(_ popupView: VKPopupView)
    
    /// Called when `VKPopupView` is processing to hide
    ///
    /// - Parameter popupView: `VKPopupView` owner
    func popupViewWillHide(_ popupView: VKPopupView)
    
    /// Called when `VKPopupView` become hidden and completed all animations
    ///
    /// - Parameter popupView: `VKPopupView` owner
    func popupViewDidHide(_ popupView: VKPopupView)
}
