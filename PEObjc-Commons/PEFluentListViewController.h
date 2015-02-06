//
// PEFluentListViewController.h
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

#import <UIKit/UIKit.h>
#import "PEDataProvider.h"

/**
 *  Returns a table cell appropriate for the given model object parameter.
 *  @param id A model object to be associated with the returned table cell.
 *  @return a table cell appropriate for the given model object parameter.
 */
typedef UITableViewCell *(^PEFluentTableCellMakerBlk)(id);

/**
 *  Returns an empty table cell.
 *  @return an empty table cell.
 */
typedef UITableViewCell *(^PENullFluentTableCellMakerBlk)(void);

/**
 *  Styles the given non-empty cell.
 *  @param UITableViewCell The table cell to style.
 *  @param id              The model object associated with the cell.
 */
typedef void (^PEFluentTableCellStylerBlk)(UITableViewCell *, id);

/**
 *  Styles the given empty table cell.
 *  @param UITableViewCell The table cell to style.
 */
typedef void (^PENullFluentTableCellStylerBlk)(UITableViewCell *);

/**
 * List view controller providing fluent scrolling.
 */
@interface PEFluentListViewController : UIViewController <UITableViewDataSource,
UITableViewDelegate>

///------------------------------------------------
/// @name Initialization
///------------------------------------------------
#pragma mark - Initialization

/**
 *  Returns a newly initialized fluent-scrolling list view controller.
 *  @param title               The title for the view controller.
 *  @param dataProvider        The data provider (aka data source) for the view
 controller's table.
 *  @param tableCellMaker      Table cell maker block.
 *  @param tableCellStyler     Table cell styler block.
 *  @param nullTableCellMaker  Empty table cell maker block.
 *  @param nullTableCellStyler Empty table cell styler block.
 *  @param addItemActionBlk    Invoked when an item is added to the table view.
 *  @param cellIdentifier      The cell identifer to use for table cells.
 *  @return a newly initialized fluent-scrolling list view controller.
 */
- (id)initWithTitle:(NSString *)title
       dataProvider:(PEDataProvider *)dataProvider
     tableCellMaker:(PEFluentTableCellMakerBlk)tableCellMaker
    tableCellStyler:(PEFluentTableCellStylerBlk)tableCellStyler
 nullTableCellMaker:(PENullFluentTableCellMakerBlk)nullTableCellMaker
nullTableCellStyler:(PENullFluentTableCellStylerBlk)nullTableCellStyler
      addItemAction:(void(^)(void))addItemActionBlk
     cellIdentifier:(NSString *)cellIdentifier;

/** Data provider (i.e., data source) for this fluent list view controller. */
@property (nonatomic, readonly) PEDataProvider *dataProvider;

@end

