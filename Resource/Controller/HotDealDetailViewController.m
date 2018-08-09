//
//  HotDealDetailViewController.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 26/6/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "HotDealDetailViewController.h"
#import "CustomTableViewCellRewardDetail.h"
#import "CustomTableViewCellLabel.h"
#import "Branch.h"
#import "Setting.h"


@interface HotDealDetailViewController ()
{
    NSInteger _expandCollapse;//1=expand,0=collapse
}
@end

@implementation HotDealDetailViewController
static NSString * const reuseIdentifierRewardDetail = @"CustomTableViewCellRewardDetail";
static NSString * const reuseIdentifierLabel = @"CustomTableViewCellLabel";


@synthesize lblNavTitle;
@synthesize tbvData;
@synthesize promotion;
@synthesize topViewHeight;


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
    
    
    
    NSString *title = [Setting getValue:@"060t" example:@"Hot Deal"];
    lblNavTitle.text = title;
    _expandCollapse = 1;
    tbvData.delegate = self;
    tbvData.dataSource = self;
    
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierRewardDetail bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierRewardDetail];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabel bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierLabel];
    }
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    if(item == 0)
    {
        CustomTableViewCellRewardDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierRewardDetail];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
        [self.homeModel downloadImageWithFileName:promotion.imageUrl type:3 branchID:0 completionBlock:^(BOOL succeeded, UIImage *image)
         {
             if (succeeded)
             {
                 NSLog(@"succeed");
                 cell.imgVwValue.image = image;
             }
         }];
        float imageWidth = cell.frame.size.width -2*16 > 375?375:cell.frame.size.width -2*16;
        cell.imgVwValueHeight.constant = imageWidth/16*9;
        cell.imgVwValue.contentMode = UIViewContentModeScaleAspectFit;
        
        
        
        cell.lblHeader.text = promotion.header;
        [cell.lblHeader sizeToFit];
        cell.lblHeaderHeight.constant = cell.lblHeader.frame.size.height;
        
        
        cell.lblSubTitle.text = promotion.subTitle;
        [cell.lblSubTitle sizeToFit];
        cell.lblSubTitleHeight.constant = cell.lblSubTitle.frame.size.height;
        
        
        cell.lblRemark.hidden = YES;
        cell.lblRemark.text = @"";//[NSString stringWithFormat:@"%ld points",rewardRedemption.point];
        [cell.lblRemark sizeToFit];
        cell.lblRemarkWidth.constant = cell.lblRemark.frame.size.width;

        
        cell.imgRemark.hidden = YES;
        
        return cell;
    }
    else if(item == 1)
    {
        CustomTableViewCellLabel *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.lblTextLabel.text = promotion.termsConditions;
        [cell.lblTextLabel sizeToFit];        
        cell.lblTextLabelHeight.constant = _expandCollapse?cell.lblTextLabel.frame.size.height:0;
        
        
        
        UIImage *image = _expandCollapse?[UIImage imageNamed:@"collapse2.png"]:[UIImage imageNamed:@"expand2.png"];
        [cell.btnValue setBackgroundImage:image forState:UIControlStateNormal];
        [cell.btnValue addTarget:self action:@selector(expandCollapse:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = indexPath.item;
    
    if(item == 0)
    {
        CustomTableViewCellRewardDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierRewardDetail];
        
        
        
        [self.homeModel downloadImageWithFileName:promotion.imageUrl type:3 branchID:0 completionBlock:^(BOOL succeeded, UIImage *image)
         {
             if (succeeded)
             {
                 NSLog(@"succeed");
                 cell.imgVwValue.image = image;
             }
         }];
        float imageWidth = cell.frame.size.width -2*16 > 375?375:cell.frame.size.width -2*16;
        cell.imgVwValueHeight.constant = imageWidth/16*9;
        
        
        
        cell.lblHeader.text = promotion.header;
        [cell.lblHeader sizeToFit];
        cell.lblHeaderHeight.constant = cell.lblHeader.frame.size.height;
        
        
        cell.lblSubTitle.text = promotion.subTitle;
        [cell.lblSubTitle sizeToFit];
        cell.lblSubTitleHeight.constant = cell.lblSubTitle.frame.size.height;
        
        
        
        
        return 11+cell.imgVwValueHeight.constant+20+cell.lblHeaderHeight.constant+8+cell.lblSubTitleHeight.constant+8+18+11;
    }
    else
    {
        CustomTableViewCellLabel *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabel];
        
        
        cell.lblTextLabel.text = promotion.termsConditions;
        [cell.lblTextLabel sizeToFit];
        cell.lblTextLabelHeight.constant = cell.lblTextLabel.frame.size.height;
        
        return 49+cell.lblTextLabelHeight.constant+20;
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
    
    
}


- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToHotDeal" sender:self];
}

-(void)expandCollapse:(id)sender
{
    _expandCollapse = !_expandCollapse;
    [tbvData reloadData];
}
@end
