//
//  RewardViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 4/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "RewardViewController.h"
#import "RewardDetailViewController.h"
#import "MyRewardViewController.h"
#import "CustomTableViewCellSearchBar.h"
#import "CustomTableViewCellReward.h"
#import "CustomTableViewCellLabelDetailLabelWithImage.h"
#import "RewardPoint.h"
#import "UserAccount.h"
#import "RewardRedemption.h"
#import "Branch.h"
#import "Receipt.h"
#import "Utility.h"
#import "Setting.h"


@interface RewardViewController ()
{
    RewardPoint *_rewardPoint;
    NSMutableArray *_rewardRedemptionList;
    NSMutableArray *_filterRewardRedemptionList;
    RewardRedemption *_rewardRedemption;
    BOOL _lastItemReached;
    NSInteger _page;
    NSInteger _perPage;
}

@property (nonatomic)        BOOL           searchBarActive;
@end

@implementation RewardViewController
static float const SEARCH_BAR_HEIGHT = 56;
static NSString * const reuseIdentifierSearchBar = @"CustomTableViewCellSearchBar";
static NSString * const reuseIdentifierReward = @"CustomTableViewCellReward";
static NSString * const reuseIdentifierLabelDetailLabelWithImage = @"CustomTableViewCellLabelDetailLabelWithImage";


@synthesize lblNavTitle;
@synthesize tbvData;
@synthesize topViewHeight;


-(IBAction)unwindToReward:(UIStoryboardSegue *)segue
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    CustomTableViewCellLabelDetailLabelWithImage *cell = [tbvData cellForRowAtIndexPath:indexPath];
    NSInteger point = (int)floor(_rewardPoint.point);
    NSString *strPoint = [Utility formatDecimal:point];
    cell.lblValue.text = [NSString stringWithFormat:@"%@ points",strPoint];
    [cell.lblValue sizeToFit];
    cell.lblValueWidth.constant = cell.lblValue.frame.size.width;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIWindow *window = UIApplication.sharedApplication.keyWindow;    
    
    float topPadding = window.safeAreaInsets.top;
    topViewHeight.constant = topPadding == 0?20:topPadding;
}

-(void)loadView
{
    [super loadView];
    

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSString *title = [Language getText:@"แต้มสะสม/แลกของรางวัล"];
    lblNavTitle.text = title;
    
    tbvData.delegate = self;
    tbvData.dataSource = self;
    
    _page = 1;
    _perPage = 10;
    _lastItemReached = NO;
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierSearchBar bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierSearchBar];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierReward bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierReward];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelDetailLabelWithImage bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelDetailLabelWithImage];
    }
    
    
    [self loadingOverlayView];
    UserAccount *userAccount = [UserAccount getCurrentUserAccount];
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    [self.homeModel downloadItems:dbRewardPoint withData:@[@"",@(_page),@(_perPage),userAccount]];
    
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if(section == 0)
    {
        return 1;
    }
    else if(section == 1)
    {
        return 2;
    }
    else
    {
        return [_filterRewardRedemptionList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    if(section == 0)
    {        
        CustomTableViewCellSearchBar *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierSearchBar];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.sbText.delegate = self;
        cell.sbText.tag = 300;
        cell.sbText.placeholder = [Language getText:@"ค้นหา Reward"];
        [cell.sbText setInputAccessoryView:self.toolBar];
        UITextField *textField = [cell.sbText valueForKey:@"searchField"];
        textField.layer.borderColor = [cTextFieldBorder CGColor];
        textField.layer.borderWidth = 1;
        textField.font = [UIFont fontWithName:@"Prompt-Regular" size:14.0f];
        [self setTextFieldDesign:textField];
        
        
        //cancel button in searchBar
        UIFont *font = [UIFont fontWithName:@"Prompt-SemiBold" size:15.0f];
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil]
         setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:cSystem1, NSForegroundColorAttributeName,font, NSFontAttributeName, nil]
         forState:UIControlStateNormal];
        
        
        return cell;
    }
    else if(section == 1)
    {
        if(item == 0)
        {
            CustomTableViewCellLabelDetailLabelWithImage *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelDetailLabelWithImage];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            

            cell.lblText.text = [Language getText:@"แต้มสะสม"];
            cell.lblText.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15.0f];
            NSInteger point = (int)floor(_rewardPoint.point);
            NSString *strPoint = [Utility formatDecimal:point];
            cell.lblValue.text = [NSString stringWithFormat:@"%@ points",strPoint];
            cell.lblValue.textColor = cSystem2;
            [cell.lblValue sizeToFit];
            cell.lblValueWidth.constant = cell.lblValue.frame.size.width;
            
            
            return cell;
        }
        else
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            }
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = [Language getText:@"รางวัลของฉัน"];
            cell.textLabel.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15.0f];
            cell.textLabel.textColor = cSystem4;
            
            
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            
            
            return cell;
        }
    }
    else
    {
        CustomTableViewCellReward *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierReward];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        RewardRedemption *rewardRedemption = _filterRewardRedemptionList[item];
        cell.lblHeader.text = rewardRedemption.header;
        [cell.lblHeader sizeToFit];
        cell.lblHeaderHeight.constant = cell.lblHeader.frame.size.height>70?70:cell.lblHeader.frame.size.height;
        
        
        cell.lblSubTitle.text = rewardRedemption.subTitle;
        [cell.lblSubTitle sizeToFit];
        

        cell.lblSubTitleHeight.constant = 70-8-cell.lblHeaderHeight.constant<0?0:70-8-cell.lblHeaderHeight.constant;
        NSLog(@"left space: %f",70-8-cell.lblHeaderHeight.constant);
        NSLog(@"cell.lblHeaderHeight.constant: %f",cell.lblHeaderHeight.constant);
        NSLog(@"update cell.lblSubTitleHeight.constant: %f",cell.lblSubTitleHeight.constant);
        
        
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
        
        
        cell.lblCountDownTop.constant = 0;
        cell.lblCountDownHeight.constant = 0;
        
        
        if (!_lastItemReached && item == [_filterRewardRedemptionList count]-1)
        {
            UserAccount *userAccount = [UserAccount getCurrentUserAccount];
            self.homeModel = [[HomeModel alloc]init];
            self.homeModel.delegate = self;
            [self.homeModel downloadItems:dbRewardPoint withData:@[@"",@(_page),@(_perPage),userAccount]];
        }
        
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if(section == 0)
    {
        return SEARCH_BAR_HEIGHT;
    }
    else if(section == 1)
    {
        return 44;
    }
    else if(section == 2)
    {
        return 112;
    }
    return 44;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if([tableView isEqual:tbvData])
    {
        if (section == 0)
        {
            return CGFLOAT_MIN;
        }

        return tableView.sectionHeaderHeight;
    }

    return CGFLOAT_MIN;
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
    if(section == 1 && item == 1)
    {
        [self performSegueWithIdentifier:@"segMyReward" sender:self];
    }
    else if(section == 2)
    {
        _rewardRedemption = _filterRewardRedemptionList[item];
        [self performSegueWithIdentifier:@"segRewardDetail" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"segRewardDetail"])
    {
        RewardDetailViewController *vc = segue.destinationViewController;
        vc.rewardPoint = _rewardPoint;
        vc.rewardRedemption = _rewardRedemption;
    }
    else if([segue.identifier isEqualToString:@"segMyReward"])
    {
        MyRewardViewController *vc = segue.destinationViewController;
        vc.rewardPoint = _rewardPoint;
    }
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToMe" sender:self];
}

-(void)itemsDownloaded:(NSArray *)items manager:(NSObject *)objHomeModel
{
    
    HomeModel *homeModel = (HomeModel *)objHomeModel;
    if(homeModel.propCurrentDB == dbRewardPoint)
    {
        [self removeOverlayViews];
        [Utility updateSharedObject:items];
        
        //rewardPoint
        NSMutableArray *rewardPointList = items[0];
        _rewardPoint = rewardPointList[0];
        
        NSRange range = NSMakeRange(1, 1);
        NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
        [tbvData reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
        
        
        
        
        //rewardRedemptionList
        if(_page == 1)
        {
            _filterRewardRedemptionList = items[1];
        }
        else
        {
            NSInteger remaining = [_filterRewardRedemptionList count]%_perPage;
            for(int i=0; i<remaining; i++)
            {
                [_filterRewardRedemptionList removeLastObject];
            }
            
            [_filterRewardRedemptionList addObjectsFromArray:items[0]];
        }
        
        
        if([items[0] count] < _perPage)
        {
            _lastItemReached = YES;
        }
        else
        {
            _page += 1;
        }
        
        {
            NSRange range = NSMakeRange(2, 1);
            NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
            [tbvData reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

#pragma mark - search

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    if([Utility isStringEmpty:searchText])
    {
        _filterRewardRedemptionList = _rewardRedemptionList;
        NSRange range = NSMakeRange(2, 1);
        NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
        [tbvData reloadSections:section withRowAnimation:UITableViewRowAnimationNone];

    }
    else
    {
        NSPredicate *resultPredicate   = [NSPredicate predicateWithFormat:@"(_header contains[c] %@) or (_subTitle contains[c] %@) or (_termsConditions contains[c] %@) or (_point contains[c] %@)", searchText, searchText, searchText];
        _filterRewardRedemptionList = [[_rewardRedemptionList filteredArrayUsingPredicate:resultPredicate] mutableCopy];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // user did type something, check our datasource for text that looks the same
    if (searchText.length>0)
    {
        // search and reload data source
        self.searchBarActive = YES;
    }
    else
    {
        // if text length == 0
        // we will consider the searchbar is not active
        self.searchBarActive = NO;
    }
    
    
    [self loadingOverlayView];
    _page = 1;
    _lastItemReached = NO;
    UserAccount *userAccount = [UserAccount getCurrentUserAccount];
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    [self.homeModel downloadItems:dbRewardPoint withData:@[searchText,@(_page),@(_perPage),userAccount]];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self cancelSearching];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchBarActive = YES;
    [self.view endEditing:YES];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // we used here to set self.searchBarActive = YES
    // but we'll not do that any more... it made problems
    // it's better to set self.searchBarActive = YES when user typed something
    //    [self.searchBar setShowsCancelButton:YES animated:YES];
    UISearchBar *sbText = [self.view viewWithTag:300];
    [sbText setShowsCancelButton:YES animated:YES];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // this method is being called when search btn in the keyboard tapped
    // we set searchBarActive = NO
    // but no need to reloadCollectionView
    //    self.searchBarActive = NO;
    
    //    [self.searchBar setShowsCancelButton:NO animated:YES];
    UISearchBar *sbText = [self.view viewWithTag:300];
    [sbText setShowsCancelButton:NO animated:YES];
}
-(void)cancelSearching
{
    UISearchBar *sbText = [self.view viewWithTag:300];
    self.searchBarActive = NO;
    [sbText resignFirstResponder];
    sbText.text  = @"";
    [self searchBar:sbText textDidChange:sbText.text];
}

@end
