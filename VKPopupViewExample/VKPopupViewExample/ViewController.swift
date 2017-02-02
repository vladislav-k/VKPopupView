//
//  ViewController.swift
//  VKPopupViewExample
//
//  Created by Vladislav Kovalyov on 2/1/17.
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

enum ButtonTag: Int
{
    case show
    case showWithTitle
}

class ViewController: UIViewController
{
    @IBOutlet weak var buttonShow: UIButton!
    @IBOutlet weak var buttonShowWithTitle: UIButton!
    @IBOutlet weak var buttonShowFromNib: UIButton!
    
    let popup = VKPopupView(backgroundStyle: .dark, contentViewStyle: .extraLight)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.setupButton(buttonShow)
        self.setupButton(buttonShowWithTitle)
        self.setupButton(buttonShowFromNib)
        
        self.buttonShow.tag = ButtonTag.show.rawValue
        self.buttonShowWithTitle.tag = ButtonTag.showWithTitle.rawValue
    }

    @IBAction func onButtonShow(_ sender: UIButton)
    {
        let luckyNumber = arc4random_uniform(100)
        
        let label           = UILabel(frame: VKPopupView.contentFrame)
        label.text          = "Your lucky number is\n\n\(luckyNumber)"
        label.font          = .systemFont(ofSize: 27)
        label.numberOfLines = 0
        label.textAlignment = .center
        
        if ButtonTag(rawValue: sender.tag)! == .showWithTitle
        {
            popup.show(contentView: label, withTitle: "Some title", fromRect: sender.frame)
        }
        else
        {
            popup.show(contentView: label, fromRect: sender.frame)
        }
    }
    
    @IBAction func onButtonShowFromNib(_ sender: UIButton)
    {
        let contentView = DateView()
        popup.show(contentView: contentView, withTitle: "From nib", fromRect: sender.frame)
    }
}

extension ViewController
{
    func setupButton(_ button: UIButton)
    {
        button.layer.cornerRadius  = button.frame.size.height * 0.5
        button.layer.masksToBounds = true
    }
}

