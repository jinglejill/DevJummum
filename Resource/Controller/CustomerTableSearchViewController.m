//
//  CustomerTableSearchViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 7/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomerTableSearchViewController.h"
#import "MenuSelectionViewController.h"
#import "CustomTableViewCellMenu.h"
#import "CustomTableViewCellSearchBar.h"
#import "CustomerTable.h"
#import "Setting.h"


@interface CustomerTableSearchViewController ()
{
    NSMutableArray *_customerTableZoneList;
    NSMutableArray *_customerTableList;
    CustomerTable *_selectedCustomerTable;
    NSMutableArray *_filterCustomerTableList;
    NSInteger _selectedZoneIndex;
}


@property (nonatomic)        BOOL           searchBarActive;
@end

@implementation CustomerTableSearchViewController
static float const SEARCH_BAR_HEIGHT = 56;
static NSString * const reuseIdentifierMenu = @"CustomTableViewCellMenu";
static NSString * const reuseIdentifierSearchBar = @"CustomTableViewCellSearchBar";


@synthesize lblNavTitle;
@synthesize tbvCustomerTable;
@synthesize branch;
@synthesize vwBottomShadow;
@synthesize fromCreditCardAndOrderSummaryMenu;
@synthesize customerTable;
@synthesize btnBack;
@synthesize topViewHeight;


-(IBAction)unwindToCustomerTableSearch:(UIStoryboardSegue *)segue
{
    
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
    
    
    if(fromCreditCardAndOrderSummaryMenu)
    {
        [btnBack setImage:nil forState:UIControlStateNormal];
    }
    else
    {
        btnBack.imageView.image = [UIImage imageNamed:@"home_icon_red.png"];
    }
    
    [self setShadow:vwBottomShadow];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSString *title = [Language getText:@"เลือกโต๊ะ"];
    lblNavTitle.text = title;
    tbvCustomerTable.delegate = self;
    tbvCustomerTable.dataSource = self;

    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierMenu bundle:nil];
        [tbvCustomerTable registerNib:nib forCellReuseIdentifier:reuseIdentifierMenu];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierSearchBar bundle:nil];
        [tbvCustomerTable registerNib:nib forCellReuseIdentifier:reuseIdentifierSearchBar];
    }
    
    
    [self.homeModel downloadItems:dbCustomerTable withData:branch];
    
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if([tableView isEqual:tbvCustomerTable])
    {
        if(section == 0)
        {
            return 1;
        }
        else
        {
            NSString *zone = _customerTableZoneList[_selectedZoneIndex];
            NSMutableArray *customerTableList = [CustomerTable getCustomerTableListWithZone:zone customerTableList:_filterCustomerTableList];
            return [customerTableList count];
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    if([tableView isEqual:tbvCustomerTable])
    {
        if(section == 0)
        {
            
            CustomTableViewCellSearchBar *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierSearchBar];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.sbText.delegate = self;
            cell.sbText.tag = 300;
            cell.sbText.placeholder = [Language getText:@"ค้นหาเบอร์โต๊ะ"];
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
        else
        {
            CustomTableViewCellMenu *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierMenu];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            
            NSString *zone = _customerTableZoneList[_selectedZoneIndex];
            NSMutableArray *customerTableList = [CustomerTable getCustomerTableListWithZone:zone customerTableList:_filterCustomerTableList];
            CustomerTable *customerTable = customerTableList[item];
            
            
            cell.lblPrice.hidden = YES;
            cell.lblSpecialPrice.hidden = YES;
            cell.lblQuantity.hidden = YES;
            cell.imgTriangle.hidden = YES;
            cell.imgMenuPic.hidden = YES;
            cell.imgMenuPicWidthConstant.constant = 0;
            cell.lblMenuName.text = customerTable.tableName;
            
            
            return cell;
        }
        
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:tbvCustomerTable])
    {
        if(indexPath.section == 0)
        {
            return SEARCH_BAR_HEIGHT;
        }
        else
        {
            return 44;
        }
        
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
    
    
    if([tableView isEqual:tbvCustomerTable])
    {
        if(section == 1)
        {
            if(fromCreditCardAndOrderSummaryMenu)
            {
                NSString *zone = _customerTableZoneList[_selectedZoneIndex];
                NSMutableArray *customerTableList = [CustomerTable getCustomerTableListWithZone:zone customerTableList:_filterCustomerTableList];
                customerTable = customerTableList[item];
                [self performSegueWithIdentifier:@"segUnwindToCreditCardAndOrderSummary" sender:self];
            }
            else
            {
                NSString *zone = _customerTableZoneList[_selectedZoneIndex];
                NSMutableArray *customerTableList = [CustomerTable getCustomerTableListWithZone:zone customerTableList:_filterCustomerTableList];
                
                
                CustomerTable *customerTable = customerTableList[indexPath.item];
                _selectedCustomerTable = customerTable;
                [self performSegueWithIdentifier:@"segMenuSelection" sender:self];
            }
            
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segMenuSelection"])
    {
        MenuSelectionViewController *vc = segue.destinationViewController;
        vc.branch = branch;
        vc.customerTable = _selectedCustomerTable;
    }
}

#pragma mark - search

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    if([Utility isStringEmpty:searchText])
    {
        _filterCustomerTableList = _customerTableList;
        NSRange range = NSMakeRange(1, 1);
        NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
        [tbvCustomerTable reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
    }
    else
    {
        NSPredicate *resultPredicate   = [NSPredicate predicateWithFormat:@"(_tableName contains[c] %@)", searchText];
        _filterCustomerTableList = [[_customerTableList filteredArrayUsingPredicate:resultPredicate] mutableCopy];
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
        NSRange range = NSMakeRange(1, 1);
        NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
        [tbvCustomerTable reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
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
    [self filterContentForSearchText:sbText.text scope:@""];
    
}

- (IBAction)goBackHome:(id)sender
{
//    [self performSegueWithIdentifier:@"segUnwindToQRCodeScanTable" sender:self];
    if(fromCreditCardAndOrderSummaryMenu)
    {
        [self performSegueWithIdentifier:@"segUnwindToCreditCardAndOrderSummary" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"segUnwindToBranchSearch" sender:self];
    }
    
}

- (void)createHorizontalScroll
{
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    float topPadding = window.safeAreaInsets.top;
    topPadding = topPadding == 0?20:topPadding;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topPadding+44, self.view.frame.size.width, 44)];
    scrollView.delegate = self;
    int buttonX = 15;
    for (int i = 0; i < [_customerTableZoneList count]; i++)
    {
        NSString *zone = _customerTableZoneList[i];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, 0, 100, 44)];
        button.titleLabel.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
        if(i==0)
        {
            [button setTitleColor:cSystem1 forState:UIControlStateNormal];
        }
        else
        {
            [button setTitleColor:cSystem4 forState:UIControlStateNormal];
        }
        [button setTitle:zone forState:UIControlStateNormal];
        [button sizeToFit];
        [scrollView addSubview:button];
        buttonX = 15 + buttonX+button.frame.size.width;
        [button addTarget:self action:@selector(zoneSelected:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i+1;
        
        CGRect frame = button.frame;
        frame.size.height = 2;
        frame.origin.y = button.frame.origin.y + button.frame.size.height-2;
        
        UIView *highlightBottomBorder = [[UIView alloc]initWithFrame:frame];
        highlightBottomBorder.backgroundColor = cSystem2;
        highlightBottomBorder.tag = i+1+100;
        highlightBottomBorder.hidden = i!=0;
        [scrollView addSubview:highlightBottomBorder];
    }
    
    scrollView.contentSize = CGSizeMake(buttonX, scrollView.frame.size.height);
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    
}

-(void)zoneSelected:(UIButton*)sender
{
    UIButton *button = sender;
    _selectedZoneIndex = button.tag-1;
    
    
    for(int i=1; i<=[_customerTableZoneList count]; i++)
    {
        UIButton *eachButton = [self.view viewWithTag:i];
        [eachButton setTitleColor:cSystem4 forState:UIControlStateNormal];
        
        
        UIView *highlightBottomBorder = [self.view viewWithTag:i+100];
        highlightBottomBorder.hidden = YES;
    }
    
    
    [button setTitleColor:cSystem1 forState:UIControlStateNormal];
    UIView *highlightBottomBorder = [self.view viewWithTag:button.tag+100];
    highlightBottomBorder.hidden = NO;
    
    
    
    
    
    [tbvCustomerTable reloadData];
    if([_customerTableZoneList count]>0)
    {
        NSString *zone = _customerTableZoneList[_selectedZoneIndex];
        NSMutableArray *customerTableList = [CustomerTable getCustomerTableListWithZone:zone customerTableList:_filterCustomerTableList];
        if([customerTableList count]>0)
        {
            [tbvCustomerTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        else
        {
            [tbvCustomerTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }
    else
    {
        [tbvCustomerTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

-(void)setData
{
    _customerTableList = [CustomerTable getCustomerTableListWithBranchID:branch.branchID];
    _customerTableList = [CustomerTable getCustomerTableListWithType:1 status:1 customerTableList:_customerTableList];
    _customerTableZoneList = [CustomerTable getCustomerTableZoneListWithType:1 status:1 customerTableList:_customerTableList];
    
    _filterCustomerTableList = _customerTableList;
    
    
    [self createHorizontalScroll];
    [tbvCustomerTable reloadData];
    
    
    if([_customerTableZoneList count]>0)
    {
        NSString *zone = _customerTableZoneList[0];
        NSMutableArray *customerTableList = [CustomerTable getCustomerTableListWithZone:zone customerTableList:_filterCustomerTableList];
        if([customerTableList count]>0)
        {
            [tbvCustomerTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        else
        {
            [tbvCustomerTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }
    else
    {
        [tbvCustomerTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

-(void)itemsDownloaded:(NSArray *)items manager:(NSObject *)objHomeModel
{
    [Utility updateSharedObject:items];
    [self setData];
}

@end
