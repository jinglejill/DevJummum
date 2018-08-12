//
//  HotDealViewController.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 23/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "HotDealViewController.h"
#import "HotDealDetailViewController.h"
#import "CustomTableViewCellPromoBanner.h"
#import "CustomTableViewCellPromoThumbNail.h"
#import "Promotion.h"
#import "Branch.h"
#import "Receipt.h"
#import "Setting.h"


@interface HotDealViewController ()
{
    NSMutableArray *_promotionList;
    NSMutableArray *_filterPromotionList;
    HomeModel *_homeModelDownload;
    
    Promotion *_promotion;
    BOOL _lastItemReached;
}
@property (nonatomic)        BOOL           searchBarActive;
@end

@implementation HotDealViewController
static NSString * const reuseIdentifierPromoBanner = @"CustomTableViewCellPromoBanner";
static NSString * const reuseIdentifierPromoThumbNail = @"CustomTableViewCellPromoThumbNail";


@synthesize lblNavTitle;
@synthesize tbvData;
@synthesize searchBar;
@synthesize topViewHeight;


-(IBAction)unwindToHotDeal:(UIStoryboardSegue *)segue
{
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    
    float topPadding = window.safeAreaInsets.top;
    topViewHeight.constant = topPadding == 0?20:topPadding;
    
    
    
    
    //cancel button in searchBar
    UIFont *font = [UIFont fontWithName:@"Prompt-SemiBold" size:15.0f];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil]
     setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:cSystem1, NSForegroundColorAttributeName,font, NSFontAttributeName, nil]
     forState:UIControlStateNormal];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    UserAccount *userAccount = [UserAccount getCurrentUserAccount];
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    //เพิ่งสั่งอาหารร้านนี้ไปครั้งแรก ในหน้านี้ก็จะ โหลดข้อมูล hotdeal จาก db ของร้านนี้มาแสดง
    NSInteger branchID = [Receipt getBranchIDWithMaxModifiedDateWithMemberID:userAccount.userAccountID];
    [self.homeModel downloadItems:dbHotDealWithBranchID withData:@[userAccount,@(branchID),@([_promotionList count])]];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSString *title = [Setting getValue:@"059t" example:@"Hot Deal"];
    lblNavTitle.text = title;
    
    
    UserAccount *userAccount = [UserAccount getCurrentUserAccount];
    [self.homeModel downloadItems:dbHotDeal withData:@[userAccount,@0]];
    tbvData.delegate = self;
    tbvData.dataSource = self;

    
    
    
    NSString *message = [Setting getValue:@"117m" example:@"ค้นหา Deal"];
    searchBar.delegate = self;
    searchBar.placeholder = message;
    [searchBar setInputAccessoryView:self.toolBar];
    UITextField *textField = [searchBar valueForKey:@"searchField"];
    textField.layer.borderColor = [cTextFieldBorder CGColor];
    textField.layer.borderWidth = 1;
    textField.font = [UIFont fontWithName:@"Prompt-Regular" size:14.0f];
    [self setTextFieldDesign:textField];
    

    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierPromoBanner bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierPromoBanner];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierPromoThumbNail bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierPromoThumbNail];
    }
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture setCancelsTouchesInView:NO];
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return [_filterPromotionList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    

    Promotion *promotion = _filterPromotionList[section];
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
                 NSLog(@"succeed");
                 cell.imgVwValue.image = image;
             }
         }];
        float imageWidth = cell.frame.size.width -2*16 > 375?375:cell.frame.size.width -2*16;
        cell.imgVwValueHeight.constant = imageWidth/16*9;
        cell.imgVwValue.contentMode = UIViewContentModeScaleAspectFit;
        NSLog(@"imgVwValueTop :%f",cell.imgVwValueTop.constant);
        
        
        if (!_lastItemReached && section == [_filterPromotionList count]-1)
        {
            UserAccount *userAccount = [UserAccount getCurrentUserAccount];
            self.homeModel = [[HomeModel alloc]init];
            self.homeModel.delegate = self;
            [self.homeModel downloadItems:dbHotDeal withData:@[userAccount,@([_promotionList count])]];
        }
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
                 NSLog(@"succeed");
                 cell.imgVwValue.image = image;                 
             }
         }];
        
        
        
        if (!_lastItemReached && section == [_filterPromotionList count]-1)
        {
            UserAccount *userAccount = [UserAccount getCurrentUserAccount];
            self.homeModel = [[HomeModel alloc]init];
            self.homeModel.delegate = self;
            [self.homeModel downloadItems:dbHotDeal withData:@[userAccount,@([_promotionList count])]];
        }
        return cell;
    }
    
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    Promotion *promotion = _filterPromotionList[section];
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
                 NSLog(@"succeed");
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
    
    _promotion = _filterPromotionList[section];
    [self performSegueWithIdentifier:@"segHotDealDetail" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segHotDealDetail"])
    {
        HotDealDetailViewController *vc = segue.destinationViewController;
        vc.promotion = _promotion;
    }
}

#pragma mark - search

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    if([Utility isStringEmpty:searchText])
    {
        _filterPromotionList = _promotionList;
        [tbvData reloadData];
    }
    else
    {
        NSPredicate *resultPredicate   = [NSPredicate predicateWithFormat:@"(_header contains[c] %@) or (_subTitle contains[c] %@) or (_termsConditions contains[c] %@)", searchText, searchText, searchText];
        _filterPromotionList = [[_promotionList filteredArrayUsingPredicate:resultPredicate] mutableCopy];
    }
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // user did type something, check our datasource for text that looks the same
    if (searchText.length>0)
    {
        // search and reload data source
        self.searchBarActive = YES;
        [self filterContentForSearchText:searchText scope:@""];
        [tbvData reloadData];
    }
    else
    {
        // if text length == 0
        // we will consider the searchbar is not active
        self.searchBarActive = NO;
        [self cancelSearching];
    }
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
//    UISearchBar *sbText = [self.view viewWithTag:300];
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // this method is being called when search btn in the keyboard tapped
    // we set searchBarActive = NO
    // but no need to reloadCollectionView
    //    self.searchBarActive = NO;
    
    //    [self.searchBar setShowsCancelButton:NO animated:YES];
//    UISearchBar *sbText = [self.view viewWithTag:300];
    [searchBar setShowsCancelButton:NO animated:YES];
}

-(void)cancelSearching
{
//    UISearchBar *sbText = [self.view viewWithTag:300];
    self.searchBarActive = NO;
    [searchBar resignFirstResponder];
    searchBar.text  = @"";
    [self filterContentForSearchText:searchBar.text scope:@""];
}

-(void)itemsDownloaded:(NSArray *)items manager:(NSObject *)objHomeModel
{
    HomeModel *homeModel = (HomeModel *)objHomeModel;
    if(homeModel.propCurrentDB == dbHotDeal)
    {
        if([items[0] count] == 0)
        {
            _lastItemReached = YES;
            return;
        }
        if(!_promotionList)
        {
            _promotionList = [[NSMutableArray alloc]init];
        }
        [_promotionList addObjectsFromArray:items[0]];
        _promotionList = [Promotion sortWithdataList:_promotionList];
        [self searchBar:searchBar textDidChange:searchBar.text];
    }
    else if(homeModel.propCurrentDB == dbHotDealWithBranchID)
    {
        //add update
        NSMutableArray *promotionList = items[0];
        if(!_promotionList)
        {
            _promotionList = [[NSMutableArray alloc]init];
        }
        BOOL update = [Utility updateDataList:promotionList dataList:_promotionList];
        if(update)
        {            
            _promotionList = [Promotion sortWithdataList:_promotionList];
            [self searchBar:searchBar textDidChange:searchBar.text];
        }
    }
}

@end
