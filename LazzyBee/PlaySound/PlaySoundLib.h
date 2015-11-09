//
//  PlaySoundLib.h
//  Lazzy Bee
//
//  Created by Nguyen Nam on 3/3/15.
//  Copyright (c) 2014 ITPRO. All rights reserved.
//

#ifndef SpiceCall_PlaySoundLib_h
#define SpiceCall_PlaySoundLib_h
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@protocol PlaySoundDelegate <NSObject>

@optional // Delegate protocols
- (void) audioPlayerDidFinishPlaying: (AVAudioPlayer *) player
                        successfully: (BOOL) flag;
-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player;
-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player;

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag;
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error;

//avPlayer delegate
- (void)playerItemDidReachEnd:(NSNotification *)notification;
- (void)playerItemPlayFailed;
- (void)playerItemReadyToPlay;

@end

@interface PlaySoundLib : NSObject
{
    AVAudioPlayer *audioPlayer;
    AVAudioRecorder *recorder;
    AVPlayer *avPlayer;
}

@property(nonatomic,strong) UIViewController *callerViewController;

+ (PlaySoundLib *)sharedPlaySoundLib;
@property(nonatomic, readwrite) id <PlaySoundDelegate> delegate;

- (void)streamSoundWithPath:(NSString *)soundPath;
- (void)playStream;
- (void)pauseStream;
- (BOOL)isStreamingSound;
- (AVPlayerItem *)currentItem;
- (void)seekStreamToBegin;

- (void)playEffectName:(NSString *)effectName;
- (void)playEffect;
- (void)stopEffect;
- (void)pauseEffect;
- (BOOL)isPlayingSound;
- (NSInteger)playingDuration;

- (void)startRecordEffect:(NSString *)fileName;
- (void)playRecordingFile:(NSString *)recFileName;
- (void)stopRecordingEffect;
- (BOOL)isRecordingEffect;

- (void)playFileInResource:(NSString *)fileName;
@end
#endif
