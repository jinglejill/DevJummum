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
#import "CustomTableViewCellSquareThumbNail.h"
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
#import "MenuForBuffet.h"
#import "VoucherCode.h"


@interface MenuSelectionViewController ()
{
    NSMutableArray *_menuList;
    NSMutableArray *_menuTypeList;
    NSMutableArray *_filterMenuList;
    NSInteger _selectedMenuTypeIndex;
    NSMutableArray *_currentMenuTypeList;
    UIScrollView *_horizontalScrollView;
    NSMutableArray *_recommendList;
    UIButton *_lblSpentForLuckyDraw;
}

@property (nonatomic)        BOOL           searchBarActive;
@end

@implementation MenuSelectionViewController
static float const SEARCH_BAR_HEIGHT = 56;
static NSString * const reuseIdentifierMenu = @"CustomTableViewCellMenu";
static NSString * const reuseIdentifierSearchBar = @"CustomTableViewCellSearchBar";
static NSString * const reuseIdentifierSquareThumbNail = @"CustomTableViewCellSquareThumbNail";


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
@synthesize btnViewBasket;
@synthesize fromReceiptSummaryMenu;


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
    
    
    [btnViewBasket setTitle:[Language getText:@"รถเข็น"] forState:UIControlStateNormal];
}

-(void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
  
    
    NSString *title = [Language getText:@"เลือกเมนู"];
    lblNavTitle.text = title;
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierMenu bundle:nil];
        [tbvMenu registerNib:nib forCellReuseIdentifier:reuseIdentifierMenu];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierSearchBar bundle:nil];
        [tbvMenu registerNib:nib forCellReuseIdentifier:reuseIdentifierSearchBar];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierSquareThumbNail bundle:nil];
        [tbvMenu registerNib:nib forCellReuseIdentifier:reuseIdentifierSquareThumbNail];
    }

    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _currentMenuTypeList = [[NSMutableArray alloc]init];
    
    
    if(branch.luckyDrawSpend)
    {
        NSString *message = [Language getText:@"ลุ้นรับรางวัลพิเศษ\nเมื่อทานครบทุกๆ %ld บาท"];
        NSInteger spentAmount = branch.luckyDrawSpend;
        NSString *luckyDrawMessage = [NSString stringWithFormat:message,spentAmount];
        _lblSpentForLuckyDraw = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lblSpentForLuckyDraw setTitle:luckyDrawMessage forState:UIControlStateNormal];
        [_lblSpentForLuckyDraw setTitleColor:cSystem3 forState:UIControlStateNormal];
        _lblSpentForLuckyDraw.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        _lblSpentForLuckyDraw.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _lblSpentForLuckyDraw.backgroundColor = [cSystem1_30 colorWithAlphaComponent:0.5];
        _lblSpentForLuckyDraw.titleLabel.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
        _lblSpentForLuckyDraw.titleLabel.numberOfLines = 2;
        _lblSpentForLuckyDraw.userInteractionEnabled = NO;
        
        

        [_lblSpentForLuckyDraw sizeToFit];
        
        
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        CGRect frame = _lblSpentForLuckyDraw.frame;
        frame.origin.x = self.view.frame.size.width-frame.size.width;
        frame.origin.y = self.view.frame.size.height - window.safeAreaInsets.bottom - 44 - frame.size.height;
        
        _lblSpentForLuckyDraw.frame = frame;
        [self setCornerDesign:_lblSpentForLuckyDraw];
        [self.view addSubview:_lblSpentForLuckyDraw];
    }
    
    
    
    
    
    tbvMenu.delegate = self;
    tbvMenu.dataSource = self;
    [self setShadow:vwBottomShadow];
    if(buffetReceipt)
    {
        if(fromReceiptSummaryMenu)
        {
            [btnBack setImage:nil forState:UIControlStateNormal];
        }
        [OrderTaking removeCurrentOrderTakingListAlacarteMenu];
        [self updateTotalAmount];
        branch = [Branch getBranch:buffetReceipt.branchID];
        customerTable = [CustomerTable getCustomerTable:buffetReceipt.customerTableID];
        
        
        
        //ถ้าเป็น branch เดิม ไม่ต้องโหลดเมนูใหม่ เช็ค openingTime แทน
        MenuForBuffet *menuForBuffet = [Menu getCurrentMenuForBuffet];
        if(!menuForBuffet || menuForBuffet.receiptID != buffetReceipt.receiptID)
        {
            [self loadingOverlayView];
            self.homeModel = [[HomeModel alloc]init];
            self.homeModel.delegate = self;
            [self.homeModel downloadItems:dbMenuBelongToBuffet withData:buffetReceipt];
        }
        else
        {
//            _recommendList =
            _menuList = [Menu getMenuBelongToBuffet:buffetReceipt];
            _menuTypeList = [MenuType getMenuTypeListWithMenuList:_menuList];
            _menuTypeList = [MenuType sortList:_menuTypeList];
            _filterMenuList = _menuList;
            [self setData];
            
            
            
            //check opening time การสั่งอาหารด้วยตัวเอง
            self.homeModel = [[HomeModel alloc]init];
            self.homeModel.delegate = self;
            [self.homeModel downloadItems:dbMenuBelongToBuffet withData:buffetReceipt];
            
        }
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
                [VoucherCode removeCurrentVoucherCode];
                lblTotalQuantity.text = @"0";
                lblTotalQuantityTop.text = @"";
                lblTotalAmount.text = [Utility addPrefixBahtSymbol:@"0.00"];
            }
        }
        else
        {
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
            _menuTypeList = [MenuType getMenuTypeListWithMenuList:_menuList];
            _menuTypeList = [MenuType sortList:_menuTypeList];
            _filterMenuList = _menuList;
            [self setData];
            
            
            
            
            //check opening time การสั่งอาหารด้วยตัวเอง
            self.homeModel = [[HomeModel alloc]init];
            self.homeModel.delegate = self;
            [self.homeModel downloadItems:dbMenuList withData:branch];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (IBAction)goBackHome:(id)sender
{
    if(buffetReceipt && fromReceiptSummaryMenu)
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
            if(_menuTypeList && [_menuTypeList count]>0)
            {
                NSMutableArray *menuList = [self getMenuListWithSelectedIndex:_selectedMenuTypeIndex];
                if([Menu hasRecommendedMenuWithMenuList:_filterMenuList] && _selectedMenuTypeIndex == 0)
                {
                    [_lblSpentForLuckyDraw removeFromSuperview];
                    return ceilf([menuList count]/2.0);
                }
                else
                {
                    [self.view addSubview:_lblSpentForLuckyDraw];
                    return [menuList count];
                }
            }
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
            cell.sbText.placeholder = [Language getText:@"ค้นหาเมนู"];
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
            if([Menu hasRecommendedMenuWithMenuList:_filterMenuList] && _selectedMenuTypeIndex == 0)
            {
                CustomTableViewCellSquareThumbNail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierSquareThumbNail];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
                NSMutableArray *menuList = [self getMenuListWithSelectedIndex:_selectedMenuTypeIndex];
                Menu *menuLeft = menuList[item*2];
            
            
            
                //vw
                cell.vwLeftWidth.constant = (self.view.frame.size.width - 3*8)/2;
//                cell.vwLeftHeight.constant = cell.vwLeftWidth.constant+44;
                cell.vwLeftHeight.constant = cell.vwLeftWidth.constant+44+30;
                cell.vwLeft.layer.shadowColor = [UIColor lightGrayColor].CGColor;
                cell.vwLeft.layer.shadowOpacity = 0.8;
                cell.vwLeft.layer.shadowRadius = 6;
                cell.vwLeft.layer.shadowOffset = CGSizeZero;
                cell.vwLeft.layer.masksToBounds = NO;
//                cell.vwLeft.tag = item;
                [cell.vwLeft addGestureRecognizer:cell.singleTapGestureRecognizerLeft];
                
                
                //gesture
                cell.singleTapGestureRecognizerLeft.numberOfTapsRequired = 1;
                [cell.singleTapGestureRecognizerLeft addTarget:self action:@selector(handleSingleTapLeft:)];
            
            
                //imgVw
                NSString *strPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                NSString *noImageFileName = [NSString stringWithFormat:@"%@/JMM/%@/Image/NoImage.jpg",strPath,branch.dbName];
                NSString *imageFileName = [NSString stringWithFormat:@"%@/JMM/%@/Image/Menu/%@",strPath,branch.dbName,menuLeft.imageUrl];
                imageFileName = [Utility isStringEmpty:menuLeft.imageUrl]?noImageFileName:imageFileName;
                UIImage *image = [Utility getImageFromCache:imageFileName];
                if(image)
                {
                    cell.imgVwLeft.image = image;
                }
                else
                {
                    [self.homeModel downloadImageWithFileName:menuLeft.imageUrl type:1 branchID:branch.branchID completionBlock:^(BOOL succeeded, UIImage *image)
                     {
                         if (succeeded)
                         {
                             [Utility saveImageInCache:image imageName:imageFileName];
                             cell.imgVwLeft.image = image;
                         }
                     }];
                }
                cell.imgVwLeft.contentMode = UIViewContentModeScaleAspectFit;
                cell.imgVwLeftHeight.constant = cell.vwLeftWidth.constant;
            
            
            
                //lbl
                cell.lblLeft.text = menuLeft.titleThai;
                
                
                //price
                SpecialPriceProgram *specialPriceProgram = [SpecialPriceProgram getSpecialPriceProgramTodayWithMenuID:menuLeft.menuID branchID:branch.branchID];
                if(specialPriceProgram)
                {
                    NSString *strPrice = [Utility formatDecimal:menuLeft.price withMinFraction:2 andMaxFraction:2];
                    strPrice = [NSString stringWithFormat:@"฿ %@",strPrice];
                    UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:14];
                    NSDictionary *attribute = @{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
                    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:strPrice attributes:attribute];
                    cell.lblPriceLeft.attributedText = attrString;
                    [cell.lblPriceLeft sizeToFit];
                    CGRect frame = cell.lblPriceLeft.frame;
                    frame.size.height = 18;
                    cell.lblPriceLeft.frame = frame;
                    
                    
                    NSString *strSpecialPrice = [Utility formatDecimal:specialPriceProgram.specialPrice withMinFraction:2 andMaxFraction:2];
                    cell.lblSpecialPriceLeft.text = [NSString stringWithFormat:@"฿ %@",strSpecialPrice];
                }
                else
                {
                    NSString *strPrice = [Utility formatDecimal:menuLeft.price withMinFraction:2 andMaxFraction:2];
                    cell.lblPriceLeft.text = [NSString stringWithFormat:@"฿ %@",strPrice];
                    cell.lblSpecialPriceLeft.text = @"";
                }
                
                
                //triangle
                NSMutableArray *orderTakingList = [OrderTaking getCurrentOrderTakingList];
                NSMutableArray *orderTakingListWithMenuID = [OrderTaking getOrderTakingListWithMenuID:menuLeft.menuID orderTakingList:orderTakingList];
                if([orderTakingListWithMenuID count]==0)
                {
                    cell.imgVwTriangleLeft.hidden = YES;
                    cell.lblQuantityLeft.hidden = cell.imgVwTriangleLeft.hidden;
                }
                else
                {
                    cell.imgVwTriangleLeft.hidden = NO;
                    cell.lblQuantityLeft.hidden = cell.imgVwTriangleLeft.hidden;
                    cell.lblQuantityLeft.text = [Utility formatDecimal:[orderTakingListWithMenuID count] withMinFraction:0 andMaxFraction:0];
                }
            
            
            
                NSInteger rightIndex = item*2+1;
                if(rightIndex < [menuList count])
                {
                    Menu *menuRight = menuList[rightIndex];
                    
                    
                    //vw
                    cell.vwRight.hidden = NO;
                    cell.vwRight.layer.shadowColor = [UIColor lightGrayColor].CGColor;
                    cell.vwRight.layer.shadowOpacity = 0.8;
                    cell.vwRight.layer.shadowRadius = 6;
                    cell.vwRight.layer.shadowOffset = CGSizeZero;
                    cell.vwRight.layer.masksToBounds = NO;
//                    cell.vwRight.tag = item;
                    [cell.vwRight addGestureRecognizer:cell.singleTapGestureRecognizerRight];
                    
                    
                    //gesture
                    cell.singleTapGestureRecognizerRight.numberOfTapsRequired = 1;
                    [cell.singleTapGestureRecognizerRight addTarget:self action:@selector(handleSingleTapRight:)];
                    
                    
                    //imgVw
                    NSString *strPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                    NSString *noImageFileName = [NSString stringWithFormat:@"%@/JMM/%@/Image/NoImage.jpg",strPath,branch.dbName];
                    NSString *imageFileName = [NSString stringWithFormat:@"%@/JMM/%@/Image/Menu/%@",strPath,branch.dbName,menuRight.imageUrl];
                    imageFileName = [Utility isStringEmpty:menuRight.imageUrl]?noImageFileName:imageFileName;
                    UIImage *image = [Utility getImageFromCache:imageFileName];
                    if(image)
                    {
                        cell.imgVwRight.image = image;
                    }
                    else
                    {
                        [self.homeModel downloadImageWithFileName:menuRight.imageUrl type:1 branchID:branch.branchID completionBlock:^(BOOL succeeded, UIImage *image)
                         {
                             if (succeeded)
                             {
                                 [Utility saveImageInCache:image imageName:imageFileName];
                                 cell.imgVwRight.image = image;
                             }
                         }];
                    }
                    cell.imgVwRight.contentMode = UIViewContentModeScaleAspectFit;
                    cell.imgVwRightHeight.constant = cell.vwLeftWidth.constant;
                    
                    
                    
                    //lbl
                    cell.lblRight.text = menuRight.titleThai;
                    
                    
                    //price
                    SpecialPriceProgram *specialPriceProgram = [SpecialPriceProgram getSpecialPriceProgramTodayWithMenuID:menuRight.menuID branchID:branch.branchID];
                    if(specialPriceProgram)
                    {
                        NSString *strPrice = [Utility formatDecimal:menuRight.price withMinFraction:2 andMaxFraction:2];
                        strPrice = [NSString stringWithFormat:@"฿ %@",strPrice];
                        UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:14];
                        NSDictionary *attribute = @{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
                        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:strPrice attributes:attribute];
                        cell.lblPriceRight.attributedText = attrString;
                        [cell.lblPriceRight sizeToFit];
                        CGRect frame = cell.lblPriceRight.frame;
                        frame.size.height = 18;
                        cell.lblPriceRight.frame = frame;
                        
                        
                        NSString *strSpecialPrice = [Utility formatDecimal:specialPriceProgram.specialPrice withMinFraction:2 andMaxFraction:2];
                        cell.lblSpecialPriceRight.text = [NSString stringWithFormat:@"฿ %@",strSpecialPrice];
                    }
                    else
                    {
                        NSString *strPrice = [Utility formatDecimal:menuRight.price withMinFraction:2 andMaxFraction:2];
                        cell.lblPriceRight.text = [NSString stringWithFormat:@"฿ %@",strPrice];
                        cell.lblSpecialPriceRight.text = @"";
                    }
                    
                    
                    //triangle
                    NSMutableArray *orderTakingList = [OrderTaking getCurrentOrderTakingList];
                    NSMutableArray *orderTakingListWithMenuID = [OrderTaking getOrderTakingListWithMenuID:menuRight.menuID orderTakingList:orderTakingList];
                    if([orderTakingListWithMenuID count]==0)
                    {
                        cell.imgVwTriangleRight.hidden = YES;
                        cell.lblQuantityRight.hidden = cell.imgVwTriangleRight.hidden;
                    }
                    else
                    {
                        cell.imgVwTriangleRight.hidden = NO;
                        cell.lblQuantityRight.hidden = cell.imgVwTriangleRight.hidden;
                        cell.lblQuantityRight.text = [Utility formatDecimal:[orderTakingListWithMenuID count] withMinFraction:0 andMaxFraction:0];
                    }
                }
                else
                {
                    cell.vwRight.hidden = YES;
                }
            
                return cell;
            
            }
            else
            {
                CustomTableViewCellMenu *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierMenu];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                NSMutableArray *menuList = [self getMenuListWithSelectedIndex:_selectedMenuTypeIndex];
                Menu *menu = menuList[item];
                cell.lblMenuName.text = menu.titleThai;
                [cell.lblMenuName sizeToFit];
                cell.lblMenuNameHeight.constant = cell.lblMenuName.frame.size.height;
                
                
                
                
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
                
                
                NSString *strPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                NSString *noImageFileName = [NSString stringWithFormat:@"%@/JMM/%@/Image/NoImage.jpg",strPath,branch.dbName];
                NSString *imageFileName = [NSString stringWithFormat:@"%@/JMM/%@/Image/Menu/%@",strPath,branch.dbName,menu.imageUrl];
                imageFileName = [Utility isStringEmpty:menu.imageUrl]?noImageFileName:imageFileName;
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
                    cell.lblQuantity.hidden = cell.imgTriangle.hidden;
                }
                else
                {
                    cell.imgTriangle.hidden = NO;
                    cell.lblQuantity.hidden = cell.imgTriangle.hidden;
                    cell.lblQuantity.text = [Utility formatDecimal:[orderTakingListWithMenuID count] withMinFraction:0 andMaxFraction:0];
                }
                
                
                return cell;
            }
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = indexPath.item;
    if(indexPath.section == 0)
    {
        return SEARCH_BAR_HEIGHT;
    }
    else
    {
        if([Menu hasRecommendedMenuWithMenuList:_filterMenuList] && _selectedMenuTypeIndex == 0)
        {
            return 4 + (self.view.frame.size.width - 3*8)/2 + 44 + 4 + 30;
//            return 4 + (self.view.frame.size.width - 3*8)/2 + 44 + 4;
        }
        else
        {
            CustomTableViewCellMenu *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierMenu];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            NSMutableArray *menuList = [self getMenuListWithSelectedIndex:_selectedMenuTypeIndex];
            Menu *menu = menuList[item];
            cell.lblMenuName.text = menu.titleThai;
            [cell.lblMenuName sizeToFit];
            
            return cell.lblMenuName.frame.size.height+46<90?90:cell.lblMenuName.frame.size.height+46;
        }
    }
    return 0;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
    [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
    if(indexPath.section == 1)
    {
        if(_selectedMenuTypeIndex == 0)
        {
            cell.separatorInset = UIEdgeInsetsMake(0.0f, self.view.bounds.size.width, 0.0f, CGFLOAT_MAX);
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    
    if([tableView isEqual:tbvMenu])
    {
        if(section == 1)
        {
            if(([Menu hasRecommendedMenuWithMenuList:_filterMenuList] && _selectedMenuTypeIndex == 0))
            {
                
            }
            else
            {
                //add ordertaking
                NSMutableArray *menuList = [self getMenuListWithSelectedIndex:_selectedMenuTypeIndex];
                Menu *menu = menuList[item];
                SpecialPriceProgram *specialPriceProgram = [SpecialPriceProgram getSpecialPriceProgramTodayWithMenuID:menu.menuID branchID:branch.branchID];
                float specialPrice = specialPriceProgram?specialPriceProgram.specialPrice:menu.price;
                
                
                NSMutableArray *orderTakingList = [OrderTaking getCurrentOrderTakingList];
                OrderTaking *orderTaking = [[OrderTaking alloc]initWithBranchID:branch.branchID customerTableID:customerTable.customerTableID menuID:menu.menuID quantity:1 specialPrice:specialPrice price:menu.price takeAway:0 takeAwayPrice:0 noteIDListInText:@"" notePrice:0 orderNo:0 status:1 receiptID:0];
                [OrderTaking addObject:orderTaking];
                [orderTakingList addObject:orderTaking];
                
                
                
                CustomTableViewCellMenu *cell = [tableView cellForRowAtIndexPath:indexPath];
                NSMutableArray *orderTakingListWithMenuID = [OrderTaking getOrderTakingListWithMenuID:menu.menuID orderTakingList:orderTakingList];
                cell.lblQuantity.text = [Utility formatDecimal:[orderTakingListWithMenuID count] withMinFraction:0 andMaxFraction:0];
                cell.imgTriangle.hidden = [orderTakingListWithMenuID count]==0;
                cell.lblQuantity.hidden = cell.imgTriangle.hidden;
                
                
                [self updateTotalAmount];
                [self blinkAddedNotiView];
            }
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
            NSString *message = [Language getText:@"ทางร้านไม่ได้เปิดระบบการสั่งอาหารด้วยตนเองตอนนี้ ขออภัยในความไม่สะดวกค่ะ"];
            [self showAlert:@"" message:message];
        }
        
        
        [Utility updateSharedObject:items];
        _menuList = [Menu getMenuListALaCarteWithBranchID:branch.branchID];
        _menuTypeList = [MenuType getMenuTypeListWithMenuList:_menuList];
        _menuTypeList = [MenuType sortList:_menuTypeList];
        _filterMenuList = _menuList;
        [Menu setCurrentMenuList:_menuList];
        [self setData];
        [self removeOverlayViews];
        
    }
    else if(homeModel.propCurrentDB == dbMenuBelongToBuffet)
    {
        NSMutableArray *messageList = [items[0] mutableCopy];
        Message *message = messageList[0];
        if(![message.text integerValue])
        {
            NSString *message = [Language getText:@"ทางร้านไม่ได้เปิดระบบการสั่งอาหารด้วยตนเองตอนนี้ ขออภัยในความไม่สะดวกค่ะ"];
            [self showAlert:@"" message:message];
        }
        
        
        [Utility updateSharedObject:items];
        _menuList = [Menu getMenuBelongToBuffet:buffetReceipt];
        _menuTypeList = [MenuType getMenuTypeListWithMenuList:_menuList];
        _menuTypeList = [MenuType sortList:_menuTypeList];
        _filterMenuList = _menuList;
        
        NSMutableArray *receiptList = items[6];
        Receipt *receipt = receiptList[0];
        MenuForBuffet *menuForBuffet = [[MenuForBuffet alloc]initWithReceiptID:receipt.receiptID menuList:_menuList];
        [Menu setCurrentMenuForBuffet:menuForBuffet];
        [self setData];
        [self removeOverlayViews];
    }
}

-(void)setData
{
    [self createHorizontalScroll];
    [tbvMenu reloadData];
    if([_menuTypeList count]>0)
    {
        NSMutableArray *menuList = [self getMenuListWithSelectedIndex:_selectedMenuTypeIndex];
        if([menuList count]>0)
        {
            //hide searchBar
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
    if(![_currentMenuTypeList isEqualToArray:_menuTypeList])
    {
        if(_horizontalScrollView)
        {
            [_horizontalScrollView removeFromSuperview];
        }
        
        
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        float topPadding = window.safeAreaInsets.top;
        topPadding = topPadding == 0?20:topPadding;
        _horizontalScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topPadding+44, self.view.frame.size.width, 44)];
        _horizontalScrollView.delegate = self;
        int buttonX = 15;
        _currentMenuTypeList = [NSMutableArray arrayWithArray:_menuTypeList];
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
            
            if([Language langIsTH])
            {
                [button setTitle:menuType.name forState:UIControlStateNormal];
            }
            else if([Language langIsEN])
            {
                [button setTitle:menuType.nameEn forState:UIControlStateNormal];
            }
            [button sizeToFit];
            [_horizontalScrollView addSubview:button];
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
            [_horizontalScrollView addSubview:highlightBottomBorder];
        }
        
        _horizontalScrollView.contentSize = CGSizeMake(buttonX, _horizontalScrollView.frame.size.height);
        _horizontalScrollView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_horizontalScrollView];
    }
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
        NSMutableArray *menuList = [self getMenuListWithSelectedIndex:_selectedMenuTypeIndex];
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
        NSMutableSet *searchSet = [[NSMutableSet alloc]init];
        NSArray *arrSearchText = [searchText componentsSeparatedByString:@" "];
        for(NSString *item in arrSearchText)
        {
            NSPredicate *resultPredicate   = [NSPredicate predicateWithFormat:@"(_titleThai contains[c] %@) or (_price = %f)", item, [Utility floatValue:item]];
            NSArray *filterArray = [[_menuList filteredArrayUsingPredicate:resultPredicate] copy];
            [searchSet addObjectsFromArray:filterArray];
        }
        _filterMenuList = [[searchSet allObjects]mutableCopy];
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

-(NSMutableArray *)getMenuListWithSelectedIndex:(NSInteger)selectedIndex
{
    NSMutableArray *menuList;
    if([Menu hasRecommendedMenuWithMenuList:_filterMenuList] && _selectedMenuTypeIndex == 0)
    {
        menuList = [Menu getMenuListRecommendedWithMenuList:_filterMenuList];
    }
    else
    {
        MenuType *menuType = _menuTypeList[_selectedMenuTypeIndex];
        menuList = [Menu getMenuListWithMenuType:menuType.menuTypeID menuList:_filterMenuList];
    }
    return menuList;
}

- (void)handleSingleTapLeft:(UITapGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:tbvMenu];
    NSIndexPath * tappedIP = [tbvMenu indexPathForRowAtPoint:point];
    NSInteger item = tappedIP.row;


    //add ordertaking
    NSMutableArray *menuList = [self getMenuListWithSelectedIndex:_selectedMenuTypeIndex];
    Menu *menu = menuList[item*2];
    SpecialPriceProgram *specialPriceProgram = [SpecialPriceProgram getSpecialPriceProgramTodayWithMenuID:menu.menuID branchID:branch.branchID];
    float specialPrice = specialPriceProgram?specialPriceProgram.specialPrice:menu.price;


    NSMutableArray *orderTakingList = [OrderTaking getCurrentOrderTakingList];
    OrderTaking *orderTaking = [[OrderTaking alloc]initWithBranchID:branch.branchID customerTableID:customerTable.customerTableID menuID:menu.menuID quantity:1 specialPrice:specialPrice price:menu.price takeAway:0 takeAwayPrice:0 noteIDListInText:@"" notePrice:0 orderNo:0 status:1 receiptID:0];
    [OrderTaking addObject:orderTaking];
    [orderTakingList addObject:orderTaking];


    //update quantity display
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:item inSection:1];
    CustomTableViewCellSquareThumbNail *cell = [tbvMenu cellForRowAtIndexPath:indexPath];
    NSMutableArray *orderTakingListWithMenuID = [OrderTaking getOrderTakingListWithMenuID:menu.menuID orderTakingList:orderTakingList];
    cell.lblQuantityLeft.text = [Utility formatDecimal:[orderTakingListWithMenuID count] withMinFraction:0 andMaxFraction:0];
    cell.imgVwTriangleLeft.hidden = [orderTakingListWithMenuID count]==0;
    cell.lblQuantityLeft.hidden = cell.imgVwTriangleLeft.hidden;

    [self updateTotalAmount];
    [self blinkAddedNotiView];
}

- (void)handleSingleTapRight:(UITapGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:tbvMenu];
    NSIndexPath * tappedIP = [tbvMenu indexPathForRowAtPoint:point];
    NSInteger item = tappedIP.row;


    //add ordertaking
    NSMutableArray *menuList = [self getMenuListWithSelectedIndex:_selectedMenuTypeIndex];
    Menu *menu = menuList[item*2+1];
    SpecialPriceProgram *specialPriceProgram = [SpecialPriceProgram getSpecialPriceProgramTodayWithMenuID:menu.menuID branchID:branch.branchID];
    float specialPrice = specialPriceProgram?specialPriceProgram.specialPrice:menu.price;


    NSMutableArray *orderTakingList = [OrderTaking getCurrentOrderTakingList];
    OrderTaking *orderTaking = [[OrderTaking alloc]initWithBranchID:branch.branchID customerTableID:customerTable.customerTableID menuID:menu.menuID quantity:1 specialPrice:specialPrice price:menu.price takeAway:0 takeAwayPrice:0 noteIDListInText:@"" notePrice:0 orderNo:0 status:1 receiptID:0];
    [OrderTaking addObject:orderTaking];
    [orderTakingList addObject:orderTaking];


    //update quantity display
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:item inSection:1];
    CustomTableViewCellSquareThumbNail *cell = [tbvMenu cellForRowAtIndexPath:indexPath];
    NSMutableArray *orderTakingListWithMenuID = [OrderTaking getOrderTakingListWithMenuID:menu.menuID orderTakingList:orderTakingList];
    cell.lblQuantityRight.text = [Utility formatDecimal:[orderTakingListWithMenuID count] withMinFraction:0 andMaxFraction:0];
    cell.imgVwTriangleRight.hidden = [orderTakingListWithMenuID count]==0;
    cell.lblQuantityRight.hidden = cell.imgVwTriangleRight.hidden;

    [self updateTotalAmount];
    [self blinkAddedNotiView];
}
@end
