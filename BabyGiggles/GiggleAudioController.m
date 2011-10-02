//
//  GiggleAudioController.m
//  BabyGiggles
//
//  Created by Mike Oliver on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GiggleAudioController.h"


@implementation GiggleAudioController

- (id) initWithContinuousSound: (BOOL) playWithContinuousSound
{
    self = [super init];
    if (self)
    {
        playSoundsRepeatedly = playWithContinuousSound;
    }
    
    return self;
}

- (void) beginPlayingSounds
{
    [self playNextSound];
}

- (void) playNextSound
{
    [self loadNextSound];
    [self playSound];    
}

- (void) playSound
{
    AudioServicesPlaySystemSound(soundID);
}

- (void) loadNextSound
{
    NSInteger soundIDNum = arc4random() % 6 + 1;
    
    if (soundIDNum == lastSoundID)
        soundIDNum = (soundIDNum + 1) % 6 + 1;
    
    lastSoundID = soundIDNum;
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *path = [mainBundle pathForResource: [NSString stringWithFormat: @"BabyGiggles%i", soundIDNum] ofType:@"aif"];
    
    NSURL *aFileURL = [NSURL fileURLWithPath:path isDirectory:NO];
    OSStatus error = AudioServicesCreateSystemSoundID((CFURLRef)aFileURL, &soundID); 
    
    if (error != kAudioServicesNoError) 
    {   
        NSLog(@"Error %ld loading sound at path: %@", error, path);
        return;
    }
    
    OSStatus completionRegisterError = AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, completionCallback, (void*) self);
    
    if (completionRegisterError != kAudioSessionNoError)
    {
        NSLog(@"Error %ld loading sound at path: %@", completionRegisterError, path);
    }
}


- (void) soundFinishedPlaying
{
    AudioServicesRemoveSystemSoundCompletion(soundID);
    
    if (playSoundsRepeatedly)
    {
        [NSTimer scheduledTimerWithTimeInterval:1.0 
                                         target:self
                                       selector:@selector(playNextSound) 
                                       userInfo:nil 
                                        repeats:NO];
    }
}

static void completionCallback (SystemSoundID  mySSID, void* myself) 
{
    [(GiggleAudioController *)myself soundFinishedPlaying];
}

-(void) dealloc
{
    [super dealloc];
    AudioServicesRemoveSystemSoundCompletion(soundID);    
}

@end
