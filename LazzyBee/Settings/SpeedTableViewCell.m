//
//  SpeedTableViewCell.m
//  LazzyBee
//
//  Created by HuKhong on 9/10/15.
//  Copyright (c) 2015 Born2go. All rights reserved.
//

#import "SpeedTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "Common.h"

@implementation SpeedTableViewCell
{
    AVSpeechSynthesizer *synthesizer;
}

- (void)awakeFromNib {
    // Initialization code
    NSNumber *speedNumberObj = [[Common sharedCommon] loadDataFromUserDefaultStandardWithKey:KEY_SPEAKING_SPEED];
    
    if (speedNumberObj) {
        [speedSlider setValue:[speedNumberObj floatValue]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)sliderchangeValue:(id)sender {
    NSNumber *speedNumberObj = [NSNumber numberWithFloat:[speedSlider value]];
    [[Common sharedCommon] saveDataToUserDefaultStandard:speedNumberObj withKey:KEY_SPEAKING_SPEED];

}

- (IBAction)valueChangeEnd:(id)sender {
    [self textToSpeech:@"This is to adjust speaking speed. Thank you for using lazy bee application." withRate:[speedSlider value]];
}

- (void)textToSpeech:(NSString *)text withRate:(float)rate {
    if (!synthesizer) {
        synthesizer = [[AVSpeechSynthesizer alloc]init];
    }
    
    [synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:text];
    
    [utterance setRate:rate];
    [synthesizer speakUtterance:utterance];
}
@end
