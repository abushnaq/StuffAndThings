//
//  MoveableUIImageView.h
//  StuffAndThings
//
//  Created by Ahmad Bushnaq on 9/19/15.
//  Copyright © 2015 Ahmad Bushnaq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MoveableUIImageView;

@protocol MoveableUIImageViewDelegate

- (void) moveBlockToNearestEmptySpace:(MoveableUIImageView*)block;

@end


@interface MoveableUIImageView : UIImageView


@property (nonatomic, assign) id<MoveableUIImageViewDelegate> delegate;
@property (nonatomic, assign) CGRect originalFrame;
@property (nonatomic, getter=isPirate) BOOL pirate;
@end
