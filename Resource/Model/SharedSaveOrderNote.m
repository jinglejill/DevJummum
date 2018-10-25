//
//  SharedSaveOrderNote.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 24/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "SharedSaveOrderNote.h"

@implementation SharedSaveOrderNote
@synthesize saveOrderNoteList;

+(SharedSaveOrderNote *)sharedSaveOrderNote {
    static dispatch_once_t pred;
    static SharedSaveOrderNote *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedSaveOrderNote alloc] init];
        shared.saveOrderNoteList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
