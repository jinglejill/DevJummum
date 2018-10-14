//
//  ReceiptSummaryViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 11/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "ReceiptSummaryViewController.h"
#import "OrderDetailViewController.h"
#import "CreditCardAndOrderSummaryViewController.h"
#import "MenuSelectionViewController.h"
#import "CustomTableViewCellReceiptSummary.h"
#import "CustomTableViewCellOrderSummary.h"
#import "CustomTableViewCellTotal.h"
#import "CustomTableViewCellLabelLabel.h"
#import "CustomTableViewCellLabelRemark.h"
#import "CustomTableViewCellButton.h"
#import "Receipt.h"
#import "UserAccount.h"
#import "Branch.h"
#import "OrderTaking.h"
#import "Menu.h"
#import "OrderNote.h"
#import "Setting.h"


@interface ReceiptSummaryViewController ()
{
    NSMutableArray *_receiptList;
    BOOL _lastItemReached;
    Branch *_receiptBranch;
    NSInteger _selectedReceiptID;
    Receipt *_selectedReceipt;
    Receipt *_orderItAgainReceipt;
    NSMutableDictionary *_dicTimer;
    NSInteger _page;
    NSInteger _perPage;
    BOOL _loadData;
}
@end

@implementation ReceiptSummaryViewController
static NSString * const reuseIdentifierReceiptSummary = @"CustomTableViewCellReceiptSummary";
static NSString * const reuseIdentifierOrderSummary = @"CustomTableViewCellOrderSummary";
static NSString * const reuseIdentifierTotal = @"CustomTableViewCellTotal";
static NSString * const reuseIdentifierLabelLabel = @"CustomTableViewCellLabelLabel";
static NSString * const reuseIdentifierLabelRemark = @"CustomTableViewCellLabelRemark";
static NSString * const reuseIdentifierButton = @"CustomTableViewCellButton";


@synthesize lblNavTitle;
@synthesize tbvData;
@synthesize topViewHeight;


-(IBAction)unwindToReceiptSummary:(UIStoryboardSegue *)segue
{
    self.showOrderDetail = 0;
    [tbvData reloadData];
    CustomViewController *vc = segue.sourceViewController;
    if([vc isKindOfClass:[CreditCardAndOrderSummaryViewController class]] && !vc.showOrderDetail)
    {
        CreditCardAndOrderSummaryViewController *vc = segue.sourceViewController;
        
        
        //get index and scroll to that index
        NSInteger index = [Receipt getIndex:_receiptList receipt:vc.receipt];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
        [tbvData scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIWindow *window = UIApplication.sharedApplication.keyWindow;

    
    float topPadding = window.safeAreaInsets.top;
    topViewHeight.constant = topPadding == 0?20:topPadding;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [tbvData reloadData];
    
}
    
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    if(!_loadData)
    {
        _page = 1;
        _lastItemReached = NO;
        UserAccount *userAccount = [UserAccount getCurrentUserAccount];
        self.homeModel = [[HomeModel alloc]init];
        self.homeModel.delegate = self;
        [self.homeModel downloadItems:dbReceiptSummaryPage withData:@[userAccount,@(_page),@(_perPage)]];
    }
    else
    {
        _loadData = NO;
    }
    

    if(self.showOrderDetail)
    {
        self.showOrderDetail = 0;
        [self segueToOrderDetailAuto:self.selectedReceipt];
    }
    else if(self.goToBuffetOrder)
    {
        self.goToBuffetOrder = 0;
        _selectedReceipt = self.selectedReceipt;
        [self performSegueWithIdentifier:@"segMenuSelection" sender:self];
    }
}

-(void)setReceiptList
{
    UserAccount *currentUserAccount = [UserAccount getCurrentUserAccount];
    _receiptList = [Receipt getReceiptListWithMemeberID:currentUserAccount.userAccountID];
    _receiptList = [Receipt sortList:_receiptList];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSString *title = [Language getText:@"ประวัติการสั่งอาหาร"];
    lblNavTitle.text = title;
    tbvData.delegate = self;
    tbvData.dataSource = self;
    tbvData.separatorColor = [UIColor clearColor];
//    _timerList = [[NSMutableArray alloc]init];
//    _timeToCountDownList = [[NSMutableArray alloc]init];
    _dicTimer = [[NSMutableDictionary alloc]init];
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierReceiptSummary bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierReceiptSummary];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelRemark bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelRemark];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierOrderSummary bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierOrderSummary];
    }
    
    
    
    [self loadingOverlayView];
    _loadData = YES;
    _page = 1;
    _perPage = 10;
    _lastItemReached = NO;
    _receiptList = [[NSMutableArray alloc]init];
    UserAccount *userAccount = [UserAccount getCurrentUserAccount];
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    [self.homeModel downloadItems:dbReceiptSummaryPage withData:@[userAccount,@(_page),@(_perPage)]];
    
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if([tableView isEqual:tbvData])
    {
        if([_receiptList count] == 0)
        {
            NSString *message = [Language getText:@"คุณไม่มีประวัติการสั่งอาหาร"];
            UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
            noDataLabel.text             = message;
            noDataLabel.textColor        = cSystem4;
            noDataLabel.textAlignment    = NSTextAlignmentCenter;
            noDataLabel.font = [UIFont fontWithName:@"Prompt-Regular" size:15.0f];
            tableView.backgroundView = noDataLabel;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            return 0;
        }
        else
        {
            tableView.backgroundView = nil;
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }
        return [_receiptList count];
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if([tableView isEqual:tbvData])
    {
        return 1;
    }
    else
    {
        NSInteger receiptID = tableView.tag;
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receiptID];
        orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
        
        return [orderTakingList count]+4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    if([tableView isEqual:tbvData])
    {
        CustomTableViewCellReceiptSummary *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierReceiptSummary];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
        Receipt *receipt = _receiptList[section];
        
        
        //(buffet)
        UIColor *color = cSystem4;
        NSDictionary *attribute = @{NSForegroundColorAttributeName:color};
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Order no. #%@",receipt.receiptNoID] attributes:attribute];
    
    
        UIColor *color2 = cSystem2;
        NSDictionary *attribute2 = @{NSForegroundColorAttributeName:color2};
        NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:@" (Buffet)" attributes:attribute2];
        if(receipt.buffetReceiptID)
        {
            [attrString appendAttributedString:attrString2];
        }
        
        
        NSString *message = [Language getText:@"ร้าน %@"];
        Branch *branch = [Branch getBranch:receipt.branchID];
        cell.lblReceiptNo.attributedText = attrString;
        cell.lblReceiptDate.text = [Utility dateToString:receipt.modifiedDate toFormat:@"d MMM yy HH:mm"];
        cell.lblBranchName.text = [NSString stringWithFormat:message,branch.name];
        cell.lblBranchName.textColor = cSystem1;
        
        
        
        {
            UINib *nib = [UINib nibWithNibName:reuseIdentifierOrderSummary bundle:nil];
            [cell.tbvOrderDetail registerNib:nib forCellReuseIdentifier:reuseIdentifierOrderSummary];
        }
        {
            UINib *nib = [UINib nibWithNibName:reuseIdentifierTotal bundle:nil];
            [cell.tbvOrderDetail registerNib:nib forCellReuseIdentifier:reuseIdentifierTotal];
        }
        {
            UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelLabel bundle:nil];
            [cell.tbvOrderDetail registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelLabel];
        }
        {
            UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelRemark bundle:nil];
            [cell.tbvOrderDetail registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelRemark];
        }
        {
            UINib *nib = [UINib nibWithNibName:reuseIdentifierButton bundle:nil];
            [cell.tbvOrderDetail registerNib:nib forCellReuseIdentifier:reuseIdentifierButton];
        }
        
        
        cell.tbvOrderDetail.delegate = self;
        cell.tbvOrderDetail.dataSource = self;
        cell.tbvOrderDetail.tag = receipt.receiptID;
        [cell.tbvOrderDetail reloadData];
        [cell.btnOrderItAgain setTitle:[Language getText:@"สั่งซ้ำ"] forState:UIControlStateNormal];
        [cell.btnOrderItAgain addTarget:self action:@selector(orderItAgain:) forControlEvents:UIControlEventTouchUpInside];
        [self setButtonDesign:cell.btnOrderItAgain];
        
        

        if (!_lastItemReached && section == [_receiptList count]-1)
        {
            UserAccount *userAccount = [UserAccount getCurrentUserAccount];
            self.homeModel = [[HomeModel alloc]init];
            self.homeModel.delegate = self;
            [self.homeModel downloadItems:dbReceiptSummaryPage withData:@[userAccount,@(_page),@(_perPage)]];
        }
        
        return cell;
    }
    else
    {
        NSInteger receiptID = tableView.tag;
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receiptID];
        orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
        
        
        if(item < [orderTakingList count])
        {
            CustomTableViewCellOrderSummary *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierOrderSummary];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            OrderTaking *orderTaking = orderTakingList[item];
            Menu *menu = [Menu getMenu:orderTaking.menuID branchID:orderTaking.branchID];
            cell.lblQuantity.text = [Utility formatDecimal:orderTaking.quantity withMinFraction:0 andMaxFraction:0];
            
            
            //menu
            if(orderTaking.takeAway)
            {
                NSString *message = [Language getText:@"ใส่ห่อ"];
                UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:message attributes:attribute];
                
                NSDictionary *attribute2 = @{NSFontAttributeName: font};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",menu.titleThai] attributes:attribute2];
                
                
                [attrString appendAttributedString:attrString2];
                cell.lblMenuName.attributedText = attrString;
            }
            else
            {
                cell.lblMenuName.text = menu.titleThai;
            }
            [cell.lblMenuName sizeToFit];
            cell.lblMenuNameHeight.constant = cell.lblMenuName.frame.size.height>46?46:cell.lblMenuName.frame.size.height;
            
            
            
            //note
            NSMutableAttributedString *strAllNote;
            NSMutableAttributedString *attrStringRemove;
            NSMutableAttributedString *attrStringAdd;
            NSString *strRemoveTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:-1];
            NSString *strAddTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:1];
            if(![Utility isStringEmpty:strRemoveTypeNote])
            {
                NSString *message = [Language getText:@"ไม่ใส่"];
                UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:11];
                NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                attrStringRemove = [[NSMutableAttributedString alloc] initWithString:message attributes:attribute];
                
                
                UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:11];
                NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strRemoveTypeNote] attributes:attribute2];
                
                
                [attrStringRemove appendAttributedString:attrString2];
            }
            if(![Utility isStringEmpty:strAddTypeNote])
            {
                NSString *message = [Language getText:@"เพิ่ม"];
                UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:11];
                NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                attrStringAdd = [[NSMutableAttributedString alloc] initWithString:message attributes:attribute];
                
                
                UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:11];
                NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strAddTypeNote] attributes:attribute2];
                
                
                [attrStringAdd appendAttributedString:attrString2];
            }
            if(![Utility isStringEmpty:strRemoveTypeNote])
            {
                strAllNote = attrStringRemove;
                if(![Utility isStringEmpty:strAddTypeNote])
                {
                    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"\n" attributes:nil];
                    [strAllNote appendAttributedString:attrString];
                    [strAllNote appendAttributedString:attrStringAdd];
                }
            }
            else
            {
                if(![Utility isStringEmpty:strAddTypeNote])
                {
                    strAllNote = attrStringAdd;
                }
                else
                {
                    strAllNote = [[NSMutableAttributedString alloc]init];
                }
            }
            cell.lblNote.attributedText = strAllNote;
            [cell.lblNote sizeToFit];
            cell.lblNoteHeight.constant = cell.lblNote.frame.size.height>40?40:cell.lblNote.frame.size.height;
            
            
            
            float totalAmount = (orderTaking.specialPrice+orderTaking.takeAwayPrice+orderTaking.notePrice) * orderTaking.quantity;
            NSString *strTotalAmount = [Utility formatDecimal:totalAmount withMinFraction:2 andMaxFraction:2];
            cell.lblTotalAmount.text = [Utility addPrefixBahtSymbol:strTotalAmount];
            
            
            
            if(receiptID == _selectedReceiptID)
            {
                cell.backgroundColor = mSelectionStyleGray;
                if(item == [orderTakingList count]-1)
                {
                    _selectedReceiptID = 0;
                }
            }
            else
            {
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            return cell;
        }
        else if(item == [orderTakingList count])
        {
            CustomTableViewCellLabelRemark *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelRemark];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            Receipt *receipt = [Receipt getReceipt:receiptID];
            if([Utility isStringEmpty:receipt.remark])
            {
                cell.lblText.attributedText = [self setAttributedString:@"" text:receipt.remark];
            }
            else
            {
                NSString *message = [Language getText:@"หมายเหตุ: "];
                cell.lblText.attributedText = [self setAttributedString:message text:receipt.remark];
            }
            [cell.lblText sizeToFit];
            cell.lblTextHeight.constant = cell.lblText.frame.size.height;
            
            return cell;
        }
        else if(item == [orderTakingList count]+1)
        {
            CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            Receipt *receipt = [Receipt getReceipt:receiptID];
            NSString *strTotalAmount = [Utility formatDecimal:receipt.cashAmount+receipt.transferAmount+receipt.creditCardAmount withMinFraction:2 andMaxFraction:2];
            strTotalAmount = [Utility addPrefixBahtSymbol:strTotalAmount];
            cell.lblAmount.text = strTotalAmount;
            cell.lblTitle.text = [Language getText:@"รวมทั้งหมด"];
            cell.lblTitleTop.constant = 8;
            cell.lblTitle.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
            cell.lblTitle.textColor = cSystem4;
            cell.lblAmount.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
            cell.lblAmount.textColor = cSystem1;
            
            
            
            return cell;
        }
        else if(item == [orderTakingList count]+2)
        {
            CustomTableViewCellLabelLabel *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelLabel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            Receipt *receipt = [Receipt getReceipt:receiptID];
            NSString *strStatus = [Receipt getStrStatus:receipt];
            UIColor *color = cSystem2;
            
            
            
            UIFont *font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
            NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
            NSMutableAttributedString *attrStringStatus = [[NSMutableAttributedString alloc] initWithString:strStatus attributes:attribute];
            
            
            UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:15];
            UIColor *color2 = cSystem4;
            NSDictionary *attribute2 = @{NSForegroundColorAttributeName:color2 ,NSFontAttributeName: font2};
            NSMutableAttributedString *attrStringStatusLabel = [[NSMutableAttributedString alloc] initWithString:@"Status: " attributes:attribute2];
            
            
            [attrStringStatusLabel appendAttributedString:attrStringStatus];
            cell.lblValue.attributedText = attrStringStatusLabel;
            if(receipt.hasBuffetMenu)
            {
                NSInteger timeToOrder = receipt.timeToOrder;
                NSTimeInterval seconds = [[Utility currentDateTime] timeIntervalSinceDate:receipt.receiptDate];
                NSInteger timeToCountDown = timeToOrder - seconds >= 0?timeToOrder - seconds:0;
                if(timeToCountDown == 0 || receipt.buffetEnded)
                {
                    cell.lblText.text = @"";
                    cell.lblText.hidden = YES;
                }
                else
                {
                    if(![_dicTimer objectForKey:[NSString stringWithFormat:@"%ld",receiptID]])
                    {
                        [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
                        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer:) userInfo:receipt repeats:YES];
                        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
                        [self populateLabelwithTime:timeToCountDown receipt:receipt];
                        [_dicTimer setValue:timer forKey:[NSString stringWithFormat:@"%ld",receiptID]];
                    }
                    cell.lblText.hidden = NO;
                }
            }
            else
            {
                cell.lblText.text = @"";
            }
            cell.lblTextWidthConstant.constant = 70;
            
        
            
            return cell;
        }
        else if(item == [orderTakingList count]+3)
        {
            CustomTableViewCellButton *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierButton];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            NSString *title = [Language getText:@"สั่งบุฟเฟ่ต์"];
            
            
            Receipt *receipt = [Receipt getReceipt:receiptID];
            NSInteger timeToOrder = receipt.timeToOrder;
            NSTimeInterval seconds = [[Utility currentDateTime] timeIntervalSinceDate:receipt.receiptDate];
            NSInteger timeToCountDown = timeToOrder - seconds >= 0?timeToOrder - seconds:0;
            cell.btnValue.tag = receiptID;
            cell.btnValue.hidden = !(receipt.hasBuffetMenu && timeToCountDown && !receipt.buffetEnded);
            cell.btnValue.backgroundColor = cSystem1;
            [cell.btnValue setTitle:title forState:UIControlStateNormal];
            [cell.btnValue addTarget:self action:@selector(orderBuffet:) forControlEvents:UIControlEventTouchUpInside];
            [self setButtonDesign:cell.btnValue];
            
            
            return cell;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:tbvData])
    {
        //load order มาโชว์
        Receipt *receipt = _receiptList[indexPath.section];
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receipt.receiptID];
        orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
        float sumHeight = 0;
        for(int i=0; i<[orderTakingList count]; i++)
        {
            CustomTableViewCellOrderSummary *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierOrderSummary];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            OrderTaking *orderTaking = orderTakingList[i];
            Menu *menu = [Menu getMenu:orderTaking.menuID branchID:orderTaking.branchID];
            cell.lblQuantity.text = [Utility formatDecimal:orderTaking.quantity withMinFraction:0 andMaxFraction:0];
            
            
            //menu
            if(orderTaking.takeAway)
            {
                NSString *message = [Language getText:@"ใส่ห่อ"];
                UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:message attributes:attribute];
                
                NSDictionary *attribute2 = @{NSFontAttributeName: font};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",menu.titleThai] attributes:attribute2];
                
                
                [attrString appendAttributedString:attrString2];
                cell.lblMenuName.attributedText = attrString;
            }
            else
            {
                cell.lblMenuName.text = menu.titleThai;
            }
            [cell.lblMenuName sizeToFit];
            cell.lblMenuNameHeight.constant = cell.lblMenuName.frame.size.height>46?46:cell.lblMenuName.frame.size.height;
            
            
            
            //note
            NSMutableAttributedString *strAllNote;
            NSMutableAttributedString *attrStringRemove;
            NSMutableAttributedString *attrStringAdd;
            NSString *strRemoveTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:-1];
            NSString *strAddTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:1];
            if(![Utility isStringEmpty:strRemoveTypeNote])
            {
                NSString *message = [Language getText:@"ไม่ใส่"];
                UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:11];
                NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                attrStringRemove = [[NSMutableAttributedString alloc] initWithString:message attributes:attribute];
                
                
                UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:11];
                NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strRemoveTypeNote] attributes:attribute2];
                
                
                [attrStringRemove appendAttributedString:attrString2];
            }
            if(![Utility isStringEmpty:strAddTypeNote])
            {
                NSString *message = [Language getText:@"เพิ่ม"];
                UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:11];
                NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                attrStringAdd = [[NSMutableAttributedString alloc] initWithString:message attributes:attribute];
                
                
                UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:11];
                NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strAddTypeNote] attributes:attribute2];
                
                
                [attrStringAdd appendAttributedString:attrString2];
            }
            if(![Utility isStringEmpty:strRemoveTypeNote])
            {
                strAllNote = attrStringRemove;
                if(![Utility isStringEmpty:strAddTypeNote])
                {
                    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"\n" attributes:nil];
                    [strAllNote appendAttributedString:attrString];
                    [strAllNote appendAttributedString:attrStringAdd];
                }
            }
            else
            {
                if(![Utility isStringEmpty:strAddTypeNote])
                {
                    strAllNote = attrStringAdd;
                }
                else
                {
                    strAllNote = [[NSMutableAttributedString alloc]init];
                }
            }
            cell.lblNote.attributedText = strAllNote;
            [cell.lblNote sizeToFit];
            cell.lblNoteHeight.constant = cell.lblNote.frame.size.height>40?40:cell.lblNote.frame.size.height;
            
            float height = 8+cell.lblMenuNameHeight.constant+2+cell.lblNoteHeight.constant+8;
            sumHeight += height;
        }
        
        
        //remarkHeight
//        CustomTableViewCellReceiptSummary *receiptSummaryCell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierReceiptSummary];
        CustomTableViewCellLabelRemark *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelRemark];
        if([Utility isStringEmpty:receipt.remark])
        {
            cell.lblText.attributedText = [self setAttributedString:@"" text:receipt.remark];
        }
        else
        {
            NSString *message = [Language getText:@"หมายเหตุ: "];
            cell.lblText.attributedText = [self setAttributedString:message text:receipt.remark];
        }
        [cell.lblText sizeToFit];
        cell.lblTextHeight.constant = cell.lblText.frame.size.height;
        
        cell.lblTextHeight.constant = cell.lblTextHeight.constant<18?18:cell.lblTextHeight.constant;
        float remarkHeight = [Utility isStringEmpty:receipt.remark]?0:4+cell.lblTextHeight.constant+4;
        
        
        
        float btnBuffetHeight = 0;
        if(receipt.hasBuffetMenu)
        {
            NSInteger timeToOrder = receipt.timeToOrder;
            NSTimeInterval seconds = [[Utility currentDateTime] timeIntervalSinceDate:receipt.receiptDate];
            NSInteger timeToCountDown = timeToOrder - seconds >= 0?timeToOrder - seconds:0;
            btnBuffetHeight = timeToCountDown && !receipt.buffetEnded ?44:0;
        }        
    
        
        return sumHeight+83+remarkHeight+34+34+btnBuffetHeight;//+37;
    }
    else
    {
        
        //load order มาโชว์
        NSInteger receiptID = tableView.tag;
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receiptID];
        orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
        
        if(indexPath.item < [orderTakingList count])
        {
            CustomTableViewCellOrderSummary *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierOrderSummary];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            OrderTaking *orderTaking = orderTakingList[indexPath.item];
            Menu *menu = [Menu getMenu:orderTaking.menuID branchID:orderTaking.branchID];
            cell.lblQuantity.text = [Utility formatDecimal:orderTaking.quantity withMinFraction:0 andMaxFraction:0];
            
            
            //menu
            if(orderTaking.takeAway)
            {
                NSString *message = [Language getText:@"ใส่ห่อ"];
                UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:message attributes:attribute];
                
                NSDictionary *attribute2 = @{NSFontAttributeName: font};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",menu.titleThai] attributes:attribute2];
                
                
                [attrString appendAttributedString:attrString2];
                cell.lblMenuName.attributedText = attrString;
            }
            else
            {
                cell.lblMenuName.text = menu.titleThai;
            }
            [cell.lblMenuName sizeToFit];
            cell.lblMenuNameHeight.constant = cell.lblMenuName.frame.size.height>46?46:cell.lblMenuName.frame.size.height;
            
            
            
            //note
            NSMutableAttributedString *strAllNote;
            NSMutableAttributedString *attrStringRemove;
            NSMutableAttributedString *attrStringAdd;
            NSString *strRemoveTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:-1];
            NSString *strAddTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:1];
            if(![Utility isStringEmpty:strRemoveTypeNote])
            {
                NSString *message = [Language getText:@"ไม่ใส่"];
                UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:11];
                NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                attrStringRemove = [[NSMutableAttributedString alloc] initWithString:message attributes:attribute];
                
                
                UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:11];
                NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strRemoveTypeNote] attributes:attribute2];
                
                
                [attrStringRemove appendAttributedString:attrString2];
            }
            if(![Utility isStringEmpty:strAddTypeNote])
            {
                NSString *message = [Language getText:@"เพิ่ม"];
                UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:11];
                NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                attrStringAdd = [[NSMutableAttributedString alloc] initWithString:message attributes:attribute];
                
                
                UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:11];
                NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strAddTypeNote] attributes:attribute2];
                
                
                [attrStringAdd appendAttributedString:attrString2];
            }
            if(![Utility isStringEmpty:strRemoveTypeNote])
            {
                strAllNote = attrStringRemove;
                if(![Utility isStringEmpty:strAddTypeNote])
                {
                    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"\n" attributes:nil];
                    [strAllNote appendAttributedString:attrString];
                    [strAllNote appendAttributedString:attrStringAdd];
                }
            }
            else
            {
                if(![Utility isStringEmpty:strAddTypeNote])
                {
                    strAllNote = attrStringAdd;
                }
                else
                {
                    strAllNote = [[NSMutableAttributedString alloc]init];
                }
            }
            cell.lblNote.attributedText = strAllNote;
            [cell.lblNote sizeToFit];
            cell.lblNoteHeight.constant = cell.lblNote.frame.size.height>40?40:cell.lblNote.frame.size.height;
            
            float height = 8+cell.lblMenuNameHeight.constant+2+cell.lblNoteHeight.constant+8;
            return height;
            
        }
        else if(indexPath.item == [orderTakingList count])
        {
            CustomTableViewCellLabelRemark *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelRemark];
            
            
            Receipt *receipt = [Receipt getReceipt:receiptID];
            if([Utility isStringEmpty:receipt.remark])
            {
                cell.lblText.attributedText = [self setAttributedString:@"" text:receipt.remark];
            }
            else
            {
                NSString *message = [Language getText:@"หมายเหตุ: "];
                cell.lblText.attributedText = [self setAttributedString:message text:receipt.remark];
            }
            [cell.lblText sizeToFit];
            cell.lblTextHeight.constant = cell.lblText.frame.size.height;
            
            if([Utility isStringEmpty:receipt.remark])
            {
                return 0;
            }
            else
            {
                cell.lblTextHeight.constant = cell.lblTextHeight.constant<18?18:cell.lblTextHeight.constant;
                float remarkHeight = [Utility isStringEmpty:receipt.remark]?0:4+cell.lblTextHeight.constant+4;
                
                return remarkHeight;
            }
        }
        else if(indexPath.item == [orderTakingList count]+1)
        {
            return 34;
        }
        else if(indexPath.item == [orderTakingList count]+2)
        {
            return 34;
        }
        else if(indexPath.item == [orderTakingList count]+3)
        {
            Receipt *receipt = [Receipt getReceipt:receiptID];
            if(receipt.hasBuffetMenu)
            {                
                NSInteger timeToOrder = receipt.timeToOrder;
                NSTimeInterval seconds = [[Utility currentDateTime] timeIntervalSinceDate:receipt.receiptDate];
                NSInteger timeToCountDown = timeToOrder - seconds >= 0?timeToOrder - seconds:0;
                return timeToCountDown && !receipt.buffetEnded ?44:0;
            }
            return 0;
        }
    }
    return 0;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    if([tableView isEqual:tbvData])
    {
        [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
    }
    else
    {
        NSInteger receiptID = tableView.tag;
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receiptID];
        orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
        Receipt *receipt = [Receipt getReceipt:receiptID];
        cell.separatorInset = UIEdgeInsetsMake(0.0f, self.view.bounds.size.width, 0.0f, CGFLOAT_MAX);
        if([Utility isStringEmpty:receipt.remark] && indexPath.item == [orderTakingList count]-1)
        {
            [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
        }
        
        
        if(indexPath.item == [orderTakingList count] || indexPath.item == [orderTakingList count]+1)
        {
            [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
        }        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![tableView isEqual:tbvData])
    {
        
        _selectedReceiptID = tableView.tag;
        _selectedReceipt = [Receipt getReceipt:_selectedReceiptID];
        [tableView reloadData];
        
        
        double delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self performSegueWithIdentifier:@"segOrderDetail" sender:self];
        });
        
    }
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToMe" sender:self];
}

-(void)itemsDownloaded:(NSArray *)items manager:(NSObject *)objHomeModel
{
    HomeModel *homeModel = (HomeModel *)objHomeModel;
    if(homeModel.propCurrentDB == dbReceiptSummaryPage)
    {
        [self removeOverlayViews];
        [Utility updateSharedObject:items];


        if(_page == 1)
        {
            _receiptList = items[0];
        }
        else
        {
            NSInteger remaining = [_receiptList count]%_perPage;
            for(int i=0; i<remaining; i++)
            {
                [_receiptList removeLastObject];
            }
            
            [_receiptList addObjectsFromArray:items[0]];
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

-(void)reloadTableView
{
    [tbvData reloadData];
}

- (IBAction)refresh:(id)sender
{
    [self viewDidAppear:NO];
}

-(void)orderItAgain:(id)sender
{
    CGPoint point = [sender convertPoint:CGPointZero toView:tbvData];
    NSIndexPath *indexPath = [tbvData indexPathForRowAtPoint:point];
    Receipt *receipt = _receiptList[indexPath.section];
    NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receipt.receiptID];
    [OrderTaking setCurrentOrderTakingList:orderTakingList];
    _orderItAgainReceipt = receipt;
    
    //belong to buffet
    if(_orderItAgainReceipt.buffetReceiptID)
    {
        Receipt *buffetReceipt = [Receipt getReceipt:_orderItAgainReceipt.buffetReceiptID];
        if(buffetReceipt)
        {
            NSInteger timeToOrder = buffetReceipt.timeToOrder;
            NSTimeInterval seconds = [[Utility currentDateTime] timeIntervalSinceDate:receipt.receiptDate];
            NSInteger timeToCountDown = timeToOrder - seconds >= 0?timeToOrder - seconds:0;
            if(timeToCountDown <= 0)
            {
                [self showAlert:@"" message:[Language getText:@"ขอโทษค่ะ หมดเวลาสั่งบุฟเฟ่ต์แล้วค่ะ"]];
                return;
            }
        }
        else
        {
            [self showAlert:@"" message:[Language getText:@"ขอโทษค่ะ หมดเวลาสั่งบุฟเฟ่ต์แล้วค่ะ"]];
            return;
        }
    }
    
    
    _receiptBranch = [Branch getBranch:receipt.branchID];
    [self performSegueWithIdentifier:@"segCreditCardAndOrderSummary" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segCreditCardAndOrderSummary"])
    {
        CreditCardAndOrderSummaryViewController *vc = segue.destinationViewController;
        vc.branch = _receiptBranch;
        vc.customerTable = nil;
        vc.fromReceiptSummaryMenu = 1;
        vc.receipt = _orderItAgainReceipt;
        Receipt *buffetReceipt = [Receipt getReceipt:_orderItAgainReceipt.buffetReceiptID];
        vc.buffetReceipt = buffetReceipt;
    }
    else if([[segue identifier] isEqualToString:@"segOrderDetail"] || [[segue identifier] isEqualToString:@"segOrderDetailNoAnimate"])
    {
        OrderDetailViewController *vc = segue.destinationViewController;
        vc.receipt = _selectedReceipt;
    }
    else if([[segue identifier] isEqualToString:@"segMenuSelection"])
    {
        MenuSelectionViewController *vc = segue.destinationViewController;
        vc.buffetReceipt = _selectedReceipt;
        vc.fromReceiptSummaryMenu = 1;
    }
}

-(void)segueToOrderDetailAuto:(Receipt *)receipt
{
    _selectedReceipt = receipt;
    [self performSegueWithIdentifier:@"segOrderDetailNoAnimate" sender:self];
}

-(void)orderBuffet:(id)sender
{
    UIButton *btnValue = sender;
    _selectedReceipt = [Receipt getReceipt:btnValue.tag];
    [self performSegueWithIdentifier:@"segMenuSelection" sender:self];
}

-(void)updateTimer:(NSTimer *)timer
{
    Receipt *receipt = timer.userInfo;
    NSInteger timeToOrder = receipt.timeToOrder;
    NSTimeInterval seconds = [[Utility currentDateTime] timeIntervalSinceDate:receipt.receiptDate];
    NSInteger timeToCountDown = timeToOrder - seconds >= 0?timeToOrder - seconds:0;
    if(timeToCountDown == 0)
    {
        [timer invalidate];
        [tbvData reloadData];
    }
    else
    {
        [self populateLabelwithTime:timeToCountDown receipt:receipt];
    }
}

- (void)populateLabelwithTime:(NSInteger)seconds receipt:(Receipt *)receipt
{
    NSInteger minutes = seconds / 60;
    NSInteger hours = minutes / 60;
    
    seconds -= minutes * 60;
    minutes -= hours * 60;
    
    
    NSInteger index = [Receipt getIndex:_receiptList receipt:receipt];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    CustomTableViewCellReceiptSummary *cell = [tbvData cellForRowAtIndexPath:indexPath];
    
    
    NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receipt.receiptID];
    orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
    NSIndexPath *indexPathOrderDetail = [NSIndexPath indexPathForRow:[orderTakingList count]+2 inSection:0];
    
    
    CustomTableViewCellLabelLabel *cellTimeToCountDown = [cell.tbvOrderDetail cellForRowAtIndexPath:indexPathOrderDetail];
    cellTimeToCountDown.lblText.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hours, minutes, seconds];
}
@end

