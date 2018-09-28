//
//  NoteViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 24/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "NoteViewController.h"
#import "CustomCollectionViewCellNote.h"
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
    NSMutableArray *_currentOrderNoteList;
}
@end

@implementation NoteViewController
static NSString * const reuseHeaderViewIdentifier = @"CustomCollectionReusableView";
static NSString * const reuseIdentifierNote = @"CustomCollectionViewCellNote";


@synthesize colVwNote;
@synthesize noteList;
@synthesize orderTaking;
@synthesize vc;
@synthesize btnConfirm;
@synthesize btnCancel;
@synthesize branch;


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self setButtonDesign:btnConfirm];
    [self setButtonDesign:btnCancel];
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
        UINib *nib = [UINib nibWithNibName:reuseHeaderViewIdentifier bundle:nil];
        [colVwNote registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderViewIdentifier];
    }
    
    {
        UINib *nib = [UINib nibWithNibName:reuseHeaderViewIdentifier bundle:nil];
        [colVwNote registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseHeaderViewIdentifier];
    }
    
    
    
    noteList = [MenuNote getNoteListWithMenuID:orderTaking.menuID];
    if([noteList count] == 0)
    {
        //download menunote
        self.homeModel = [[HomeModel alloc]init];
        self.homeModel.delegate = self;
        [self.homeModel downloadItems:dbMenuNoteList withData:@[branch,@(orderTaking.menuID)] completionBlock:^(BOOL succeeded, NSMutableArray *items)
         {
             if (succeeded)
             {
                 [Utility updateSharedObject:items];

                 
                 /////////
                 noteList = [MenuNote getNoteListWithMenuID:orderTaking.menuID];
                 _noteTypeList = [[NSMutableArray alloc]init];
                 NSSet *noteTypeIDSet = [NSSet setWithArray:[noteList valueForKey:@"_noteTypeID"]];
                 for(NSNumber *noteTypeID in noteTypeIDSet)
                 {
                     NoteType *noteType = [NoteType getNoteType:[noteTypeID integerValue]];
                     NSMutableArray *noteListByNoteTypeID = [Note getNoteListWithNoteTypeID:noteType.noteTypeID noteList:noteList];
                     NSSet *typeSet = [NSSet setWithArray:[noteListByNoteTypeID valueForKey:@"_type"]];
                     for(NSNumber *type in typeSet)
                     {
                         NoteType *newNoteType = [noteType copy];
                         newNoteType.type = [type integerValue];
                         [_noteTypeList addObject:newNoteType];
                     }
                 }
                 _noteTypeList = [NoteType sort:_noteTypeList];
                 _currentOrderNoteList = [OrderNote getOrderNoteListWithOrderTakingID:orderTaking.orderTakingID];
                 
                 [colVwNote reloadData];
             }
         }];
    }
    else
    {
        _noteTypeList = [[NSMutableArray alloc]init];
        NSSet *noteTypeIDSet = [NSSet setWithArray:[noteList valueForKey:@"_noteTypeID"]];
        for(NSNumber *noteTypeID in noteTypeIDSet)
        {
            NoteType *noteType = [NoteType getNoteType:[noteTypeID integerValue]];
            NSMutableArray *noteListByNoteTypeID = [Note getNoteListWithNoteTypeID:noteType.noteTypeID noteList:noteList];
            NSSet *typeSet = [NSSet setWithArray:[noteListByNoteTypeID valueForKey:@"_type"]];
            for(NSNumber *type in typeSet)
            {
                NoteType *newNoteType = [noteType copy];
                newNoteType.type = [type integerValue];
                [_noteTypeList addObject:newNoteType];
            }
        }
        _noteTypeList = [NoteType sort:_noteTypeList];
        _currentOrderNoteList = [OrderNote getOrderNoteListWithOrderTakingID:orderTaking.orderTakingID];
        
        [colVwNote reloadData];
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
    return  [_noteTypeList count];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger countColumn = 3;
    NoteType *noteType = _noteTypeList[section];
    NSMutableArray *noteListBySection = [Note getNoteListWithNoteTypeID:noteType.noteTypeID type:noteType.type noteList:noteList];
    
    
    return ceilf(1.0*[noteListBySection count]/countColumn)*countColumn;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CustomCollectionViewCellNote *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierNote forIndexPath:indexPath];
    
    
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    
    
    NoteType *noteType = _noteTypeList[section];
    NSMutableArray *noteListBySection = [Note getNoteListWithNoteTypeID:noteType.noteTypeID type:noteType.type noteList:noteList];
    noteListBySection = [Utility sortDataByColumn:noteListBySection numOfColumn:3];
    if(item < [noteListBySection count])
    {
        Note *note = noteListBySection[item];
        OrderNote *orderNote = [OrderNote getOrderNoteWithNoteID:note.noteID orderNoteList:_currentOrderNoteList];
        if(orderNote)
        {
            cell.selected = YES;
            [colVwNote selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            [cell.btnCheckBox setImage:[UIImage imageNamed:@"checkbox_gray.png"] forState:UIControlStateNormal];
            cell.layer.backgroundColor = [cSystem1_20 CGColor];
        }
        else
        {
            cell.selected = NO;
            [cell.btnCheckBox setImage:[UIImage imageNamed:@"uncheckbox_gray.png"] forState:UIControlStateNormal];
            cell.layer.backgroundColor = [[UIColor clearColor]CGColor];
        }
        if(note.type == 1)//เพิ่ม
        {
            UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:14];
            NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[Language getText:@"เพิ่ม"] attributes:attribute];
            
            
            UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:14];
            NSDictionary *attribute2 = @{NSFontAttributeName: font2};
            NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",note.name] attributes:attribute2];
            
            
            [attrString appendAttributedString:attrString2];
            
            
            cell.lblNoteName.attributedText = attrString;        
            
        }
        else//ไม่ใส่
        {
            cell.lblNoteName.text = [NSString stringWithFormat:[Language getText:@"ไม่ใส่ %@"],note.name];
        }
        
        NSString *strNotePrice = @"";
        if(note.price > 0)
        {
            strNotePrice = [NSString stringWithFormat:@"+%@",[Utility formatDecimal:note.price withMinFraction:0 andMaxFraction:0]];
        }
        else if (note.price < 0)
        {
            strNotePrice = [NSString stringWithFormat:@"-%@",[Utility formatDecimal:note.price withMinFraction:0 andMaxFraction:0]];
        }
        cell.lblPrice.text = strNotePrice;
        cell.lblPrice.textColor = cSystem1;
        
        
        cell.btnCheckBox.hidden = NO;
        cell.lblNoteName.hidden = NO;
        cell.lblPrice.hidden = NO;
    }
    else
    {
        cell.btnCheckBox.hidden = YES;
        cell.lblNoteName.hidden = YES;
        cell.lblPrice.hidden = YES;
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
    
    OrderNote *orderNote = [OrderNote getOrderNoteWithNoteID:note.noteID orderNoteList:_currentOrderNoteList];
    if(!orderNote)
    {
        OrderNote *addOrderNote = [[OrderNote alloc]initWithOrderTakingID:orderTaking.orderTakingID noteID:note.noteID];
        [OrderNote addObject:addOrderNote];
        [_currentOrderNoteList addObject:addOrderNote];
    }
    
    
    CustomCollectionViewCellNote *cell = (CustomCollectionViewCellNote *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell.btnCheckBox setImage:[UIImage imageNamed:@"checkbox_gray.png"] forState:UIControlStateNormal];
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
    
    OrderNote *orderNote = [OrderNote getOrderNoteWithNoteID:note.noteID orderNoteList:_currentOrderNoteList];
    if(orderNote)
    {
        [OrderNote removeObject:orderNote];
        [_currentOrderNoteList removeObject:orderNote];
    }
    
    
    CustomCollectionViewCellNote *cell = (CustomCollectionViewCellNote *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell.btnCheckBox setImage:[UIImage imageNamed:@"uncheckbox_gray.png"] forState:UIControlStateNormal];
    cell.layer.backgroundColor = [[UIColor clearColor] CGColor];
}

#pragma mark <UICollectionViewDelegate>


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger countColumn = 2;
    return CGSizeMake(floorf(collectionView.frame.size.width/countColumn), 34);
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
        
        
        headerView.lblHeaderName.text = noteType.name;
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)confirmNote:(id)sender
{
    //update note id list in text
    orderTaking.noteIDListInText = [OrderNote getNoteIDListInTextWithOrderTakingID:orderTaking.orderTakingID];
    
    
    //update ordertaking price
    float sumNotePrice = [OrderNote getSumNotePriceWithOrderTakingID:orderTaking.orderTakingID];
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

@end
