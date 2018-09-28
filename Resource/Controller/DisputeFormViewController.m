//
//  DisputeFormViewController.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 12/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "DisputeFormViewController.h"
#import "CustomTableViewCellLabelText.h"
#import "CustomTableViewCellLabelTextView.h"
#import "CustomTableViewHeaderFooterOkCancel.h"
#import "Dispute.h"
#import "DisputeReason.h"
#import "Receipt.h"
#import "Branch.h"
#import "Setting.h"



@interface DisputeFormViewController ()
{
    Dispute *_dispute;
    NSMutableArray *_disputeReasonList;
    NSInteger _selectedIndexPicker;
    NSString *_strPlaceHolder;
    
}
@end

@implementation DisputeFormViewController
static NSString * const reuseIdentifierLabelText = @"CustomTableViewCellLabelText";
static NSString * const reuseIdentifierLabelTextView = @"CustomTableViewCellLabelTextView";
static NSString * const reuseIdentifierHeaderFooterOkCancel = @"CustomTableViewHeaderFooterOkCancel";


@synthesize lblNavTitle;
@synthesize tbvData;
@synthesize pickerVw;
@synthesize receipt;
@synthesize fromType;
@synthesize tbvAction;
@synthesize topViewHeight;
@synthesize bottomViewHeight;


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    bottomViewHeight.constant = window.safeAreaInsets.bottom;
    
    float topPadding = window.safeAreaInsets.top;
    topViewHeight.constant = topPadding == 0?20:topPadding;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.textColor = [UIColor blackColor];
    if([textView.text isEqualToString:_strPlaceHolder])
    {
        textView.text = @"";
    }
    
    [textView becomeFirstResponder];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    _dispute.detail = [Utility trimString:textView.text];
    if([textView.text isEqualToString:@""])
    {
        textView.text = _strPlaceHolder;
        textView.textColor = mPlaceHolder;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 1:
        {
            DisputeReason *disputeReason = [DisputeReason getDisputeReasonWithText:textField.text];
            _dispute.disputeReasonID = disputeReason.disputeReasonID;
        }
            break;
        case 2:
        {
            _dispute.refundAmount = [Utility floatValue:textField.text];
        }
            break;
        case 4:
        {
            _dispute.phoneNo = [Utility removeDashAndSpaceAndParenthesis:[Utility trimString:textField.text]];
        }
            break;
        default:
            break;
    }
}



- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.tag == 1)
    {
        DisputeReason *disputeReason = _disputeReasonList[_selectedIndexPicker];
        textField.text = [Language langIsEN]?disputeReason.text:disputeReason.text;
        [pickerVw selectRow:_selectedIndexPicker inComponent:0 animated:NO];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    

    NSString *message = [Language getText:@"กรุณาใส่รายละเอียดเหตุผลในการขอเงินคืน"];
    _strPlaceHolder = message;
    [pickerVw removeFromSuperview];
    pickerVw.delegate = self;
    pickerVw.dataSource = self;
    pickerVw.showsSelectionIndicator = YES;
    
    
    
    
    tbvData.delegate = self;
    tbvData.dataSource = self;
    tbvData.separatorColor = [UIColor clearColor];
    tbvData.backgroundColor = [UIColor whiteColor];
    _dispute = [[Dispute alloc]init];
    
    
    
    tbvAction.delegate = self;
    tbvAction.dataSource = self;
    tbvAction.backgroundColor = [UIColor whiteColor];
    tbvAction.scrollEnabled = NO;
    
    
    
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelText bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelText];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelTextView bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelTextView];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierHeaderFooterOkCancel bundle:nil];
        [tbvAction registerNib:nib forHeaderFooterViewReuseIdentifier:reuseIdentifierHeaderFooterOkCancel];
    }
    
    
    
    [self loadingOverlayView];
    if(fromType == 1)
    {
        NSString *title = [Setting getValue:@"080t" example:@"Cancel order"];
        lblNavTitle.text = title;
        [self.homeModel downloadItems:dbDisputeReasonList withData:@(1)];
    }
    else if(fromType == 2)
    {
        NSString *title = [Setting getValue:@"073t" example:@"Open dispute"];
        lblNavTitle.text = title;
        [self.homeModel downloadItems:dbDisputeReasonList withData:@(2)];
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
    
    if([tableView isEqual:tbvData])
    {
        if(fromType == 1)
        {
            return 3;
        }
        else if(fromType == 2)
        {
            return 5;
        }
    }
    else
    {
        return 0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    if([tableView isEqual:tbvData])
    {
        if(fromType == 1)
        {
            if(item == 0)
            {
                UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"cell"];
                if (!cell) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                }
                cell.backgroundColor = [UIColor whiteColor];
                
                
                NSString *message = [Language getText:@"กรุณากรอกรายละเอียดด้านล่างนี้"];
                cell.textLabel.text = message;
                cell.textLabel.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                cell.textLabel.textColor = [UIColor lightGrayColor];
                
                
                return cell;
            }
            else if(item == 1)
            {
                CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                NSString *message = [Language getText:@"เหตุผลในการขอเงินคืน"];
                NSString *strTitle = message;
                
                
                
                UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                UIColor *color = cSystem1;;
                NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"* " attributes:attribute];
                
                
                UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:15];
                UIColor *color2 = cSystem4;
                NSDictionary *attribute2 = @{NSForegroundColorAttributeName:color2 ,NSFontAttributeName: font2};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:strTitle attributes:attribute2];
                
                
                [attrString appendAttributedString:attrString2];
                cell.lblTitle.attributedText = attrString;
                
                
                
                NSString *message2 = [Language getText:@"กรุณาเลือกเหตุผลในการขอเงินคืน"];
                cell.txtValue.tag = item;
                cell.txtValue.placeholder = message2;
                cell.txtValue.delegate = self;
                cell.txtValue.inputView = pickerVw;
                [cell.txtValue setInputAccessoryView:self.toolBar];
                [cell.txtValue removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
                
                
                DisputeReason *disputeReason = [DisputeReason getDisputeReason:_dispute.disputeReasonID];
                cell.txtValue.text = [Language langIsEN]?disputeReason.text:disputeReason.text;
                cell.lblRemark.text = @"";
                
                
                return cell;
            }
            else if(item == 2)
            {
                CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                NSString *message = [Language getText:@"กรุณาใส่เบอร์โทรติดต่อกลับ เพื่อเจ้าหน้าที่จะโทรสอบถามข้อมูลเพิ่มเติมสำหรับการโอนเงินคืนท่าน"];
                NSString *strTitle = @"เบอร์โทร.";
                NSString *strRemark = message;
                
                
                
                UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                UIColor *color = cSystem1;;
                NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"* " attributes:attribute];
                
                
                UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:15];
                UIColor *color2 = cSystem4;
                NSDictionary *attribute2 = @{NSForegroundColorAttributeName:color2 ,NSFontAttributeName: font2};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:strTitle attributes:attribute2];
                
                
                [attrString appendAttributedString:attrString2];
                cell.lblTitle.attributedText = attrString;
                
                
                
                cell.txtValue.tag = 4;
                cell.txtValue.delegate = self;
                cell.txtValue.placeholder = @"xxx-xxx-xxxx";
                cell.txtValue.text = [Utility setPhoneNoFormat:_dispute.phoneNo];
                cell.txtValue.keyboardType = UIKeyboardTypePhonePad;
                [cell.txtValue setInputAccessoryView:self.toolBar];
                [cell.txtValue addTarget:self action:@selector(txtPhoneNoDidChange:) forControlEvents:UIControlEventEditingChanged];
                
                
                cell.lblRemark.text = strRemark;
                [cell.lblRemark sizeToFit];
                cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                
                return cell;
            }
        }
        else if(fromType == 2)
        {
            if(item == 0)
            {
                UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"cell"];
                if (!cell) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                }
                cell.backgroundColor = [UIColor whiteColor];
                
                
                NSString *message = [Language getText:@"กรุณากรอกรายละเอียดด้านล่างนี้"];
                cell.textLabel.text = message;
                cell.textLabel.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                cell.textLabel.textColor = [UIColor lightGrayColor];
                
                
                return cell;
            }
            else if(item == 1)
            {
                CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                
                NSString *message = [Language getText:@"เหตุผลในการขอเงินคืน"];
                NSString *strTitle = message;
                
                
                
                UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                UIColor *color = cSystem1;;
                NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"* " attributes:attribute];
                
                
                UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:15];
                UIColor *color2 = cSystem4;
                NSDictionary *attribute2 = @{NSForegroundColorAttributeName:color2 ,NSFontAttributeName: font2};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:strTitle attributes:attribute2];
                
                
                [attrString appendAttributedString:attrString2];
                cell.lblTitle.attributedText = attrString;
                
                
                
                NSString *message2 = [Language getText:@"กรุณาเลือกเหตุผลในการขอเงินคืน"];
                cell.txtValue.tag = item;
                cell.txtValue.placeholder = message2;
                cell.txtValue.delegate = self;
                cell.txtValue.inputView = pickerVw;
                [cell.txtValue setInputAccessoryView:self.toolBar];
                [cell.txtValue removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
                
                
                DisputeReason *disputeReason = [DisputeReason getDisputeReason:_dispute.disputeReasonID];
                cell.txtValue.text = [Language langIsEN]?disputeReason.text:disputeReason.text;
                cell.lblRemark.text = @"";
                
                
                return cell;
            }
            else if(item == 2)
            {
                CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                NSString *strTitle = [Language getText:@"จำนวนเงิน"];
                NSString *message = [Language getText:@"จำนวนเงิน: THB 0.01 to %@"];
                NSString *strTotalAmount = [Utility formatDecimal:[Receipt getTotalAmount:receipt] withMinFraction:2 andMaxFraction:2];
                NSString *strRemark = [NSString stringWithFormat:message,strTotalAmount];
                
                
                
                UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                UIColor *color = cSystem1;;
                NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"* " attributes:attribute];
                
                
                UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:15];
                UIColor *color2 = cSystem4;
                NSDictionary *attribute2 = @{NSForegroundColorAttributeName:color2 ,NSFontAttributeName: font2};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:strTitle attributes:attribute2];
                
                
                [attrString appendAttributedString:attrString2];
                cell.lblTitle.attributedText = attrString;
                
                
                
                cell.txtValue.tag = item;
                cell.txtValue.delegate = self;
                cell.txtValue.placeholder = @"THB";
                cell.txtValue.keyboardType = UIKeyboardTypeDecimalPad;
                cell.txtValue.text = [Utility formatDecimal:_dispute.refundAmount withMinFraction:0 andMaxFraction:2];
                [cell.txtValue setInputAccessoryView:self.toolBar];
                [cell.txtValue removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
                if(_dispute.refundAmount == 0)
                {
                    cell.txtValue.text = @"";
                }
                
                
                cell.lblRemark.text = strRemark;
                
                
                return cell;
            }
            else if(item == 3)
            {
                CustomTableViewCellLabelTextView *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelTextView];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                NSString *message = [Language getText:@"รายละเอียดเหตุผลในการขอเงินคืน"];
                NSString *strTitle = message;
                
                
                
                UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                UIColor *color = cSystem1;;
                NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"* " attributes:attribute];
                
                
                UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:15];
                UIColor *color2 = cSystem4;
                NSDictionary *attribute2 = @{NSForegroundColorAttributeName:color2 ,NSFontAttributeName: font2};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:strTitle attributes:attribute2];
                
                
                [attrString appendAttributedString:attrString2];
                cell.lblTitle.attributedText = attrString;
                
                
                
                cell.txvValue.tag = 3;
                cell.txvValue.delegate = self;
                cell.txvValue.text = _dispute.detail;
                if([cell.txvValue.text isEqualToString:@""])
                {
                    cell.txvValue.text = _strPlaceHolder;
                    cell.txvValue.textColor = mPlaceHolder;
                }
                else
                {
                    cell.txvValue.textColor = [UIColor blackColor];
                }
                [cell.txvValue.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
                [cell.txvValue.layer setBorderWidth:0.5];
                
                //The rounded corner part, where you specify your view's corner radius:
                cell.txvValue.layer.cornerRadius = 5;
                cell.txvValue.clipsToBounds = YES;
                [cell.txvValue setInputAccessoryView:self.toolBar];
                
                
                return cell;
            }
            else if(item == 4)
            {
                CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                NSString *message = [Language getText:@"กรุณาใส่เบอร์โทรติดต่อกลับ เพื่อเจ้าหน้าที่จะโทรสอบถามข้อมูลเพิ่มเติมสำหรับการโอนเงินคืนท่าน"];
                NSString *strTitle = [Language getText:@"เบอร์โทร."];;
                NSString *strRemark = message;
                
                
                
                UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                UIColor *color = cSystem1;
                NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"* " attributes:attribute];
                
                
                UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:15];
                UIColor *color2 = cSystem4;
                NSDictionary *attribute2 = @{NSForegroundColorAttributeName:color2 ,NSFontAttributeName: font2};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:strTitle attributes:attribute2];
                
                
                [attrString appendAttributedString:attrString2];
                cell.lblTitle.attributedText = attrString;
                
                
                
                cell.txtValue.tag = item;
                cell.txtValue.delegate = self;
                cell.txtValue.placeholder = @"xxx-xxx-xxxx";
                cell.txtValue.text = [Utility setPhoneNoFormat:_dispute.phoneNo];
                cell.txtValue.keyboardType = UIKeyboardTypePhonePad;
                [cell.txtValue setInputAccessoryView:self.toolBar];
                [cell.txtValue addTarget:self action:@selector(txtPhoneNoDidChange:) forControlEvents:UIControlEventEditingChanged];
                
                
                
                cell.lblRemark.text = strRemark;
                [cell.lblRemark sizeToFit];
                cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                
                return cell;
            }
        }
        
    }
    
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = indexPath.item;
    if([tableView isEqual:tbvData])
    {
        if(fromType == 1)
        {
            if(item == 0)
            {
                return 44;
            }
            else if(item == 1)
            {
                return 102-8-16;
            }
            else if(item == 2)
            {
                CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
                NSString *message = [Language getText:@"กรุณาใส่เบอร์โทรติดต่อกลับ เพื่อเจ้าหน้าที่จะโทรสอบถามข้อมูลเพิ่มเติมสำหรับการโอนเงินคืนท่าน"];
                NSString *strRemark = message;
                
                
                cell.lblRemark.text = strRemark;
                [cell.lblRemark sizeToFit];
                return 102-16+cell.lblRemark.frame.size.height;
            }
        }
        else if(fromType == 2)
        {
            if(item == 0)
            {
                return 44;
            }
            else if(item == 1)
            {
                return 102-8-16;
            }
            else if(item == 2)
            {
                return 102;
            }
            else if(item == 3)
            {
                return 108;
            }
            else if(item == 4)
            {
                CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
                NSString *message = [Language getText:@"กรุณาใส่เบอร์โทรติดต่อกลับ เพื่อเจ้าหน้าที่จะโทรสอบถามข้อมูลเพิ่มเติมสำหรับการโอนเงินคืนท่าน"];
                NSString *strRemark = message;
                
                
                cell.lblRemark.text = strRemark;
                [cell.lblRemark sizeToFit];
                return 102-16+cell.lblRemark.frame.size.height;
            }
        }
        
    }
    
    return 0;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if([tableView isEqual:tbvAction])
    {
        CustomTableViewHeaderFooterOkCancel *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifierHeaderFooterOkCancel];
        
        
        
        [footerView.btnOk addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
        [footerView.btnCancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [self setButtonDesign:footerView.btnOk];
        [self setButtonDesign:footerView.btnCancel];
        
        
        return footerView;
    }
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if([tableView isEqual:tbvAction])
    {
        return 8+30+8+30;
    }
    return 0;
    
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToOrderDetail" sender:self];
}

-(void)itemsDownloaded:(NSArray *)items
{
    if(self.homeModel.propCurrentDB == dbDisputeReasonList)
    {
        [self removeOverlayViews];
        
        
        _disputeReasonList = items[0];
        [DisputeReason setSharedData:items[0]];
        [tbvData reloadData];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component
{
    // Handle the selection
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    CustomTableViewCellLabelText *cell = [tbvData cellForRowAtIndexPath:indexPath];
    
    
    if([cell.txtValue isFirstResponder])
    {
        _selectedIndexPicker = row;
        DisputeReason *disputeReason = _disputeReasonList[row];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        CustomTableViewCellLabelText *cell = [tbvData cellForRowAtIndexPath:indexPath];
        cell.txtValue.text = [Language langIsEN]?disputeReason.text:disputeReason.text;
    }
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    CustomTableViewCellLabelText *cell = [tbvData cellForRowAtIndexPath:indexPath];
    
    
    if([cell.txtValue isFirstResponder])
    {
        return [_disputeReasonList count];
    }
    
    return 0;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *strText = @"";
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    CustomTableViewCellLabelText *cell = [tbvData cellForRowAtIndexPath:indexPath];
    
    
    if([cell.txtValue isFirstResponder])
    {
        DisputeReason *disputeReason = _disputeReasonList[row];
        strText = [Language langIsEN]?disputeReason.text:disputeReason.text;
    }
    
    return strText;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return self.view.frame.size.width;
}

-(void)submit:(id)sender
{
    if(fromType == 1)
    {
        [self.view endEditing:YES];
        if(![self validate])
        {
            return;
        }
        
        
        [self loadingOverlayView];
        _dispute.receiptID = receipt.receiptID;
        _dispute.type = fromType;
        _dispute.modifiedUser = [Utility modifiedUser];
        _dispute.modifiedDate = [Utility currentDateTime];
        
        Branch *branch = [Branch getBranch:receipt.branchID];
        [self.homeModel insertItems:dbDisputeCancel withData:@[_dispute,branch] actionScreen:@"insert dispute cancel"];
        
    }
    else if(fromType == 2)
    {
        [self submit];
    }
}

-(void)submit
{
    [self.view endEditing:YES];
    
    
    if(![self validate])
    {
        return;
    }
    [self loadingOverlayView];
    
    
    _dispute.receiptID = receipt.receiptID;
    _dispute.type = fromType;
    _dispute.modifiedUser = [Utility modifiedUser];
    _dispute.modifiedDate = [Utility currentDateTime];
    
    Branch *branch = [Branch getBranch:receipt.branchID];
    [self.homeModel insertItems:dbDispute withData:@[_dispute,branch] actionScreen:@"insert dispute"];
}

-(void)cancel:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToReceiptSummary" sender:self];
}

-(void)itemsInsertedWithReturnData:(NSArray *)items
{
    [Utility updateSharedObject:items];
    NSMutableArray *receiptList = items[0];
    Receipt *downloadReceipt = receiptList[0];
    if(downloadReceipt.status == 5 || downloadReceipt.status == 6)
    {
        NSString *message = [Language getText:@"ร้านค้ากำลังปรุงอาหารให้คุณอยู่ค่ะ โปรดรอสักครู่นะคะ"];
        NSString *message2 = [Language getText:@"อาหารได้ส่งถึงคุณแล้วค่ะ"];
        NSString *strMessage = downloadReceipt.status == 5?message:message2;
        [self showAlert:@"" message:strMessage method:@selector(goBack:)];
        [self removeOverlayViews];
    }
    else if(downloadReceipt.status == 7)
    {
        NSString *message = [Language getText:@"คำร้องขอเงินคืนเต็มจำนวนได้ถูกส่งไปแล้ว กรุณารอการยืนยันจากร้านค้า"];
        [self showAlert:@"" message:message method:@selector(unwindToReceiptSummary)];
        [self removeOverlayViews];
    }
    else if(downloadReceipt.status == 8)
    {
        NSString *message = [Language getText:@"คำร้องขอเงินคืนได้ถูกส่งไปแล้ว กรุณารอการยืนยันจากร้านค้า"];
        [self showAlert:@"" message:message method:@selector(unwindToReceiptSummary)];
        [self removeOverlayViews];
    }
    
}

-(BOOL)validate
{
    if(fromType == 1)
    {
        {
            UITextField *textField = [self.view viewWithTag:1];
            if([Utility isStringEmpty:textField.text])
            {
                NSString *message = [Language getText:@"กรุณาเลือกเหตุผลในการขอเงินคืน"];
                [self blinkAlertMsg:message];
                return NO;
            }
        }       
        
        {
            UITextField *textField = [self.view viewWithTag:4];
            if([Utility isStringEmpty:textField.text])
            {
                [self blinkAlertMsg:[Language getText:@"กรุณาใส่เบอร์โทร"]];
                return NO;
            }
        }
    }
    else if(fromType == 2)
    {
        {
            UITextField *textField = [self.view viewWithTag:1];
            if([Utility isStringEmpty:textField.text])
            {
                NSString *message = [Language getText:@"กรุณาเลือกเหตุผลในการขอเงินคืน"];
                [self blinkAlertMsg:message];
                return NO;
            }
        }
        
        {
            UITextField *textField = [self.view viewWithTag:2];
            if([Utility isStringEmpty:textField.text])
            {
                [self blinkAlertMsg:[Language getText:@"กรุณาใส่จำนวนเงิน"]];
                return NO;
            }
            
            
            NSString *message = [Language getText:@"กรุณาใส่จำนวนเงินระหว่าง %@"];
            float totalAmount = [Receipt getTotalAmount:receipt];
            NSString *strTotalAmount = [Utility formatDecimal:totalAmount withMinFraction:2 andMaxFraction:2];
            NSString *strRemark = [NSString stringWithFormat:@"THB 0.01 to %@",strTotalAmount];
            NSString *strMessage = [NSString stringWithFormat:message,strRemark];
            if([Utility floatValue:textField.text] > totalAmount)
            {
                [self blinkAlertMsg:strMessage];
                return NO;
            }
        }
        
        {
            UITextView *textView = [self.view viewWithTag:3];
            if([textView.text isEqualToString:_strPlaceHolder])
            {
                NSString *message = [Language getText:@"กรุณาใส่รายละเอียดเหตุผลในการขอเงินคืน"];
                [self blinkAlertMsg:message];            
                return NO;
            }
        }
        
        {
            UITextField *textField = [self.view viewWithTag:4];
            if([Utility isStringEmpty:textField.text])
            {
                [self blinkAlertMsg:[Language getText:@"กรุณาใส่เบอร์โทร"]];
                return NO;
            }
        }
    }
    
    return YES;
}

-(void)unwindToReceiptSummary
{
    [self performSegueWithIdentifier:@"segUnwindToReceiptSummary" sender:self];
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect toView:nil];
    
    CGSize kbSize = kbRect.size;
    
    
    
    // Assign new frame to your view
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         [self.view setFrame:CGRectMake(0,kbSize.height*-1,self.view.frame.size.width,self.view.frame.size.height)]; //here taken -110 for example i.e. your view will be scrolled to -110. change its value according to your requirement.
                     }
                     completion:nil
     ];
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
                         [self.view layoutSubviews];
                     }
                     completion:nil
     ];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSInteger textFieldTag = fromType == 1?2:4;
    
    if(textField.tag == textFieldTag)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSInteger textFieldTag = fromType == 1?2:4;
    
    if(textField.tag == textFieldTag)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
        
        
        [self.view endEditing:YES];
        
        return YES;
    }
    
    return YES;
}

-(void)txtPhoneNoDidChange:(id)sender
{
    UITextField *txtPhoneNo = sender;
    txtPhoneNo.text = [Utility formatPhoneNo:[Utility removeDashAndSpaceAndParenthesis:txtPhoneNo.text]];
}
@end
