//
//  neuronetAppDelegate.h
//  neuronet
//
//  Created by rockosov on 25.04.12.
//  Copyright 2012 TIT_SFEDU. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ImageView.h"

@interface neuronetAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow				*window;
	IBOutlet ImageView		*imageViewer;
}

@property (assign) IBOutlet NSWindow *window;

-(IBAction)selectImage: (id)sender;

@end
