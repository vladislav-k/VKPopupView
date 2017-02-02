//
//  CollectionViewController.swift
//  VKPopupViewExample
//
//  Created by Vladislav Kovalyov on 2/2/17.
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

class CollectionViewController: UICollectionViewController
{
    let popup = VKPopupView(backgroundStyle: .light, contentViewStyle: .extraLight)
    
    // Custom content view
    let contentView = UIView(frame: VKPopupView.contentFrame)
    let viewIcon    = UIView()
    let labelItem   = UILabel()
    
    // Some data
    var allColors = [UIColor]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Generate data
        for _ in 0...15
        {
            self.allColors.append(UIColor.randomColor())
        }
        
        // Setup content view
        self.viewIcon.frame = CGRect(x: 30, y: 50, width: 80, height: 200)
        self.viewIcon.layer.cornerRadius  = viewIcon.frame.size.height * 0.1
        self.viewIcon.layer.masksToBounds = true
        self.contentView.addSubview(self.viewIcon)
        
        self.labelItem.frame = CGRect(x: 130, y: 50, width: 140, height: 200)
        self.labelItem.textColor     = .black
        self.labelItem.font          = .systemFont(ofSize: 24)
        self.labelItem.numberOfLines = 0
        self.contentView.addSubview(self.labelItem)
    }
}

// MARK: UICollectionViewDataSource
extension CollectionViewController
{
    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.allColors.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
    
        // Configure the cell
        cell.labelTitle.text = "Item #\(indexPath.item + 1)"
        cell.viewIcon.backgroundColor = self.allColors[indexPath.item]
    
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension CollectionViewController
{
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        // Prepare content view
        let color = self.allColors[indexPath.item]
        let title = "Item #\(indexPath.item + 1)"
        
        var red: CGFloat    = 0
        var green: CGFloat  = 0
        var blue: CGFloat   = 0
        var alpha: CGFloat  = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let message = "R: \(String(format: "%.4f", red))\nG: \(String(format: "%.4f", green))\nB: \(String(format: "%.4f", blue))\nA: \(alpha)"
        
        self.viewIcon.backgroundColor = color
        self.labelItem.text = message
        
        // Calculate initial frame
        let cell = collectionView.cellForItem(at: indexPath)!
        let rect = self.view.convert(cell.frame, to: self.view)
        
        // Show popup
        popup.show(contentView: contentView, withTitle: title, fromRect: rect)
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let insets: CGFloat = 8
        let screenWidth: CGFloat = UIScreen.main.bounds.size.width
        let countPerRow: CGFloat = 4
        
        let width = screenWidth / countPerRow - insets * countPerRow / 3
        return CGSize(width: width, height: width)
    }
}

extension UIColor
{
    class func randomColor() -> UIColor
    {
        let red   = CGFloat(Decimal.randomNumber())
        let blue  = CGFloat(Decimal.randomNumber())
        let green = CGFloat(Decimal.randomNumber())
        
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
}

extension Decimal
{
    static func randomNumber(_ range: Range<UInt32> = 0..<255) -> UInt32
    {   
        let min = range.lowerBound
        let max = range.upperBound
        return min + arc4random_uniform(max - min + 1)
    }
}
