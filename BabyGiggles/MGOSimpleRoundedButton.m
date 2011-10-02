//
//  MGOSimpleRoundedButton.m
//  BabyGiggles
//
//  Created by Mike Oliver on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MGOSimpleRoundedButton.h"


@implementation MGOSimpleRoundedButton

@synthesize standardBackground;
@synthesize highlightBackground;

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    self.layer.cornerRadius = ROUNDED_RADIUS;
    self.standardBackground = self.backgroundColor;
    self.highlightBackground = [self titleColorForState:UIControlStateNormal];
    
    return self;
}

- (void) setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.backgroundColor = selected ? self.highlightBackground : self.standardBackground;
    self.titleLabel.textColor = selected ? [self titleColorForState:UIControlStateHighlighted] : [self titleColorForState:UIControlStateNormal];
}

- (void) setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    //self.backgroundColor = highlighted ? self.highlightBackground : self.standardBackground;
}

@end
