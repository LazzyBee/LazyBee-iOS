//
//  MajorObject.m
//  LazzyBee
//
//  Created by HuKhong on 3/31/15.
//  Copyright (c) 2015 HuKhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MajorObject.h"


@implementation MajorObject

- (id)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (id)initWithName:(NSString *)majorName thumbnail:(NSString *)thumbnail andCheckFlag:(BOOL)flag {
    self = [super init];
    if (self) {
        self.majorName = majorName;
        self.majorThumbnail = thumbnail;
        self.checkFlag = flag;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
//    [encoder encodeObject:self.wordid forKey:@"wordid"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super init])) // Superclass init
    {

    }
    
    return self;
}
@end