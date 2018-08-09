//
//  SharedRating.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 8/7/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedRating : NSObject
@property (retain, nonatomic) NSMutableArray *ratingList;

+ (SharedRating *)sharedRating;
@end
