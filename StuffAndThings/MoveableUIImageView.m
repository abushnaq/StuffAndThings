//
//  MoveableUIImageView.m
//  StuffAndThings
//
//  Created by Ahmad Bushnaq on 9/19/15.
//  Copyright © 2015 Ahmad Bushnaq. All rights reserved.
//

#import "MoveableUIImageView.h"
#import "Globals.h"

@implementation MoveableUIImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kIncrementMovesNotification object:nil];
    [self.delegate moveBlockToNearestEmptySpace:self];
}

//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    [self.superview bringSubviewToFront:self];
//    self.center = [touch locationInView:self.superview];
//}

@end
