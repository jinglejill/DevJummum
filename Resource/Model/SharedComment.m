//
//  SharedComment.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 4/7/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedComment.h"

@implementation SharedComment
@synthesize commentList;

+(SharedComment *)sharedComment {
    static dispatch_once_t pred;
    static SharedComment *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedComment alloc] init];
        shared.commentList = [[NSMutableArray alloc]init];
    });
    return shared;
}

@end
