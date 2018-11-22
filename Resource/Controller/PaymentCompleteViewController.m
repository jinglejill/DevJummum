//
//  PaymentCompleteViewController.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 14/6/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "PaymentCompleteViewController.h"
#import "LuckyDrawViewController.h"
#import "CustomTableViewCellLogo.h"
#import "CustomTableViewCellReceiptSummary.h"
#import "CustomTableViewCellReceiptHeader.h"
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
    BOOL _addGiftBox;
    CAKeyframeAnimation *_animateHand;
    CAKeyframeAnimation *_animateHandHide;
    BOOL _showHand;
    UIImageView *_imgVwHand;
}
@end

@implementation PaymentCompleteViewController
static NSString * const reuseIdentifierLogo = @"CustomTableViewCellLogo";
static NSString * const reuseIdentifierReceiptSummary = @"CustomTableViewCellReceiptSummary";
static NSString * const reuseIdentifierReceiptHeader = @"CustomTableViewCellReceiptHeader";
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
@synthesize numberOfGift;
@synthesize imgVwCheck;
@synthesize btnBackToHome;
@synthesize orderBuffet;
@synthesize goToHotDeal;


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self setButtonDesign:btnSaveToCameraRoll];
    
    
    imgVwCheckTop.constant = (self.view.frame.size.height - 63 - (559-69))/2;
    if(receipt.buffetReceiptID)
    {
        lblTitle.text = [Language getText:@"สั่งบุฟเฟ่ต์สำเร็จ"];
    }
    else
    {
        lblTitle.text = [Language getText:@"ชำระเงินสำเร็จ"];
    }
    if(receipt.hasBuffetMenu || receipt.buffetReceiptID)
    {
        [self setButtonDesign:btnOrderBuffet];
        [btnSaveToCameraRoll setTitle:[Language getText:@"บันทึกใบเสร็จ และสั่งบุฟเฟต์"] forState:UIControlStateNormal];
    }
    else
    {
        btnOrderBuffet.hidden = YES;
        [btnSaveToCameraRoll setTitle:[Language getText:@"บันทึกใบเสร็จลงอัลบั้ม"] forState:UIControlStateNormal];
    }
    if(!_addGiftBox && numberOfGift > 0)
    {
        _addGiftBox = YES;
        NSInteger giftWidth = 80;
        UIImageView* animatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-16-giftWidth, imgVwCheck.frame.origin.y, giftWidth, giftWidth)];
        imgVwCheck.hidden =YES;
        
        
        UIImage *imageNormal = [UIImage imageNamed:@"jummumGiftBoxNormal.png"];
        UIImage *imagePop = [UIImage imageNamed:@"jummumGiftBoxPop.png"];
        animatedImageView.animationImages = [NSArray arrayWithObjects:imageNormal,imagePop,nil];
        animatedImageView.animationDuration = 1.0f;
        animatedImageView.animationRepeatCount = 0;
        [animatedImageView startAnimating];
        [self.view addSubview: animatedImageView];
        
        
        //add singleTap
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGiftBox)];
        singleTap.numberOfTapsRequired = 1;
        [animatedImageView setUserInteractionEnabled:YES];
        [animatedImageView addGestureRecognizer:singleTap];
        
        
        
        //uilabel
        NSString *strTicket = numberOfGift==1?@"ticket":@"tickets";
        UILabel *lblGiftNum = [[UILabel alloc]init];
        lblGiftNum.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
        lblGiftNum.textColor = [UIColor whiteColor];
        lblGiftNum.textAlignment = NSTextAlignmentRight;        
        lblGiftNum.numberOfLines = 1;
        lblGiftNum.text = [NSString stringWithFormat:@"You've got %ld %@",numberOfGift,strTicket];
        [lblGiftNum sizeToFit];
        lblGiftNum.center = animatedImageView.center;
        CGRect frame = lblGiftNum.frame;
        frame.origin.x = self.view.frame.size.width-16-animatedImageView.frame.size.width-8-lblGiftNum.frame.size.width;        
        lblGiftNum.frame = frame;        
        [self.view addSubview:lblGiftNum];
        

        
        //tap here animate
        NSInteger handSize = 50;
        _imgVwHand = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, handSize, handSize)];
        _imgVwHand.center = animatedImageView.center;
        {
            CGRect frame = _imgVwHand.frame;
            frame.origin.y = animatedImageView.frame.origin.y + animatedImageView.frame.size.height-20;
            _imgVwHand.frame = frame;
        }
        
        
        //hand blink
        NSMutableArray *imgHandAnimation = [[NSMutableArray alloc]init];
        UIImage *handLift = [UIImage imageNamed:@"handLift.png"];
        UIImage *handTap = [UIImage imageNamed:@"handTap.png"];
        [imgHandAnimation addObject:(NSObject *)(handLift.CGImage)];
        [imgHandAnimation addObject:(NSObject *)(handTap.CGImage)];
        
        _animateHand = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        _animateHand.calculationMode = kCAAnimationDiscrete;
        _animateHand.duration = 0.5;
        _animateHand.values = imgHandAnimation;
        _animateHand.repeatCount = 4;
        _animateHand.removedOnCompletion = NO;
        _animateHand.fillMode = kCAFillModeForwards;
        _animateHand.delegate = self;
        [_imgVwHand.layer addAnimation:_animateHand forKey:@"animateHand"];
        [self.view addSubview:_imgVwHand];
        
        
        //hand hide
        NSMutableArray *imgHandHideAnimation = [[NSMutableArray alloc]init];
        UIImage *handEmpty = [UIImage imageNamed:@"handEmpty.png"];
        [imgHandHideAnimation addObject:(NSObject *)(handEmpty.CGImage)];
        
        _animateHandHide = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        _animateHandHide.calculationMode = kCAAnimationDiscrete;
        _animateHandHide.duration = 0.5;
        _animateHandHide.values = imgHandHideAnimation;
        _animateHandHide.repeatCount = 4;
        _animateHandHide.removedOnCompletion = NO;
        _animateHandHide.fillMode = kCAFillModeForwards;
        _animateHandHide.delegate = self;
        
    }
    
    [btnOrderBuffet setTitle:[Language getText:@"สั่งบุฟเฟ่ต์"] forState:UIControlStateNormal];
    [btnBackToHome setTitle:[Language getText:@"< กลับสู่เมนูหลัก"] forState:UIControlStateNormal];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    if(theAnimation == [_imgVwHand.layer animationForKey:@"animateHand"])
    {
        if (flag)
        {
            [_imgVwHand.layer addAnimation:_animateHandHide forKey:@"animateHandHide"];
        }
    }
    else if(theAnimation == [_imgVwHand.layer animationForKey:@"animateHandHide"])
    {
        if (flag)
        {
            [_imgVwHand.layer addAnimation:_animateHand forKey:@"animateHand"];
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *title = [Language getText:@"ชำระเงินสำเร็จ"];
    NSString *message = [Language getText:@"ขอบคุณที่ใช้บริการ ​JUMMUM"];
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
        UINib *nib = [UINib nibWithNibName:reuseIdentifierReceiptHeader bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierReceiptHeader];
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

- (IBAction)button1Clicked:(id)sender//save receipt
{
    //save to camera roll
    [self screenCaptureBill:receipt];
    if(receipt.hasBuffetMenu || receipt.buffetReceiptID)
    {
        orderBuffet = 1;
        [self performSegueWithIdentifier:@"segUnwindToMainTabBar" sender:self];
    }
    else
    {
        goToHotDeal = 1;
        [self performSegueWithIdentifier:@"segUnwindToMainTabBar" sender:self];
    }
}

- (IBAction)button2Clicked:(id)sender//go to home
{
    goToHotDeal = 1;
    [self performSegueWithIdentifier:@"segUnwindToMainTabBar" sender:self];
}

- (IBAction)orderBuffet:(id)sender
{
    orderBuffet = 1;
    [self performSegueWithIdentifier:@"segUnwindToMainTabBar" sender:self];
}

-(void)screenCaptureBill:(Receipt *)receipt
{
    NSMutableArray *arrImage = [[NSMutableArray alloc]init];
    Branch *branch = [Branch getBranch:receipt.branchID];


    {
        //shop logo
        NSString *jummumLogo = [Setting getSettingValueWithKeyName:@"JummumLogo"];
        CustomTableViewCellLogo *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierLogo];


        NSString *strPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *noImageFileName = [NSString stringWithFormat:@"%@/JMM/Image/NoImage.jpg",strPath];
        NSString *imageFileName = [NSString stringWithFormat:@"%@/JMM/Image/%@",strPath,jummumLogo];
        imageFileName = [Utility isStringEmpty:jummumLogo]?noImageFileName:imageFileName;
        UIImage *image = [Utility getImageFromCache:imageFileName];
        if(image)
        {
            cell.imgVwValue.image = image;
            [self setImageDesign:cell.imgVwValue];
            UIImage *imageLogo = [self imageFromView:cell];
            [arrImage insertObject:imageLogo atIndex:0];
            _logoDownloaded = YES;
            if(_logoDownloaded && _endOfFile)
            {
                UIImage *combineImage = [self combineImage:arrImage];
                UIImage *pinkBackground = [UIImage imageNamed:@"pinkBackground.png"];
                UIImage *watermark = [UIImage imageNamed:@"jummumWatermark.jpg"];
//                pinkBackground = [self imageWithImage:pinkBackground convertToSize:CGSizeMake(combineImage.size.width+combineImage.size.width*0.02*2, combineImage.size.height+combineImage.size.width*0.02*2)];
                pinkBackground = [self imageWithImage:pinkBackground convertToSize:combineImage.size];

                watermark = [self imageByScalingProportionallyToSize:CGSizeMake(combineImage.size.width, combineImage.size.width/watermark.size.width*watermark.size.height) sourceImage:watermark];
                if(watermark.size.height < combineImage.size.height)
                {
                    NSMutableArray *arrWaterMark = [[NSMutableArray alloc]init];
                    for(int i=0; i<combineImage.size.height/watermark.size.height+1; i++)
                    {
                        [arrWaterMark addObject:watermark];
                    }
                    watermark = [self combineImage:arrWaterMark];
                }
                watermark = [self cropImageByImage:watermark toRect:CGRectMake(0, 0, combineImage.size.width, combineImage.size.height)];
                

                pinkBackground = [self addWatermarkOnImage:pinkBackground withImage:watermark];
                combineImage = [self addWatermarkOnImage:pinkBackground withImage:combineImage];


                UIImageWriteToSavedPhotosAlbum(combineImage, nil, nil, nil);
                return;
            }
        }
        else
        {
            [self.homeModel downloadImageWithFileName:jummumLogo type:5 branchID:0 completionBlock:^(BOOL succeeded, UIImage *image)
             {
                 if (succeeded)
                 {
                    [Utility saveImageInCache:image imageName:imageFileName];
                    cell.imgVwValue.image = image;
                    [self setImageDesign:cell.imgVwValue];
                    UIImage *imageLogo = [self imageFromView:cell];
                    
                    [arrImage insertObject:imageLogo atIndex:0];
                    _logoDownloaded = YES;
                    if(_logoDownloaded && _endOfFile)
                    {
                        UIImage *combineImage = [self combineImage:arrImage];
                        UIImage *pinkBackground = [UIImage imageNamed:@"pinkBackground.png"];
                        UIImage *watermark = [UIImage imageNamed:@"jummumWatermark.jpg"];
//                        pinkBackground = [self imageWithImage:pinkBackground convertToSize:CGSizeMake(combineImage.size.width+combineImage.size.width*0.02*2, combineImage.size.height+combineImage.size.width*0.02*2)];
                        pinkBackground = [self imageWithImage:pinkBackground convertToSize:combineImage.size];
                        watermark = [self imageByScalingProportionallyToSize:CGSizeMake(combineImage.size.width, combineImage.size.width/watermark.size.width*watermark.size.height) sourceImage:watermark];
                        if(watermark.size.height < combineImage.size.height)
                        {
                            NSMutableArray *arrWaterMark = [[NSMutableArray alloc]init];
                            for(int i=0; i<combineImage.size.height/watermark.size.height+1; i++)
                            {
                                [arrWaterMark addObject:watermark];
                            }
                            watermark = [self combineImage:arrWaterMark];
                        }
                        watermark = [self cropImageByImage:watermark toRect:CGRectMake(0, 0, combineImage.size.width, combineImage.size.height)];
                        
                
                        pinkBackground = [self addWatermarkOnImage:pinkBackground withImage:watermark];
                        combineImage = [self addWatermarkOnImage:pinkBackground withImage:combineImage];


                        UIImageWriteToSavedPhotosAlbum(combineImage, nil, nil, nil);
                        return;
                    }
                 }
             }];
        }
    }



    {
        //space after logo
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

    {
        //order header order no.
        CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
    
        //order no.
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
        cell.lblTitle.attributedText = attrString;
        [cell.lblTitle sizeToFit];
        {
            CGRect frame = cell.lblTitle.frame;
            frame.size.height = 18;
            cell.lblTitle.frame = frame;
        }
        cell.lblAmount.hidden = YES;
        cell.lblTitle.font = [UIFont fontWithName:@"Prompt-Regular" size:14];
        cell.lblTitle.textColor = cSystem4;
        cell.lblAmount.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
        cell.lblAmount.textColor = cSystem4;


        UIImage *image = [self imageFromView:cell];
        [arrImage addObject:image];
    }
    
    {
        //order header branch name and date
        CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
    
        cell.lblTitle.text = [NSString stringWithFormat:[Language getText:@"ร้าน %@"],branch.name];
        cell.lblAmount.text = [Utility dateToString:receipt.receiptDate toFormat:@"d MMM yy HH:mm"];
        cell.lblTitle.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
        cell.lblTitle.textColor = cSystem1;
        cell.lblAmount.font = [UIFont fontWithName:@"Prompt-Regular" size:13];
        cell.lblAmount.textColor = cSystem4;


        UIImage *image = [self imageFromView:cell];
        [arrImage addObject:image];
    }

    //separatorLine
    if([Utility isStringEmpty:receipt.remark])
    {
        CustomTableViewCellSeparatorLine *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierSeparatorLine];

        UIImage *image = [self imageFromView:cell];
        [arrImage addObject:image];
    }







    ///// order detail
    NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receipt.receiptID];
    orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
    for(int i=0; i<[orderTakingList count]; i++)
    {
        CustomTableViewCellOrderSummary *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierOrderSummary];
        cell.backgroundColor = [UIColor clearColor];


        OrderTaking *orderTaking = orderTakingList[i];
        Menu *menu = [Menu getMenu:orderTaking.menuID branchID:branch.branchID];
        cell.lblQuantity.text = [Utility formatDecimal:orderTaking.quantity withMinFraction:0 andMaxFraction:0];


        //menu
        if(orderTaking.takeAway)
        {
            UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:15];
            NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[Language getText:@"ใส่ห่อ"] attributes:attribute];

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
            UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:11];
            NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
            attrStringRemove = [[NSMutableAttributedString alloc] initWithString:[Language getText:branch.wordNo] attributes:attribute];


            UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:11];
            NSDictionary *attribute2 = @{NSFontAttributeName: font2};
            NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strRemoveTypeNote] attributes:attribute2];


            [attrStringRemove appendAttributedString:attrString2];
        }
        if(![Utility isStringEmpty:strAddTypeNote])
        {
            UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:11];
            NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
            attrStringAdd = [[NSMutableAttributedString alloc] initWithString:[Language getText:branch.wordAdd] attributes:attribute];


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


        float height = 8+cell.lblMenuNameHeight.constant+2+cell.lblNoteHeight.constant+8;
        CGRect frame = cell.frame;
        frame.size.height = height;
        cell.frame = frame;


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



        //remark
        if(![Utility isStringEmpty:receipt.remark])
        {
            CustomTableViewCellLabelRemark *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierLabelRemark];
            NSString *message = [Language getText:@"หมายเหตุ: "];
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
            NSString *strTitle = [NSString stringWithFormat:[Language getText:@"%ld รายการ"],[orderTakingList count]];
            NSString *strTotal = [Utility formatDecimal:receipt.totalAmount withMinFraction:2 andMaxFraction:2];
            strTotal = [Utility addPrefixBahtSymbol:strTotal];
            cell.lblTitle.text = strTitle;
            cell.lblAmount.text = strTotal;
            cell.lblTitle.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
            cell.lblTitle.textColor = cSystem4;
            cell.lblAmount.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
            cell.lblAmount.textColor = cSystem1;


            UIImage *image = [self imageFromView:cell];
            [arrImage addObject:image];
        }
        {
            //specialPriceDiscount
            CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];


            NSString *strAmount = [Utility formatDecimal:receipt.specialPriceDiscount withMinFraction:2 andMaxFraction:2];
            strAmount = [Utility addPrefixBahtSymbol:strAmount];
            strAmount = [NSString stringWithFormat:@"-%@",strAmount];


            cell.lblTitle.text = [Language getText:@"ส่วนลด"];;
            cell.lblAmount.text = strAmount;
            cell.lblTitle.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
            cell.lblTitle.textColor = cSystem4;
            cell.lblAmount.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
            cell.lblAmount.textColor = cSystem2;


            UIImage *image = [self imageFromView:cell];
            if(receipt.discountValue > 0)
            {
                [arrImage addObject:image];
            }
        }
        {
            //DiscountProgram1
            CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
            
            NSString *strDiscountProgramValue = [Utility formatDecimal:receipt.discountProgramValue withMinFraction:2 andMaxFraction:2];
            strDiscountProgramValue = [Utility addPrefixBahtSymbol:strDiscountProgramValue];
            strDiscountProgramValue = [NSString stringWithFormat:@"-%@",strDiscountProgramValue];
            cell.lblTitle.text = receipt.discountProgramTitle;
            cell.lblAmount.text = strDiscountProgramValue;
            cell.lblTitle.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
            cell.lblTitle.textColor = cSystem4;
            cell.lblAmount.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
            cell.lblAmount.textColor = cSystem2;

            UIImage *image = [self imageFromView:cell];
            if(receipt.discountProgramValue > 0)
            {
                [arrImage addObject:image];
            }
        }
        // 1:
        {
            //discount
            CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
            NSString *strDiscount = ![Utility isStringEmpty:receipt.voucherCode]?[NSString stringWithFormat:[Language getText:@"คูปองส่วนลด %@"],receipt.voucherCode]:@"";


            NSString *strAmount = [Utility formatDecimal:receipt.discountValue withMinFraction:2 andMaxFraction:2];
            strAmount = [Utility addPrefixBahtSymbol:strAmount];
            strAmount = [NSString stringWithFormat:@"-%@",strAmount];


            cell.lblTitle.text = strDiscount;
            cell.lblAmount.text = strAmount;
            cell.lblTitle.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
            cell.lblTitle.textColor = cSystem4;
            cell.lblAmount.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
            cell.lblAmount.textColor = cSystem2;


            UIImage *image = [self imageFromView:cell];
            if(receipt.discountValue > 0)
            {
                [arrImage addObject:image];
            }

        }
        // 2:
        {
            //after discount
            CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
            NSString *strTitle = branch.priceIncludeVat?[Language getText:@"ยอดรวม (รวม Vat)"]:[Language getText:@"ยอดรวม"];
            NSString *strTotal = [Utility formatDecimal:[OrderTaking getSumSpecialPrice:orderTakingList]-receipt.discountValue withMinFraction:2 andMaxFraction:2];
            strTotal = [Utility addPrefixBahtSymbol:strTotal];
            cell.lblTitle.text = strTitle;
            cell.lblAmount.text = strTotal;
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
            cell.lblTitle.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
            cell.lblTitle.textColor = cSystem4;
            cell.lblAmount.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
            cell.lblAmount.textColor = cSystem4;


            UIImage *image = [self imageFromView:cell];
            if(branch.serviceChargePercent > 0)
            {
                [arrImage addObject:image];
            }
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
            cell.lblTitle.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
            cell.lblTitle.textColor = cSystem4;
            cell.lblAmount.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
            cell.lblAmount.textColor = cSystem4;


            UIImage *image = [self imageFromView:cell];
            if(branch.percentVat > 0)
            {
                [arrImage addObject:image];
            }
        }
        // 5:
        {
            //net total
            CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
            float netTotalAmount = receipt.netTotal;
            NSString *strAmount = [Utility formatDecimal:netTotalAmount withMinFraction:2 andMaxFraction:2];
            strAmount = [Utility addPrefixBahtSymbol:strAmount];
            cell.lblTitle.text = [Language getText:@"ยอดรวมทั้งสิ้น"];
            cell.lblAmount.text = strAmount;
            cell.lblTitle.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
            cell.lblTitle.textColor = cSystem4;
            cell.lblAmount.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
            cell.lblAmount.textColor = cSystem1;


            UIImage *image = [self imageFromView:cell];
            if(branch.serviceChargePercent+branch.percentVat > 0)
            {
                [arrImage addObject:image];
            }
        }
        
        {
            //luckyDrawCount
            CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];

            NSInteger luckyDrawCount = receipt.luckyDrawCount;
            if(luckyDrawCount)
            {
                cell.lblTitle.text = [NSString stringWithFormat:[Language getText:@"(คุณจะได้สิทธิ์ลุ้นรางวัล %ld ครั้ง)"], luckyDrawCount];
            }
            else
            {
                cell.lblTitle.text = [Language getText:@"(คุณไม่ได้รับสิทธิ์ลุ้นรางวัลในครั้งนี้)"];
            }
            cell.lblTitle.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
            cell.lblTitle.textColor = cSystem2;
            cell.lblAmount.text = @"";
            cell.lblAmountWidth.constant = 0;
            UIImage *image = [self imageFromView:cell];
            [arrImage addObject:image];
        }
        
        {
            //before vat
            CustomTableViewCellTotal *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
            
            NSString *strAmount = [Utility formatDecimal:receipt.beforeVat withMinFraction:2 andMaxFraction:2];
            strAmount = [Utility addPrefixBahtSymbol:strAmount];

            cell.lblTitle.text = [Language getText:@"ราคารวมก่อน Vat"];
            cell.lblAmount.text = strAmount;
            cell.lblTitle.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
            cell.lblTitle.textColor = cSystem4;
            cell.lblAmount.font = [UIFont fontWithName:@"Prompt-Regular" size:15];
            cell.lblAmount.textColor = cSystem4;


            UIImage *image = [self imageFromView:cell];            
            if((branch.serviceChargePercent>0 && branch.percentVat>0) || (branch.serviceChargePercent == 0 && branch.percentVat>0 && branch.priceIncludeVat))
            {
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
        UIImage *pinkBackground = [UIImage imageNamed:@"pinkBackground.png"];
        UIImage *watermark = [UIImage imageNamed:@"jummumWatermark.jpg"];
//        pinkBackground = [self imageWithImage:pinkBackground convertToSize:CGSizeMake(combineImage.size.width+combineImage.size.width*0.02*2, combineImage.size.height+combineImage.size.width*0.02*2)];
        pinkBackground = [self imageWithImage:pinkBackground convertToSize:combineImage.size];
        watermark = [self imageByScalingProportionallyToSize:CGSizeMake(combineImage.size.width, combineImage.size.width/watermark.size.width*watermark.size.height) sourceImage:watermark];
        if(watermark.size.height < combineImage.size.height)
        {
            NSMutableArray *arrWaterMark = [[NSMutableArray alloc]init];
            for(int i=0; i<combineImage.size.height/watermark.size.height+1; i++)
            {
                [arrWaterMark addObject:watermark];
            }
            watermark = [self combineImage:arrWaterMark];
        }
        watermark = [self cropImageByImage:watermark toRect:CGRectMake(0, 0, combineImage.size.width, combineImage.size.height)];
        

        pinkBackground = [self addWatermarkOnImage:pinkBackground withImage:watermark];
        combineImage = [self addWatermarkOnImage:pinkBackground withImage:combineImage];

        UIImageWriteToSavedPhotosAlbum(combineImage, nil, nil, nil);
        return;
    }
}

-(void)tapGiftBox
{
    [self performSegueWithIdentifier:@"segLuckyDraw" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segLuckyDraw"])
    {
        LuckyDrawViewController *vc = segue.destinationViewController;
        vc.receipt = receipt;
    }
}

@end
