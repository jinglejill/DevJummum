//
//  SharedComment.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 4/7/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedComment : NSObject
@property (retain, nonatomic) NSMutableArray *commentList;

+ (SharedComment *)sharedComment;
@end
