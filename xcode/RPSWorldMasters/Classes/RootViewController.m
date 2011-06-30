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


#import "RootViewController.h"

@implementation RootViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    // Assuming that the main window has the size of the screen
    // BUG: This won't work if the EAGLView is not fullscreen

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGRect rect = screenRect;

    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
        rect.size = CGSizeMake( screenRect.size.height, screenRect.size.width );

    CCDirector *director = [CCDirector sharedDirector];
    EAGLView *glView = [director openGLView];
    float contentScaleFactor = [director contentScaleFactor];

    if (contentScaleFactor != 1)
        rect.size = CGSizeMake(rect.size.width * contentScaleFactor, rect.size.height * contentScaleFactor);

    glView.frame = rect;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.

    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

@end
