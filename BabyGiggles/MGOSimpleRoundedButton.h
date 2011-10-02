//
//  MGOSimpleRoundedButton.h
//  BabyGiggles
//
//  Created by Mike Oliver on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define ROUNDED_RADIUS 10.0f

@interface MGOSimpleRoundedButton : UIButton {
    UIColor *standardBackground;
    UIColor *highlightBackground;
}

@property (nonatomic, retain) UIColor *standardBackground;
@property (nonatomic, retain) UIColor *highlightBackground;

@end
