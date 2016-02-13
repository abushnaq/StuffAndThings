//
//  ChallengeCreationViewController.m
//  StuffAndThings
//
//  Created by Ahmad Bushnaq on 11/26/15.
//  Copyright © 2015 Ahmad Bushnaq. All rights reserved.
//

#import "ChallengeCreationViewController.h"
#import "PhotoCollectionViewCell.h"
#import "StuffAndThings-Swift.h"
#import "Globals.h"
#import "SSZipArchive.h"
#import <Photos/Photos.h>


#define awardPoints  @[@(100), @(200), @(400), @(500), @(1000)]

@interface ChallengeCreationViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate,
    UIPickerViewDataSource,
    UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *challengePhotosCollectionView;
@property (strong, nonatomic) NSMutableArray *challengePhotos;

@property (strong, nonatomic) IBOutlet UIButton *challengePointsButton;
@property (strong, nonatomic) IBOutlet UIPickerView *challengePointsPicker;
@property (nonatomic) NSInteger numberOfPoints;

@end

@implementation ChallengeCreationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UINib *nib = [UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:[NSBundle mainBundle]];
    [self.challengePhotosCollectionView registerNib:nib forCellWithReuseIdentifier:@"PhotoCell"];

    
    UINib *nib2 = [UINib nibWithNibName:@"AddAPhotoCell" bundle:[NSBundle mainBundle]];
    [self.challengePhotosCollectionView registerNib:nib2 forCellWithReuseIdentifier:@"AddAPhotoCell"];

    
    self.challengePhotos = [NSMutableArray new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.challengePhotos.count > 0 ? self.challengePhotos.count + 1 : 1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.challengePhotos.count == 0 || indexPath.row == self.challengePhotos.count )
    {
        AddAPhotoCell *addCell = [self.challengePhotosCollectionView dequeueReusableCellWithReuseIdentifier:@"AddAPhotoCell" forIndexPath:indexPath];
        return addCell;
    }
    
    
    PhotoCollectionViewCell *cell = [self.challengePhotosCollectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    cell.photo.image = self.challengePhotos[indexPath.row];
    return cell;
}


- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath
{
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    __weak ChallengeCreationViewController *weakSelf = self;
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
//        UIImagePickerController *controller
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = weakSelf;
        [weakSelf presentViewController:picker animated:YES completion:nil];

    }];
    
//    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
//        int x = 0;
//        x++;
//    }];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self.challengePhotos addObject:info[UIImagePickerControllerOriginalImage]];
    [self.challengePhotosCollectionView reloadData];
    
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
}

- (IBAction)challengePointsButtonPressed:(id)sender
{
    [UIView animateWithDuration:0.4f animations:^{
        self.challengePointsPicker.alpha = 1.0f;
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)sendChallenge:(id)sender
{
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
//    NSString* resultFilename = [documentDirectory stringByAppendingPathComponent:fileName];

    
    
    NSString *path = [NSString stringWithFormat:@"%@/%d",documentDirectories[0], rand()];// NSCachesDirectory, rand()];
    NSError *err = NULL;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&err];
    NSData *points = [[NSString stringWithFormat:@"%ld", (long)self.numberOfPoints] dataUsingEncoding:NSUTF8StringEncoding];
    
    [points writeToFile:[NSString stringWithFormat:@"%@/points", path] atomically:YES];
    int index = 0;
    for ( UIImage *challengePic in self.challengePhotos )
    {
        [UIImagePNGRepresentation(challengePic) writeToFile:[NSString stringWithFormat:@"%@/%d", path, index] atomically:YES];
        index ++;
    }
    
    
    NSString *path2 = [NSString stringWithFormat:@"%@/%@", documentDirectories[0], @"challenge"];
    [SSZipArchive createZipFileAtPath:path2 withContentsOfDirectory:path];
    
}

#pragma mark UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return awardPoints.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.challengePointsButton setTitle:[NSString stringWithFormat:@"%@", awardPoints[row]] forState:UIControlStateNormal];
    self.numberOfPoints = [awardPoints[row] integerValue];
}

#pragma mark UIPickerViewDatasource
- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", awardPoints[row]] attributes:@{NSFontAttributeName : [UIFont fontWithName:kMainFont size:kMainFontSize]}];
}



@end
