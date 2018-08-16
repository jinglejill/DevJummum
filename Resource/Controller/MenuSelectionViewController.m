//
//  MenuSelectionViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 18/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "MenuSelectionViewController.h"
#import "BasketViewController.h"
#import "CustomTableViewCellMenu.h"
#import "CustomTableViewCellSearchBar.h"
#import "Menu.h"
#import "MenuType.h"
#import "MenuNote.h"
#import "Note.h"
#import "NoteType.h"
#import "SubMenuType.h"
#import "OrderTaking.h"
#import "SpecialPriceProgram.h"
#import "Setting.h"
#import "Utility.h"
#import "Message.h"
#import "CreditCard.h"
#import "Branch.h"


@interface MenuSelectionViewController ()
{
    NSMutableArray *_menuList;
    NSMutableArray *_menuTypeList;
    NSMutableArray *_filterMenuList;
    NSInteger _selectedMenuTypeIndex;
}

@property (nonatomic)        BOOL           searchBarActive;
@end

@implementation MenuSelectionViewController
static float const SEARCH_BAR_HEIGHT = 56;
static NSString * const reuseIdentifierMenu = @"CustomTableViewCellMenu";
static NSString * const reuseIdentifierSearchBar = @"CustomTableViewCellSearchBar";


@synthesize lblNavTitle;
@synthesize branch;
@synthesize customerTable;
@synthesize tbvMenu;
@synthesize vwBottomShadow;
@synthesize lblTotalQuantityTop;
@synthesize lblTotalQuantity;
@synthesize lblTotalAmount;
@synthesize topViewHeight;
@synthesize bottomButtonHeight;
@synthesize buffetReceipt;
@synthesize btnBack;


-(IBAction)unwindToMenuSelection:(UIStoryboardSegue *)segue
{
    [self.view endEditing:true];
    [tbvMenu reloadData];
    [self updateTotalAmount];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segViewBasket"])
    {
        BasketViewController *vc = segue.destinationViewController;
        vc.branch = branch;
        vc.customerTable = customerTable;
        vc.buffetReceipt = buffetReceipt;
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    bottomButtonHeight.constant = window.safeAreaInsets.bottom;
    
    float topPadding = window.safeAreaInsets.top;
    topViewHeight.constant = topPadding == 0?20:topPadding;
}

-(void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
  
    
    NSString *title = [Setting getValue:@"074t" example:@"เลือกเมนู"];
    lblNavTitle.text = title;
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierMenu bundle:nil];
        [tbvMenu registerNib:nib forCellReuseIdentifier:reuseIdentifierMenu];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierSearchBar bundle:nil];
        [tbvMenu registerNib:nib forCellReuseIdentifier:reuseIdentifierSearchBar];
    }

    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
    
    
    
    
    
    tbvMenu.delegate = self;
    tbvMenu.dataSource = self;
    [self setShadow:vwBottomShadow];
    if(buffetReceipt)
    {
        [Menu removeCurrentMenuList];
        [OrderTaking removeCurrentOrderTakingList];
        [CreditCard removeCurrentCreditCard];
        lblTotalQuantity.text = @"0";
        lblTotalQuantityTop.text = @"";
        lblTotalAmount.text = [Utility addPrefixBahtSymbol:@"0.00"];
        
        
        [btnBack setImage:nil forState:UIControlStateNormal];
        branch = [Branch getBranch:buffetReceipt.branchID];
        customerTable = [CustomerTable getCustomerTable:buffetReceipt.customerTableID];
        self.homeModel = [[HomeModel alloc]init];
        self.homeModel.delegate = self;
        [self loadingOverlayView];
        [self.homeModel downloadItems:dbMenuBelongToBuffet withData:buffetReceipt completionBlock:^(BOOL succeeded, NSMutableArray *items)
        {
            [self removeOverlayViews];
            NSMutableArray *messageList = [items[0] mutableCopy];
            Message *message = messageList[0];
            if(![message.text integerValue])
            {
                NSString *message = [Setting getValue:@"124m" example:@"ทางร้านไม่ได้เปิดระบบการสั่งอาหารด้วยตนเองตอนนี้ ขออภัยในความไม่สะดวกค่ะ"];
                [self showAlert:@"" message:message];
            }
            
            
            
            [Utility updateSharedObject:items];
            _menuList = items[1];
            _menuTypeList = items[2];
            _menuTypeList = [MenuType sortList:_menuTypeList];
            _filterMenuList = _menuList;
            [Menu setCurrentMenuList:_menuList];
            
            
            
            [self setData];
        }];
    }
    else
    {
        NSMutableArray *orderTakingList = [OrderTaking getCurrentOrderTakingList];
        if([orderTakingList count]>0)
        {
            OrderTaking *orderTaking = orderTakingList[0];
            if(orderTaking.branchID == branch.branchID)
            {
                lblTotalQuantity.text = [Utility formatDecimal:[orderTakingList count] withMinFraction:0 andMaxFraction:0];
                lblTotalQuantityTop.text = lblTotalQuantity.text;
                
                
                NSString *strTotal = [Utility formatDecimal:[OrderTaking getSubTotalAmount:orderTakingList] withMinFraction:2 andMaxFraction:2];
                strTotal = [Utility addPrefixBahtSymbol:strTotal];
                lblTotalAmount.text = strTotal;
            }
            else
            {
                [Menu removeCurrentMenuList];
                [OrderTaking removeCurrentOrderTakingList];
                [CreditCard removeCurrentCreditCard];
                lblTotalQuantity.text = @"0";
                lblTotalQuantityTop.text = @"";
                lblTotalAmount.text = [Utility addPrefixBahtSymbol:@"0.00"];
            }
        }
        else
        {
            [Menu removeCurrentMenuList];
            lblTotalQuantity.text = @"0";
            lblTotalQuantityTop.text = @"";
            lblTotalAmount.text = [Utility addPrefixBahtSymbol:@"0.00"];
        }
        
        
        
        
        _menuList = [Menu getCurrentMenuList];
        if([_menuList count] == 0)
        {
            [self loadingOverlayView];
            self.homeModel = [[HomeModel alloc]init];
            self.homeModel.delegate = self;
            [self.homeModel downloadItems:dbMenuList withData:branch];
        }
        else
        {
            _menuList = [Menu getMenuListALaCarteWithBranchID:branch.branchID];
            _menuTypeList = [MenuType getMenuTypeListALarCarteWithBranchID:branch.branchID];
            _menuTypeList = [MenuType sortList:_menuTypeList];
            _filterMenuList = _menuList;
            [self setData];
            
            
            
            
            //check opening time การสั่งอาหารด้วยตัวเอง
            self.homeModel = [[HomeModel alloc]init];
            self.homeModel.delegate = self;
            [self.homeModel downloadItems:dbOpeningTime withData:branch];
        }
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (IBAction)goBackHome:(id)sender
{
    if(buffetReceipt)
    {
        [OrderTaking removeCurrentOrderTakingList];
        [self performSegueWithIdentifier:@"segUnwindToReceiptSummary" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"segUnwindToQRCodeScanTable" sender:self];
    }
}

- (IBAction)viewBasket:(id)sender
{
    NSMutableArray *orderTakingList = [OrderTaking getCurrentOrderTakingList];
    if([orderTakingList count] != 0)
    {
        [self performSegueWithIdentifier:@"segViewBasket" sender:self];
    }
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if([tableView isEqual:tbvMenu])
    {
        if(section == 0)
        {
            return 1;
        }
        else
        {
            MenuType *menuType = _menuTypeList[_selectedMenuTypeIndex];
            NSMutableArray *menuList = [Menu getMenuListWithMenuType:menuType.menuTypeID menuList:_filterMenuList];
            return [menuList count];
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    if([tableView isEqual:tbvMenu])
    {
        if(section == 0)
        {
            CustomTableViewCellSearchBar *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierSearchBar];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.sbText.delegate = self;
            cell.sbText.tag = 300;
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
            
            
            MenuType *menuType = _menuTypeList[_selectedMenuTypeIndex];
            NSMutableArray *menuList = [Menu getMenuListWithMenuType:menuType.menuTypeID menuList:_filterMenuList];
            Menu *menu = menuList[item];
            cell.lblMenuName.text = menu.titleThai;
            
            
            
            
            
            SpecialPriceProgram *specialPriceProgram = [SpecialPriceProgram getSpecialPriceProgramTodayWithMenuID:menu.menuID branchID:branch.branchID];
            if(specialPriceProgram)
            {
                NSString *strPrice = [Utility formatDecimal:menu.price withMinFraction:2 andMaxFraction:2];
                strPrice = [NSString stringWithFormat:@"฿ %@",strPrice];
                UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                NSDictionary *attribute = @{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:strPrice attributes:attribute];
                cell.lblPrice.attributedText = attrString;
                [cell.lblPrice sizeToFit];
                
                
                NSString *strSpecialPrice = [Utility formatDecimal:specialPriceProgram.specialPrice withMinFraction:2 andMaxFraction:2];
                cell.lblSpecialPrice.text = [NSString stringWithFormat:@"฿ %@",strSpecialPrice];
            }
            else
            {
                NSString *strPrice = [Utility formatDecimal:menu.price withMinFraction:2 andMaxFraction:2];
                strPrice = [NSString stringWithFormat:@"฿ %@",strPrice];
                UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                NSDictionary *attribute = @{NSFontAttributeName: font};
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:strPrice attributes:attribute];
                cell.lblPrice.attributedText = attrString;
                cell.lblSpecialPrice.text = @"";
            }
            
            
            
            NSString *imageFileName = [Utility isStringEmpty:menu.imageUrl]?@"./Image/NoImage.jpg":[NSString stringWithFormat:@"./%@/Image/Menu/%@",branch.dbName,menu.imageUrl];
            UIImage *image = [Utility getImageFromCache:imageFileName];
            if(image)
            {
                cell.imgMenuPic.image = image;
            }
            else
            {
                [self.homeModel downloadImageWithFileName:menu.imageUrl type:1 branchID:branch.branchID completionBlock:^(BOOL succeeded, UIImage *image)
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
            
            
            NSMutableArray *orderTakingList = [OrderTaking getCurrentOrderTakingList];
            NSMutableArray *orderTakingListWithMenuID = [OrderTaking getOrderTakingListWithMenuID:menu.menuID orderTakingList:orderTakingList];
            if([orderTakingListWithMenuID count]==0)
            {
                cell.imgTriangle.hidden = YES;
            }
            else
            {
                cell.imgTriangle.hidden = NO;
                cell.lblQuantity.text = [Utility formatDecimal:[orderTakingListWithMenuID count] withMinFraction:0 andMaxFraction:0];
            }
            
            
            return cell;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return SEARCH_BAR_HEIGHT;
    }
    else
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
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    
    if([tableView isEqual:tbvMenu])
    {
        if(section == 1)
        {
            //add ordertaking
            MenuType *menuType = _menuTypeList[_selectedMenuTypeIndex];
            NSMutableArray *menuList = [Menu getMenuListWithMenuType:menuType.menuTypeID menuList:_filterMenuList];
            Menu *menu = menuList[item];
            SpecialPriceProgram *specialPriceProgram = [SpecialPriceProgram getSpecialPriceProgramTodayWithMenuID:menu.menuID branchID:branch.branchID];
            float specialPrice = specialPriceProgram?specialPriceProgram.specialPrice:menu.price;
            
            
            NSMutableArray *orderTakingList = [OrderTaking getCurrentOrderTakingList];
            OrderTaking *orderTaking = [[OrderTaking alloc]initWithBranchID:branch.branchID customerTableID:customerTable.customerTableID menuID:menu.menuID quantity:1 specialPrice:specialPrice price:menu.price takeAway:0 noteIDListInText:@"" orderNo:0 status:1 receiptID:0];
            [OrderTaking addObject:orderTaking];
            [orderTakingList addObject:orderTaking];
            
            
            
            CustomTableViewCellMenu *cell = [tableView cellForRowAtIndexPath:indexPath];
            NSMutableArray *orderTakingListWithMenuID = [OrderTaking getOrderTakingListWithMenuID:menu.menuID orderTakingList:orderTakingList];
            cell.lblQuantity.text = [Utility formatDecimal:[orderTakingListWithMenuID count] withMinFraction:0 andMaxFraction:0];
            cell.imgTriangle.hidden = [orderTakingListWithMenuID count]==0;

            [self updateTotalAmount];
            [self blinkAddedNotiView];
        }
    }
}

-(void)itemsDownloaded:(NSArray *)items manager:(NSObject *)objHomeModel
{
    HomeModel *homeModel = (HomeModel *)objHomeModel;
    if(homeModel.propCurrentDB == dbMenuList)
    {
        NSMutableArray *messageList = [items[0] mutableCopy];
        Message *message = messageList[0];
        if(![message.text integerValue])
        {
            NSString *message = [Setting getValue:@"124m" example:@"ทางร้านไม่ได้เปิดระบบการสั่งอาหารด้วยตนเองตอนนี้ ขออภัยในความไม่สะดวกค่ะ"];
            [self showAlert:@"" message:message];
        }
        
        
        
        [Utility updateSharedObject:items];
        _menuList = [Menu getMenuListALaCarteWithBranchID:branch.branchID];
        _menuTypeList = [MenuType getMenuTypeListALarCarteWithBranchID:branch.branchID];
        _menuTypeList = [MenuType sortList:_menuTypeList];
        _filterMenuList = _menuList;
        [Menu setCurrentMenuList:_menuList];
     
        
        
        [self setData];
        [self removeOverlayViews];
              
    }
    else if(homeModel.propCurrentDB == dbOpeningTime)
    {
        [self removeOverlayViews];
        [Utility updateSharedObject:items];
        NSMutableArray *messageList = items[0];
        Message *message = messageList[0];
        if(![message.text integerValue])//open
        {
            NSString *message = [Setting getValue:@"124m" example:@"ทางร้านไม่ได้เปิดระบบการสั่งอาหารด้วยตนเองตอนนี้ ขออภัยในความไม่สะดวกค่ะ"];
            [self showAlert:@"" message:message];
        }
        [tbvMenu reloadData];
    }
}

-(void)setData
{
    [self createHorizontalScroll];
    [tbvMenu reloadData];
    if([_menuTypeList count]>0)
    {
        MenuType *menuType = _menuTypeList[0];
        NSMutableArray *menuList = [Menu getMenuListWithMenuType:menuType.menuTypeID menuList:_filterMenuList];
        if([menuList count]>0)
        {
            [tbvMenu scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        else
        {
            [tbvMenu scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }
    else
    {
        [tbvMenu scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
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
    for (int i = 0; i < [_menuTypeList count]; i++)
    {
        MenuType *menuType = _menuTypeList[i];
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
        [button setTitle:menuType.name forState:UIControlStateNormal];
        [button sizeToFit];
        [scrollView addSubview:button];
        buttonX = 15 + buttonX+button.frame.size.width;
        [button addTarget:self action:@selector(menuTypeSelected:) forControlEvents:UIControlEventTouchUpInside];
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

-(void)menuTypeSelected:(UIButton*)sender
{
    UIButton *button = sender;
    _selectedMenuTypeIndex = button.tag-1;
    
    
    for(int i=1; i<=[_menuTypeList count]; i++)
    {
        UIButton *eachButton = [self.view viewWithTag:i];
        [eachButton setTitleColor:cSystem4 forState:UIControlStateNormal];
        
        
        UIView *highlightBottomBorder = [self.view viewWithTag:i+100];
        highlightBottomBorder.hidden = YES;
    }
    
    
    [button setTitleColor:cSystem1 forState:UIControlStateNormal];
    UIView *highlightBottomBorder = [self.view viewWithTag:button.tag+100];
    highlightBottomBorder.hidden = NO;
    
    
    
    

    [tbvMenu reloadData];
    if([_menuTypeList count]>0)
    {
        MenuType *menuType = _menuTypeList[_selectedMenuTypeIndex];
        NSMutableArray *menuList = [Menu getMenuListWithMenuType:menuType.menuTypeID menuList:_filterMenuList];
        if([menuList count]>0)
        {
            [tbvMenu scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        else
        {
            [tbvMenu scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }
    else
    {
        [tbvMenu scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

-(void)updateTotalAmount
{
    NSMutableArray *orderTakingList = [OrderTaking getCurrentOrderTakingList];
    lblTotalQuantity.text = [NSString stringWithFormat:@"%ld",[orderTakingList count]];
    lblTotalQuantityTop.text = [orderTakingList count]==0?@"":[NSString stringWithFormat:@"%ld",[orderTakingList count]];
    
    
    NSString *strTotal = [Utility formatDecimal:[OrderTaking getSubTotalAmount:orderTakingList] withMinFraction:2 andMaxFraction:2];
    strTotal = [Utility addPrefixBahtSymbol:strTotal];
    lblTotalAmount.text = strTotal;
}

#pragma mark - search

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    if([Utility isStringEmpty:searchText])
    {
        _filterMenuList = _menuList;
        NSRange range = NSMakeRange(1, 1);
        NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
        [tbvMenu reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
    }
    else
    {
        NSPredicate *resultPredicate   = [NSPredicate predicateWithFormat:@"(_titleThai contains[c] %@) or (_price = %f)", searchText, [Utility floatValue:searchText]];
        _filterMenuList = [[_menuList filteredArrayUsingPredicate:resultPredicate] mutableCopy];
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
        [tbvMenu reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
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
@end
