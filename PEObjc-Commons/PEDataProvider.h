//
// PEDataProvider.h
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
#import "PEDataProviderDelegate.h"
#import "PEDataLoadingOperation.h"

@interface PEDataProvider : NSObject

///------------------------------------------------
/// @name Initialization
///------------------------------------------------
#pragma mark - Initialization

- (instancetype)initWithPageSize:(NSUInteger)pageSize
         shouldLoadAutomatically:(BOOL)shouldLoadAutomatically
          automaticPreloadMargin:(NSUInteger)automaticPreloadMargin
           dataProviderItemCount:(NSUInteger)dataProviderItemCount
            dataProviderPageSize:(NSUInteger)dataProviderPageSize
          dataObjectsPageFetcher:(PEDataObjectsPageFetcherBlk)dataObjectsPageFetcher;

@property (nonatomic, weak) id<PEDataProviderDelegate> delegate;

/**
 * The array returned will be a proxy object containing NSNull values for data
 * objects not yet loaded. As data loads, the proxy updates automatically to
 * include the newly loaded objects.
 * @see shouldLoadAutomatically
 */
@property (nonatomic, readonly) NSArray *dataObjects;

@property (nonatomic, readonly) NSUInteger pageSize;

@property (nonatomic, readonly) NSUInteger loadedCount;

/**
 * When this property is set, new data is automatically loaded when the
 * dataObjects array returns an NSNull reference.
 * @see dataObjects
 */
@property (nonatomic, readonly) BOOL shouldLoadAutomatically;

@property (nonatomic, readonly) NSUInteger automaticPreloadMargin;

- (BOOL)isLoadingDataAtIndex:(NSUInteger)index;
- (void)loadDataForIndex:(NSUInteger)index;

@end
