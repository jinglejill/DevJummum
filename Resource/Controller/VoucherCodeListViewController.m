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
#import "Time.h"


@interface VoucherCodeListViewController ()
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
    
    

    for(int i=0; i<[rewardRedemptionList count]; i++)
    {
        //timeToCountDown กับ UsingEndDate เช็คทั้งสอง ว่า อันไหนหมดก่อนกัน เช็คพร้อมกันใช้ timer อันเดียว
        //พอเวลาหมดก็ invalidate แล้ว remove rewardRedemption
        //หาก withInPeriod = 0 ไม่ต้อง countDown ให้เช็ค usingEndDate อย่างเดียว
        RewardRedemption *rewardRedemption = rewardRedemptionList[i];
        if(rewardRedemption.withInPeriod == 0)
        {
            NSTimeInterval seconds2 = [[Utility setEndOfTheDay:rewardRedemption.usingEndDate] timeIntervalSinceDate:[Utility currentDateTime]];
            NSInteger timeToCountDownUsingEndDate = seconds2>0?seconds2:0;
            
            
            [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:timeToCountDownUsingEndDate target:self selector:@selector(updateTimer2:) userInfo:rewardRedemption repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        }
        else
        {
            NSTimeInterval seconds = [[Utility currentDateTime] timeIntervalSinceDate:rewardRedemption.redeemDate];
            NSInteger timeToCountDown = rewardRedemption.withInPeriod - seconds >= 0?rewardRedemption.withInPeriod - seconds:0;
            
            
            NSTimeInterval seconds2 = [[Utility setEndOfTheDay:rewardRedemption.usingEndDate] timeIntervalSinceDate:[Utility currentDateTime]];
            NSInteger timeToCountDownUsingEndDate = seconds2>0?seconds2:0;
            
            
            timeToCountDown = timeToCountDown <= timeToCountDownUsingEndDate?timeToCountDown:timeToCountDownUsingEndDate;
            Time *time = [[Time alloc]init];
            time.countDown = timeToCountDown;
            
            
            [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer:) userInfo:@[rewardRedemption, time] repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        }
    }
}

-(void)updateTimer:(NSTimer *)timer
{
    NSArray *dataList = timer.userInfo;
    RewardRedemption *rewardRedemptionSelected = dataList[0];
    Time *time = dataList[1];
    time.countDown--;
    time.countDown = time.countDown < 0?0:time.countDown;
    

    
    
    
    [self populateLabelwithTime:time.countDown rewardRedemption:rewardRedemptionSelected];
    if(time.countDown == 0)
    {
        [timer invalidate];
        [rewardRedemptionList removeObject:rewardRedemptionSelected];
        [tbvData reloadData];
    }
}

-(void)updateTimer2:(NSTimer *)timer
{
    RewardRedemption *rewardRedemptionSelected = timer.userInfo;
    [rewardRedemptionList removeObject:rewardRedemptionSelected];
    [tbvData reloadData];
}

- (void)populateLabelwithTime:(NSInteger)seconds rewardRedemption:(RewardRedemption *)rewardRedemptionSelected
{
    NSInteger minutes = seconds / 60;
    NSInteger hours = minutes / 60;

    seconds -= minutes * 60;
    minutes -= hours * 60;



    NSInteger index = [RewardRedemption getIndexOfObject:rewardRedemptionSelected rewardRedemptionList:rewardRedemptionList];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:1];
    CustomTableViewCellReward *cell = [tbvData cellForRowAtIndexPath:indexPath];
    cell.lblCountDown.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hours, minutes, seconds];
    
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
            
            
            
            NSString *strPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
            NSString *noImageFileName = [NSString stringWithFormat:@"%@/JMM/Image/NoImage.jpg",strPath];
            NSString *imageFileName = [NSString stringWithFormat:@"%@/JMM/Image/Promotion/%@",strPath,promotion.imageUrl];
            imageFileName = [Utility isStringEmpty:promotion.imageUrl]?noImageFileName:imageFileName;
            UIImage *image = [Utility getImageFromCache:imageFileName];
            if(image)
            {
                cell.imgVwValue.image = image;
            }
            else
            {
                [self.homeModel downloadImageWithFileName:promotion.imageUrl type:3 branchID:0 completionBlock:^(BOOL succeeded, UIImage *image)
                 {
                     if (succeeded)
                     {
                         [Utility saveImageInCache:image imageName:imageFileName];
                         cell.imgVwValue.image = image;
                     }
                 }];
            }
            
            
            
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
            
            
            
            NSString *strPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
            NSString *noImageFileName = [NSString stringWithFormat:@"%@/JMM/Image/NoImage.jpg",strPath];
            NSString *imageFileName = [NSString stringWithFormat:@"%@/JMM/Image/Promotion/%@",strPath,promotion.imageUrl];
            imageFileName = [Utility isStringEmpty:promotion.imageUrl]?noImageFileName:imageFileName;
            UIImage *image = [Utility getImageFromCache:imageFileName];
            if(image)
            {
                cell.imgVwValue.image = image;
            }
            else
            {
                [self.homeModel downloadImageWithFileName:promotion.imageUrl type:3 branchID:0 completionBlock:^(BOOL succeeded, UIImage *image)
                 {
                     if (succeeded)
                     {
                         [Utility saveImageInCache:image imageName:imageFileName];
                         cell.imgVwValue.image = image;
                     }
                 }];
            }
            
            
            
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
        NSString *strPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *noImageFileName = [NSString stringWithFormat:@"%@/JMM/%@/Image/NoImage.jpg",strPath,branch.dbName];
        NSString *imageFileName = [NSString stringWithFormat:@"%@/JMM/%@/Image/Logo/%@",strPath,branch.dbName,branch.imageUrl];
        imageFileName = [Utility isStringEmpty:branch.imageUrl]?noImageFileName:imageFileName;
        UIImage *image = [Utility getImageFromCache:imageFileName];
        if(image)
        {
            cell.imgVwValue.image = image;
        }
        else
        {
            [self.homeModel downloadImageWithFileName:branch.imageUrl type:2 branchID:branch.branchID completionBlock:^(BOOL succeeded, UIImage *image)
             {
                 if (succeeded)
                 {
                     [Utility saveImageInCache:image imageName:imageFileName];
                     cell.imgVwValue.image = image;
                 }
             }];
        }
        [self setImageDesign:cell.imgVwValue];
        

        
        if(rewardRedemption.withInPeriod == 0)
        {
            NSString *message = [Language getText:@"ใช้ได้ 1 ครั้ง ภายใน %@"];
            cell.lblCountDown.text = [NSString stringWithFormat:message,[Utility dateToString:rewardRedemption.usingEndDate toFormat:@"d MMM yyyy"]];
        }


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
            
            
            
            NSString *strPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
            NSString *noImageFileName = [NSString stringWithFormat:@"%@/JMM/Image/NoImage.jpg",strPath];
            NSString *imageFileName = [NSString stringWithFormat:@"%@/JMM/Image/Promotion/%@",strPath,promotion.imageUrl];
            imageFileName = [Utility isStringEmpty:promotion.imageUrl]?noImageFileName:imageFileName;
            UIImage *image = [Utility getImageFromCache:imageFileName];
            if(image)
            {
                cell.imgVwValue.image = image;
            }
            else
            {
                [self.homeModel downloadImageWithFileName:promotion.imageUrl type:3 branchID:0 completionBlock:^(BOOL succeeded, UIImage *image)
                 {
                     if (succeeded)
                     {
                         [Utility saveImageInCache:image imageName:imageFileName];
                         cell.imgVwValue.image = image;
                     }
                 }];
            }
            
            
            
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
