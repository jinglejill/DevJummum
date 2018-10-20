//
//  BranchSearchViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 28/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "BranchSearchViewController.h"
#import "CustomerTableSearchViewController.h"
#import "CreditCardAndOrderSummaryViewController.h"
#import "MenuSelectionViewController.h"
#import "CustomTableViewCellMenu.h"
#import "Branch.h"
#import "Setting.h"


@interface BranchSearchViewController ()
{
    Branch *_selectedBranch;
    NSMutableArray *_filterBranchList;
    NSInteger _fromReceiptSummaryMenu;
    CustomerTable *_customerTable;
    BOOL _lastItemReached;
    NSInteger _page;
    NSInteger _perPage;
}


@property (nonatomic)        BOOL           searchBarActive;
@end

@implementation BranchSearchViewController
static NSString * const reuseIdentifierMenu = @"CustomTableViewCellMenu";


@synthesize lblNavTitle;
@synthesize tbvBranch;
@synthesize sbText;
@synthesize topViewHeight;


-(IBAction)unwindToBranchSearch:(UIStoryboardSegue *)segue
{

}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToQRCodeScanTable" sender:self];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    
    
    float topPadding = window.safeAreaInsets.top;
    topViewHeight.constant = topPadding == 0?20:topPadding;
    
    
    sbText.placeholder = [Language getText:@"ค้นหาร้านอาหาร"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
       
    
    NSString *title = [Language getText:@"เลือกร้าน"];
    lblNavTitle.text = title;
    tbvBranch.delegate = self;
    tbvBranch.dataSource = self;
    
    _page = 1;
    _perPage = 10;
    _lastItemReached = NO;
    sbText.delegate = self;
    [sbText setInputAccessoryView:self.toolBar];
    UITextField *textField = [sbText valueForKey:@"searchField"];
    textField.layer.borderColor = [cTextFieldBorder CGColor];
    textField.layer.borderWidth = 1;
    textField.font = [UIFont fontWithName:@"Prompt-Regular" size:14.0f];
    [self setTextFieldDesign:textField];
    [sbText becomeFirstResponder];
    
    
    //cancel button in searchBar
    UIFont *font = [UIFont fontWithName:@"Prompt-SemiBold" size:15.0f];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil]
     setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:cSystem1, NSForegroundColorAttributeName,font, NSFontAttributeName, nil]
     forState:UIControlStateNormal];
    
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierMenu bundle:nil];
        [tbvBranch registerNib:nib forCellReuseIdentifier:reuseIdentifierMenu];
    }
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture setCancelsTouchesInView:NO];
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if([tableView isEqual:tbvBranch])
    {
        return [_filterBranchList count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    if([tableView isEqual:tbvBranch])
    {
        CustomTableViewCellMenu *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierMenu];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        Branch *branch = _filterBranchList[item];
        
        
        
        cell.lblPrice.hidden = YES;
        cell.lblSpecialPrice.hidden = YES;
        cell.lblQuantity.hidden = YES;
        cell.imgTriangle.hidden = YES;
        cell.lblMenuName.text = branch.name;
        
        
        NSString *strPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *noImageFileName = [NSString stringWithFormat:@"%@/JMM/%@/Image/NoImage.jpg",strPath,branch.dbName];
        NSString *imageFileName = [NSString stringWithFormat:@"%@/JMM/%@/Image/Logo/%@",strPath,branch.dbName,branch.imageUrl];
        imageFileName = [Utility isStringEmpty:branch.imageUrl]?noImageFileName:imageFileName;
        UIImage *image = [Utility getImageFromCache:imageFileName];
        if(image)
        {
            cell.imgMenuPic.image = image;
        }
        else
        {
            [self.homeModel downloadImageWithFileName:branch.imageUrl type:2 branchID:branch.branchID completionBlock:^(BOOL succeeded, UIImage *image)
             {
                 if (succeeded)
                 {
                     [Utility saveImageInCache:image imageName:imageFileName];
                     cell.imgMenuPic.image = image;
                 }
             }];
        }        
        cell.imgMenuPic.contentMode = UIViewContentModeScaleAspectFit;
        [self setImageDesign:cell.imgMenuPic];
        
        
        if (!_lastItemReached && item == [_filterBranchList count]-1)
        {
            self.homeModel = [[HomeModel alloc]init];
            self.homeModel.delegate = self;
            [self.homeModel downloadItems:dbBranchSearch withData:@[sbText.text,@(_page),@(_perPage)]];
        }

        
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:tbvBranch])
    {
        return 90;
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
    if([tableView isEqual:tbvBranch])
    {
        Branch *branch = _filterBranchList[indexPath.item];
        _selectedBranch = branch;
        
        
        NSMutableArray *branchList = [[NSMutableArray alloc]init];
        [branchList addObject:branch];
        NSMutableArray *dataList = [[NSMutableArray alloc]init];
        [dataList addObject:branchList];
        [Utility updateSharedObject:dataList];
        [self performSegueWithIdentifier:@"segCustomerTableSearch" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segCustomerTableSearch"])
    {
        CustomerTableSearchViewController *vc = segue.destinationViewController;
        vc.branch = _selectedBranch;
    }
    else if([[segue identifier] isEqualToString:@"segMenuSelection"])
    {
        MenuSelectionViewController *vc = segue.destinationViewController;
        vc.branch = _selectedBranch;
        vc.customerTable = _customerTable;
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
        _page = 1;
        _lastItemReached = NO;
        [self loadingOverlayView];
        self.homeModel = [[HomeModel alloc]init];
        self.homeModel.delegate = self;
        [self.homeModel downloadItems:dbBranchSearch withData:@[searchText,@(_page),@(_perPage)]];
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
    [sbText setShowsCancelButton:YES animated:YES];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // this method is being called when search btn in the keyboard tapped
    // we set searchBarActive = NO
    // but no need to reloadCollectionView
    //    self.searchBarActive = NO;
    
    //    [self.searchBar setShowsCancelButton:NO animated:YES];
    [sbText setShowsCancelButton:NO animated:YES];
}
-(void)cancelSearching
{
    self.searchBarActive = NO;
    [sbText resignFirstResponder];
    sbText.text  = @"";
    _filterBranchList = nil;
    [tbvBranch reloadData];
}

-(void)itemsDownloaded:(NSArray *)items manager:(NSObject *)objHomeModel
{
    HomeModel *homeModel = (HomeModel *)objHomeModel;
    if(homeModel.propCurrentDB == dbBranchSearch)
    {
        [self removeOverlayViews];
        if(_page == 1)
        {
            _filterBranchList = items[0];
        }
        else
        {
            NSInteger remaining = [_filterBranchList count]%_perPage;
            for(int i=0; i<remaining; i++)
            {
                [_filterBranchList removeLastObject];
            }
            
            [_filterBranchList addObjectsFromArray:items[0]];
        }
        
        
        if([items[0] count] < _perPage)
        {
            _lastItemReached = YES;
        }
        else
        {
            _page += 1;
        }
        
        
        [tbvBranch reloadData];
    }
}
@end
