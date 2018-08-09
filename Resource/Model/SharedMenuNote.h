//
//  SharedMenuNote.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 11/7/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedMenuNote : NSObject
@property (retain, nonatomic) NSMutableArray *menuNoteList;

+ (SharedMenuNote *)sharedMenuNote;
@end
