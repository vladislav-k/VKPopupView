//
//  DateView.swift
//  VKPopupViewExample
//
//  Created by Vladislav Kovalyov on 2/2/17.
//  Copyright © 2017 WOOPSS.com. All rights reserved.
//

import UIKit

class DateView: UIView
{
    var view: UIView!
    var viewDate: UIView!
    var labelMonth: UILabel!
    var labelDate: UILabel!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.setupView()
    }
}

// MARK: - Setup
extension DateView
{
    fileprivate func setupView()
    {
        self.xibSetup()
        
        self.viewDate   = view.viewWithTag(100)
        self.labelMonth = view.viewWithTag(101) as! UILabel
        self.labelDate  = view.viewWithTag(102) as! UILabel
        
        self.viewDate.layer.shadowColor     = UIColor.black.cgColor
        self.viewDate.layer.shadowOpacity   = 0.7
        self.viewDate.layer.shadowOffset    = CGSize(width: 1, height: 1)
        
        self.updateDate()
    }
    
    private func loadViewFromNib() -> UIView
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "DateView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    private func xibSetup()
    {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    func updateDate()
    {
        let today = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMMM"
        self.labelMonth.text = dateFormatter.string(from: today)
        
        dateFormatter.dateFormat = "dd"
        self.labelDate.text  = dateFormatter.string(from: today)
    }
}
