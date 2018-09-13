//
//  Card.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 12/9/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "Card.h"
#import "SharedCard.h"
#import <UIKit/UIKit.h>


@implementation Card


+(void)setUpCards
{
    NSMutableArray *_arrRankCard = [[NSMutableArray alloc]init];
    NSString *rankCard;
    for(int j=1; j<=4; j++)
    {
        switch (j) {
            case 1:
            rankCard = @"Excellent";
            break;
            case 2:
            rankCard = @"Awesome";
            break;
            case 3:
            rankCard = @"Good";
            break;
            case 4:
            rankCard = @"Boo";
            break;
            default:
            break;
        }
        NSMutableArray *animationImages = [[NSMutableArray alloc]init];
        NSInteger steps = 17;
        for(int i=0; i<steps; i++)
        {
            NSString *imageName = [NSString stringWithFormat:@"giftBox%@%05d.jpg",rankCard,(i+7)];
            UIImage *imageRunning = [UIImage imageNamed:imageName];
            [animationImages addObject:(NSObject *)(imageRunning.CGImage)];
        }
        [_arrRankCard addObject:animationImages];
    }
    
    [SharedCard sharedCard].cardList = _arrRankCard;
}

+(NSMutableArray *)getExcellentCard
{
    NSMutableArray *cardList = [SharedCard sharedCard].cardList;
    return cardList[0];
}
+(NSMutableArray *)getAwesomeCard
{
    NSMutableArray *cardList = [SharedCard sharedCard].cardList;
    return cardList[1];
}
+(NSMutableArray *)getGoodCard
{
    NSMutableArray *cardList = [SharedCard sharedCard].cardList;
    return cardList[2];
}
+(NSMutableArray *)getBooCard
{
    NSMutableArray *cardList = [SharedCard sharedCard].cardList;
    return cardList[3];
}

@end
