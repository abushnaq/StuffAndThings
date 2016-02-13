//
//  MoveableUIImageView.swift
//  StuffAndThings
//
//  Created by Ahmad Bushnaq on 2/13/16.
//  Copyright © 2016 Ahmad Bushnaq. All rights reserved.
//

import UIKit

@objc protocol MoveableUIImageViewDelegate
{
    //- (void) moveBlockToNearestEmptySpace:(MoveableUIImageView*)block;
    func moveBlockToNearestEmptySpace(block: MoveableUIImageView);
}


class MoveableUIImageView: UIImageView
{

    
    
    var originalFrame : CGRect
    var pirate : Bool
    var delegate : MoveableUIImageViewDelegate?
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect)
    {
        self.originalFrame = frame
        self.pirate = false
//        self.delegate = NilLiteralConvertible
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        NSNotificationCenter.defaultCenter().postNotificationName(kIncrementMovesNotification, object: nil);
        self.delegate?.moveBlockToNearestEmptySpace(self)
//        [[NSNotificationCenter defaultCenter] postNotificationName:kIncrementMovesNotification object:nil];
//        [self.delegate moveBlockToNearestEmptySpace:self];
    }
}
