//
//  Login.h
//  SAIM_UPDATING
//
//  Created by Thidaporn Kijkamjai on 5/2/2559 BE.
//  Copyright © 2559 Thidaporn Kijkamjai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogIn : NSObject
@property (nonatomic) NSInteger logInID;
@property (retain, nonatomic) NSString * username;
@property (nonatomic) NSInteger status;
@property (retain, nonatomic) NSString * deviceToken;
@property (retain, nonatomic) NSString * model;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;

-(LogIn *)initWithUsername:(NSString *)username status:(NSInteger)status deviceToken:(NSString *)deviceToken model:(NSString *)model;
+(NSInteger)getNextID;
+(void)addObject:(LogIn *)logIn;
+(void)removeObject:(LogIn *)logIn;
+(void)addList:(NSMutableArray *)logInList;
+(void)removeList:(NSMutableArray *)logInList;
+(LogIn *)getLogIn:(NSInteger)logInID;
-(BOOL)editLogIn:(LogIn *)editingLogIn;
+(LogIn *)copyFrom:(LogIn *)fromLogIn to:(LogIn *)toLogIn;

@end
