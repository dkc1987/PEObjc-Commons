//
// PEFluentListViewController.m
//
// Copyright (c) 2014-2015 PEObjc-Commons
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "PEFluentListViewController.h"
#import "PEDataProviderDelegate.h"
#import "PEUIUtils.h"

@interface PEFluentListViewController () <PEDataProviderDelegate>
@end

@implementation PEFluentListViewController {
  NSString *_title;
  UITableView *_tableView;
  PEFluentTableCellMakerBlk _tableCellMaker;
  PEFluentTableCellStylerBlk _tableCellStyler;
  PENullFluentTableCellMakerBlk _nullTableCellMaker;
  PENullFluentTableCellStylerBlk _nullTableCellStyler;
  void (^_addItemAction)(void);
  NSString *_cellIdentifier;
}

- (id)initWithTitle:(NSString *)title
       dataProvider:(PEDataProvider *)dataProvider
     tableCellMaker:(PEFluentTableCellMakerBlk)tableCellMaker
    tableCellStyler:(PEFluentTableCellStylerBlk)tableCellStyler
 nullTableCellMaker:(PENullFluentTableCellMakerBlk)nullTableCellMaker
nullTableCellStyler:(PENullFluentTableCellStylerBlk)nullTableCellStyler
      addItemAction:(void(^)(void))addItemActionBlk
     cellIdentifier:(NSString *)cellIdentifier {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _title = title;
    _dataProvider = dataProvider;
    _tableCellMaker = tableCellMaker;
    _tableCellStyler = tableCellStyler;
    _nullTableCellMaker = nullTableCellMaker;
    _nullTableCellStyler = nullTableCellStyler;
    _addItemAction = addItemActionBlk;
    _cellIdentifier = cellIdentifier;
    [_dataProvider setDelegate:self];
  }
  return self;
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  /* Set the Title */
  UINavigationItem *navItem = [self navigationItem];
  [self setTitle:_title];
  [navItem setTitle:_title];

  /* Add 'add' action */
  if (_addItemAction) {
    [navItem setRightBarButtonItem:
      [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                             target:self
                             action:@selector(addItem)]];
  }
  
  /* Add the table view */
  _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)
                                            style:UITableViewStylePlain];
  [PEUIUtils setFrameWidthOfView:_tableView ofWidth:1.0 relativeTo:[self view]];
  [PEUIUtils setFrameHeightOfView:_tableView ofHeight:.80 relativeTo:[self view]];
  [_tableView setDataSource:self];
  [_tableView setDelegate:self];
  [PEUIUtils placeView:_tableView
            inMiddleOf:[self view]
         withAlignment:PEUIHorizontalAlignmentTypeLeft
              hpadding:0.0];
}

#pragma mark - Adding an item

- (void)addItem {
  _addItemAction();
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  NSLog(@"numberOfRowsInSection: [%lu]", (unsigned long)[[_dataProvider dataObjects] count]);
  return [[_dataProvider dataObjects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  id dataObject = _dataProvider.dataObjects[indexPath.row];
  BOOL dataObjectIsNull = [dataObject isKindOfClass:[NSNull class]];
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
  if (!cell) {
    if (dataObjectIsNull) {
      cell = _nullTableCellMaker();
    } else {
      cell = _tableCellMaker(dataObject);
    }
  } else {
    if (dataObjectIsNull) {
      _nullTableCellStyler(cell);
    } else {
      _tableCellStyler(cell, dataObject);
    }
  }
  return cell;
}

#pragma mark - Data controller delegate

- (void)dataProvider:(PEDataProvider *)dataProvider
didLoadDataAtIndexes:(NSIndexSet *)indexes {
  NSLog(@"dataProvider:didLoadDataAtIndexes: invoked");
  NSLog(@"indexes: [%@]", indexes);
  NSMutableArray *indexPathsToReload = [NSMutableArray array];
  [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
    if ([[_tableView indexPathsForVisibleRows] containsObject:indexPath]) {
      [indexPathsToReload addObject:indexPath];
    }
  }];
  if (indexPathsToReload.count > 0) {
    [_tableView reloadRowsAtIndexPaths:indexPathsToReload
                      withRowAnimation:UITableViewRowAnimationFade];
  }
}

@end
