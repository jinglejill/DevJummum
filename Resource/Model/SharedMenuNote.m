//
//  SharedMenuNote.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 11/7/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedMenuNote.h"

@implementation SharedMenuNote
@synthesize menuNoteList;

+(SharedMenuNote *)sharedMenuNote {
    static dispatch_once_t pred;
    static SharedMenuNote *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedMenuNote alloc] init];
        shared.menuNoteList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
