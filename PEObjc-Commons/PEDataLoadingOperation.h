//
// PEDataLoadingOperation.h
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

#import <Foundation/Foundation.h>

/**
 *  Block for fetching and returning a set of data elements for the given set of
 table row indexes.
 *  @param NSIndexSet The set of table row indexes the return data (NSArray) is
 meant for.
 *  @return the set of data elements for the given set of table row indexes.
 */
typedef NSArray * (^PEDataObjectsPageFetcherBlk)(NSIndexSet *);

/**
 *  Operation used for asynchronously loading new rows into our fluent list view
 *  controller.
 */
@interface PEDataLoadingOperation : NSBlockOperation

///------------------------------------------------
/// @name Initialization
///------------------------------------------------
#pragma mark - Initialization

/**
 *  Returns a newly initialized data-loader operation.
 *  @param indexes                The set of table view indexes to become
 populated by the execution of this operation.
 *  @param dataObjectsPageFetcher Block responsible for fetching the set of data
 needed to populate a given set of row indexes.
 *  @return a newly initialized data-loader operation.
 */
- (instancetype)initWithIndexes:(NSIndexSet *)indexes
         dataObjectsPageFetcher:(PEDataObjectsPageFetcherBlk)dataObjectsPageFetcher;

/** The set of table row indexes to be populated by this operation. */
@property (nonatomic, readonly) NSIndexSet *indexes;

/** The set of data elements meant to populate the table row indexes. */
@property (nonatomic, readonly) NSArray *dataPage;

@end
