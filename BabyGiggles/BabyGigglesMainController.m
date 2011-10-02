//
//  BabyGigglesMainController.m
//  BabyGiggles
//
//  Created by Mike Oliver on 7/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BabyGigglesMainController.h"
#import "BabyGigglesAppDelegate.h"

// I want a three finger swipe to go back to the landing page from the ken burns controller, 
// but you can't do that on a simulator.  So on the sim, we'll make it a one finger swipe.  
#if (TARGET_IPHONE_SIMULATOR)
#define SWIPE_TOUCHES 1
#else
#define SWIPE_TOUCHES 3
#endif

#define ROUNDED_RADIUS 10.0f

#define PREFERENCES_LOCATION @"/preferences.archive"

@implementation BabyGigglesMainController

@synthesize kenBurnsController;
@synthesize audioController;
@synthesize controlPanel;
@synthesize giggleOptions;
@synthesize goButton;
@synthesize settingsLabel;
@synthesize settingsContainer;
@synthesize chooseImagesButton;
@synthesize imagePreviewScrollView;
@synthesize resetButton;

@dynamic backInstructionLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    self.kenBurnsController = nil;
    self.audioController = nil;
    [backInstructionLabel release];
    backInstructionLabel = nil;
    [userImages release];
    userImages = nil;
    [userImageLocations release];
    userImageLocations = nil;
    [defaultImages release];
    defaultImages = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Round everyone's edges
    self.controlPanel.layer.cornerRadius = ROUNDED_RADIUS;
    self.settingsContainer.layer.cornerRadius = ROUNDED_RADIUS;
    
    self.goButton.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.goButton.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    self.goButton.layer.shadowOpacity = 1.0;

    self.chooseImagesButton.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.chooseImagesButton.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    self.chooseImagesButton.layer.shadowOpacity = 1.0;
    
    // Load up any saved images
    userImageLocations = [[NSKeyedUnarchiver unarchiveObjectWithFile:PREFERENCES_LOCATION] retain];
    userImages = [[NSMutableArray alloc] initWithCapacity:[userImageLocations count]];
    
    if (userImageLocations && [userImageLocations count] > 0)
    {
        ALAssetsLibraryAssetForURLResultBlock getImageBlock = ^(ALAsset *myasset)
        {
            ALAssetRepresentation *rep = [myasset defaultRepresentation];
            CGImageRef iref = [rep fullResolutionImage];
            if (iref) {
                UIImage *image = [UIImage imageWithCGImage:iref];
                [userImages addObject:image];
            }
        };
        
        ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error)
        {
            NSLog(@"Error getting access to asset: %@", error);
        };
        
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        for (NSURL *location in userImageLocations)
        {
            [assetslibrary assetForURL:location resultBlock:getImageBlock failureBlock:failureBlock];
        }
        [assetslibrary release];

        [self loadDefaultImages];
    }
    else
    {
        [self loadImagePreviews: [self defaultImages]];
        self.resetButton.alpha = 0.0;
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction) toggleSettings: (id) sender
{
    int heightChanged = (settingsExpanded) ? -210.0 : 210.0;
    
    CGRect originalBounds = self.controlPanel.frame;
    
    [UIView animateWithDuration:0.3 animations:^(void) {
        self.controlPanel.frame = CGRectMake(originalBounds.origin.x, originalBounds.origin.y - heightChanged, originalBounds.size.width, originalBounds.size.height + heightChanged);
    }];
    
    if ([imagePreviewScrollView subviews] || [[imagePreviewScrollView subviews] count] == 0)
    {
        if (userImages && [userImages count] > 0)
        {
            [self loadImagePreviews:userImages];
        }
        else
        {
            [self loadImagePreviews:[self defaultImages]];
        }
    }
    
    settingsExpanded = !settingsExpanded;
}
- (IBAction) chooseImagesPressed:(id)sender
{
    ELCAlbumPickerController *albumController = [[ELCAlbumPickerController alloc] initWithNibName:@"ELCAlbumPickerController" bundle:[NSBundle mainBundle]];    
	ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:albumController];
    [albumController setParent:elcPicker];
	[elcPicker setDelegate:self];
    
    [self presentModalViewController:elcPicker animated:YES];
    
    [albumController release];
    [elcPicker release];
}

- (IBAction) resetButtonPressed: (id) sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Are you sure?" 
                                                        message:@"This will reset the app to the default images.  Are you sure you want to do that?" 
                                                       delegate:self 
                                              cancelButtonTitle:@"No" 
                                              otherButtonTitles:@"Yes", nil];
    
    [alertView show];
    [alertView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex > 0)
    {
        [userImages release];
        userImages = [[NSMutableArray alloc] initWithCapacity:10];
        
        // TODO: delete persisted file
        [[NSFileManager defaultManager] removeItemAtPath:PREFERENCES_LOCATION error:nil];
        
        [self loadImagePreviews: [self defaultImages]];
        self.resetButton.alpha = 0.0;
    }
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissModalViewControllerAnimated: YES];
    
    [userImages release];
    userImages = [[NSMutableArray alloc] initWithCapacity: [info count]];
    [userImageLocations release];
    userImageLocations = [[NSMutableArray alloc] initWithCapacity: [info count]];
    
	for(NSDictionary *dict in info) {
        
        NSURL *imageLocation = [dict objectForKey:UIImagePickerControllerReferenceURL];
        [userImageLocations addObject:imageLocation];
        
		UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        
        [userImages addObject:image];
	}
	
    if ([userImages count] > 0)
    {
        [self loadImagePreviews: userImages];
        self.resetButton.alpha = 1.0;
    }
    else
    {
        [self loadImagePreviews: defaultImages];
        self.resetButton.alpha = 0.0;
    }
    
    [NSKeyedArchiver archiveRootObject:userImageLocations toFile:PREFERENCES_LOCATION];
    
    [self imagePickerDidDismiss];

}

- (void) loadImagePreviews: (NSMutableArray *) imageArray
{
    [[imagePreviewScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

    CGRect workingFrame = self.imagePreviewScrollView.frame;
	workingFrame.origin.x = 0;
    workingFrame.origin.y = 0;
	
    for (UIImage *image in imageArray)
    {
        UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
		[imageview setContentMode:UIViewContentModeScaleAspectFit];
		imageview.frame = workingFrame;
		
		[imagePreviewScrollView addSubview:imageview];
		[imageview release];
		
		workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
    }
    
    [imagePreviewScrollView setPagingEnabled:YES];
	[imagePreviewScrollView setContentSize:CGSizeMake(workingFrame.origin.x, workingFrame.size.height)];
    
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated: YES];
    [self imagePickerDidDismiss];
}

- (void) imagePickerDidDismiss
{
    // After I dismiss the image picker, my view is messed up.  Pretty sure this is an Apple bug when dealing with
    // Navigation Controller's and the top level window.  Basically, the sytem has moved my view down by the status bar.  
    // We'll fix our frame manually here. 
    self.view.frame = CGRectMake(self.view.frame.origin.x, 
                                 self.view.frame.origin.y - [[UIApplication sharedApplication] statusBarFrame].size.height,
                                 self.view.frame.size.width, 
                                 self.view.frame.size.height);
}

- (IBAction) startGiggling: (id) sender
{
    MGOKenBurnsController *newKenBurnsController = [[MGOKenBurnsController alloc] initWithDelegate: self];
    self.kenBurnsController = newKenBurnsController;
    [self.view addSubview: kenBurnsController.view];
    [newKenBurnsController release];
    
    BOOL continuousGiggles = YES;
    if (self.giggleOptions.selectedSegmentIndex == 1)
        continuousGiggles = NO;
    
    GiggleAudioController *newAudioController = [[GiggleAudioController alloc] initWithContinuousSound: continuousGiggles];
    self.audioController = newAudioController;
    [self.audioController beginPlayingSounds];
    [newAudioController release];
                      
    if (!continuousGiggles)
    {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handleTap:)];
        [self.kenBurnsController.view addGestureRecognizer:tapGesture];
        [tapGesture release];
    }
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget: self action:@selector(handleSwipe:)];
    swipeGesture.numberOfTouchesRequired = SWIPE_TOUCHES;
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeGesture];
    [swipeGesture release];
    
    [self.view addSubview:self.backInstructionLabel];
    
}

- (UILabel *) backInstructionLabel
{
    if (!backInstructionLabel)
    {
        backInstructionLabel = [[UILabel alloc] init];
        backInstructionLabel.backgroundColor = [UIColor clearColor];
        backInstructionLabel.textColor = [UIColor whiteColor];
        backInstructionLabel.text = [NSString stringWithFormat: @"%i-finger scroll left to go back", SWIPE_TOUCHES];
        backInstructionLabel.font = [UIFont systemFontOfSize: [UIFont systemFontSize]];
        [backInstructionLabel sizeToFit];
        backInstructionLabel.textAlignment = UITextAlignmentCenter;
        backInstructionLabel.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height);
    }
    
    return backInstructionLabel;
}

- (void) handleTap: (UIGestureRecognizer *) sender
{
    [self.audioController playNextSound];
}

- (void) handleSwipe: (UIGestureRecognizer *) sender
{
    [self.kenBurnsController.view removeFromSuperview];
    [self.backInstructionLabel removeFromSuperview];
    self.kenBurnsController = nil;
    self.audioController = nil;
}

- (UIImage *) loadNextImage
{
    if (userImages && [userImages count] > 0)
        return [self getRandomImageFromArray: userImages];
    else
        return [self getRandomImageFromArray: [self defaultImages]];
}

- (UIImage *) getRandomImageFromArray: (NSArray *) imageArray
{
    NSInteger imageNum = arc4random() % [imageArray count];
    
    // Ensure that we are not animating the same image twice. 
    if (imageNum == lastImageID)
        imageNum = (imageNum + 1) % [imageArray count];
    
    lastImageID = imageNum;
    
    return [imageArray objectAtIndex: imageNum];
}

- (NSMutableArray *) defaultImages
{
    if (!defaultImages)
    {
        [self loadDefaultImages];
    }
    
    return defaultImages;
}

- (void) loadDefaultImages
{
    [defaultImages release];
    defaultImages = [[NSMutableArray alloc] initWithCapacity:10];
    for (int i = 1; i <= 10; i++)
    {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat: @"BabyGiggles%i", i]];
        [defaultImages addObject:image];
    }    
}

@end
