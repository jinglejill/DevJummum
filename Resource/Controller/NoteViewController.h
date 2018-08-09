//
//  NoteViewController.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 24/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "MenuSelectionViewController.h"
#import "OrderTaking.h"
#import "Branch.h"


@interface NoteViewController : CustomViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UICollectionView *colVwNote;
@property (strong, nonatomic) IBOutlet UIButton *btnConfirm;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) NSMutableArray *noteList;
@property (strong, nonatomic) OrderTaking *orderTaking;
@property (strong, nonatomic) MenuSelectionViewController *vc;
@property (strong, nonatomic) Branch *branch;
- (IBAction)confirmNote:(id)sender;
- (IBAction)cancelNote:(id)sender;
@end
