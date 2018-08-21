//
//  Login.m
//  SAIM_UPDATING
//
//  Created by Thidaporn Kijkamjai on 5/2/2559 BE.
//  Copyright © 2559 Thidaporn Kijkamjai. All rights reserved.
//

#import "LogIn.h"
#import "SharedLogIn.h"
#import "Utility.h"


@implementation LogIn

-(LogIn *)initWithUsername:(NSString *)username status:(NSInteger)status deviceToken:(NSString *)deviceToken model:(NSString *)model
{
    self = [super init];
    if(self)
    {
        self.logInID = [LogIn getNextID];
        self.username = username;
        self.status = status;
        self.deviceToken = deviceToken;
        self.model = model;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"logInID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedLogIn sharedLogIn].logInList;
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:propertyName ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [dataList sortedArrayUsingDescriptors:sortDescriptors];
    dataList = [sortArray mutableCopy];
    
    if([dataList count] == 0)
    {
        return -1;
    }
    else
    {
        id value = [dataList[0] valueForKey:primaryKeyName];
        if([value integerValue]>0)
        {
            return -1;
        }
        else
        {
            return [value integerValue]-1;
        }
    }
}

+(void)addObject:(LogIn *)logIn
{
    NSMutableArray *dataList = [SharedLogIn sharedLogIn].logInList;
    [dataList addObject:logIn];
}

+(void)removeObject:(LogIn *)logIn
{
    NSMutableArray *dataList = [SharedLogIn sharedLogIn].logInList;
    [dataList removeObject:logIn];
}

+(void)addList:(NSMutableArray *)logInList
{
    NSMutableArray *dataList = [SharedLogIn sharedLogIn].logInList;
    [dataList addObjectsFromArray:logInList];
}

+(void)removeList:(NSMutableArray *)logInList
{
    NSMutableArray *dataList = [SharedLogIn sharedLogIn].logInList;
    [dataList removeObjectsInArray:logInList];
}

+(LogIn *)getLogIn:(NSInteger)logInID
{
    NSMutableArray *dataList = [SharedLogIn sharedLogIn].logInList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_logInID = %ld",logInID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

-(id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        ((LogIn *)copy).logInID = self.logInID;
        [copy setUsername:self.username];
        ((LogIn *)copy).status = self.status;
        [copy setDeviceToken:self.deviceToken];
        [copy setModel:self.model];
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
    }
    
    return copy;
}

-(BOOL)editLogIn:(LogIn *)editingLogIn
{
    if(self.logInID == editingLogIn.logInID
       && [self.username isEqualToString:editingLogIn.username]
       && self.status == editingLogIn.status
       && [self.deviceToken isEqualToString:editingLogIn.deviceToken]
       && [self.model isEqualToString:editingLogIn.model]
       )
    {
        return NO;
    }
    return YES;
}

+(LogIn *)copyFrom:(LogIn *)fromLogIn to:(LogIn *)toLogIn
{
    toLogIn.logInID = fromLogIn.logInID;
    toLogIn.username = fromLogIn.username;
    toLogIn.status = fromLogIn.status;
    toLogIn.deviceToken = fromLogIn.deviceToken;
    toLogIn.model = fromLogIn.model;
    toLogIn.modifiedUser = [Utility modifiedUser];
    toLogIn.modifiedDate = [Utility currentDateTime];
    
    return toLogIn;
}

@end
