//
//  MyChallengesViewController.m
//  StuffAndThings
//
//  Created by Ahmad Bushnaq on 1/3/16.
//  Copyright © 2016 Ahmad Bushnaq. All rights reserved.
//

#import "MyChallengesViewController.h"
//#import "ChallengeCell.h"
//#import "PhotoProvider.h"
#import "StuffAndThings-Swift.h"
//@import ChallengeCell;


@interface MyChallengesViewController ()
@property (nonatomic, strong) NSMutableArray<PhotoProvider*> *challenges;
@end

@implementation MyChallengesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.challenges = [[NSMutableArray alloc] initWithCapacity:4];
    
    // temp code
    PhotoProvider *provider = [[PhotoProvider alloc] init];
    provider.challengeID = 1;
    provider.currentPhotoSet = @[[UIImage imageNamed:@"IMG_0036"], [UIImage imageNamed:@"pirate"]];
    provider.totalPointBounty = 200;
    
    [self.challenges addObject:provider];
    // end temp code
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.challenges.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66.0f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChallengeCell *cell = nil;
    cell = (ChallengeCell*)[tableView dequeueReusableCellWithIdentifier:@"ChallengeCell"];
    PhotoProvider *challenge = self.challenges[indexPath.row];
    
    cell.currentPhoto = [[UIImageView alloc] initWithImage:challenge.currentPhotoSet[0]];
    cell.progressLabel.text = @"Progress:";
    cell.progressValue.text = @"2/5";
    cell.sender.text = @"Billy";
    
    return cell;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
