/*
 * Copyright 2011 Fictorial LLC. All Rights Reserved.
 *
 * This file is part of RPS World Masters - Online Rock Paper Scissors.
 *
 * RPS World Masters - Online Rock Paper Scissors is free software: you can
 * redistribute it and/or modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * RPS World Masters - Online Rock Paper Scissors is distributed in the hope that
 * it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
 * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
 * Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * RPS World Masters - Online Rock Paper Scissors.  If not, see
 * <http://www.gnu.org/licenses/>.
 */


#import "BackgroundLayer.h"

@implementation BackgroundLayer

- (id)init {
    if ((self = [super init])) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CGPoint center = CGPointMake(winSize.width/2, winSize.height/2);

        CCSprite *stars = [CCSprite spriteWithFile:NameForJPGImage(@"starfield")];
        [self addChild:stars z:-2 tag:kRPSTagStars];
        stars.position = center;

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            [stars runAction:[CCScaleTo actionWithDuration:5 scale:1.25]];

        [stars runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:360 angle:360]]];

        CCSprite *earth = [CCSprite spriteWithFile:NameForPNGImage(@"earth")];
        earth.position = center;
        [self addChild:earth z:0 tag:kRPSTagEarth];
    }
    return self;
}

@end
