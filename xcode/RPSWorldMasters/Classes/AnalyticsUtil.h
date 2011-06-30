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

#import "GANTracker.h"

#ifdef DEBUG
#define GAN_TRACK_PAGEVIEW(name) { \
    NSError *__error__; \
    NSLog(@"GAN_TRACK_PAGEVIEW: %@", name);\
    if (![[GANTracker sharedTracker] trackPageview:[NSString stringWithFormat:@"/%@", name] withError:&__error__]) \
        NSLog(@"GANTracker error: %@", [__error__ localizedDescription]); \
}

#define GAN_TRACK_EVENT(category, anAction) {\
    NSError *__error__; \
    NSLog(@"GAN_TRACK_EVENT: category:%@ action:%@", category, anAction);\
    if (![[GANTracker sharedTracker] trackEvent:category action:anAction label:nil value:-1 withError:&__error__]) \
        NSLog(@"GANTracker error: %@", [__error__ localizedDescription]); \
}

#define GAN_TRACK_EVENT_WITH_LABEL(category, anAction, aLabel) { \
    NSError *__error__; \
    NSLog(@"GAN_TRACK_EVENT_WITH_LABEL: category:%@ action:%@ label:%@", category, anAction, aLabel);\
    if (![[GANTracker sharedTracker] trackEvent:category action:anAction label:aLabel value:-1 withError:&__error__]) \
        NSLog(@"GANTracker error: %@", [__error__ localizedDescription]); \
}

#else

#define GAN_TRACK_PAGEVIEW(name) { \
    NSError *__error__; \
    if (![[GANTracker sharedTracker] trackPageview:[NSString stringWithFormat:@"/%@", name] withError:&__error__]) \
        NSLog(@"GANTracker error: %@", [__error__ localizedDescription]); \
}

#define GAN_TRACK_EVENT(category, anAction) {\
    NSError *__error__; \
    if (![[GANTracker sharedTracker] trackEvent:category action:anAction label:nil value:-1 withError:&__error__]) \
        NSLog(@"GANTracker error: %@", [__error__ localizedDescription]); \
}

#define GAN_TRACK_EVENT_WITH_LABEL(category, anAction, aLabel) { \
    NSError *__error__; \
    if (![[GANTracker sharedTracker] trackEvent:category action:anAction label:aLabel value:-1 withError:&__error__]) \
        NSLog(@"GANTracker error: %@", [__error__ localizedDescription]); \
}

#endif

