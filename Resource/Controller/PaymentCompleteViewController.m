//
//  PaymentCompleteViewController.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 14/6/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "PaymentCompleteViewController.h"
#import "CustomTableViewCellLogo.h"
#import "CustomTableViewCellReceiptSummary.h"
#import "CustomTableViewCellOrderSummary.h"
#import "CustomTableViewCellTotal.h"
#import "CustomTableViewCellLabelRemark.h"
#import "CustomTableViewCellSeparatorLine.h"
#import "Branch.h"
#import "OrderTaking.h"
#import "Note.h"
#import "OrderNote.h"
#import "Menu.h"
#import "Setting.h"


@interface PaymentCompleteViewController ()
{
    UITableView *tbvData;
    BOOL _endOfFile;
    BOOL _logoDownloaded;
}
@end

@implementation PaymentCompleteViewController
static NSString * const reuseIdentifierLogo = @"CustomTableViewCellLogo";
static NSString * const reuseIdentifierReceiptSummary = @"CustomTableViewCellReceiptSummary";
static NSString * const reuseIdentifierOrderSummary = @"CustomTableViewCellOrderSummary";
static NSString * const reuseIdentifierTotal = @"CustomTableViewCellTotal";
static NSString * const reuseIdentifierLabelRemark = @"CustomTableViewCellLabelRemark";
static NSString * const reuseIdentifierSeparatorLine = @"CustomTableViewCellSeparatorLine";


@synthesize receipt;
@synthesize btnSaveToCameraRoll;
@synthesize lblTitle;
@synthesize lblMessage;
@synthesize imgVwCheckTop;
@synthesize btnOrderBuffet;
@synthesize btnOrderBuffetHeight;


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self setButtonDesign:btnSaveToCameraRoll];
    
    
    imgVwCheckTop.constant = (self.view.frame.size.height - 63 - (559-69))/2;
    if(receipt.buffetReceiptID)
    {
        lblTitle.text = @"สั่งบุฟเฟ่ต์สำเร็จ";
    }
    else
    {
        lblTitle.text = @"ชำระเงินสำเร็จ";
    }
    if([Receipt hasBuffetMenu:receipt.receiptID] || receipt.buffetReceiptID)
    {
        [self setButtonDesign:btnOrderBuffet];
        [btnSaveToCameraRoll setTitle:@"บันทึกใบเสร็จ และสั่งบุฟเฟต์" forState:UIControlStateNormal];
    }
    else
    {
        btnOrderBuffet.hidden = YES;
        [btnSaveToCameraRoll setTitle:@"บันทึกใบเสร็จลงอัลบั้ม" forState:UIControlStateNormal];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *title = [Setting getValue:@"044t" example:@"ชำระเงินสำเร็จ"];
    NSString *message = [Setting getValue:@"044m" example:@"ขอบคุณที่ใช้บริการ ​JUMMUM"];
    lblTitle.text = title;
    lblMessage.text = message;
    tbvData = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLogo bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierLogo];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierReceiptSummary bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierReceiptSummary];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierOrderSummary bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierOrderSummary];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierTotal bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierTotal];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelRemark bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelRemark];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierSeparatorLine bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierSeparatorLine];
    }
    
}

- (IBAction)button1Clicked:(id)sender
{
    //save to camera roll
    [self screenCaptureBill:receipt];
    if([Receipt hasBuffetMenu:receipt.receiptID] || receipt.buffetReceiptID)
    {
        [self performSegueWithIdentifier:@"segUnwindToMe" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"segUnwindToHotDeal" sender:self];
    }
}

- (IBAction)button2Clicked:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToHotDeal" sender:self];
}

- (IBAction)orderBuffet:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToMe" sender:self];
}

-(void)screenCaptureBill:(Receipt *)receipt
{
    NSMutableArray *arrImage = [[NSMutableArray alloc]init];
    Branch *branch = [Branch getBranch:receipt.branchID];
    
    
    {
        //shop logo
        CustomTableViewCellLogo *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierLogo];
        [self.homeModel downloadImageWithFileName:branch.imageUrl type:2 branchID:branch.branchID completionBlock:^(BOOL succeeded, UIImage *image)
         {
             if (succeeded)
             {
                 cell.imgVwValue.image = image;
                 UIImage *image = [self imageFromView:cell];
                 [arrImage insertObject:image atIndex:0];
                 _logoDownloaded = YES;
                 
                 if(_logoDownloaded && _endOfFile)
                 {
                     UIImage *combineImage = [self combineImage:arrImage];
                     UIImageWriteToSavedPhotosAlbum(combineImage, nil, nil, nil);
                     return;
                 }
             }
         }];
    }
    
    
    
    {
        //order header
        CustomTableViewCellReceiptSummary *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierReceiptSummary];
        cell.lblReceiptNo.text = [NSString stringWithFormat:@"Order no. #%@", receipt.receiptNoID];
        cell.lblReceiptDate.text = [Utility dateToString:receipt.receiptDate toFormat:@"d MMM yy HH:mm"];
        cell.lblBranchName.text = [NSString stringWithFormat:@"ร้าน %@",branch.name];
        cell.lblBranchName.textColor = cSystem1;
        cell.btnOrderItAgain.hidden = YES;
        
        
        CGRect frame = cell.frame;
        frame.size.height = 79;
        cell.frame = frame;
        
        UIImage *image = [self imageFromView:cell];
        [arrImage addObject:image];
    }
    
    
    
    
    
    
    
    ///// order detail
    NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receipt.receiptID];
    orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
    for(int i=0; i<[orderTakingList count]; i++)
    {
        CustomTableViewCellOrderSummary *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierOrderSummary];
        
        
        OrderTaking *orderTaking = orderTakingList[i];
        Menu *menu = [Menu getMenu:orderTaking.menuID branchID:orderTaking.branchID];
        cell.lblQuantity.text = [Utility formatDecimal:orderTaking.quantity withMinFraction:0 andMaxFraction:0];
        
        
        //menu
        if(orderTaking.takeAway)
        {
            UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:15];
            NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"ใส่ห่อ"
                                                                                           attributes:attribute];
            
            NSDictionary *attribute2 = @{NSFontAttributeName: font};
            NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",menu.titleThai] attributes:attribute2];
            
            
            [attrString appendAttributedString:attrString2];
            cell.lblMenuName.attributedText = attrString;
        }
        else
        {
            cell.lblMenuName.text = menu.titleThai;
        }
        CGSize menuNameLabelSize = [self suggestedSizeWithFont:cell.lblMenuName.font size:CGSizeMake(tbvData.frame.size.width - 75-28-2*16-2*8, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:cell.lblMenuName.text];
        CGRect frame = cell.lblMenuName.frame;
        frame.size.width = menuNameLabelSize.width;
        frame.size.height = menuNameLabelSize.height;
        cell.lblMenuNameHeight.constant = menuNameLabelSize.height;
        cell.lblMenuName.frame = frame;
        
        
        
        //note
        NSMutableAttributedString *strAllNote;
        NSMutableAttributedString *attrStringRemove;
        NSMutableAttributedString *attrStringAdd;
        NSString *strRemoveTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:-1];
        NSString *strAddTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:1];
        if(![Utility isStringEmpty:strRemoveTypeNote])
        {
            UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:11];
            NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
            attrStringRemove = [[NSMutableAttributedString alloc] initWithString:@"ไม่ใส่" attributes:attribute];
            
            
            UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:11];
            NSDictionary *attribute2 = @{NSFontAttributeName: font2};
            NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strRemoveTypeNote] attributes:attribute2];
            
            
            [attrStringRemove appendAttributedString:attrString2];
        }
        if(![Utility isStringEmpty:strAddTypeNote])
        {
            UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:11];
            NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
            attrStringAdd = [[NSMutableAttributedString alloc] initWithString:@"เพิ่ม" attributes:attribute];
            
            
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
        
        
        
        CGSize noteLabelSize = [self suggestedSizeWithFont:cell.lblNote.font size:CGSizeMake(tbvData.frame.size.width - 75-28-2*16-2*8, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:[strAllNote string]];
        noteLabelSize.height = [Utility isStringEmpty:[strAllNote string]]?0:noteLabelSize.height;
        CGRect frame2 = cell.lblNote.frame;
        frame2.size.width = noteLabelSize.width;
        frame2.size.height = noteLabelSize.height;
        cell.lblNoteHeight.constant = noteLabelSize.height;
        cell.lblNote.frame = frame2;
        
        
        
        
        
        float totalAmount = orderTaking.specialPrice * orderTaking.quantity;
        NSString *strTotalAmount = [Utility formatDecimal:totalAmount withMinFraction:2 andMaxFraction:2];
        cell.lblTotalAmount.text = [Utility addPrefixBahtSymbol:strTotalAmount];
        
        
        float height = menuNameLabelSize.height+noteLabelSize.height+8+8+2;
        CGRect frameCell = cell.frame;
        frameCell.size.height = height;
        cell.frame = frameCell;
        
        
        UIImage *image = [self imageFromView:cell];
        [arrImage addObject:image];
    }
    /////
    
    
    //separatorLine
    if([Utility isStringEmpty:receipt.remark])
    {
        CustomTableViewCellSeparatorLine *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierSeparatorLine];
        
        UIImage *image = [self imageFromView:cell];
        [arrImage addObject:image];
    }
    
    
    //section 1 --> total //
    {
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receipt.receiptID];
        
        
        if(receipt.discountValue == 0 && receipt.serviceChargePercent == 0)//3 rows
        {
            //remark
            if(![Utility isStringEmpty:receipt.remark])
            {
                CustomTableViewCellLabelRemark *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierLabelRemark];
                NSString *message = [Setting getValue:@"128m" example:@"หมายเหตุ: "];
                cell.lblText.attributedText = [self setAttributedString:message text:receipt.remark];
                [cell.lblText sizeToFit];
                cell.lblTextHeight.constant = cell.lblText.frame.size.height;
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
                
                
                //separatorLine
                CustomTableViewCellSeparatorLine *cell2 = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierSeparatorLine];
                
                UIImage *image2 = [self imageFromView:cell2];
                [arrImage addObject:image2];
            }
            
            // 0:
            {
                CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                NSString *strTitle = [NSString stringWithFormat:@"%ld รายการ",[orderTakingList count]];
                NSString *strTotal = [Utility formatDecimal:[OrderTaking getSumSpecialPrice:orderTakingList] withMinFraction:2 andMaxFraction:2];
                strTotal = [Utility addPrefixBahtSymbol:strTotal];
                cell.lblTitle.text = strTitle;
                cell.lblAmount.text = strTotal;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                cell.lblTitle.textColor = cSystem4;
                cell.lblAmount.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                cell.lblAmount.textColor = cSystem1;
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
            }
            // 1:
            {
                //vat
                CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                NSString *strPercentVat = [Utility formatDecimal:receipt.vatPercent withMinFraction:0 andMaxFraction:2];
                strPercentVat = [NSString stringWithFormat:@"Vat %@%%",strPercentVat];
                
                NSString *strAmount = [Utility formatDecimal:receipt.vatValue withMinFraction:2 andMaxFraction:2];
                strAmount = [Utility addPrefixBahtSymbol:strAmount];
                
                cell.lblTitle.text = receipt.vatPercent==0?@"Vat":strPercentVat;
                cell.lblAmount.text = strAmount;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                cell.lblTitle.textColor = cSystem4;
                cell.lblAmount.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                cell.lblAmount.textColor = cSystem4;
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
            }
            // 2:
            {
                //net total
                CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                float netTotalAmount = receipt.cashAmount+receipt.creditCardAmount+receipt.transferAmount;
                NSString *strAmount = [Utility formatDecimal:netTotalAmount withMinFraction:2 andMaxFraction:2];
                strAmount = [Utility addPrefixBahtSymbol:strAmount];
                cell.lblTitle.text = @"ยอดรวมทั้งสิ้น";
                cell.lblAmount.text = strAmount;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                cell.lblTitle.textColor = cSystem4;
                cell.lblAmount.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                cell.lblAmount.textColor = cSystem1;
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
            }
            
        }
        else if(receipt.discountValue > 0 && receipt.serviceChargePercent == 0)//5 rows
        {
            //remark
            if(![Utility isStringEmpty:receipt.remark])
            {
                CustomTableViewCellLabelRemark *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierLabelRemark];
                NSString *message = [Setting getValue:@"128m" example:@"หมายเหตุ: "];
                cell.lblText.attributedText = [self setAttributedString:message text:receipt.remark];
                [cell.lblText sizeToFit];
                cell.lblTextHeight.constant = cell.lblText.frame.size.height;
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
                
                
                
                //separatorLine
                CustomTableViewCellSeparatorLine *cell2 = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierSeparatorLine];
                
                UIImage *image2 = [self imageFromView:cell2];
                [arrImage addObject:image2];
            }
            // 0:
            {
                CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                NSString *strTitle = [NSString stringWithFormat:@"%ld รายการ",[orderTakingList count]];
                NSString *strTotal = [Utility formatDecimal:[OrderTaking getSumSpecialPrice:orderTakingList] withMinFraction:2 andMaxFraction:2];
                strTotal = [Utility addPrefixBahtSymbol:strTotal];
                cell.lblTitle.text = strTitle;
                cell.lblAmount.text = strTotal;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                cell.lblTitle.textColor = cSystem4;
                cell.lblAmount.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                cell.lblAmount.textColor = cSystem1;
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
            }
            // 1:
            {
                //discount
                CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                NSString *strDiscount = [Utility formatDecimal:receipt.discountAmount withMinFraction:0 andMaxFraction:2];
                strDiscount = [NSString stringWithFormat:@"ส่วนลด %@%%",strDiscount];
                
                NSString *strAmount = [Utility formatDecimal:receipt.discountValue withMinFraction:2 andMaxFraction:2];
                strAmount = [Utility addPrefixBahtSymbol:strAmount];
                strAmount = [NSString stringWithFormat:@"-%@",strAmount];
                
                cell.lblTitle.text = receipt.discountType==1?@"ส่วนลด":strDiscount;
                cell.lblAmount.text = strAmount;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                cell.lblTitle.textColor = cSystem4;
                cell.lblAmount.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                cell.lblAmount.textColor = cSystem2;
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
            }
            // 2:
            {
                //after discount
                CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                NSString *strTitle = @"ยอดรวม";
                NSString *strTotal = [Utility formatDecimal:[OrderTaking getSumSpecialPrice:orderTakingList]-receipt.discountValue withMinFraction:2 andMaxFraction:2];
                strTotal = [Utility addPrefixBahtSymbol:strTotal];
                cell.lblTitle.text = strTitle;
                cell.lblAmount.text = strTotal;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                cell.lblTitle.textColor = cSystem4;
                cell.lblAmount.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                cell.lblAmount.textColor = cSystem1;
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
            }
            // 3:
            {
                //vat
                CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                NSString *strPercentVat = [Utility formatDecimal:receipt.vatPercent withMinFraction:0 andMaxFraction:2];
                strPercentVat = [NSString stringWithFormat:@"Vat %@%%",strPercentVat];
                
                NSString *strAmount = [Utility formatDecimal:receipt.vatValue withMinFraction:2 andMaxFraction:2];
                strAmount = [Utility addPrefixBahtSymbol:strAmount];
                
                cell.lblTitle.text = receipt.vatPercent==0?@"Vat":strPercentVat;
                cell.lblAmount.text = strAmount;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                cell.lblTitle.textColor = cSystem4;
                cell.lblAmount.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                cell.lblAmount.textColor = cSystem4;
                
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
            }
            // 4:
            {
                //net total
                CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                float netTotalAmount = receipt.cashAmount+receipt.creditCardAmount+receipt.transferAmount;
                NSString *strAmount = [Utility formatDecimal:netTotalAmount withMinFraction:2 andMaxFraction:2];
                strAmount = [Utility addPrefixBahtSymbol:strAmount];
                cell.lblTitle.text = @"ยอดรวมทั้งสิ้น";
                cell.lblAmount.text = strAmount;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                cell.lblTitle.textColor = cSystem4;
                cell.lblAmount.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                cell.lblAmount.textColor = cSystem1;
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
            }
        }
        else if(receipt.discountValue == 0 && receipt.serviceChargePercent > 0)//4 rows
        {
            //remark
            if(![Utility isStringEmpty:receipt.remark])
            {
                CustomTableViewCellLabelRemark *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierLabelRemark];
                NSString *message = [Setting getValue:@"128m" example:@"หมายเหตุ: "];
                cell.lblText.attributedText = [self setAttributedString:message text:receipt.remark];
                [cell.lblText sizeToFit];
                cell.lblTextHeight.constant = cell.lblText.frame.size.height;
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
                
                
                
                //separatorLine
                CustomTableViewCellSeparatorLine *cell2 = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierSeparatorLine];
                
                UIImage *image2 = [self imageFromView:cell2];
                [arrImage addObject:image2];
            }
            // 0:
            {
                CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                NSString *strTitle = [NSString stringWithFormat:@"%ld รายการ",[orderTakingList count]];
                NSString *strTotal = [Utility formatDecimal:[OrderTaking getSumSpecialPrice:orderTakingList] withMinFraction:2 andMaxFraction:2];
                strTotal = [Utility addPrefixBahtSymbol:strTotal];
                cell.lblTitle.text = strTitle;
                cell.lblAmount.text = strTotal;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                cell.lblTitle.textColor = cSystem4;
                cell.lblAmount.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                cell.lblAmount.textColor = cSystem1;
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
            }
            // 1:
            {
                //service charge
                CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                NSString *strServiceChargePercent = [Utility formatDecimal:receipt.serviceChargePercent withMinFraction:0 andMaxFraction:2];
                strServiceChargePercent = [NSString stringWithFormat:@"Service charge %@%%",strServiceChargePercent];
                
                NSString *strAmount = [Utility formatDecimal:receipt.serviceChargeValue withMinFraction:2 andMaxFraction:2];
                strAmount = [Utility addPrefixBahtSymbol:strAmount];
                
                cell.lblTitle.text = strServiceChargePercent;
                cell.lblAmount.text = strAmount;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                cell.lblTitle.textColor = cSystem4;
                cell.lblAmount.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                cell.lblAmount.textColor = cSystem4;
                
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
            }
            // 2:
            {
                //vat
                CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                NSString *strPercentVat = [Utility formatDecimal:receipt.vatPercent withMinFraction:0 andMaxFraction:2];
                strPercentVat = [NSString stringWithFormat:@"Vat %@%%",strPercentVat];
                
                NSString *strAmount = [Utility formatDecimal:receipt.vatValue withMinFraction:2 andMaxFraction:2];
                strAmount = [Utility addPrefixBahtSymbol:strAmount];
                
                cell.lblTitle.text = receipt.vatPercent==0?@"Vat":strPercentVat;
                cell.lblAmount.text = strAmount;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                cell.lblTitle.textColor = cSystem4;
                cell.lblAmount.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                cell.lblAmount.textColor = cSystem4;
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
            }
            // 3:
            {
                //net total
                CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                float netTotalAmount = receipt.cashAmount+receipt.creditCardAmount+receipt.transferAmount;
                NSString *strAmount = [Utility formatDecimal:netTotalAmount withMinFraction:2 andMaxFraction:2];
                strAmount = [Utility addPrefixBahtSymbol:strAmount];
                cell.lblTitle.text = @"ยอดรวมทั้งสิ้น";
                cell.lblAmount.text = strAmount;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                cell.lblTitle.textColor = cSystem4;
                cell.lblAmount.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                cell.lblAmount.textColor = cSystem1;
                
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
            }
        }
        else if(receipt.discountValue > 0 && receipt.serviceChargePercent > 0)//6 rows
        {
            //remark
            if(![Utility isStringEmpty:receipt.remark])
            {
                CustomTableViewCellLabelRemark *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierLabelRemark];
                NSString *message = [Setting getValue:@"128m" example:@"หมายเหตุ: "];
                cell.lblText.attributedText = [self setAttributedString:message text:receipt.remark];
                [cell.lblText sizeToFit];
                cell.lblTextHeight.constant = cell.lblText.frame.size.height;
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
                
                
                
                //separatorLine
                CustomTableViewCellSeparatorLine *cell2 = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierSeparatorLine];
                
                UIImage *image2 = [self imageFromView:cell2];
                [arrImage addObject:image2];
            }
            // 0:
            {
                CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                NSString *strTitle = [NSString stringWithFormat:@"%ld รายการ",[orderTakingList count]];
                NSString *strTotal = [Utility formatDecimal:[OrderTaking getSumSpecialPrice:orderTakingList] withMinFraction:2 andMaxFraction:2];
                strTotal = [Utility addPrefixBahtSymbol:strTotal];
                cell.lblTitle.text = strTitle;
                cell.lblAmount.text = strTotal;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                cell.lblTitle.textColor = cSystem4;
                cell.lblAmount.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                cell.lblAmount.textColor = cSystem1;
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
            }
            // 1:
            {
                //discount
                CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                NSString *strDiscount = [Utility formatDecimal:receipt.discountAmount withMinFraction:0 andMaxFraction:2];
                strDiscount = [NSString stringWithFormat:@"ส่วนลด %@%%",strDiscount];
                
                NSString *strAmount = [Utility formatDecimal:receipt.discountValue withMinFraction:2 andMaxFraction:2];
                strAmount = [Utility addPrefixBahtSymbol:strAmount];
                strAmount = [NSString stringWithFormat:@"-%@",strAmount];
                
                
                cell.lblTitle.text = receipt.discountType==1?@"ส่วนลด":strDiscount;
                cell.lblAmount.text = strAmount;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                cell.lblTitle.textColor = cSystem4;
                cell.lblAmount.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                cell.lblAmount.textColor = cSystem2;
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
            }
            // 2:
            {
                //after discount
                CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                NSString *strTitle = @"ยอดรวม";
                NSString *strTotal = [Utility formatDecimal:[OrderTaking getSumSpecialPrice:orderTakingList]-receipt.discountValue withMinFraction:2 andMaxFraction:2];
                strTotal = [Utility addPrefixBahtSymbol:strTotal];
                cell.lblTitle.text = strTitle;
                cell.lblAmount.text = strTotal;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                cell.lblTitle.textColor = cSystem4;
                cell.lblAmount.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                cell.lblAmount.textColor = cSystem1;
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
            }
            // 3:
            {
                //service charge
                CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                NSString *strServiceChargePercent = [Utility formatDecimal:receipt.serviceChargePercent withMinFraction:0 andMaxFraction:2];
                strServiceChargePercent = [NSString stringWithFormat:@"Service charge %@%%",strServiceChargePercent];
                
                NSString *strAmount = [Utility formatDecimal:receipt.serviceChargeValue withMinFraction:2 andMaxFraction:2];
                strAmount = [Utility addPrefixBahtSymbol:strAmount];
                
                cell.lblTitle.text = strServiceChargePercent;
                cell.lblAmount.text = strAmount;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                cell.lblTitle.textColor = cSystem4;
                cell.lblAmount.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                cell.lblAmount.textColor = cSystem4;
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
            }
            // 4:
            {
                //vat
                CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                NSString *strPercentVat = [Utility formatDecimal:receipt.vatPercent withMinFraction:0 andMaxFraction:2];
                strPercentVat = [NSString stringWithFormat:@"Vat %@%%",strPercentVat];
                
                NSString *strAmount = [Utility formatDecimal:receipt.vatValue withMinFraction:2 andMaxFraction:2];
                strAmount = [Utility addPrefixBahtSymbol:strAmount];
                
                cell.lblTitle.text = receipt.vatPercent==0?@"Vat":strPercentVat;
                cell.lblAmount.text = strAmount;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                cell.lblTitle.textColor = cSystem4;
                cell.lblAmount.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                cell.lblAmount.textColor = cSystem4;
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
            }
            // 5:
            {
                //net total
                CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                float netTotalAmount = receipt.cashAmount+receipt.creditCardAmount+receipt.transferAmount;
                NSString *strAmount = [Utility formatDecimal:netTotalAmount withMinFraction:2 andMaxFraction:2];
                strAmount = [Utility addPrefixBahtSymbol:strAmount];
                cell.lblTitle.text = @"ยอดรวมทั้งสิ้น";
                cell.lblAmount.text = strAmount;
                cell.vwTopBorder.hidden = YES;
                cell.lblTitle.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                cell.lblTitle.textColor = cSystem4;
                cell.lblAmount.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                cell.lblAmount.textColor = cSystem1;
                
                
                UIImage *image = [self imageFromView:cell];
                [arrImage addObject:image];
            }
        }
        
        
        
        {
            //space at the end
            UITableViewCell *cell =  [tbvData dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            CGRect frame = cell.frame;
            frame.size.height = 20;
            cell.frame = frame;
            
            UIImage *image = [self imageFromView:cell];
            [arrImage addObject:image];
        }
        
        _endOfFile = YES;
    }
    ////
    
    if(_logoDownloaded && _endOfFile)
    {
        UIImage *combineImage = [self combineImage:arrImage];
        UIImageWriteToSavedPhotosAlbum(combineImage, nil, nil, nil);
        return;
    }
}

@end
