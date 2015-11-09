//
//  PlaySoundLib.m
//  LazzyBee
//
//  Created by Nguyen Nam on 3/3/15.
//  Copyright (c) 2014 ITPRO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaySoundLib.h"
#import "Common.h"

@implementation PlaySoundLib
{
    
}

-(id)init {
    self = [super init];
    if (self) {

    }
    return self;
}


+ (PlaySoundLib *)sharedPlaySoundLib {
    static PlaySoundLib *sharedPlaySoundLib = nil;
    if (!sharedPlaySoundLib) {
        sharedPlaySoundLib = [[super allocWithZone:nil] init];
    }
    return sharedPlaySoundLib;
}

+(id)allocWithZone:(NSZone *)zone {
    return [self sharedPlaySoundLib];
}

- (void)playEffectName:(NSString *)effectName {
    [self stopEffect];
    
    NSString *effectPath = [[[Common sharedCommon] privateDocumentsFolder] stringByAppendingPathComponent:effectName];
    NSURL *url=[NSURL fileURLWithPath:effectPath];
    NSError *error;

    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    
    audioPlayer.delegate = (id)self;
    [audioPlayer prepareToPlay];
    [audioPlayer play];
}

- (void)streamSoundWithPath:(NSString *)soundPath {

    if (avPlayer) {
        [avPlayer pause];
        [avPlayer removeObserver:self forKeyPath:@"status"];
    }
    
    avPlayer = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:soundPath]];
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[avPlayer currentItem]];
    [avPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == avPlayer && [keyPath isEqualToString:@"status"]) {
        if (avPlayer.status == AVPlayerStatusFailed) {
            NSLog(@"AVPlayer Failed");
            [self.delegate playerItemPlayFailed];
            
        } else if (avPlayer.status == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            [self.delegate playerItemReadyToPlay];
            [avPlayer play];
            
            
        } else if (avPlayer.status == AVPlayerItemStatusUnknown) {
            NSLog(@"AVPlayer Unknown");
            
        }
    }
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    
    //  code here to play next sound file
    [self.delegate playerItemDidReachEnd:notification];
    
}

- (void)playStream {
    if (avPlayer && avPlayer.status == AVPlayerStatusReadyToPlay) {
        [avPlayer play];
    }
}

- (AVPlayerItem *)currentItem {
    if (avPlayer) {
        return avPlayer.currentItem;
    }

    return nil;
}

- (void)pauseStream {
    if (avPlayer) {
        [avPlayer pause];
    }
}
- (BOOL)isStreamingSound {
//    NSLog(@"Rate: %f", avPlayer.rate);
    if (avPlayer.rate > 0 && !avPlayer.error) {
        return YES;
    } else {
        return NO;
    }
}

-(void)seekStreamToBegin {
    if (avPlayer) {
        CMTime newTime = CMTimeMakeWithSeconds(0, 1);
        [avPlayer seekToTime:newTime];
    }
}

- (void)playEffect {
    if (audioPlayer && audioPlayer.isPlaying == NO) {
        [audioPlayer play];
    }
}

- (void)stopEffect {
    if (audioPlayer && audioPlayer.isPlaying == YES) {
        [audioPlayer stop];
    }
}

- (void)pauseEffect {
    if (audioPlayer && audioPlayer.isPlaying == YES) {
        [audioPlayer pause];
    }
}

- (BOOL)isPlayingSound {
    if (audioPlayer && audioPlayer.isPlaying == YES) {
        return YES;
    } else {
        return NO;
    }
}

- (NSInteger)playingDuration {
    if (audioPlayer && audioPlayer.isPlaying == YES) {
        return audioPlayer.currentTime;
    } else {
        return 0;
    }
}

- (void) audioPlayerDidFinishPlaying: (AVAudioPlayer *) player
                        successfully: (BOOL) flag {
    [self.delegate audioPlayerDidFinishPlaying:player successfully:flag];
}

-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    [self.delegate audioPlayerBeginInterruption:player];
}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player {
    [self.delegate audioPlayerEndInterruption:player];
}

#pragma record
- (void)startRecordEffect:(NSString *)fileName {
    
    NSLog(@"granted");
    //start record
    // Define the recorder setting
    NSDictionary *recordSettings = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityMedium],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16],
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 1],
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:8000],
                                    AVSampleRateKey,
                                    nil];
    // Initiate and prepare the recorder
    NSString *filePath = [[[Common sharedCommon] tmpFolder] stringByAppendingPathComponent:fileName];
    NSURL *outputFileURL = [NSURL fileURLWithPath:filePath];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [session setActive:YES error:nil];
    
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSettings error:nil];
    recorder.delegate = (id)self;
    recorder.meteringEnabled = YES;
    
    if (!recorder.recording) {
        [recorder record];
    }
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)rec successfully:(BOOL)flag {
    [self.delegate audioRecorderDidFinishRecording:rec successfully:flag];
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)rec error:(NSError *)error {
    [self stopRecordingEffect];
    [self.delegate audioRecorderEncodeErrorDidOccur:rec error:error];
}

- (void)stopRecordingEffect {
    if (recorder) {
        [recorder stop];
        recorder = nil;
    }
}

- (void)playRecordingFile:(NSString *)recFileName {
    NSString *effectPath = [[[Common sharedCommon] tmpFolder] stringByAppendingPathComponent:recFileName];
    NSURL *url=[NSURL fileURLWithPath:effectPath];
    NSError *error;
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    
    audioPlayer.delegate = (id)self;
    [audioPlayer prepareToPlay];
    [audioPlayer play];
}

- (BOOL)isRecordingEffect {
    if (recorder && recorder.isRecording == YES) {
        return YES;
    } else {
        return NO;
    }
}


- (void)playFileInResource:(NSString *)fileName {
    [self stopEffect];
    
    NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    NSURL *url=[NSURL fileURLWithPath:sourcePath];
    NSError *error;
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    
    audioPlayer.delegate = (id)self;
    [audioPlayer prepareToPlay];
    [audioPlayer play];
}
@end