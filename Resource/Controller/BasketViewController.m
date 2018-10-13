//
//  BasketViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 22/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "BasketViewController.h"
#import "NoteViewController.h"
#import "CreditCardAndOrderSummaryViewController.h"
#import "CustomTableViewCellOrder.h"
#import "CustomTableViewCellTotal.h"
#import "CustomTableViewCellNote.h"
#import "CustomTableViewHeaderFooterButton.h"
#import "Receipt.h"
#import "OrderTaking.h"
#import "OrderNote.h"
#import "Menu.h"
#import "Note.h"
#import "SpecialPriceProgram.h"
#import "Promotion.h"
#import "MenuType.h"
#import "MenuNote.h"
#import "CreditCard.h"


#import "Utility.h"
#import "Setting.h"



@interface BasketViewController ()
{
    NSMutableArray *_orderTakingList;
    OrderTaking *_orderTaking;
    OrderTaking *_copyOrderTaking;
    NSMutableArray *_menuList;
    NSString *_voucherCode;
    
    
    
    Promotion *_promotionUsed;
    float _netTotal;
    NSInteger _discountType;
    float _discountAmount;
    float _discountValue;
    
    NSInteger _sourceCopyItem;
    
}
@end

@implementation BasketViewController
static NSString * const reuseIdentifierOrder = @"CustomTableViewCellOrder";
static NSString * const reuseIdentifierTotal = @"CustomTableViewCellTotal";
static NSString * const reuseIdentifierHeaderFooterButton = @"CustomTableViewHeaderFooterButton";
static NSString * const reuseIdentifierNote = @"CustomTableViewCellNote";


@synthesize lblNavTitle;
@synthesize tbvOrder;
@synthesize tbvTotal;
@synthesize branch;
@synthesize customerTable;
@synthesize tbvTotalHeightConstant;
@synthesize topViewHeight;
@synthesize bottomButtonHeight;
@synthesize buffetReceipt;


-(IBAction)unwindToBasket:(UIStoryboardSegue *)segue;
{
    [self.view endEditing:true];
    [tbvOrder reloadData];
    [tbvTotal reloadData];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.tag != 0)
    {  
        //remove ordertaking
        NSInteger menuID = textField.tag;
        NSMutableArray *currentOrderTakingList = [OrderTaking getCurrentOrderTakingList];
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithMenuID:menuID orderTakingList:currentOrderTakingList];
        NSInteger quantity = [textField.text integerValue];
        NSInteger currentOrderTakingCount = [orderTakingList count];
        if(quantity < currentOrderTakingCount)
        {
            for(int i=0; i<currentOrderTakingCount-quantity; i++)
            {
                NSMutableArray *currentOrderTakingList = [OrderTaking getCurrentOrderTakingList];
                NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithMenuID:menuID orderTakingList:currentOrderTakingList];
                
                //remove orderTaking
                OrderTaking *lastOrderTaking = orderTakingList[[orderTakingList count]-1];
                [OrderTaking removeObject:lastOrderTaking];
                [currentOrderTakingList removeObject:lastOrderTaking];
                
                
                //remove orderNote
                NSMutableArray *orderNoteList = [OrderNote getOrderNoteListWithOrderTakingID:lastOrderTaking.orderTakingID];
                [OrderNote removeList:orderNoteList];
            }
            
            
            [tbvOrder reloadData];
            [tbvTotal reloadData];
            [self blinkRemovedNotiView];
        }
        else if(quantity > currentOrderTakingCount)
        {
            //add ordertaking
//            NSInteger menuID = cell.lblMenuName.tag;
            Menu *menu = [Menu getMenu:menuID branchID:branch.branchID];
            SpecialPriceProgram *specialPriceProgram = [SpecialPriceProgram getSpecialPriceProgramTodayWithMenuID:menuID branchID:branch.branchID];
            float specialPrice = specialPriceProgram?specialPriceProgram.specialPrice:menu.price;
            NSMutableArray *currentOrderTakingList = [OrderTaking getCurrentOrderTakingList];
            
            
            for(int i=0; i<quantity-currentOrderTakingCount; i++)
            {
                OrderTaking *orderTaking = [[OrderTaking alloc]initWithBranchID:branch.branchID customerTableID:customerTable.customerTableID menuID:menuID quantity:1 specialPrice:specialPrice price:menu.price takeAway:0 takeAwayPrice:0 noteIDListInText:@"" notePrice:0 orderNo:0 status:1 receiptID:0];
                [OrderTaking addObject:orderTaking];
                [currentOrderTakingList addObject:orderTaking];
            }
            
            [tbvOrder reloadData];
            [tbvTotal reloadData];
            [self blinkAddedNotiView];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    if(textField.tag != 0)
    {
        NSString *resultingString = [textField.text stringByReplacingCharactersInRange: range withString: string];
        
        // The user deleting all input is perfectly acceptable.
        if ([resultingString length] == 0) {
            return true;
        }
        
        NSInteger holder;
        
        NSScanner *scan = [NSScanner scannerWithString: resultingString];
        
        
        
        //fix length
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        //**********
        
        
        
        return [scan scanInteger: &holder] && [scan isAtEnd] && (newLength <= 2 || returnKey);
    }
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segNote"])
    {
        NoteViewController *vc = segue.destinationViewController;
        vc.noteList = [MenuNote getNoteListWithMenuID:_orderTaking.menuID];
        vc.orderTaking = _orderTaking;
        vc.branch = branch;
    }
    else if([[segue identifier] isEqualToString:@"segCreditCardAndOrderSummary"])
    {
        CreditCardAndOrderSummaryViewController *vc = segue.destinationViewController;
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
    
    
    NSMutableArray *currentOrderTakingList = [OrderTaking getCurrentOrderTakingList];
    NSMutableArray *menuList = [Menu getMenuListWithOrderTakingList:currentOrderTakingList];
    
    
    for(Menu *item in menuList)
    {
        item.expand = 0;
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithMenuID:item.menuID orderTakingList:currentOrderTakingList];
        for(OrderTaking *orderTaking in orderTakingList)
        {
            if(![Utility isStringEmpty:orderTaking.noteIDListInText] || orderTaking.takeAway)
            {
                item.expand = 1;
                break;
            }
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    NSString *title = [Language getText:@"สรุปรายการที่สั่ง"];
    lblNavTitle.text = title;
    tbvOrder.delegate = self;
    tbvOrder.dataSource = self;
    [tbvOrder setSeparatorColor:[UIColor clearColor]];
    tbvOrder.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    tbvTotal.delegate = self;
    tbvTotal.dataSource = self;
    [tbvTotal setSeparatorColor:[UIColor clearColor]];
    tbvTotal.scrollEnabled = NO;
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierOrder bundle:nil];
        [tbvOrder registerNib:nib forCellReuseIdentifier:reuseIdentifierOrder];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierTotal bundle:nil];
        [tbvTotal registerNib:nib forCellReuseIdentifier:reuseIdentifierTotal];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierHeaderFooterButton bundle:nil];
        [tbvTotal registerNib:nib forHeaderFooterViewReuseIdentifier:reuseIdentifierHeaderFooterButton];
    }
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture setCancelsTouchesInView:NO];
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    if([tableView isEqual:tbvOrder])
    {
        return 1;
    }
    else if([tableView isEqual:tbvTotal])
    {
        return 1;
    }

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([tableView isEqual:tbvOrder])
    {
        _orderTakingList = [OrderTaking getCurrentOrderTakingList];
        _menuList = [Menu getMenuListWithOrderTakingList:_orderTakingList];
        return [_menuList count];
    }
    else if([tableView isEqual:tbvTotal])
    {
        tbvTotalHeightConstant.constant = 78;
        return 1;
    }
    else
    {
        NSInteger menuID = tableView.tag;
        NSMutableArray *currentOrderTakingList = [OrderTaking getCurrentOrderTakingList];
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithMenuID:menuID orderTakingList:currentOrderTakingList];
        return [orderTakingList count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    if([tableView isEqual:tbvOrder])
    {
        CustomTableViewCellOrder *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierOrder];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
        
        //menu
        Menu *menu = _menuList[item];
        cell.lblMenuName.text = menu.titleThai;
        cell.lblMenuName.tag = menu.menuID;
        [cell.lblMenuName sizeToFit];
        cell.lblMenuNameHeight.constant = cell.lblMenuName.frame.size.height<21.5?21.5:cell.lblMenuName.frame.size.height;
        
        
        //quantity
        NSMutableArray *currentOrderTakingList = [OrderTaking getCurrentOrderTakingList];
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithMenuID:menu.menuID orderTakingList:currentOrderTakingList];
        float sumQuantity = [OrderTaking getSumQuantity:orderTakingList];
        NSString *strSumQuantity = [Utility formatDecimal:sumQuantity withMinFraction:0 andMaxFraction:0];
        cell.txtQuantity.text = strSumQuantity;
        cell.txtQuantity.tag = menu.menuID;
        cell.txtQuantity.delegate = self;
        cell.txtQuantity.keyboardType = UIKeyboardTypeNumberPad;
        [cell.txtQuantity setInputAccessoryView:self.toolBar];
        
        
        //total
        float totalPrice = [OrderTaking getSumSpecialPrice:orderTakingList];
        NSString *strTotalPrice = [Utility formatDecimal:totalPrice withMinFraction:2 andMaxFraction:2];
        cell.lblTotalPrice.text = strTotalPrice;
        

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
            [self.homeModel downloadImageWithFileName:menu.imageUrl type:1 branchID:menu.branchID completionBlock:^(BOOL succeeded, UIImage *image)
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
        

        
        
        cell.tbvNote.tag = menu.menuID;
        cell.tbvNote.dataSource = self;
        cell.tbvNote.delegate = self;
        [cell.tbvNote setSeparatorColor:[UIColor clearColor]];
        [cell.tbvNote reloadData];
        
        {
            UINib *nib = [UINib nibWithNibName:reuseIdentifierNote bundle:nil];
            [cell.tbvNote registerNib:nib forCellReuseIdentifier:reuseIdentifierNote];
        }
        
        
        
        
        if(menu.expand)
        {
            cell.imgExpandCollapse.image = [UIImage imageNamed:@"collapse2.png"];
        }
        else
        {
            cell.imgExpandCollapse.image = [UIImage imageNamed:@"expand2.png"];
        }
        
        
        cell.stepperValue = sumQuantity;
        cell.btnDeleteQuantity.tag = 201;
        cell.btnAddQuantity.tag = 202;
        [cell.btnDeleteQuantity addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnAddQuantity addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        //expand collapse position
        cell.imgExpandCollapseTrailing.constant =  self.view.frame.size.width - (cell.btnAddQuantity.frame.origin.x+cell.btnAddQuantity.frame.size.width+(self.view.frame.size.width-16-cell.lblTotalPrice.frame.size.width))/2-16;
        
        
        return cell;
    }
    else if([tableView isEqual:tbvTotal])
    {
        _orderTakingList = [OrderTaking getCurrentOrderTakingList];
        switch (item)
        {
            case 0:
            {
                CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                NSString *message = [Language getText:@"%ld รายการ"];
                NSString *strTitle = [NSString stringWithFormat:message,[_orderTakingList count]];
                NSString *strTotal = [Utility formatDecimal:[OrderTaking getSumSpecialPrice:_orderTakingList] withMinFraction:2 andMaxFraction:2];
                strTotal = [Utility addPrefixBahtSymbol:strTotal];
                cell.lblTitle.text = strTitle;
                cell.lblAmount.text = strTotal;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                cell.lblTitle.textColor = cSystem4;
                cell.lblAmount.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                cell.lblAmount.textColor = cSystem1;
                
                
                return  cell;
            }
                break;
            default:
                break;
        }
    }
    else
    {
        NSInteger menuID = tableView.tag;
        
        {
            NSString *message = [Language getText:@"เพิ่มโน้ต"];
            NSString *message2 = [Language getText:@"จานที่ %ld"];
            CustomTableViewCellNote *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierNote];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            cell.lblDishNo.text = [NSString stringWithFormat:message2,item+1];
            cell.txtNote.delegate = self;
            cell.txtNote.placeholder = message;
            
        
            //note
            NSMutableArray *currentOrderTakingList = [OrderTaking getCurrentOrderTakingList];
            NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithMenuID:menuID orderTakingList:currentOrderTakingList];
            OrderTaking *orderTaking;
            if([orderTakingList count]>0)
            {
                orderTaking = orderTakingList[item];
                
                
                NSMutableAttributedString *strAllNote;
                NSMutableAttributedString *attrStringRemove;
                NSMutableAttributedString *attrStringAdd;
                NSString *strRemoveTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:-1];
                NSString *strAddTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:1];
                if(![Utility isStringEmpty:strRemoveTypeNote])
                {
                    UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:11];
                    NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                    attrStringRemove = [[NSMutableAttributedString alloc] initWithString:[Language getText:@"ไม่ใส่"] attributes:attribute];
                    
                    
                    UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:11];
                    NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strRemoveTypeNote] attributes:attribute2];
                    
                    
                    [attrStringRemove appendAttributedString:attrString2];
                }
                if(![Utility isStringEmpty:strAddTypeNote])
                {
                    UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:11];
                    NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                    attrStringAdd = [[NSMutableAttributedString alloc] initWithString:[Language getText:@"เพิ่ม"] attributes:attribute];
                    
                    
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
                cell.txtNote.attributedText = strAllNote;
                
                
                float sumNotePrice = [OrderNote getSumNotePriceWithOrderTakingID:orderTaking.orderTakingID];
                NSString *strSumNotePrice = [Utility formatDecimal:sumNotePrice withMinFraction:0 andMaxFraction:0];
                strSumNotePrice = [NSString stringWithFormat:@"+%@",strSumNotePrice];
                cell.lblTotalNotePrice.text = strSumNotePrice;
                if(sumNotePrice == 0)
                {
                    cell.lblTotalNotePrice.text = @"";
                }
            }
            [cell.longPressGestureRecognizer addTarget:self action:@selector(handleLongPress:)];
            [cell.txtNote addGestureRecognizer:cell.longPressGestureRecognizer];
            
            
            
            [cell.doubleTapGestureRecognizer addTarget:self action:@selector(handleDoubleTap:)];
            [cell.txtNote addGestureRecognizer:cell.doubleTapGestureRecognizer];
            cell.doubleTapGestureRecognizer.numberOfTapsRequired = 2;
            [cell.singleTapGestureRecognizer addTarget:self action:@selector(handleSingleTap:)];
            [cell.txtNote addGestureRecognizer:cell.singleTapGestureRecognizer];
            cell.singleTapGestureRecognizer.numberOfTapsRequired = 1;
            [cell.singleTapGestureRecognizer requireGestureRecognizerToFail:cell.doubleTapGestureRecognizer];
            
            
            
            
            
            cell.btnDelete.tag = item;
            [cell.btnDelete addTarget:self action:@selector(deleteNote:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnDelete addTarget:self action:@selector(deleteNoteTouchDown:) forControlEvents:UIControlEventTouchDown];
            
            
            
            cell.btnTakeAway.tag = item;
            [cell.btnTakeAway addTarget:self action:@selector(takeAway:) forControlEvents:UIControlEventTouchUpInside];
            if(orderTaking.takeAway)
            {
                UIImage *image = [UIImage imageNamed:@"takeAway2.png"];
                [cell.btnTakeAway setBackgroundImage:image forState:UIControlStateNormal];
            }
            else
            {
                UIImage *image = [UIImage imageNamed:@"takeAwayGrayOut.png"];
                [cell.btnTakeAway setBackgroundImage:image forState:UIControlStateNormal];
            }
            
            
            return cell;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    if([tableView isEqual:tbvOrder])
    {
        CustomTableViewCellOrder *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierOrder];
        
      
        Menu *menu = _menuList[item];
        cell.lblMenuName.text = menu.titleThai;
        [cell.lblMenuName sizeToFit];
        float height = 58.5+cell.lblMenuName.frame.size.height+8<88?88:58.5+cell.lblMenuName.frame.size.height+8;

        
        NSMutableArray *currentOrderTakingList = [OrderTaking getCurrentOrderTakingList];
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithMenuID:menu.menuID orderTakingList:currentOrderTakingList];
        height = menu.expand?height+([orderTakingList count])*44:height;
        
        
        return height;
        
    }
    else if([tableView isEqual:tbvTotal])
    {
        return 34;
    }
    else
    {
        return 44;
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
    

    if([tableView isEqual:tbvOrder])
    {
        Menu *menu = _menuList[item];
        if(!menu.expand)
        {
            NSString *message = [Language getText:@"กดค้างที่ช่อง \"เพิ่มโน้ต\" เพื่อแสดงเมนูแก้ไขโน้ต"];
            [self blinkAlertMsg:message];
        }
        menu.expand = !menu.expand;
        
        
        
        
        [tbvOrder reloadData];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if([tableView isEqual:tbvTotal])
    {
        CustomTableViewHeaderFooterButton *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifierHeaderFooterButton];
        
        
        NSString *message = [Language getText:@"ยืนยันการสั่งอาหาร"];
        [footerView.btnValue setTitle:message forState:UIControlStateNormal];
        [footerView.btnValue addTarget:self action:@selector(checkOut:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        return footerView;
    }
    return nil;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if([tableView isEqual:tbvTotal])
    {
        float height = 44;
        return height;
    }
    return 0;
}

- (IBAction)unwindToMenuSelection:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToMenuSelection" sender:self];
}

- (IBAction)deleteAll:(id)sender
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:[Language getText:@"ลบทั้งหมด"]
                                                      style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
                              {
                                  [OrderTaking removeCurrentOrderTakingList];
                                  [CreditCard removeCurrentCreditCard];
                                  [tbvOrder reloadData];
                                  [tbvTotal reloadData];
                              }];
    
    [alert addAction:action1];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:[Language getText:@"ยกเลิก"]
                                                      style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                              {
                                  
                              }];
    
    [alert addAction:action2];
    
    
    
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        UIButton *button = sender;
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        popPresenter.sourceView = button;
        popPresenter.sourceRect = button.bounds;
    }
    [self presentViewController:alert animated:YES completion:nil];
    
    
    // this has to be set after presenting the alert, otherwise the internal property __representer is nil
    UIFont *font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
    UIColor *color = cSystem1;
    NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[Language getText:@"ลบทั้งหมด"] attributes:attribute];
    
    UILabel *label = [[action1 valueForKey:@"__representer"] valueForKey:@"label"];
    label.attributedText = attrString;
    
    
    
    UIFont *font2 = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
    UIColor *color2 = cSystem4;
    NSDictionary *attribute2 = @{NSForegroundColorAttributeName:color2 ,NSFontAttributeName: font2};
    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[Language getText:@"ลบทั้งหมด"] attributes:attribute2];
    
    UILabel *label2 = [[action2 valueForKey:@"__representer"] valueForKey:@"label"];
    label2.attributedText = attrString2;
}

-(void)stepperValueChanged:(id)sender
{
    UIButton *button = sender;
    
    CGPoint point = [sender convertPoint:CGPointZero toView:tbvOrder];
    NSIndexPath *indexPath = [tbvOrder indexPathForRowAtPoint:point];
    CustomTableViewCellOrder *cell = [tbvOrder cellForRowAtIndexPath:indexPath];
    if(button.tag == 201)
    {
        NSInteger quantity = [cell.txtQuantity.text integerValue]-1;
        cell.txtQuantity.text = [Utility formatDecimal:quantity withMinFraction:0 andMaxFraction:0];
        
        
        //remove ordertaking
        NSInteger menuID = cell.lblMenuName.tag;
        NSMutableArray *currentOrderTakingList = [OrderTaking getCurrentOrderTakingList];
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithMenuID:menuID orderTakingList:currentOrderTakingList];
        OrderTaking *lastOrderTaking = orderTakingList[[orderTakingList count]-1];
        [OrderTaking removeObject:lastOrderTaking];
        [currentOrderTakingList removeObject:lastOrderTaking];
        
        
        //remove orderNote
        NSMutableArray *orderNoteList = [OrderNote getOrderNoteListWithOrderTakingID:lastOrderTaking.orderTakingID];
        [OrderNote removeList:orderNoteList];
        
        

        [tbvOrder reloadData];
        [tbvTotal reloadData];
        [self blinkRemovedNotiView];
    }
    else if(button.tag == 202)
    {
        if([cell.txtQuantity.text integerValue] == 99)
        {
            return;
        }
        NSInteger quantity = [cell.txtQuantity.text integerValue]+1;
        cell.txtQuantity.text = [Utility formatDecimal:quantity withMinFraction:0 andMaxFraction:0];
        
        
        //add ordertaking
        NSInteger menuID = cell.lblMenuName.tag;
        Menu *menu = [Menu getMenu:menuID branchID:branch.branchID];
        SpecialPriceProgram *specialPriceProgram = [SpecialPriceProgram getSpecialPriceProgramTodayWithMenuID:menuID branchID:branch.branchID];
        float specialPrice = specialPriceProgram?specialPriceProgram.specialPrice:menu.price;
        
        
        NSMutableArray *currentOrderTakingList = [OrderTaking getCurrentOrderTakingList];
        OrderTaking *orderTaking = [[OrderTaking alloc]initWithBranchID:branch.branchID customerTableID:customerTable.customerTableID menuID:menuID quantity:1 specialPrice:specialPrice price:menu.price takeAway:0 takeAwayPrice:0 noteIDListInText:@"" notePrice:0 orderNo:0 status:1 receiptID:0];
        [OrderTaking addObject:orderTaking];
        [currentOrderTakingList addObject:orderTaking];

        
        
                
        [tbvOrder reloadData];
        [tbvTotal reloadData];
        [self blinkAddedNotiView];
    }
}

-(void)deleteNote:(id)sender
{
    UIButton *button = sender;
    NSInteger item = button.tag;
    CGPoint point = [sender convertPoint:CGPointZero toView:tbvOrder];
    NSIndexPath *indexPath = [tbvOrder indexPathForRowAtPoint:point];
    
    
    
    Menu *menu = _menuList[indexPath.item];
    NSMutableArray *currentOrderTakingList = [OrderTaking getCurrentOrderTakingList];
    NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithMenuID:menu.menuID orderTakingList:currentOrderTakingList];
    OrderTaking *orderTaking = orderTakingList[item];
    
    

    NSMutableArray *orderNoteList = [OrderNote getOrderNoteListWithOrderTakingID:orderTaking.orderTakingID];
    [OrderNote removeList:orderNoteList];
    
    
    
    orderTaking.notePrice = 0;
    orderTaking.modifiedUser = [Utility modifiedUser];
    orderTaking.modifiedDate = [Utility currentDateTime];
    
    [tbvOrder reloadData];
    [tbvTotal reloadData];
}

- (void)deleteNoteTouchDown:(id)sender
{
    UIButton *button = sender;
    [button setImage:[UIImage imageNamed:@"remove light color.png"] forState:UIControlStateNormal];
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [button setImage:[UIImage imageNamed:@"remove.png"] forState:UIControlStateNormal];
    });
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:tbvOrder];
    NSIndexPath * tappedIP = [tbvOrder indexPathForRowAtPoint:point];
    CustomTableViewCellOrder *cell = [tbvOrder cellForRowAtIndexPath:tappedIP];
    {
        CGPoint point = [gestureRecognizer locationInView:cell.tbvNote];
        NSIndexPath * tappedIP = [cell.tbvNote indexPathForRowAtPoint:point];
        _sourceCopyItem = tappedIP.item;
    }
    
    
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:[Language getText:@"คัดลอก"]
                                                      style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                              {
                                  Menu *menu = _menuList[tappedIP.item];
                                  NSMutableArray *currentOrderTakingList = [OrderTaking getCurrentOrderTakingList];
                                  NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithMenuID:menu.menuID orderTakingList:currentOrderTakingList];
                                  
                                  {
                                      CGPoint point = [gestureRecognizer locationInView:cell.tbvNote];
                                      NSIndexPath * tappedIP = [cell.tbvNote indexPathForRowAtPoint:point];
                                      _copyOrderTaking = orderTakingList[_sourceCopyItem];
//                                      _copyOrderTaking = orderTakingList[tappedIP.item];
                                  }
                                  
                                  
                                  UIFont *font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                                  UIColor *color = cSystem1;
                                  NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
                                  NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[Language getText:@"คัดลอก"] attributes:attribute];
                                  
                                  UILabel *label = [[action1 valueForKey:@"__representer"] valueForKey:@"label"];
                                  label.attributedText = attrString;
                              }];
    [alert addAction:action1];
    
    
    NSString *message4 = [Language getText:@"วางทั้งหมด"];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:message4
                                                      style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                              {
                                  Menu *menu = _menuList[tappedIP.item];
                                  NSMutableArray *currentOrderTakingList = [OrderTaking getCurrentOrderTakingList];
                                  NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithMenuID:menu.menuID orderTakingList:currentOrderTakingList];
                                  
                                  
                                  for(OrderTaking *orderTaking in orderTakingList)
                                  {
                                      if(_copyOrderTaking && ![orderTaking isEqual:_copyOrderTaking] && _copyOrderTaking.menuID == orderTaking.menuID)
                                      {
                                          //remove current note
                                          NSMutableArray *currentOrderNoteList = [OrderNote getOrderNoteListWithOrderTakingID:orderTaking.orderTakingID];
                                          [OrderNote removeList:currentOrderNoteList];
                                          
                                          
                                          //add note
                                          NSMutableArray *orderNoteList = [OrderNote getOrderNoteListWithOrderTakingID:_copyOrderTaking.orderTakingID];
                                          for(OrderNote *item in orderNoteList)
                                          {
                                              OrderNote *orderNote = [item copy];
                                              orderNote.orderNoteID = [OrderNote getNextID];
                                              orderNote.orderTakingID = orderTaking.orderTakingID;
                                              [OrderNote addObject:orderNote];
                                          }
                                          
                                          
                                          //update note id list in text
                                          orderTaking.noteIDListInText = [OrderNote getNoteIDListInTextWithOrderTakingID:orderTaking.orderTakingID];
                                          
                                          
                                          //update ordertaking price
                                          float sumNotePrice = [OrderNote getSumNotePriceWithOrderTakingID:orderTaking.orderTakingID];
                                          orderTaking.notePrice = sumNotePrice;
                                          orderTaking.modifiedUser = [Utility modifiedUser];
                                          orderTaking.modifiedDate = [Utility currentDateTime];
                                      }
                                  }
                                  
                                  [tbvOrder reloadData];
                              }];
    [alert addAction:action4];
    
    
    NSString *message5 = [Language getText:@"Take away ทั้งหมด"];
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:message5
                                                      style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                              {
                                  Menu *menu = _menuList[tappedIP.item];
                                  NSMutableArray *currentOrderTakingList = [OrderTaking getCurrentOrderTakingList];
                                  NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithMenuID:menu.menuID orderTakingList:currentOrderTakingList];
                                  
                                  
                                  for(OrderTaking *orderTaking in orderTakingList)
                                  {
                                      orderTaking.takeAway = orderTaking.takeAway;
                                      float takeAwayFee = orderTaking.takeAway?branch.takeAwayFee:0;
                                      orderTaking.takeAwayPrice = takeAwayFee;
                                      orderTaking.modifiedUser = [Utility modifiedUser];
                                      orderTaking.modifiedDate = [Utility currentDateTime];
                            
                                  }
                                  
                                  [tbvOrder reloadData];
                                  [tbvTotal reloadData];
                              }];
    [alert addAction:action5];
    
    
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:[Language getText:@"ยกเลิก"]
                                                      style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                              {
                              }];
    [alert addAction:action2];
    
    
    
    NSString *message3 = [Setting getValue:@"114m" example:@"Double tap at note to paste"];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:message3
                                                         style:UIAlertActionStyleDestructive
                                                       handler:^(UIAlertAction *action)
                                 {
                                 }];
    [alert addAction:action3];
    
    

    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        CGPoint pointTbvNote = [gestureRecognizer locationInView:cell.tbvNote];
        NSIndexPath * indexPath = [cell.tbvNote indexPathForRowAtPoint:pointTbvNote];
        CustomTableViewCellNote *cellNote = [cell.tbvNote cellForRowAtIndexPath:indexPath];
        
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        popPresenter.sourceView = cellNote.txtNote;
        popPresenter.sourceRect = cellNote.txtNote.bounds;
    }
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
    
    UIFont *font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
    UIColor *color = cSystem1;
    NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[Language getText:@"คัดลอก"] attributes:attribute];
    
    UILabel *label = [[action1 valueForKey:@"__representer"] valueForKey:@"label"];
    label.attributedText = attrString;
    
    
    
    UIFont *font4 = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
    UIColor *color4 = cSystem1;
    NSDictionary *attribute4 = @{NSForegroundColorAttributeName:color4 ,NSFontAttributeName: font4};
    NSMutableAttributedString *attrString4 = [[NSMutableAttributedString alloc] initWithString:message4 attributes:attribute4];
    
    UILabel *label4 = [[action4 valueForKey:@"__representer"] valueForKey:@"label"];
    label4.attributedText = attrString4;
    
    
    
    UIFont *font5 = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
    UIColor *color5 = cSystem1;
    NSDictionary *attribute5 = @{NSForegroundColorAttributeName:color5 ,NSFontAttributeName: font5};
    NSMutableAttributedString *attrString5 = [[NSMutableAttributedString alloc] initWithString:message5 attributes:attribute5];
    
    UILabel *label5 = [[action5 valueForKey:@"__representer"] valueForKey:@"label"];
    label5.attributedText = attrString5;
    
    
    
    UIFont *font2 = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
    UIColor *color2 = cSystem4;
    NSDictionary *attribute2 = @{NSForegroundColorAttributeName:color2 ,NSFontAttributeName: font2};
    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[Language getText:@"ยกเลิก"] attributes:attribute2];
    
    UILabel *label2 = [[action2 valueForKey:@"__representer"] valueForKey:@"label"];
    label2.attributedText = attrString2;
    
    
    
    UIFont *font3 = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
    UIColor *color3 = mPlaceHolder;
    NSDictionary *attribute3 = @{NSForegroundColorAttributeName:color3 ,NSFontAttributeName: font3};
    NSMutableAttributedString *attrString3 = [[NSMutableAttributedString alloc] initWithString:message3 attributes:attribute3];
    
    UILabel *label3 = [[action3 valueForKey:@"__representer"] valueForKey:@"label"];
    label3.attributedText = attrString3;
    
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:tbvOrder];
    NSIndexPath * tappedIP = [tbvOrder indexPathForRowAtPoint:point];
    CustomTableViewCellOrder *cell = [tbvOrder cellForRowAtIndexPath:tappedIP];
    
    
    Menu *menu = _menuList[tappedIP.item];
    NSMutableArray *currentOrderTakingList = [OrderTaking getCurrentOrderTakingList];
    NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithMenuID:menu.menuID orderTakingList:currentOrderTakingList];
    OrderTaking *orderTaking;
    {
        CGPoint point = [gestureRecognizer locationInView:cell.tbvNote];
        NSIndexPath * tappedIP = [cell.tbvNote indexPathForRowAtPoint:point];
        orderTaking = orderTakingList[tappedIP.item];
    }
    
    
    
    if(_copyOrderTaking && ![orderTaking isEqual:_copyOrderTaking] && _copyOrderTaking.menuID == orderTaking.menuID)
    {
        //remove current note
        NSMutableArray *currentOrderNoteList = [OrderNote getOrderNoteListWithOrderTakingID:orderTaking.orderTakingID];
        [OrderNote removeList:currentOrderNoteList];
        
        
        //add note
        NSMutableArray *orderNoteList = [OrderNote getOrderNoteListWithOrderTakingID:_copyOrderTaking.orderTakingID];
        for(OrderNote *item in orderNoteList)
        {
            OrderNote *orderNote = [item copy];
            orderNote.orderNoteID = [OrderNote getNextID];
            orderNote.orderTakingID = orderTaking.orderTakingID;
            [OrderNote addObject:orderNote];
        }
        
        
        //update note id list in text
        orderTaking.noteIDListInText = [OrderNote getNoteIDListInTextWithOrderTakingID:orderTaking.orderTakingID];
        
        
        //update ordertaking price
        float sumNotePrice = [OrderNote getSumNotePriceWithOrderTakingID:orderTaking.orderTakingID];
        orderTaking.notePrice = sumNotePrice;
        orderTaking.modifiedUser = [Utility modifiedUser];
        orderTaking.modifiedDate = [Utility currentDateTime];
        
        [tbvOrder reloadData];
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:tbvOrder];
    NSIndexPath * tappedIP = [tbvOrder indexPathForRowAtPoint:point];
    CustomTableViewCellOrder *cell = [tbvOrder cellForRowAtIndexPath:tappedIP];

    
    
    Menu *menu = _menuList[tappedIP.item];
    NSMutableArray *currentOrderTakingList = [OrderTaking getCurrentOrderTakingList];
    NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithMenuID:menu.menuID orderTakingList:currentOrderTakingList];
    {
        CGPoint point = [gestureRecognizer locationInView:cell.tbvNote];
        NSIndexPath * tappedIP = [cell.tbvNote indexPathForRowAtPoint:point];
        _orderTaking = orderTakingList[tappedIP.item];
    }

    

    [self performSegueWithIdentifier:@"segNote" sender:self];
}

-(void)checkOut:(id)sender
{    
    [self performSegueWithIdentifier:@"segCreditCardAndOrderSummary" sender:self];
}

-(void)takeAway:(id)sender
{
    UIButton *button = sender;
    NSInteger item = button.tag;
    CGPoint point = [sender convertPoint:CGPointZero toView:tbvOrder];
    NSIndexPath *indexPath = [tbvOrder indexPathForRowAtPoint:point];
    
    
    
    Menu *menu = _menuList[indexPath.item];
    NSMutableArray *currentOrderTakingList = [OrderTaking getCurrentOrderTakingList];
    NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithMenuID:menu.menuID orderTakingList:currentOrderTakingList];
    OrderTaking *orderTaking = orderTakingList[item];
    
    
    
    orderTaking.takeAway = !orderTaking.takeAway;
    float takeAwayFee = orderTaking.takeAway?branch.takeAwayFee:0;
    orderTaking.takeAwayPrice = takeAwayFee;
    orderTaking.modifiedUser = [Utility modifiedUser];
    orderTaking.modifiedDate = [Utility currentDateTime];

    
    if(orderTaking.takeAway)
    {        
        [self blinkTakeAwayNotiView];
    }
    [tbvOrder reloadData];
    [tbvTotal reloadData];
}
@end
