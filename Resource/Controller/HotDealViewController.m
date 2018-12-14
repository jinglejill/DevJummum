//
//  HotDealViewController.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 23/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "HotDealViewController.h"
#import "HotDealDetailViewController.h"
#import "LuckyDrawViewController.h"
#import "PaymentCompleteViewController.h"
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
    NSInteger _page;
    NSInteger _perPage;
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
//    CustomViewController *vc = segue.sourceViewController;
//    if([vc isKindOfClass:[LuckyDrawViewController class]] || [vc isKindOfClass:[PaymentCompleteViewController class]])
//    {
//        [self searchBar:searchBar textDidChange:searchBar.text];
//    }
    
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
    
    
    [self searchBar:searchBar textDidChange:searchBar.text];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSString *title = [Language getText:@"Hot Deal"];
    lblNavTitle.text = title;
    
    
    tbvData.delegate = self;
    tbvData.dataSource = self;

    
    
    _page = 1;
    _perPage = 10;
    _lastItemReached = NO;
    searchBar.delegate = self;
    
    NSString *message = [Language getText:@"ค้นหาโปรโมชั่นร้าน"];
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
    
    
    [self loadingOverlayView];
    UserAccount *userAccount = [UserAccount getCurrentUserAccount];
    [self.homeModel downloadItems:dbHotDeal withData:@[searchBar.text,@(_page),@(_perPage),userAccount]];
    
    
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

        
        
        NSString *noImageFileName = [NSString stringWithFormat:@"/JMM/Image/NoImage.jpg"];
        NSString *imageFileName = [NSString stringWithFormat:@"/JMM/Image/Promotion/%@",promotion.imageUrl];
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
        
        
        if (!_lastItemReached && section == [_filterPromotionList count]-1)
        {
            UserAccount *userAccount = [UserAccount getCurrentUserAccount];
            self.homeModel = [[HomeModel alloc]init];
            self.homeModel.delegate = self;
            [self.homeModel downloadItems:dbHotDeal withData:@[searchBar.text,@(_page),@(_perPage),userAccount]];
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
        
        
        
        NSString *noImageFileName = [NSString stringWithFormat:@"/JMM/Image/NoImage.jpg"];
        NSString *imageFileName = [NSString stringWithFormat:@"/JMM/Image/Promotion/%@",promotion.imageUrl];
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
        
        
        
        if (!_lastItemReached && section == [_filterPromotionList count]-1)
        {
            UserAccount *userAccount = [UserAccount getCurrentUserAccount];
            self.homeModel = [[HomeModel alloc]init];
            self.homeModel.delegate = self;
            [self.homeModel downloadItems:dbHotDeal withData:@[searchBar.text,@(_page),@(_perPage),userAccount]];
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
        
        
    
        NSString *noImageFileName = [NSString stringWithFormat:@"/JMM/Image/NoImage.jpg"];
        NSString *imageFileName = [NSString stringWithFormat:@"/JMM/Image/Promotion/%@",promotion.imageUrl];
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
    _page = 1;
    _lastItemReached = NO;
    UserAccount *userAccount = [UserAccount getCurrentUserAccount];
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    [self.homeModel downloadItems:dbHotDeal withData:@[searchText,@(_page),@(_perPage),userAccount]];
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
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // this method is being called when search btn in the keyboard tapped
    // we set searchBarActive = NO
    // but no need to reloadCollectionView
    //    self.searchBarActive = NO;
    
    //    [self.searchBar setShowsCancelButton:NO animated:YES];
    [searchBar setShowsCancelButton:NO animated:YES];
}

-(void)cancelSearching
{
    self.searchBarActive = NO;
    [searchBar resignFirstResponder];
    searchBar.text  = @"";
    [self searchBar:searchBar textDidChange:searchBar.text];
}

-(void)itemsDownloaded:(NSArray *)items manager:(NSObject *)objHomeModel
{
    HomeModel *homeModel = (HomeModel *)objHomeModel;
    if(homeModel.propCurrentDB == dbHotDeal)
    {
        [self removeOverlayViews];
        [Utility updateSharedObject:items];
        if(_page == 1)
        {
            _filterPromotionList = items[0];
        }
        else
        {
            NSInteger remaining = [_filterPromotionList count]%_perPage;
            for(int i=0; i<remaining; i++)
            {
                [_filterPromotionList removeLastObject];
            }
            
            [_filterPromotionList addObjectsFromArray:items[0]];
        }
        
        
        if([items[0] count] < _perPage)
        {
            _lastItemReached = YES;
        }
        else
        {
            _page += 1;
        }
        
        
        [tbvData reloadData];
    }
}

@end
