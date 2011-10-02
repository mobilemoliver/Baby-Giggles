//
//  GiggleAudioController.h
//  BabyGiggles
//
//  Created by Mike Oliver on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioServices.h>


@interface GiggleAudioController : NSObject {
    SystemSoundID soundID;
    NSInteger lastSoundID;
    BOOL playSoundsRepeatedly;
}

- (id) initWithContinuousSound: (BOOL) playWithContinuousSound;

- (void) beginPlayingSounds;
- (void) loadNextSound;
- (void) playNextSound;
- (void) playSound;
- (void) soundFinishedPlaying;

static void completionCallback (SystemSoundID  mySSID, void* myself); 

@end
