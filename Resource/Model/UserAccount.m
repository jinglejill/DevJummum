//
//  UserAccount.m
//  SaleAndInventoryManagement
//
//  Created by Thidaporn Kijkamjai on 7/10/2558 BE.
//  Copyright (c) 2558 Thidaporn Kijkamjai. All rights reserved.
//

#import "UserAccount.h"
#import "SharedUserAccount.h"
#import "SharedCurrentUserAccount.h"
#import "Utility.h"


@implementation UserAccount

-(UserAccount *)initWithUsername:(NSString *)username password:(NSString *)password deviceToken:(NSString *)deviceToken firstName:(NSString *)firstName lastName:(NSString *)lastName fullName:(NSString *)fullName nickName:(NSString *)nickName birthDate:(NSDate *)birthDate email:(NSString *)email phoneNo:(NSString *)phoneNo lineID:(NSString *)lineID roleID:(NSInteger)roleID
{
    self = [super init];
    if(self)
    {
        self.userAccountID = [UserAccount getNextID];
        self.username = username;
        self.password = password;
        self.deviceToken = deviceToken;
        self.firstName = firstName;
        self.lastName = lastName;
        self.fullName = fullName;
        self.nickName = nickName;
        self.birthDate = birthDate;
        self.email = email;
        self.phoneNo = phoneNo;
        self.lineID = lineID;
        self.roleID = roleID;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"userAccountID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedUserAccount sharedUserAccount].userAccountList;
    
    
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

+(void)addObject:(UserAccount *)userAccount
{
    NSMutableArray *dataList = [SharedUserAccount sharedUserAccount].userAccountList;
    [dataList addObject:userAccount];
}

+(void)removeObject:(UserAccount *)userAccount
{
    NSMutableArray *dataList = [SharedUserAccount sharedUserAccount].userAccountList;
    [dataList removeObject:userAccount];
}

+(void)addList:(NSMutableArray *)userAccountList
{
    NSMutableArray *dataList = [SharedUserAccount sharedUserAccount].userAccountList;
    [dataList addObjectsFromArray:userAccountList];
}

+(void)removeList:(NSMutableArray *)userAccountList
{
    NSMutableArray *dataList = [SharedUserAccount sharedUserAccount].userAccountList;
    [dataList removeObjectsInArray:userAccountList];
}

+(UserAccount *)getUserAccount:(NSInteger)userAccountID
{
    NSMutableArray *dataList = [SharedUserAccount sharedUserAccount].userAccountList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_userAccountID = %ld",userAccountID];
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
        ((UserAccount *)copy).userAccountID = self.userAccountID;
        [copy setUsername:self.username];
        [copy setPassword:self.password];
        [copy setDeviceToken:self.deviceToken];
        [copy setFirstName:self.firstName];
        [copy setLastName:self.lastName];
        [copy setFullName:self.fullName];
        [copy setNickName:self.nickName];
        [copy setBirthDate:self.birthDate];
        [copy setEmail:self.email];
        [copy setPhoneNo:self.phoneNo];
        [copy setLineID:self.lineID];
        ((UserAccount *)copy).roleID = self.roleID;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
    }
    
    return copy;
}

-(BOOL)editUserAccount:(UserAccount *)editingUserAccount
{
    if(self.userAccountID == editingUserAccount.userAccountID
       && [self.username isEqualToString:editingUserAccount.username]
       && [self.password isEqualToString:editingUserAccount.password]
       && [self.deviceToken isEqualToString:editingUserAccount.deviceToken]
       && [self.firstName isEqualToString:editingUserAccount.firstName]
       && [self.lastName isEqualToString:editingUserAccount.lastName]
       && [self.fullName isEqualToString:editingUserAccount.fullName]
       && [self.nickName isEqualToString:editingUserAccount.nickName]
       && [self.birthDate isEqual:editingUserAccount.birthDate]
       && [self.email isEqualToString:editingUserAccount.email]
       && [self.phoneNo isEqualToString:editingUserAccount.phoneNo]
       && [self.lineID isEqualToString:editingUserAccount.lineID]
       && self.roleID == editingUserAccount.roleID
       )
    {
        return NO;
    }
    return YES;
}

+(UserAccount *)copyFrom:(UserAccount *)fromUserAccount to:(UserAccount *)toUserAccount
{
    toUserAccount.userAccountID = fromUserAccount.userAccountID;
    toUserAccount.username = fromUserAccount.username;
    toUserAccount.password = fromUserAccount.password;
    toUserAccount.deviceToken = fromUserAccount.deviceToken;
    toUserAccount.firstName = fromUserAccount.firstName;
    toUserAccount.lastName = fromUserAccount.lastName;
    toUserAccount.fullName = fromUserAccount.fullName;
    toUserAccount.nickName = fromUserAccount.nickName;
    toUserAccount.birthDate = fromUserAccount.birthDate;
    toUserAccount.email = fromUserAccount.email;
    toUserAccount.phoneNo = fromUserAccount.phoneNo;
    toUserAccount.lineID = fromUserAccount.lineID;
    toUserAccount.roleID = fromUserAccount.roleID;
    toUserAccount.modifiedUser = [Utility modifiedUser];
    toUserAccount.modifiedDate = [Utility currentDateTime];
    
    return toUserAccount;
}

+(BOOL) usernameExist:(NSString *)username
{
    UserAccount *userAccount = [UserAccount getUserAccountWithUsername:username];
    if(!userAccount)
    {
        return NO;
    }
    return YES;
}

+(BOOL)isPasswordValidWithUsername:(NSString *)username password:(NSString *)password
{
    NSUInteger fieldHash = [password hash];
    NSString *fieldString = [KeychainWrapper securedSHA256DigestHashForPIN:fieldHash];
    
    
    UserAccount *userAccount = [UserAccount getUserAccountWithUsername:username];
    if([userAccount.password isEqualToString:fieldString])
    {
        return YES;
    }
    return NO;
}

+(UserAccount *)getUserAccountWithUsername:(NSString *)username
{
    NSMutableArray *userAccountList = [SharedUserAccount sharedUserAccount].userAccountList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_username = %@",username];
    NSArray *filterArray = [userAccountList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return  filterArray[0];
    }
    return nil;
}

+(void)setCurrentUserAccount:(UserAccount *)userAccount
{
    [SharedCurrentUserAccount sharedCurrentUserAccount].userAccount = userAccount;
}

+(UserAccount *)getCurrentUserAccount
{
    return [SharedCurrentUserAccount sharedCurrentUserAccount].userAccount;
}

+(NSString *)getFirstNameWithFullName:(NSString *)fullName
{
    NSArray* component = [fullName componentsSeparatedByString: @" "];
    NSString* firstName = [component objectAtIndex: 0];
    return firstName;
}
@end
