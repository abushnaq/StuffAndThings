//
//  ScoreBar.m
//  StuffAndThings
//
//  Created by Ahmad Bushnaq on 11/8/15.
//  Copyright © 2015 Ahmad Bushnaq. All rights reserved.
//

#import "ScoreBar.h"
#import "Globals.h"

@interface ScoreBar ()


@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger time;


@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation ScoreBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    self.time = 0;
    self.score = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incrementScore:) name:kIncrementMovesNotification object:nil];
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.score];
    
    [self incrementTime];
    
}

- (void) incrementTime
{
    __weak ScoreBar *weakSelf = self;
    dispatch_block_t block = ^{
        self.time++;
        [self updateTimeLabel];
        NSInteger numberOfSeconds = self.time % 60;
        NSInteger numberOfMinutes = (self.time - numberOfSeconds) / 60;
        [UIView transitionWithView:self.timeLabel duration:0.1f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            if ( self.time > 60 )
            {
                NSLog(@"min: %ld, sec: %ld", numberOfMinutes, numberOfSeconds);
                self.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)numberOfMinutes, (long)numberOfSeconds];
            }
            else
            {
                self.timeLabel.text = [NSString stringWithFormat:@"0:%02ld", (long)weakSelf.time];
            }
        } completion:^(BOOL finished)
         {
             [weakSelf incrementTime];
         }];
    };
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(1 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), block
                   );
}


- (void)incrementScore:(NSNotification*)notification
{
    self.score++;

    [self updateScoreLabel];

}


- (void)saveScoreAndReset
{
    // save the score
    
 
    self.score = 0;
    [self updateScoreLabel];
    self.time = 0;
    [self updateTimeLabel];
}

- (void)updateScoreLabel
{
    [UIView transitionWithView:self.scoreLabel duration:0.25f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
        self.scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.score];
    } completion:nil];
}

- (void)updateTimeLabel
{
    
}

@end
