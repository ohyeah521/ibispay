//
//  CAAnimationBlockDelegate.m
//  AnimationHelper
//
//  Created by cooerson on 13-1-22.
//  Copyright (c) 2013年 Cooerson Inc. All rights reserved.
//

#import "CAAnimationBlockDelegate.h"

@implementation CAAnimationBlockDelegate : NSObject

- (void) animationDidStart:(CAAnimation *)theAnimation {
    
    if( !self.blockOnAnimationStarted ) return;
    
    self.blockOnAnimationStarted();
}

- (void) animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    if(flag) {
        if(!self.blockOnAnimationSucceeded)
            return;
        self.blockOnAnimationSucceeded();
        return;
    }
    if(!self.blockOnAnimationFailed)
        return;
    self.blockOnAnimationFailed();
}

@end
