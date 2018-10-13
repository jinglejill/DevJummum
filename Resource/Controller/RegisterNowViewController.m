//
//  RegisterNowViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 2/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "RegisterNowViewController.h"
#import "TermsOfServiceViewController.h"
#import "CustomTableViewCellText.h"
#import "UserAccount.h"


@interface RegisterNowViewController ()
{
    UserAccount *_userAccount;
    BOOL _validate;
    BOOL _updateBirthDateAndPhoneNo;
    
}
@end

@implementation RegisterNowViewController
static NSString * const reuseIdentifierText = @"CustomTableViewCellText";


@synthesize lblNavTitle;
@synthesize tbvData;
@synthesize dtPicker;
@synthesize topViewHeight;
@synthesize bottomViewHeight;
@synthesize userAccount;
@synthesize btnCreateAccount;
@synthesize btnBack;
@synthesize btnBackWidth;


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    bottomViewHeight.constant = window.safeAreaInsets.bottom;
    
    float topPadding = window.safeAreaInsets.top;
    topViewHeight.constant = topPadding == 0?20:topPadding;
    
    
    NSString *btnNext = userAccount?[Language getText:@"เริ่มใช้งาน"]:[Language getText:@"สร้างบัญชี"];
    [btnCreateAccount setTitle:btnNext forState:UIControlStateNormal];
    [btnBack setTitle:[Language getText:@"ย้อนกลับ"] forState:UIControlStateNormal];
    btnBackWidth.constant = self.view.frame.size.width/4;
    
    
    UIImage *image;
    if([[self deviceName] rangeOfString:@"iPhone X" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        image = [UIImage imageNamed:@"JummumRegisterBgIphoneX.jpg"];
    }
    else if ([[self deviceName] rangeOfString:@"iPhone" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        image = [UIImage imageNamed:@"JummumRegisterBg.jpg"];
    }
    else if ([[self deviceName] rangeOfString:@"iPad" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        image = [UIImage imageNamed:@"JummumRegisterBgIpad.jpg"];
    }
    else
    {
        image = [UIImage imageNamed:@"JummumRegisterBg.jpg"];
    }
    image = [self tranlucentWithAlpha:0.9 image:image];
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:image];
    [tempImageView setFrame:tbvData.frame];

//    tbvData.backgroundView = tempImageView;
//    tbvData.backgroundView.backgroundColor = [cSystem1 colorWithAlphaComponent:0.9];


    
    NSLog(@"width:%f,height:%f",tbvData.frame.size.width,tbvData.frame.size.height);
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(userAccount && !_updateBirthDateAndPhoneNo)
    {
        _userAccount = userAccount;
        [tbvData reloadData];
        NSString *message = [Language getText:@"คุณล็อคอินผ่าน facebook สำเร็จแล้ว กรุณาใส่วันเกิดและเบอร์โทรศัพท์ เพื่อเราจะได้สร้างบัญชีสำหรับใช้งานให้คุณ"];
        [self showAlert:@"" message:message];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    if(textField.tag == 5)
    {
        NSString *strDate = textField.text;
        if([strDate isEqualToString:@""])
        {
            NSInteger year = [[Utility dateToString:[Utility currentDateTime] toFormat:@"yyyy"] integerValue];
            NSString *strDefaultDate = [NSString stringWithFormat:@"01/01/%ld",year-20];
            NSDate *datePeriod = [Utility stringToDate:strDefaultDate fromFormat:@"dd/MM/yyyy"];
            [dtPicker setDate:datePeriod];
        }
        else
        {
            NSDate *datePeriod = [Utility stringToDate:strDate fromFormat:@"d MMM yyyy"];
            [dtPicker setDate:datePeriod];
        }
    }
}

- (IBAction)datePickerChanged:(id)sender
{
    UITextField *textField = (UITextField *)[self.view viewWithTag:5];
    if([textField isFirstResponder])
    {
        textField.text = [Utility dateToString:dtPicker.date toFormat:@"d MMM yyyy"];
        _userAccount.birthDate = dtPicker.date;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 1:
        {
            _userAccount.username = @"";
            _userAccount.email = @"";
        }
            break;
        case 2:
        {
            _userAccount.password = @"";
        }
            break;
        case 3:
        {
            _userAccount.firstName = @"";
        }
            break;
        case 4:
        {
            _userAccount.lastName = @"";
        }
            break;
        case 5:
        {
            _userAccount.birthDate = nil;
        }
        case 6:
        {
            _userAccount.phoneNo = @"";
        }
            break;
        default:
            break;
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 1:
        {
            _userAccount.username = [Utility trimString:textField.text];
            _userAccount.email = [Utility trimString:textField.text];
        }
            break;
        case 2:
        {
            _userAccount.password = [Utility trimString:textField.text];
        }
            break;
        case 3:
        {
            _userAccount.firstName = [Utility trimString:textField.text];
        }
            break;
        case 4:
        {
            _userAccount.lastName = [Utility trimString:textField.text];
        }
            break;
        case 6:
        {
            _userAccount.phoneNo = [Utility removeDashAndSpaceAndParenthesis:[Utility trimString:textField.text]];
        }
            break;
        default:
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSString *title = userAccount?[Language getText:@"ข้อมูลส่วนตัว"]:[Language getText:@"สร้างบัญชีใหม่"];
    lblNavTitle.text = title;
    _userAccount = [[UserAccount alloc]init];
    tbvData.delegate = self;
    tbvData.dataSource = self;
    tbvData.scrollEnabled = NO;
    [tbvData setSeparatorColor:[cSystem4 colorWithAlphaComponent:0.6]];
    
    
    [dtPicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dtPicker removeFromSuperview];
    
    
    
    
    
    
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierText bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierText];
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
    
    if(userAccount)
    {
        return 5;
    }
    else
    {
        return 6;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    
    CustomTableViewCellText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierText];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if(userAccount)
    {
        switch (item)
        {
            case 0:
            {
                cell.textValue.tag = 1;
                cell.textValue.delegate = self;
                cell.textValue.placeholder = [Language getText:@"อีเมล"];
                cell.textValue.text = _userAccount.email;
                cell.textValue.enabled = NO;
                [cell.textValue setInputAccessoryView:self.toolBar];
                [cell.textValue removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
                cell.textValue.autocapitalizationType = UITextAutocapitalizationTypeNone;
                cell.textValue.clearButtonMode = UITextFieldViewModeWhileEditing;
            }
                break;
            case 1:
            {
                cell.textValue.tag = 3;
                cell.textValue.delegate = self;
                cell.textValue.placeholder = [Language getText:@"ชื่อ"];
                cell.textValue.text = _userAccount.firstName;
                cell.textValue.enabled = NO;
                [cell.textValue setInputAccessoryView:self.toolBar];
                [cell.textValue removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
                cell.textValue.autocapitalizationType = UITextAutocapitalizationTypeWords;
                cell.textValue.clearButtonMode = UITextFieldViewModeWhileEditing;
            }
                break;
            case 2:
            {
                cell.textValue.tag = 4;
                cell.textValue.delegate = self;
                cell.textValue.placeholder = [Language getText:@"นามสกุล"];
                cell.textValue.text = _userAccount.lastName;
                cell.textValue.enabled = NO;
                [cell.textValue setInputAccessoryView:self.toolBar];
                [cell.textValue removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
                cell.textValue.autocapitalizationType = UITextAutocapitalizationTypeWords;
                cell.textValue.clearButtonMode = UITextFieldViewModeWhileEditing;
            }
                break;
            case 3:
            {
                cell.textValue.tag = 5;
                cell.textValue.delegate = self;
                cell.textValue.placeholder = [Language getText:@"วันเกิด (optional)"];
                cell.textValue.inputView = dtPicker;
                cell.textValue.text = [Utility dateToString:_userAccount.birthDate toFormat:@"d MMM yyyy"];
                cell.textValue.enabled = YES;
                [cell.textValue setInputAccessoryView:self.toolBar];
                [cell.textValue removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
                cell.textValue.autocapitalizationType = UITextAutocapitalizationTypeNone;
                cell.textValue.clearButtonMode = UITextFieldViewModeWhileEditing;
            }
                break;
            case 4:
            {
                cell.textValue.tag = 6;
                cell.textValue.delegate = self;
                cell.textValue.placeholder = [Language getText:@"เบอร์โทร. (optional)"];
                cell.textValue.text = [Utility setPhoneNoFormat:_userAccount.phoneNo];
                cell.textValue.keyboardType = UIKeyboardTypePhonePad;
                cell.textValue.enabled = YES;
                [cell.textValue setInputAccessoryView:self.toolBar];
                [cell.textValue addTarget:self action:@selector(txtPhoneNoDidChange:) forControlEvents:UIControlEventEditingChanged];
                cell.textValue.autocapitalizationType = UITextAutocapitalizationTypeNone;
                cell.textValue.clearButtonMode = UITextFieldViewModeWhileEditing;
            }
                break;
            default:
                break;
        }
    }
    else
    {
        switch (item)
        {
            case 0:
            {
                cell.textValue.tag = 1;
                cell.textValue.delegate = self;
                cell.textValue.placeholder = [Language getText:@"อีเมล"];
                cell.textValue.text = _userAccount.username;
                cell.textValue.enabled = YES;
                [cell.textValue setInputAccessoryView:self.toolBar];
                [cell.textValue removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
                cell.textValue.autocapitalizationType = UITextAutocapitalizationTypeNone;
                cell.textValue.clearButtonMode = UITextFieldViewModeWhileEditing;
            }
                break;
            case 1:
            {
                cell.textValue.tag = 2;
                cell.textValue.delegate = self;
                cell.textValue.placeholder = [Language getText:@"พาสเวิร์ด"];
                cell.textValue.text = _userAccount.password;
                cell.textValue.secureTextEntry = YES;
                cell.textValue.enabled = YES;
                [cell.textValue setInputAccessoryView:self.toolBar];
                [cell.textValue removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
                cell.textValue.autocapitalizationType = UITextAutocapitalizationTypeNone;
                cell.textValue.clearButtonMode = UITextFieldViewModeWhileEditing;
            }
                break;
            case 2:
            {
                cell.textValue.tag = 3;
                cell.textValue.delegate = self;
                cell.textValue.placeholder = [Language getText:@"ชื่อ"];
                cell.textValue.text = _userAccount.firstName;
                cell.textValue.enabled = YES;
                [cell.textValue setInputAccessoryView:self.toolBar];
                [cell.textValue removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
                cell.textValue.autocapitalizationType = UITextAutocapitalizationTypeWords;
                cell.textValue.clearButtonMode = UITextFieldViewModeWhileEditing;
            }
                break;
            case 3:
            {
                cell.textValue.tag = 4;
                cell.textValue.delegate = self;
                cell.textValue.placeholder = [Language getText:@"นามสกุล"];
                cell.textValue.text = _userAccount.lastName;
                cell.textValue.enabled = YES;
                [cell.textValue setInputAccessoryView:self.toolBar];
                [cell.textValue removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
                cell.textValue.autocapitalizationType = UITextAutocapitalizationTypeWords;
                cell.textValue.clearButtonMode = UITextFieldViewModeWhileEditing;
            }
                break;
            case 4:
            {
                cell.textValue.tag = 5;
                cell.textValue.delegate = self;
                cell.textValue.placeholder = [Language getText:@"วันเกิด (optional)"];
                cell.textValue.inputView = dtPicker;
                cell.textValue.text = [Utility dateToString:_userAccount.birthDate toFormat:@"d MMM yyyy"];
                cell.textValue.enabled = YES;
                [cell.textValue setInputAccessoryView:self.toolBar];
                [cell.textValue removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
                cell.textValue.autocapitalizationType = UITextAutocapitalizationTypeNone;
                cell.textValue.clearButtonMode = UITextFieldViewModeWhileEditing;
            }
                break;
            case 5:
            {
                cell.textValue.tag = 6;
                cell.textValue.delegate = self;
                cell.textValue.placeholder = [Language getText:@"เบอร์โทร. (optional)"];
                cell.textValue.text = [Utility setPhoneNoFormat:_userAccount.phoneNo];
                cell.textValue.keyboardType = UIKeyboardTypePhonePad;
                cell.textValue.enabled = YES;
                [cell.textValue setInputAccessoryView:self.toolBar];
                [cell.textValue addTarget:self action:@selector(txtPhoneNoDidChange:) forControlEvents:UIControlEventEditingChanged];
                cell.textValue.autocapitalizationType = UITextAutocapitalizationTypeNone;
                cell.textValue.clearButtonMode = UITextFieldViewModeWhileEditing;
            }
                break;
            default:
                break;
        }
    }
    
    cell.textValue.attributedPlaceholder = [[NSAttributedString alloc] initWithString:cell.textValue.placeholder attributes:@{NSForegroundColorAttributeName: [cSystem4 colorWithAlphaComponent:0.6]}];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
//    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

 -(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, 44)];
    label.font = [UIFont fontWithName:@"Prompt-SemiBold" size:14];
    label.textColor = cSystem4;
     NSString *string = [Language getText:@"ใส่ข้อมูลด้านล่าง แล้วเตรียม มั่ม มั่ม ได้เลย !!"];
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    view.backgroundColor = [UIColor clearColor];
//    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIImage *)tranlucentWithAlpha:(CGFloat)alpha image:(UIImage *)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawAtPoint:CGPointZero blendMode:kCGBlendModeNormal alpha:alpha];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (IBAction)createAccount:(id)sender
{
    if(userAccount)//facebook login
    {
        //        if(!_userAccount.birthDate)
        //        {
        //            [self showAlert:@"" message:@"กรุณาระบุวันเกิด"];
        //            return;
        //        }
        //
        //
        //        if([Utility isStringEmpty:_userAccount.phoneNo])
        //        {
        //            [self showAlert:@"" message:@"กรุณาระบุเบอร์โทร."];
        //            return;
        //        }
        
        _userAccount.modifiedUser = [Utility modifiedUser];
        _userAccount.modifiedDate = [Utility currentDateTime];
        [self.homeModel updateItems:dbUserAccount withData:userAccount actionScreen:@"update userAccount login via facebook"];
        [self loadingOverlayView];
    }
    else//normal register
    {
        [self loadingOverlayView];
        [self.homeModel downloadItems:dbUserAccount withData:_userAccount.username];
    }
    
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToLogIn" sender:self];
}

- (IBAction)skip:(id)sender {
}

-(void)itemsDownloaded:(NSArray *)items
{
    [self removeOverlayViews];
    
    
    //validate
    if([Utility isStringEmpty:_userAccount.username])
    {
        [self showAlert:@"" message:@"กรุณาระบุอีเมล"];
        return;
    }
    
    
    if(![Utility validateEmailWithString:_userAccount.username])
    {
        [self showAlert:@"" message:@"อีเมลไม่ถูกต้อง"];
        return;
    }
    
    
    if([items count] > 0 && [items[0] count]>0)
    {
        [self showAlert:@"" message:@"อีเมลนี้ถูกใช้แล้ว"];
        return;
    }
    
    
    if(![Utility validateStrongPassword:_userAccount.password])
    {
        [self showAlert:@"" message:@"พาสเวิร์ดต้องประกอบไปด้วย\n1.อักษรตัวเล็กอย่างน้อย 1 ตัว\n2.อักษรตัวใหญ่อย่างน้อย 1 ตัว\n3.ตัวเลขหรืออักษรพิเศษอย่างน้อย 1 ตัว\n4.ความยาวขั้นต่ำ 8 ตัวอักษร"];
        return ;
    }
    
    if([Utility isStringEmpty:_userAccount.firstName])
    {
        [self showAlert:@"" message:@"กรุณาระบุชื่อ"];
        return;
    }
    
    if([Utility isStringEmpty:_userAccount.lastName])
    {
        [self showAlert:@"" message:@"กรุณาระบุนามสกุล"];
        return;
    }
    
    //    if([Utility isStringEmpty:_userAccount.fullName])
    //    {
    //        [self showAlert:@"" message:@"กรุณาระบุชื่อเต็ม"];
    //        return;
    //    }
    
    
    //    if(!_userAccount.birthDate)
    //    {
    //        [self showAlert:@"" message:@"กรุณาระบุวันเกิด"];
    //        return;
    //    }
    //
    //
    //    if([Utility isStringEmpty:_userAccount.phoneNo])
    //    {
    //        [self showAlert:@"" message:@"กรุณาระบุเบอร์โทร."];
    //        return;
    //    }
    //-----
    
    
    UserAccount *userAccount = [[UserAccount alloc]initWithUsername:_userAccount.username password:[Utility hashTextSHA256:_userAccount.password] deviceToken:[Utility deviceToken] firstName:_userAccount.firstName lastName:_userAccount.lastName fullName:_userAccount.fullName nickName:@"" birthDate:_userAccount.birthDate email:_userAccount.email phoneNo:_userAccount.phoneNo lineID:@"" roleID:0];
    [self.homeModel insertItems:dbUserAccount withData:userAccount actionScreen:@"create new account"];
    [self loadingOverlayView];
}

-(void)itemsInserted
{
    [self removeOverlayViews];
    [self showAlert:@"" message:@"สร้างบัญชีสำเร็จ" method:@selector(segUnwindToLogIn)];
}

-(void)itemsUpdated
{
    [self removeOverlayViews];
    _updateBirthDateAndPhoneNo = YES;
    
    
    
    //show terms of service
    NSDictionary *dicTosAgree = [[NSUserDefaults standardUserDefaults] valueForKey:@"tosAgree"];
    NSString *username = _userAccount.username;
    NSNumber *tosAgree = [dicTosAgree objectForKey:username];
    if(tosAgree)
    {
        [self performSegueWithIdentifier:@"segQrCodeScanTable" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"segTermsOfService" sender:self];
    }
}

-(void)segUnwindToLogIn
{
    [self performSegueWithIdentifier:@"segUnwindToLogIn" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segTermsOfService"])
    {
        TermsOfServiceViewController *vc = segue.destinationViewController;
        vc.username = _userAccount.username;
    }
}

-(void)txtPhoneNoDidChange:(id)sender
{
    UITextField *txtPhoneNo = sender;
    txtPhoneNo.text = [Utility formatPhoneNo:[Utility removeDashAndSpaceAndParenthesis:txtPhoneNo.text]];
}

@end
