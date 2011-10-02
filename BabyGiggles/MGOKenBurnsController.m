//
//  MGOKenBurnsController.m
//  BabyGiggles
//
//  Created by Mike Oliver on 7/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MGOKenBurnsController.h"
#import <stdlib.h>

#define ZOOM_MAX 25
#define HORIZONTAL_MOVEMENT_RANGE 50
#define HORIZONTAL_MOVEMENT_MIN 25
#define VERTICAL_MOVEMENT_RANGE 50
#define VERTICAL_MOVEMENT_MIN 25
#define ANIMATION_DURATION 10.0
#define FADE_DURATION 1.0

@implementation MGOKenBurnsController

@synthesize imageView;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id) initWithDelegate: (id<MGOKenBurnsDelegate>) _delegate
{
    self = [super init];
    if (self)
    {
        self.delegate = _delegate;
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    // Begin by animating the first image
    [self animateImage: [self loadNextImage]];
    
}

- (UIImage *) loadNextImage
{
    return [self.delegate loadNextImage];
}

- (void) animateImage: (UIImage *)image
{
    // Determine the amount the image is going to move, which direction, etc.
    NSInteger hMovement = arc4random() % HORIZONTAL_MOVEMENT_RANGE + HORIZONTAL_MOVEMENT_MIN;
    NSInteger vMovement = arc4random() % VERTICAL_MOVEMENT_RANGE + VERTICAL_MOVEMENT_MIN;
    NSInteger hMovementDirection = arc4random() % 2;
    NSInteger vMovementDirection = arc4random() % 2;
    
    UIImageView *newImageView = [[UIImageView alloc] initWithImage:image];
    
    // Position the image in preparation for the animation
    newImageView.contentMode = UIViewContentModeScaleAspectFill;
    newImageView.bounds = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width + hMovement, self.view.bounds.size.height + vMovement);
    
    if (hMovementDirection > 0)
        hMovement = hMovement * -1;
    
    if (vMovementDirection > 0)
        vMovement = vMovement * -1;
    
    newImageView.center = CGPointMake(self.view.center.x + hMovement / 2, 
                                   self.view.center.y + vMovement / 2 - [[UIApplication sharedApplication] statusBarFrame].size.height);
    
    // Fade the image in.
    [UIView animateWithDuration:FADE_DURATION
                          delay:0.0
                        options:UIViewAnimationCurveLinear
                     animations:^(void) {
                         [self fadeInImageView: newImageView];
                     } completion:^(BOOL finished) {
                         [self fadeAnimationFinishedImageView: newImageView hMovement:hMovement vMovement:vMovement];
                          
                     }];

    
}

- (void) fadeInImageView: (UIImageView *) newImageView
{
    // Fade the new image in, and fade the old image out.  
    newImageView.alpha = 0.0;
    [self.view addSubview:newImageView];
    newImageView.alpha = 1.0;
    self.imageView.alpha = 0.0;
}

- (void) fadeAnimationFinishedImageView: (UIImageView *) newImageView hMovement: (NSInteger) hMovement vMovement: (NSInteger) vMovement
{
    // Get rid of the old image
    [self.imageView removeFromSuperview];
    self.imageView = newImageView;
    
    // Move the image to imitate the Ken Burns effect.
    [self moveImagehMovement:hMovement vMovement:vMovement];
}

- (void) moveImagehMovement: (NSInteger) hMovement vMovement: (NSInteger) vMovement 
{
    [UIView animateWithDuration:ANIMATION_DURATION 
                          delay:0.0 
                        options:UIViewAnimationCurveLinear
                     animations:^(void) {
                         self.imageView.center = CGPointMake(self.imageView.center.x - hMovement, self.imageView.center.y - vMovement);
                     } 
                     completion:^(BOOL finished) {
                         if (finished)
                             [self animationFinished];
                     }];
        
}

- (void) animationFinished
{
    // We want the view to fade in over whatever is there the first time, but after that we don't want it to 
    // show through anymore.  
    self.view.backgroundColor = [UIColor blackColor];
    
    // Animate the next image
    [self animateImage:[self loadNextImage]];
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

@end
