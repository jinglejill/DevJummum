//
//  NoteViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 24/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "NoteViewController.h"
#import "CustomCollectionViewCellNote.h"
#import "CustomCollectionViewCellNoteWithQuantity.h"
#import "CustomCollectionReusableView.h"
#import "Note.h"
#import "NoteType.h"
#import "OrderNote.h"
#import "Menu.h"
#import "MenuNote.h"
#import "SpecialPriceProgram.h"
#import "Setting.h"



@interface NoteViewController ()
{
    NSMutableArray *_noteTypeList;
    NSMutableArray *_beforeOrderNoteList;
}
@end

@implementation NoteViewController
static NSString * const reuseHeaderViewIdentifier = @"CustomCollectionReusableView";
static NSString * const reuseIdentifierNote = @"CustomCollectionViewCellNote";
static NSString * const reuseIdentifierNoteWithQuantity = @"CustomCollectionViewCellNoteWithQuantity";


@synthesize colVwNote;
@synthesize noteList;
@synthesize orderTaking;
@synthesize vc;
@synthesize btnConfirm;
@synthesize btnCancel;
@synthesize btnDeleteAll;
@synthesize branch;


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self setButtonDesign:btnConfirm];
    [self setButtonDesign:btnCancel];
    [self setButtonDesign:btnDeleteAll];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    // Do any additional setup after loading the view.
    colVwNote.delegate = self;
    colVwNote.dataSource = self;
    
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierNote bundle:nil];
        [colVwNote registerNib:nib forCellWithReuseIdentifier:reuseIdentifierNote];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierNoteWithQuantity bundle:nil];
        [colVwNote registerNib:nib forCellWithReuseIdentifier:reuseIdentifierNoteWithQuantity];
    }
    
    {
        UINib *nib = [UINib nibWithNibName:reuseHeaderViewIdentifier bundle:nil];
        [colVwNote registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderViewIdentifier];
    }
    
    {
        UINib *nib = [UINib nibWithNibName:reuseHeaderViewIdentifier bundle:nil];
        [colVwNote registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseHeaderViewIdentifier];
    }
    
    
    _beforeOrderNoteList = [[NSMutableArray alloc]init];
    NSMutableArray *orderNoteList = [OrderNote getOrderNoteListWithOrderTakingID:orderTaking.orderTakingID];
    for(OrderNote *item in orderNoteList)
    {
        OrderNote *orderNote = [item copy];
        [_beforeOrderNoteList addObject:orderNote];
    }
    noteList = [MenuNote getNoteListWithMenuID:orderTaking.menuID branchID:branch.branchID];
    if([noteList count] == 0)
    {
        //download menunote
        [self loadingOverlayView];
        self.homeModel = [[HomeModel alloc]init];
        self.homeModel.delegate = self;
        [self.homeModel downloadItems:dbMenuNoteList withData:@[branch,@(orderTaking.menuID)]];
    }
    else
    {
        _noteTypeList = [NoteType getNoteTypeListWithNoteList:noteList branchID:branch.branchID];
        _noteTypeList = [NoteType sort:_noteTypeList];
        [colVwNote reloadData];
        
        
        
        //download menunote
        self.homeModel = [[HomeModel alloc]init];
        self.homeModel.delegate = self;
        [self.homeModel downloadItems:dbMenuNoteList withData:@[branch,@(orderTaking.menuID)]];
    }
    

    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture setCancelsTouchesInView:NO];
}

- (void)loadView
{
    [super loadView];
    
    
    colVwNote.allowsMultipleSelection = YES;

    
    [self loadViewProcess];
}

-(void)loadViewProcess
{
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if([_noteTypeList count] == 0)
    {
        NSString *message = [Language getText:@"ไม่มีตัวเลือกโน้ตสำหรับรายการนี้"];
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, collectionView.bounds.size.width, collectionView.bounds.size.height)];
        noDataLabel.text             = message;
        noDataLabel.textColor        = cSystem4;
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        noDataLabel.font = [UIFont fontWithName:@"Prompt-Regular" size:15.0f];
        collectionView.backgroundView = noDataLabel;
        return 0;
    }
    else
    {
        collectionView.backgroundView = nil;
        return  [_noteTypeList count];
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger countColumn = 1;
    NoteType *noteType = _noteTypeList[section];
    NSMutableArray *noteListBySection = [Note getNoteListWithNoteTypeID:noteType.noteTypeID type:noteType.type noteList:noteList];
    
    
    return ceilf(1.0*[noteListBySection count]/countColumn)*countColumn;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CustomCollectionViewCellNoteWithQuantity *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierNoteWithQuantity forIndexPath:indexPath];
    cell.contentView.userInteractionEnabled = NO;
    
    
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    
    
    NoteType *noteType = _noteTypeList[section];
    NSMutableArray *noteListBySection = [Note getNoteListWithNoteTypeID:noteType.noteTypeID type:noteType.type noteList:noteList];
    noteListBySection = [Utility sortDataByColumn:noteListBySection numOfColumn:3];
    if(item < [noteListBySection count])
    {
        Note *note = noteListBySection[item];
        OrderNote *orderNote = [OrderNote getOrderNoteWithOrderTakingID:orderTaking.orderTakingID noteID:note.noteID];
        if(orderNote)
        {
            cell.selected = YES;
            [colVwNote selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            cell.btnDeleteQuantity.tag = 201;
            cell.btnAddQuantity.tag = 202;
            if(noteType.allowQuantity)
            {
                cell.btnDeleteQuantity.hidden = NO;
                cell.btnAddQuantity.hidden = NO;
                cell.txtQuantity.hidden = NO;
            }
            else
            {
                cell.btnDeleteQuantity.hidden = YES;
                cell.btnAddQuantity.hidden = YES;
                cell.txtQuantity.hidden = YES;
            }
            cell.txtQuantity.text = [Utility formatDecimal:orderNote.quantity withMinFraction:0 andMaxFraction:2];
            cell.txtQuantity.tag = note.noteID;
            cell.txtQuantity.delegate = self;
            [cell.btnDeleteQuantity addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnAddQuantity addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventTouchUpInside];
            cell.layer.backgroundColor = [cSystem1_20 CGColor];
        }
        else
        {
            cell.selected = NO;
            cell.btnDeleteQuantity.tag = 201;
            cell.btnAddQuantity.tag = 202;
            cell.btnDeleteQuantity.hidden = YES;
            cell.btnAddQuantity.hidden = YES;
            cell.txtQuantity.hidden = YES;
            cell.txtQuantity.text = @"";
            cell.txtQuantity.tag = note.noteID;
            cell.txtQuantity.delegate = self;
            [cell.btnDeleteQuantity addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnAddQuantity addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventTouchUpInside];
            cell.layer.backgroundColor = [[UIColor clearColor]CGColor];
        }
        if(note.type == 1)//เพิ่ม
        {
            UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:14];
            NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[Language getText:branch.wordAdd] attributes:attribute];
            
            
            NSString *noteName = [Language langIsTH]?note.name:note.nameEn;
            UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:14];
            NSDictionary *attribute2 = @{NSFontAttributeName: font2};
            NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",noteName] attributes:attribute2];
            
            
            [attrString appendAttributedString:attrString2];
            
            
            cell.lblNoteName.attributedText = attrString;        
            cell.lblNoteName.tag = note.noteID;
        }
        else//ไม่ใส่
        {
            NSString *noteName = [Language langIsTH]?note.name:note.nameEn;
            cell.lblNoteName.text = [NSString stringWithFormat:[Language getText:@"ไม่ใส่ %@"],noteName];
            cell.lblNoteName.tag = note.noteID;
        }
        
        
        //price
        NSString *strNotePrice = note.price != 0?[NSString stringWithFormat:@"%@",[Utility formatDecimal:note.price withMinFraction:0 andMaxFraction:0]]:@"";
        strNotePrice = note.price > 0?[NSString stringWithFormat:@"+%@",strNotePrice]:strNotePrice;
        cell.lblPrice.text = strNotePrice;
        cell.lblPrice.textColor = cSystem1;
        
        
        
        //totalPrice
        cell.lblTotalPrice.textColor = cSystem1;
        cell.lblTotalPrice.text = @"";
        if(noteType.allowQuantity && note.price != 0 && orderNote.quantity > 0)
        {
            NSString *strNoteTotalPrice = note.price != 0?[NSString stringWithFormat:@"%@",[Utility formatDecimal:note.price*orderNote.quantity withMinFraction:0 andMaxFraction:0]]:@"";
            strNoteTotalPrice = note.price > 0?[NSString stringWithFormat:@"+%@",strNoteTotalPrice]:strNoteTotalPrice;
            cell.lblTotalPrice.text = strNoteTotalPrice;
        }
        
        
        cell.lblNoteName.hidden = NO;
        cell.lblPrice.hidden = NO;
        cell.lblTotalPrice.hidden = NO;
    }
    else
    {
        cell.btnDeleteQuantity.hidden = YES;
        cell.btnAddQuantity.hidden = YES;
        cell.txtQuantity.hidden = YES;
        cell.lblNoteName.hidden = YES;
        cell.lblPrice.hidden = YES;
        cell.lblTotalPrice.hidden = YES;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    NoteType *noteType = _noteTypeList[section];
    NSMutableArray *noteListBySection = [Note getNoteListWithNoteTypeID:noteType.noteTypeID type:noteType.type noteList:noteList];
    noteListBySection = [Utility sortDataByColumn:noteListBySection numOfColumn:3];
    if(item >= [noteListBySection count])
    {
        return;
    }
    Note *note = noteListBySection[item];
    
    OrderNote *orderNote = [OrderNote getOrderNoteWithOrderTakingID:orderTaking.orderTakingID noteID:note.noteID];
    if(!orderNote)
    {
        OrderNote *addOrderNote = [[OrderNote alloc]initWithOrderTakingID:orderTaking.orderTakingID noteID:note.noteID quantity:1];
        [OrderNote addObject:addOrderNote];
    }
    
    

    CustomCollectionViewCellNoteWithQuantity *cell = (CustomCollectionViewCellNoteWithQuantity *)[collectionView cellForItemAtIndexPath:indexPath];
    if(noteType.allowQuantity)
    {
        cell.btnDeleteQuantity.hidden = NO;
        cell.btnAddQuantity.hidden = NO;
        cell.txtQuantity.hidden = NO;
    }
    else
    {
        cell.btnDeleteQuantity.hidden = YES;
        cell.btnAddQuantity.hidden = YES;
        cell.txtQuantity.hidden = YES;
    }
    cell.txtQuantity.text = @"1";
    cell.lblTotalPrice.text = @"";
    if(noteType.allowQuantity)
    {
        cell.lblTotalPrice.text = note.price>0?[Utility formatDecimal:note.price*1 withMinFraction:0 andMaxFraction:0]:@"";
        cell.lblTotalPrice.text = note.price>0?[NSString stringWithFormat:@"+%@",cell.lblTotalPrice.text]:cell.lblTotalPrice.text;
    }
    
    cell.layer.backgroundColor = [cSystem1_20 CGColor];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    NoteType *noteType = _noteTypeList[section];
    NSMutableArray *noteListBySection = [Note getNoteListWithNoteTypeID:noteType.noteTypeID type:noteType.type noteList:noteList];
    noteListBySection = [Utility sortDataByColumn:noteListBySection numOfColumn:3];
    if(item >= [noteListBySection count])
    {
        return;
    }
    Note *note = noteListBySection[item];
    
    OrderNote *orderNote = [OrderNote getOrderNoteWithOrderTakingID:orderTaking.orderTakingID noteID:note.noteID];
    if(orderNote)
    {
        [OrderNote removeObject:orderNote];
    }
    
    
    CustomCollectionViewCellNoteWithQuantity *cell = (CustomCollectionViewCellNoteWithQuantity *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.btnDeleteQuantity.hidden = YES;
    cell.btnAddQuantity.hidden = YES;
    cell.txtQuantity.hidden = YES;
    cell.txtQuantity.text = @"";
    cell.lblTotalPrice.text = @"";
    cell.layer.backgroundColor = [[UIColor clearColor] CGColor];
}

#pragma mark <UICollectionViewDelegate>


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger countColumn = 1;
    return CGSizeMake(floorf(collectionView.frame.size.width/countColumn), 44);
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)colVwNote.collectionViewLayout;
    
    [layout invalidateLayout];
    [colVwNote reloadData];
    
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);//top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        CustomCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderViewIdentifier forIndexPath:indexPath];
        
        
        NSInteger section = indexPath.section;
        NoteType *noteType = _noteTypeList[section];
        NoteType *previousNoteType;
        if(section-1 >= 0)
        {
            previousNoteType = _noteTypeList[section-1];
        }
        
        
        headerView.lblHeaderName.text = [Language langIsTH]?noteType.name:noteType.nameEn;
        headerView.lblHeaderName.textColor = cSystem1;
        headerView.vwBottomLine.backgroundColor = [UIColor clearColor];
        
        
        if(previousNoteType)
        {
            if(previousNoteType.noteTypeID == noteType.noteTypeID)
            {
                headerView.lblHeaderName.text = @"";
                headerView.lblHeaderName.textColor = cSystem1;
                headerView.vwBottomLine.backgroundColor = [UIColor clearColor];
            }
        }
        
        
        reusableview = headerView;
    }
    
    if (kind == UICollectionElementKindSectionFooter)
    {
        CustomCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseHeaderViewIdentifier forIndexPath:indexPath];
        
        footerView.lblHeaderName.text = @"";
        footerView.lblHeaderName.textColor = cSystem1;
        footerView.vwBottomLine.backgroundColor = cSystem4_10;
        
        
        reusableview = footerView;
    }
    
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{
    CGSize headerSize = CGSizeMake(0, 0);
    NoteType *noteType = _noteTypeList[section];
    NoteType *previousNoteType;
    if(section-1 >= 0)
    {
        previousNoteType = _noteTypeList[section-1];
    }
    
    
    if(previousNoteType)
    {
        if(previousNoteType.noteTypeID == noteType.noteTypeID)
        {
            headerSize = CGSizeMake(collectionView.bounds.size.width, 0);
        }
        else
        {
            headerSize = CGSizeMake(collectionView.bounds.size.width, 18);
        }
    }
    else
    {
        headerSize = CGSizeMake(collectionView.bounds.size.width, 18);
    }
    
    
    return headerSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;
{
    CGSize footerSize = CGSizeMake(collectionView.bounds.size.width, 1);
    return footerSize;
}

- (IBAction)cancelNote:(id)sender
{
    NSMutableArray *orderNoteList = [OrderNote getOrderNoteListWithOrderTakingID:orderTaking.orderTakingID];
    for(OrderNote *item in orderNoteList)
    {
        [OrderNote removeObject:item];
    }
    
    for(OrderNote *item in _beforeOrderNoteList)
    {
        [OrderNote addObject:item];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)deleteAll:(id)sender
{
    NSMutableArray *orderNoteList = [OrderNote getOrderNoteListWithOrderTakingID:orderTaking.orderTakingID];
    for(OrderNote *item in orderNoteList)
    {
        [OrderNote removeObject:item];
    }
    [colVwNote reloadData];
}

- (IBAction)confirmNote:(id)sender
{
    //update note id list in text
    orderTaking.noteIDListInText = [OrderNote getNoteIDListInTextWithOrderTakingID:orderTaking.orderTakingID branchID:branch.branchID];
    
    
    //update ordertaking price
    float sumNotePrice = [OrderNote getSumNotePriceWithOrderTakingID:orderTaking.orderTakingID branchID:branch.branchID];
    orderTaking.notePrice = sumNotePrice;
    orderTaking.modifiedUser = [Utility modifiedUser];
    orderTaking.modifiedDate = [Utility currentDateTime];
    
    
    
    [self performSegueWithIdentifier:@"segUnwindToBasket" sender:self];    
}

- (void) orientationChanged:(NSNotification *)note
{
    //    [colVwNote reloadData];
    [colVwNote reloadSections:[NSIndexSet indexSetWithIndex:0]];
    UIDevice * device = note.object;
    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
            /* start special animation */
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            /* start special animation */
            break;
            
        default:
            break;
    };
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.tag != 0)
    {

        NSInteger noteID = textField.tag;
        OrderNote *orderNote = [OrderNote getOrderNoteWithOrderTakingID:orderTaking.orderTakingID noteID:noteID];
        

        NSInteger quantity = [textField.text integerValue];
        if(quantity == 0 || [Utility isStringEmpty:textField.text])
        {
            [OrderNote removeObject:orderNote];
        }
        else
        {
            orderNote.quantity = [textField.text integerValue];
        }
        
        [colVwNote reloadData];
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

-(void)stepperValueChanged:(id)sender
{
    UIButton *button = sender;
    
    CGPoint point = [sender convertPoint:CGPointZero toView:colVwNote];
    NSIndexPath *indexPath = [colVwNote indexPathForItemAtPoint:point];
    CustomCollectionViewCellNoteWithQuantity *cell = (CustomCollectionViewCellNoteWithQuantity *)[colVwNote cellForItemAtIndexPath:indexPath];
    if(button.tag == 201)
    {
        NSInteger quantity = [cell.txtQuantity.text integerValue]-1;
        cell.txtQuantity.text = [Utility formatDecimal:quantity withMinFraction:0 andMaxFraction:0];
        
        
        //remove orderNote
        NSInteger noteID = cell.lblNoteName.tag;
        OrderNote *orderNote = [OrderNote getOrderNoteWithOrderTakingID:orderTaking.orderTakingID noteID:noteID];
        if(orderNote.quantity == 1)
        {
            [OrderNote removeObject:orderNote];
        }
        else if(orderNote.quantity > 1)
        {
            orderNote.quantity -= 1;
        }
        
        [colVwNote reloadData];
    }
    else if(button.tag == 202)
    {
        if([cell.txtQuantity.text integerValue] == 99)
        {
            return;
        }
        NSInteger quantity = [cell.txtQuantity.text integerValue]+1;
        cell.txtQuantity.text = [Utility formatDecimal:quantity withMinFraction:0 andMaxFraction:0];
        
        
        //add orderNote
        NSInteger noteID = cell.lblNoteName.tag;
        OrderNote *orderNote = [OrderNote getOrderNoteWithOrderTakingID:orderTaking.orderTakingID noteID:noteID];
        orderNote.quantity += 1;
        
        
        [colVwNote reloadData];
    }
}

-(void)itemsDownloaded:(NSArray *)items manager:(NSObject *)objHomeModel
{
    HomeModel *homeModel = (HomeModel *)objHomeModel;
    if(homeModel.propCurrentDB == dbMenuNoteList)
    {
        [self removeOverlayViews];
//        [Utility updateSharedObject:items];

        NSArray *arrClassName = @[@"MenuNote",@"Note",@"NoteType"];
        for(int i=0; i<=2; i++)
        {
            [Utility updateSharedDataList:items[i] className:arrClassName[i] branchID:branch.branchID];
        }
        
        
        
        /////////
        noteList = [MenuNote getNoteListWithMenuID:orderTaking.menuID branchID:branch.branchID];
        _noteTypeList = [NoteType getNoteTypeListWithNoteList:noteList branchID:branch.branchID];
        _noteTypeList = [NoteType sort:_noteTypeList];
        
        
        
        //remove note not in current note
        NSMutableArray *removeOrderNoteList = [[NSMutableArray alloc]init];
        NSMutableArray *orderNoteList = [OrderNote getOrderNoteListWithOrderTakingID:orderTaking.orderTakingID];
        for(OrderNote *item in orderNoteList)
        {
            MenuNote *menuNote = [MenuNote getMenuNote:orderTaking.menuID noteID:item.noteID branchID:branch.branchID];
            if(!menuNote)
            {
                [removeOrderNoteList addObject:item];
            }
        }
        [OrderNote removeList:removeOrderNoteList];


        [colVwNote reloadData];
    }
}
@end
