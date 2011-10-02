//
//  MGOKenBurnsController.h
//  BabyGiggles
//
//  Created by Mike Oliver on 7/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol MGOKenBurnsDelegate 

- (UIImage *) loadNextImage;

@end

/* Rotates through a set of images using the Ken Burns effect */
@interface MGOKenBurnsController : UIViewController {
    UIImageView *imageView;
    
    id<MGOKenBurnsDelegate> delegate;
}

/* The current view being animated. */
@property (nonatomic, retain) UIImageView *imageView;

@property (nonatomic, assign) id<MGOKenBurnsDelegate> delegate;

- (id) initWithDelegate: (id<MGOKenBurnsDelegate>) _delegate;

/* Called when the Ken Burns effect has finished animating */
- (void) animationFinished;

/* Animate the image using the Ken Burns effect */
- (void) animateImage: (UIImage *)image;

/* Fade the new image in over the existing image */
- (void) fadeInImageView: (UIImageView *) newImageView;

/* Move the image the specified amounts.  This is what actually accomplishes the Ken Burns effect. */
- (void) moveImagehMovement: (NSInteger) hMovement vMovement: (NSInteger) vMovement;

/* Called when the fade animation has finished. */
- (void) fadeAnimationFinishedImageView: (UIImageView *) newImageView hMovement: (NSInteger) hMovement vMovement: (NSInteger) vMovement;

/* Calls the delegate to load the next image*/
- (UIImage *) loadNextImage;

@end
