//
//  BabyGigglesMainController.h
//  BabyGiggles
//
//  Created by Mike Oliver on 7/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGOKenBurnsController.h"
#import "GiggleAudioController.h"
#import "TargetConditionals.h"
#import "ELCAlbumPickerController.h"
#import "ELCImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface BabyGigglesMainController : UIViewController <ELCImagePickerControllerDelegate, UINavigationControllerDelegate, MGOKenBurnsDelegate>{
    MGOKenBurnsController *kenBurnsController;    
    GiggleAudioController *audioController;
    
    IBOutlet UIView *controlPanel;
    IBOutlet UISegmentedControl *giggleOptions;
    IBOutlet UIButton *goButton;
    IBOutlet UIButton *settingsLabel;
    IBOutlet UIView *settingsContainer;
    IBOutlet UIButton *chooseImagesButton;
    IBOutlet UIButton *resetButton;
    
    UILabel *backInstructionLabel;
    
    UIScrollView *imagePreviewScrollView;
    
    BOOL settingsExpanded;
    
    NSInteger lastImageID;
    
    NSMutableArray *defaultImages;
    NSMutableArray *userImages;
    NSMutableArray *userImageLocations;
}

@property (nonatomic, retain) MGOKenBurnsController *kenBurnsController;
@property (nonatomic, retain) GiggleAudioController *audioController;

@property (nonatomic, retain) IBOutlet UIView *controlPanel;
@property (nonatomic, retain) IBOutlet UISegmentedControl *giggleOptions;
@property (nonatomic, retain) IBOutlet UIButton *goButton;
@property (nonatomic, retain) IBOutlet UIButton *settingsLabel;
@property (nonatomic, retain) IBOutlet UIView *settingsContainer;
@property (nonatomic, retain) IBOutlet UIButton *chooseImagesButton;
@property (nonatomic, retain) IBOutlet UIButton *resetButton;

@property (nonatomic, readonly) UILabel *backInstructionLabel;

@property (nonatomic, readonly) IBOutlet UIScrollView *imagePreviewScrollView;

- (IBAction) startGiggling: (id) sender;
- (IBAction) toggleSettings: (id) sender;
- (IBAction) chooseImagesPressed: (id) sender;
- (IBAction) resetButtonPressed: (id) sender;

- (void) handleTap: (UIGestureRecognizer *) sender;

- (void) imagePickerDidDismiss;

- (void) loadImagePreviews: (NSMutableArray *) imageArray;

- (NSMutableArray *) defaultImages;
- (void) loadDefaultImages;
- (UIImage *) getRandomImageFromArray: (NSArray *) imageArray;


@end
