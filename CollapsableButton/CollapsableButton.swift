//
//  CollapsableButton.swift
//  CollapsableButton
//
//  Created by Benjamin Lefebvre on 9/25/15.
//

import Foundation
import UIKit

public enum CollapsableButtonState
{
    case Normal
    case Collapsed
}

/**
CollapsableButton

A button that can collapse to a circular shape and come back to its original shape
*/
public class CollapsableButton: UIButton
{
    //MARK: - IBInspectable Variables
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var animDuration: Double = 0.5
    @IBInspectable var collapsedTitle: String? = nil
    @IBInspectable var collapsedImage: UIImage? = nil
    @IBInspectable var collapsedBackgrounColor: UIColor? = nil
    // Value for the Aspect Ratio constraint when the Button is collapsed (in circle form)
    @IBInspectable var highConstraintPriority:Float = 800
    // Value for the Aspect Ratio constraint when the Button is expanded (in rectangular form)
    @IBInspectable var lowConstraintPriority:Float = 200
    

    //MARK: - Private Variables
    
    private var normalTitle:String? = nil
    private var normalImage:UIImage? = nil
    private var normalBackgroundColor:UIColor? = nil
    
    private var buttonState = CollapsableButtonState.Normal
    private var ratioConstraint:NSLayoutConstraint?
    
    
    //MARK: - Initializers
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.layer.masksToBounds = true
        self.createRatioContraint()
    }
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.masksToBounds = true
        self.createRatioContraint()
    }
}

//MARK:- Public Methods
extension CollapsableButton {
    
    public func switchState(title:String? = nil, icon: UIImage? = nil, userInteractionEnabled: Bool = true) {
        if self.normalTitle == nil && buttonState == .Normal {
            self.normalTitle = self.titleForState(.Normal)
        }
        
        if self.normalImage == nil && buttonState == .Normal {
            self.normalImage = self.imageForState(.Normal)
        }
        
        if self.normalBackgroundColor == nil && buttonState == .Normal {
            self.normalBackgroundColor = self.backgroundColor
        }
        
        animate {
            switch self.buttonState {
            case .Normal:
                self.buttonState = .Collapsed
                self.setTitle(title ?? self.collapsedTitle, forState: .Normal)
                self.setImage(icon ?? self.collapsedImage, forState: .Normal)
            case .Collapsed:
                self.buttonState = .Normal
                self.setTitle(title ?? self.normalTitle, forState: .Normal)
                self.setImage(icon ?? self.normalImage, forState: .Normal)
            }
        }
        self.userInteractionEnabled = userInteractionEnabled
    }
}


//MARK:- Animation
extension CollapsableButton
{
    private func createRatioContraint()
    {
        ratioConstraint = NSLayoutConstraint(item: self,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Height,
            multiplier: 1, constant: 0)
        ratioConstraint?.priority = lowConstraintPriority
        self.addConstraint(ratioConstraint!)
    }
    
    private func animate(completion: (Void -> Void)?) {
        
        // animate ratio constraint priority
        
        UIView.animateWithDuration(self.animDuration, animations: { () -> Void in
            switch self.buttonState {
            case .Normal:
                self.ratioConstraint?.priority = self.highConstraintPriority
                self.layer.backgroundColor = (self.collapsedBackgrounColor ?? self.normalBackgroundColor)?.CGColor
            case .Collapsed:
                self.ratioConstraint?.priority = self.lowConstraintPriority
                self.layer.backgroundColor = self.normalBackgroundColor?.CGColor
            }
            self.layoutIfNeeded()
            }, completion: { completed in
                completion?()
        })
        
        
        // animate cornerRadius
        
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.fromValue = self.layer.cornerRadius
        
        switch self.buttonState {
        case .Normal:
            self.layer.cornerRadius = min(self.frame.height, self.frame.width) / 2
        case .Collapsed:
            self.layer.cornerRadius = self.cornerRadius
        }
        
        animation.toValue = self.layer.cornerRadius
        animation.duration = animDuration
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.layer.addAnimation(animation, forKey: "cornerRadius")
        CATransaction.commit()
    }
}
