//
//  VoucherCodeListViewController.m
//  DevJummum
//
//  Created by Thidaporn Kijkamjai on 28/8/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "VoucherCodeListViewController.h"
#import "CustomTableViewCellPromoBanner.h"
#import "CustomTableViewCellPromoThumbNail.h"
#import "CustomTableViewCellReward.h"
#import "Setting.h"
#import "Promotion.h"
#import "RewardRedemption.h"
#import "Branch.h"


@interface VoucherCodeListViewController ()
{
    NSMutableArray *_timeToCountDownList;
    NSMutableArray *_timerList;
    NSMutableArray *_timerUsedList;
}
@end

@implementation VoucherCodeListViewController
static NSString * const reuseIdentifierPromoBanner = @"CustomTableViewCellPromoBanner";
static NSString * const reuseIdentifierPromoThumbNail = @"CustomTableViewCellPromoThumbNail";
static NSString * const reuseIdentifierReward = @"CustomTableViewCellReward";


@synthesize lblNavTitle;
@synthesize tbvData;
@synthesize topViewHeight;
@synthesize promotionList;
@synthesize rewardRedemptionList;
@synthesize selectedVoucherCode;


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    
    
    float topPadding = window.safeAreaInsets.top;
    topViewHeight.constant = topPadding == 0?20:topPadding;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSString *title = [Language getText:@"เลือก Voucher Code"];
    lblNavTitle.text = title;
    tbvData.delegate = self;
    tbvData.dataSource = self;
 
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierPromoBanner bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierPromoBanner];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierPromoThumbNail bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierPromoThumbNail];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierReward bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierReward];
    }
    
    
    _timeToCountDownList = [[NSMutableArray alloc]init];
    _timerList = [[NSMutableArray alloc]init];
    _timerUsedList = [[NSMutableArray alloc]init];
    for(int i=0; i<[rewardRedemptionList count]; i++)
    {
        RewardRedemption *rewardRedemption = rewardRedemptionList[i];
//        RewardPoint *rewardPoint = rewardPointList[i];
        NSTimeInterval seconds = [[Utility currentDateTime] timeIntervalSinceDate:rewardRedemption.redeemDate];
        NSInteger timeToCountDown = rewardRedemption.withInPeriod - seconds >= 0?rewardRedemption.withInPeriod - seconds:0;
        if(rewardRedemption.withInPeriod == 0)
        {
            timeToCountDown = 0;
        }
        [_timeToCountDownList addObject:[NSNumber numberWithInteger:timeToCountDown]];
        NSNumber *objIndex = [NSNumber numberWithInt:i];
        [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer:) userInfo:objIndex repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        [_timerList addObject:timer];        
    }
}

-(void)updateTimer:(NSTimer *)timer
{
    NSInteger index = [timer.userInfo integerValue];
    _timeToCountDownList[index] = @([_timeToCountDownList[index] integerValue] - 1);
    _timeToCountDownList[index] = [_timeToCountDownList[index] integerValue] < 0?@0:_timeToCountDownList[index];
    
    [self populateLabelwithTime:[_timeToCountDownList[index] integerValue] index:index];
    if([_timeToCountDownList[index] integerValue] == 0)
    {
        [timer invalidate];
        
        
//        RewardPoint *rewardPoint = _rewardPointList[index];
//        PromoCode *promoCode = _promoCodeList[index];
        RewardRedemption *rewardRedemption = rewardRedemptionList[index];
        
        
        if(rewardRedemption.withInPeriod == 0)
        {
            return;
        }
        
        
        
        
        for(NSInteger i=0; i<[_timerList count]; i++)
        {
            NSTimer *timerCountDown = _timerList[i];
            NSTimer *timer2 = _timerUsedList[i];
            
            [timerCountDown invalidate];
            [timer2 invalidate];
        }
        
        
//        [_rewardPointUsedList addObject:rewardPoint];
//        [_promoCodeUsedList addObject:promoCode];
//        [_rewardRedemptionUsedList addObject:rewardRedemption];
//        [_rewardPointList removeObject:rewardPoint];
//        [_promoCodeList removeObject:promoCode];
        [rewardRedemptionList removeObject:rewardRedemption];
        
        
        
        [_timerList removeAllObjects];
        [_timerUsedList removeAllObjects];
        [_timeToCountDownList removeAllObjects];
        for(int i=0; i<[rewardRedemptionList count]; i++)
        {
            RewardRedemption *rewardRedemption = rewardRedemptionList[i];
//            RewardPoint *rewardPoint = _rewardPointList[i];
            NSTimeInterval seconds = [[Utility currentDateTime] timeIntervalSinceDate:rewardRedemption.redeemDate];
            NSInteger timeToCountDown = rewardRedemption.withInPeriod - seconds >= 0?rewardRedemption.withInPeriod - seconds:0;
            if(rewardRedemption.withInPeriod == 0)
            {
                timeToCountDown = 0;
            }
            [_timeToCountDownList addObject:[NSNumber numberWithInteger:timeToCountDown]];
            NSNumber *objIndex = [NSNumber numberWithInt:i];
            [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer:) userInfo:objIndex repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            [_timerList addObject:timer];
            
            
            
            NSTimeInterval seconds2 = [[Utility setEndOfTheDay:rewardRedemption.usingEndDate] timeIntervalSinceDate:[Utility currentDateTime]];
            seconds2 = seconds2>0?seconds2:0;
            [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
            NSTimer *timer2 = [NSTimer scheduledTimerWithTimeInterval:seconds2 target:self selector:@selector(updateTimer2:) userInfo:objIndex repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            [_timerUsedList addObject:timer2];
        }
        
        
        [tbvData reloadData];
    }
}

-(void)updateTimer2:(NSTimer *)timer//---> สำหรับหมดอายุ ตาม enddate , พดหมดอายุก็ย้ายไป ถูกใช้แล้ว ควรจะหยุด timer ตัว countdown ด้วย  ,---> กรณีตัวย้ายไปถูกใช้แล้ว ให้ stop all timer and start new timers
{
    NSInteger index = [timer.userInfo integerValue];

    
    
    RewardRedemption *rewardRedemption = rewardRedemptionList[index];
    
    
    for(NSInteger i=0; i<[_timerList count]; i++)
    {
        NSTimer *timerCountDown = _timerList[i];
        NSTimer *timer2 = _timerUsedList[i];
        
        [timerCountDown invalidate];
        [timer2 invalidate];
    }
    
    
//    [_rewardPointUsedList addObject:rewardPoint];
//    [_promoCodeUsedList addObject:promoCode];
//    [_rewardRedemptionUsedList addObject:rewardRedemption];
//    [_rewardPointList removeObject:rewardPoint];
//    [_promoCodeList removeObject:promoCode];
    [rewardRedemptionList removeObject:rewardRedemption];
    
    
    
    [_timerList removeAllObjects];
    [_timerUsedList removeAllObjects];
    [_timeToCountDownList removeAllObjects];
    for(int i=0; i<[rewardRedemptionList count]; i++)
    {
        RewardRedemption *rewardRedemption = rewardRedemptionList[i];
//        RewardPoint *rewardPoint = _rewardPointList[i];
        NSTimeInterval seconds = [[Utility currentDateTime] timeIntervalSinceDate:rewardRedemption.redeemDate];
        NSInteger timeToCountDown = rewardRedemption.withInPeriod - seconds >= 0?rewardRedemption.withInPeriod - seconds:0;
        if(rewardRedemption.withInPeriod == 0)
        {
            timeToCountDown = 0;
        }
        [_timeToCountDownList addObject:[NSNumber numberWithInteger:timeToCountDown]];
        NSNumber *objIndex = [NSNumber numberWithInt:i];
        [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer:) userInfo:objIndex repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        [_timerList addObject:timer];
        
        
        
        NSTimeInterval seconds2 = [[Utility setEndOfTheDay:rewardRedemption.usingEndDate] timeIntervalSinceDate:[Utility currentDateTime]];
        seconds2 = seconds2>0?seconds2:0;
        [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
        NSTimer *timer2 = [NSTimer scheduledTimerWithTimeInterval:seconds2 target:self selector:@selector(updateTimer2:) userInfo:objIndex repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        [_timerUsedList addObject:timer2];
    }
    
    
    
    [tbvData reloadData];
}

- (void)populateLabelwithTime:(NSInteger)seconds index:(NSInteger)index
{
//    if(segConValue.selectedSegmentIndex == 0)
    {
        NSInteger minutes = seconds / 60;
        NSInteger hours = minutes / 60;
        
        seconds -= minutes * 60;
        minutes -= hours * 60;
        
        
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:1];
        CustomTableViewCellReward *cell = [tbvData cellForRowAtIndexPath:indexPath];
        RewardRedemption *rewardRedemption = rewardRedemptionList[index];
        if(rewardRedemption.withInPeriod == 0)
        {
            NSString *message = [Language getText:@"ใช้ได้ 1 ครั้ง ภายใน %@"];
            cell.lblCountDown.text = [NSString stringWithFormat:message,[Utility dateToString:rewardRedemption.usingEndDate toFormat:@"d MMM yyyy"]];
        }
        else
        {
            cell.lblCountDown.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hours, minutes, seconds];
        }
    }
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(section == 0)
    {
        return [promotionList count];
    }
    else if(section == 1)
    {
        return [rewardRedemptionList count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    if(section == 0)
    {
        Promotion *promotion = promotionList[item];
        if(promotion.type == 0)
        {
            CustomTableViewCellPromoBanner *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierPromoBanner];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.lblHeader.text = promotion.header;
            [cell.lblHeader sizeToFit];
            cell.lblHeaderHeight.constant = cell.lblHeader.frame.size.height>43?43:cell.lblHeader.frame.size.height;
            
            
            
            
            
            cell.lblSubTitle.text = promotion.subTitle;
            [cell.lblSubTitle sizeToFit];
            cell.lblSubTitleHeight.constant = cell.lblSubTitle.frame.size.height>37?37:cell.lblSubTitle.frame.size.height;
            
            
            
            [self.homeModel downloadImageWithFileName:promotion.imageUrl type:3 branchID:0 completionBlock:^(BOOL succeeded, UIImage *image)
             {
                 if (succeeded)
                 {
                     cell.imgVwValue.image = image;
                 }
             }];
            float imageWidth = cell.frame.size.width -2*16 > 375?375:cell.frame.size.width -2*16;
            cell.imgVwValueHeight.constant = imageWidth/16*9;
            cell.imgVwValue.contentMode = UIViewContentModeScaleAspectFit;
            
            
            
            return cell;
        }
        else
        {
            CustomTableViewCellPromoThumbNail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierPromoThumbNail];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.lblHeader.text = promotion.header;
            [cell.lblHeader sizeToFit];
            cell.lblHeaderHeight.constant = cell.lblHeader.frame.size.height>90?90:cell.lblHeader.frame.size.height;
            
            
            cell.lblSubTitle.text = promotion.subTitle;
            [cell.lblSubTitle sizeToFit];
            cell.lblSubTitleHeight.constant = 90-8-cell.lblHeaderHeight.constant<0?0:90-8-cell.lblHeaderHeight.constant;
            
            
            
            [self.homeModel downloadImageWithFileName:promotion.imageUrl type:3 branchID:0 completionBlock:^(BOOL succeeded, UIImage *image)
             {
                 if (succeeded)
                 {
                     cell.imgVwValue.image = image;
                 }
             }];
            
            
            
            return cell;
        }
    }
    else if(section == 1)
    {
        CustomTableViewCellReward *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierReward];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        RewardRedemption *rewardRedemption = rewardRedemptionList[item];
        cell.lblHeader.text = rewardRedemption.header;
        [cell.lblHeader sizeToFit];
        cell.lblHeaderHeight.constant = cell.lblHeader.frame.size.height>70?70:cell.lblHeader.frame.size.height;
        
        
        cell.lblSubTitle.text = rewardRedemption.subTitle;
        [cell.lblSubTitle sizeToFit];
        cell.lblSubTitleHeight.constant = 70-8-cell.lblHeaderHeight.constant<0?0:70-8-cell.lblHeaderHeight.constant;
        
        
        NSString *strPoint = [Utility formatDecimal:rewardRedemption.point];
        cell.lblRemark.text = [NSString stringWithFormat:@"%@ points",strPoint];
        [cell.lblRemark sizeToFit];
        cell.lblRemarkWidth.constant = cell.lblRemark.frame.size.width;
        
        
        Branch *branch = [Branch getBranch:rewardRedemption.mainBranchID];
        [self.homeModel downloadImageWithFileName:branch.imageUrl type:2 branchID:branch.branchID completionBlock:^(BOOL succeeded, UIImage *image)
         {
             if (succeeded)
             {
                 cell.imgVwValue.image = image;
                 [self setImageDesign:cell.imgVwValue];
             }
         }];
        
        
//        cell.lblCountDownTop.constant = 0;
//        cell.lblCountDownHeight.constant = 0;
        
        
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    if(section == 0)
    {
        Promotion *promotion = promotionList[item];
        if(promotion.type == 0)
        {
            CustomTableViewCellPromoBanner *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierPromoBanner];
            cell.lblHeader.text = promotion.header;
            [cell.lblHeader sizeToFit];
            cell.lblHeaderHeight.constant = cell.lblHeader.frame.size.height>43?43:cell.lblHeader.frame.size.height;
            
            
            
            
            
            cell.lblSubTitle.text = promotion.subTitle;
            [cell.lblSubTitle sizeToFit];
            cell.lblSubTitleHeight.constant = cell.lblSubTitle.frame.size.height>37?37:cell.lblSubTitle.frame.size.height;
            
            
            
            [self.homeModel downloadImageWithFileName:promotion.imageUrl type:3 branchID:0 completionBlock:^(BOOL succeeded, UIImage *image)
             {
                 if (succeeded)
                 {
                     cell.imgVwValue.image = image;
                 }
             }];
            float imageWidth = cell.frame.size.width -2*16 > 375?375:cell.frame.size.width -2*16;
            cell.imgVwValueHeight.constant = imageWidth/16*9;
            
            
            return 11+cell.lblHeaderHeight.constant+8+cell.lblSubTitleHeight.constant+8+cell.imgVwValueHeight.constant+11;
        }
        else
        {
            return 112;
        }
    }
    else if(section == 1)
    {
        return 139;
    }
    return 0;
    
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
    [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    if(section == 0)
    {
        Promotion *promotion = promotionList[item];
        selectedVoucherCode = promotion.voucherCode;
    }
    else if(section == 1)
    {
        RewardRedemption *rewardRedemption = rewardRedemptionList[item];
        selectedVoucherCode = rewardRedemption.voucherCode;
    }
    [self dismissViewController:nil];
}

- (IBAction)dismissViewController:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToCreditCardAndOrderSummary" sender:self];
}

@end
