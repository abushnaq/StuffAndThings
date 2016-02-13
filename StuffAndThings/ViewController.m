//
//  ViewController.m
//  StuffAndThings
//
//  Created by Ahmad Bushnaq on 9/19/15.
//  Copyright © 2015 Ahmad Bushnaq. All rights reserved.
//

#import "ViewController.h"
#import "MoveableUIImageView.h"
#import "ScoreBar.h"
#import "SuccessSplash.h"
//#import "PhotoProvider.h"
#import "StuffAndThings-Swift.h"


@interface ViewController ()
@property (strong, nonatomic) IBOutlet MoveableUIImageView *imageView;
@property (strong, nonatomic) NSMutableArray *imageViews;

@property (strong, nonatomic) ScoreBar *scoreBar;


@property (strong, nonatomic) NSMutableArray *board;
@property (strong, nonatomic) PhotoProvider *photoProvider;


@end

static NSInteger puzzleSize = 2;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photoProvider = [[PhotoProvider alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.board = [NSMutableArray arrayWithCapacity:puzzleSize];
    for ( int i = 0; i < puzzleSize; i++ )
    {
        [self.board addObject:[NSMutableArray array]];
    }
    
    self.scoreBar = [[[NSBundle mainBundle] loadNibNamed:@"ScoreBar" owner:self options:nil] firstObject];//[[UINib nibWithNibName:@"ScoreBar" bundle:[NSBundle mainBundle]] ;
    
    self.scoreBar.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    [self.view addSubview:self.scoreBar];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scoreBar attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0f]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scoreBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.05 constant:0.0f]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scoreBar attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0f]];

    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scoreBar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0f]];

    
    [self setupPuzzleWithImage:self.imageView.image];
    
}

- (void) setupPuzzleWithImage:(UIImage*)image
{
    self.imageViews = [self getSplitImagesFromImage:image withRow:puzzleSize withColumn:puzzleSize];
    
    for (NSUInteger i = self.imageViews.count - 1; i > 0; i--)
    {
        MoveableUIImageView *firstOne = self.imageViews[i];
        
        int nextIndex = arc4random_uniform((u_int32_t)i + 1);
        MoveableUIImageView *secondOne = self.imageViews[nextIndex];
        
        CGRect firstFrame = firstOne.frame;
        CGRect secondFrame = secondOne.frame;
        
        secondOne.frame = firstFrame;
        firstOne.frame = secondFrame;
        [self.imageViews exchangeObjectAtIndex:i withObjectAtIndex:nextIndex];
    }
    
    for ( int i = 0; i<self.imageViews.count; i++ )
    {
        NSMutableArray *row = self.board[i % puzzleSize];
        
        [row addObject:self.imageViews[i]];
        
        [self.view addSubview:self.imageViews[i]];
    }
    
    [self.scoreBar.superview bringSubviewToFront:self.scoreBar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) moveBlockToNearestEmptySpace:(MoveableUIImageView*)block//:(NSArray*)blockID
{
    
    for ( int rowID = 0; rowID < self.board.count; rowID++ )//NSMutableArray *row in self.board )
    {
        NSMutableArray *row = self.board[rowID];
        for ( int columnID = 0; columnID < row.count; columnID++ )
        {
            if ( [row[columnID] isEqual:block] )
            {
                MoveableUIImageView *rightBlock = nil;
                MoveableUIImageView *leftBlock = nil;
                MoveableUIImageView *topBlock = nil;
                MoveableUIImageView *bottomBlock = nil;
                
                if ( columnID < row.count - 1 )
                {
                    rightBlock = row[columnID+1];
                }
                
                if ( columnID > 0 )
                {
                    leftBlock = row[columnID-1];
                }
                
                if ( rowID > 0 )
                {
                    topBlock = self.board[rowID-1][columnID];
                }
                
                if ( rowID < self.board.count - 1 )
                {
                    bottomBlock = self.board[rowID+1][columnID];
                }
                
                if ( topBlock.pirate )
                {
                    [self swapBlockAtRow:rowID andColumn:columnID withBlockAtRow:rowID-1 andColumn:columnID];
                }
                else if ( bottomBlock.pirate )
                {
                    [self swapBlockAtRow:rowID andColumn:columnID withBlockAtRow:rowID+1 andColumn:columnID];
                }
                else if ( rightBlock.pirate )
                {
                    [self swapBlockAtRow:rowID andColumn:columnID withBlockAtRow:rowID andColumn:columnID+1];
                }
                else if ( leftBlock.pirate )
                {
                    [self swapBlockAtRow:rowID andColumn:columnID withBlockAtRow:rowID andColumn:columnID-1];
                }
                else
                {
                    [block.layer addAnimation:[self getShakeAnimation] forKey:@"wiggle"];
                }

            }
        }
    }
}


- (void) checkForPuzzleFinish
{
    // TODO: KVO ? Track state so that we don't have to do all of it every time?
    if ( NO )
    {
    for ( int rowID = 0; rowID < self.board.count; rowID++ )//NSMutableArray *row in self.board )
    {
        NSMutableArray *row = self.board[rowID];
        for ( int columnID = 0; columnID < row.count; columnID++ )
        {
            MoveableUIImageView *imageView = row[columnID];
            if ( !CGRectEqualToRect(imageView.frame, imageView.originalFrame))
            {
                return;
            }
                
        }
    }
    }
    NSLog(@"************************ success!");
    
    for ( int rowID = 0; rowID < self.board.count; rowID++ )//NSMutableArray *row in self.board )
    {
        NSMutableArray *row = self.board[rowID];
        for ( int columnID = 0; columnID < row.count; columnID++ )
        {
            MoveableUIImageView *imageView = row[columnID];
            [imageView.layer addAnimation:[self getShakeAnimation] forKey:@"shakeme"];
            [UIView animateWithDuration:1.0f animations:^{
                imageView.center = CGPointMake(self.view.center.x, self.view.frame.size.height + imageView.frame.size.height);
                     } completion:^(BOOL finished) {
                         if ( [self.board.lastObject isEqual:row] && [row.lastObject isEqual:imageView] )
                         {
                             // TODO: make me more efficient by just checking IDs
                             [self showSplash];
                         }
                     }];
        }
    }
    
    
}

- (void) showSplash
{
    __block SuccessSplash *splash = [[[NSBundle mainBundle] loadNibNamed:@"SuccessSplash" owner:self options:nil] firstObject];
    
    splash.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    splash.center = self.view.center;
    [self.view addSubview:splash];
    
    [UIView animateWithDuration:1.5f animations:^{
        splash.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        for ( MoveableUIImageView *imageView in self.imageViews )
        {
            [imageView removeFromSuperview];
        }
        
        [self.scoreBar saveScoreAndReset];
        
        [self setupPuzzleWithImage:[self.photoProvider nextImage]];

        [splash removeFromSuperview];
    }];
    
}




- (void)swapBlockAtRow:(int)rowID andColumn:(int)columnID withBlockAtRow:(int)otherRowID andColumn:(int)otherColumnID
{
    __block MoveableUIImageView *firstBlock = self.board[rowID][columnID];
    __block MoveableUIImageView *secondBlock = self.board[otherRowID][otherColumnID];
    
    [UIView animateWithDuration:0.4f animations:^{
        CGRect firstBlockFrame = firstBlock.frame;
        firstBlock.frame = secondBlock.frame;
        secondBlock.frame = firstBlockFrame;
        
    } completion:^(BOOL finished) {
        self.board[rowID][columnID] = secondBlock;
        self.board[otherRowID][otherColumnID] = firstBlock;
        
        [self checkForPuzzleFinish];
    }];
    
    
    
    
}

- (NSDictionary <NSValue*,MoveableUIImageView*>*) findEmptyBlock:(NSInteger)tappedBlockID
{
    // TODO: correct size.
    
    // look up, down, left, and right.(check buffer)
    
    MoveableUIImageView *tappedBlock = self.imageViews[tappedBlockID];
    
    
    MoveableUIImageView *leftBlock = nil;
    if ( tappedBlockID > 0 )
    {
        leftBlock = self.imageViews[tappedBlockID - 1];
    }

    MoveableUIImageView *rightBlock = nil;

    if ( tappedBlockID < self.imageViews.count - 1 )
    {
        rightBlock = self.imageViews[tappedBlockID + 1];
    }
    
    if ( leftBlock )
    {
//        if ( ![leftBlock.blockID[0] isEqualToValue:tappedBlock.blockID[0]] )
//        {
//            leftBlock = nil;
//        }
    }
    
    if ( rightBlock )
    {
//        if ( ![rightBlock.blockID[0] isEqualToValue:tappedBlock.blockID[0]] )
//        {
//            rightBlock = nil;
//        }
    }
    
    int upperBlockID = tappedBlockID - puzzleSize; // TODO: this should be number of rows
    int lowerBlockID = tappedBlockID + puzzleSize;
    
    MoveableUIImageView *upperBlock = nil;
    if ( upperBlockID >= 0 )
    {
        upperBlock = self.imageViews[upperBlockID];
    }
    
    MoveableUIImageView *lowerBlock = nil;
    
    if ( lowerBlockID < self.imageViews.count )
    {
        lowerBlock = self.imageViews[lowerBlockID];
    }
    
//    if ( upperBlock && upperBlock.blockID.count == 3 )
//    {
//        return @{@(upperBlockID):upperBlock};
//    }
//
//    if ( lowerBlock && lowerBlock.blockID.count == 3 )
//    {
//        return @{@(lowerBlockID):lowerBlock};
//    }
//    
//    // TODO: IDs.
//    if ( rightBlock && rightBlock.blockID.count == 3 )
//    {
//        return @{@(tappedBlockID + 1):rightBlock};
//    }
//    if ( leftBlock && leftBlock.blockID.count == 3 )
//    {
//        return @{@(tappedBlockID - 1):leftBlock};
//    }
    
//    int upperblockID = [[self.imageViews[tappedBlockID] blockID][0] integerValue] + ([[self.imageViews[tappedBlockID] blockID][1] integerValue] -1 ) * (2 - 1);//8;
//    
//    
//    int lowerBlockID = [[self.imageViews[tappedBlockID] blockID][0] integerValue] + ([[self.imageViews[tappedBlockID] blockID][1] integerValue] + 1) * (2 - 1);//8;
//    
//    
//    
//    int leftBlock = ([[self.imageViews[tappedBlockID] blockID][0] integerValue] - 1) + ([[self.imageViews[tappedBlockID] blockID][1] integerValue]) * (2 - 1);//8;
//
//    int rightBlock = ([[self.imageViews[tappedBlockID] blockID][0] integerValue] + 1) + ([[self.imageViews[tappedBlockID] blockID][1] integerValue]) * (2 - 1);//8;
//    NSLog(@"here");
//    MoveableUIImageView *potentialEmptyBlock = nil;
//    BOOL foundEmptyBlock = NO;
//    if ( upperblockID > -1 )
//    {
//        potentialEmptyBlock = self.imageViews[upperblockID];
//        if ( potentialEmptyBlock.blockID.count == 3 )
//        {
//            return @{@(upperblockID): potentialEmptyBlock};
////            foundEmptyBlock = YES;
//        }
//    }
//    
//    if ( !foundEmptyBlock && lowerBlockID < self.imageViews.count )
//    {
//        potentialEmptyBlock = self.imageViews[lowerBlockID];
//        if ( potentialEmptyBlock.blockID.count == 3 )
//        {
//            return @{@(lowerBlockID) : potentialEmptyBlock};
//        }
//    }
//        NSLog(@"there");
//    int tappedBlockMod = tappedBlockID % 2;//8;
//    int leftBlockMod = leftBlock % 2;//8;
//    int rightBlockMod = rightBlock % 2;//8;
//    
//    if ( !foundEmptyBlock && leftBlockMod < tappedBlockMod )
//    {
//        potentialEmptyBlock = self.imageViews[leftBlock];
//        if ( potentialEmptyBlock.blockID.count == 3 )
//        {
//            return @{@(leftBlock) : potentialEmptyBlock};
//        }
//    }
//        NSLog(@"everywhere");
//    if ( !foundEmptyBlock && rightBlockMod > tappedBlockMod )
//    {
//        potentialEmptyBlock = self.imageViews[rightBlock];
//        if ( potentialEmptyBlock.blockID.count == 3 )
//        {
//            return @{@(rightBlock) : potentialEmptyBlock};
//        }
//    }
//        NSLog(@"nowhere");
    
    return nil;
}

- (CAAnimation*)getShakeAnimation
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    CGFloat wobbleAngle = 0.06f;
    
    NSValue* valLeft = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(wobbleAngle, 0.0f, 0.0f, 1.0f)];
    NSValue* valRight = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-wobbleAngle, 0.0f, 0.0f, 1.0f)];
    animation.values = [NSArray arrayWithObjects:valLeft, valRight, nil];
    
    animation.autoreverses = YES;
    animation.duration = 0.15;
    animation.repeatCount = 2;
    
    return animation;
}


-(NSMutableArray *)getSplitImagesFromImage:(UIImage *)image withRow:(NSInteger)rows withColumn:(NSInteger)columns
{
    NSMutableArray *aMutArrImages = [NSMutableArray array];
    CGSize imageSize = image.size;
    CGFloat xPos = 0.0, yPos = 0.0;
    CGFloat width = imageSize.width/rows;
    CGFloat height = imageSize.height/columns;

    int pirateX = arc4random_uniform(rows);
    int pirateY = arc4random_uniform(columns);
    
    for (int aIntX = 0; aIntX < columns; aIntX++)
    {
        yPos = 0.0;
        for (int aIntY = 0; aIntY < rows; aIntY++)
        {
            CGRect rect = CGRectMake(xPos, yPos, width, height);
            CGImageRef cImage = CGImageCreateWithImageInRect([image CGImage],  rect);
            if ( aIntX == pirateX && aIntY == pirateY )
            {
                UIImage *pirate = [UIImage imageNamed:@"pirate"];

                MoveableUIImageView *aImgView = [[MoveableUIImageView alloc] initWithFrame:CGRectMake(aIntX*width, aIntY*height, width, height)];
                aImgView.delegate = self;
                aImgView.pirate = YES;
//                aImgView.blockID = @[@(aIntX), @(aIntY)];
                [aImgView setImage:pirate];
                [aImgView.layer setBorderColor:[[UIColor blackColor] CGColor]];
                [aImgView.layer setBorderWidth:1.0];
                aImgView.userInteractionEnabled = YES;
                aImgView.originalFrame = aImgView.frame;
//                [self.view addSubview:aImgView];
            [aMutArrImages addObject:aImgView];
            }
            else
            {
                UIImage *aImgRef = [[UIImage alloc] initWithCGImage:cImage];
                MoveableUIImageView *aImgView = [[MoveableUIImageView alloc] initWithFrame:CGRectMake(aIntX*width, aIntY*height, width, height)];
                
                aImgView.originalFrame = aImgView.frame;
                aImgView.delegate = self;
//                aImgView.blockID = @[@(aIntX), @(aIntY)];
                [aImgView setImage:aImgRef];
                [aImgView.layer setBorderColor:[[UIColor blackColor] CGColor]];
                [aImgView.layer setBorderWidth:1.0];
                aImgView.userInteractionEnabled = YES;
//                [self.view addSubview:aImgView];
            [aMutArrImages addObject:aImgView];
            }
            
            

            yPos += height;
        }
        xPos += width;
    }
    return aMutArrImages;
}

@end
