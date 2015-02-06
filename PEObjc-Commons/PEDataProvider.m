//
// PEDataProvider.m
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

#import "PEDataProvider.h"
#import <AWPagedArray/AWPagedArray.h>
#import "PEDataLoadingOperation.h"

@interface PEDataProvider () <AWPagedArrayDelegate>
@end

@implementation PEDataProvider {
  AWPagedArray *_pagedArray;
  NSOperationQueue *_operationQueue;
  NSMutableDictionary *_dataLoadingOperations;
  PEDataObjectsPageFetcherBlk _dataObjectsPageFetcher;
}

#pragma mark - Initialization

- (instancetype)initWithPageSize:(NSUInteger)pageSize
         shouldLoadAutomatically:(BOOL)shouldLoadAutomatically
          automaticPreloadMargin:(NSUInteger)automaticPreloadMargin
           dataProviderItemCount:(NSUInteger)dataProviderItemCount
            dataProviderPageSize:(NSUInteger)dataProviderPageSize
          dataObjectsPageFetcher:(PEDataObjectsPageFetcherBlk)dataObjectsPageFetcher {
  self = [super init];
  if (self) {
    _pagedArray =
      [[AWPagedArray alloc]
        initWithCount:dataProviderItemCount
       objectsPerPage:dataProviderPageSize];
    [_pagedArray setDelegate:self];
    _shouldLoadAutomatically = shouldLoadAutomatically;
    _automaticPreloadMargin = automaticPreloadMargin;
    _dataObjectsPageFetcher = dataObjectsPageFetcher;
    _dataLoadingOperations = [NSMutableDictionary dictionary];
    _operationQueue = [NSOperationQueue new];
  }
  return self;
}

#pragma mark - Accessors

- (NSUInteger)loadedCount {
  return _pagedArray.pages.count * _pagedArray.objectsPerPage;
}

- (NSUInteger)pageSize {
  return _pagedArray.objectsPerPage;
}

- (NSArray *)dataObjects {
  return (NSArray *)_pagedArray;
}

#pragma mark - Other public methods

- (BOOL)isLoadingDataAtIndex:(NSUInteger)index {
  return _dataLoadingOperations[@([_pagedArray pageForIndex:index])] != nil;
}

- (void)loadDataForIndex:(NSUInteger)index {
  [self setShouldLoadDataForPage:[_pagedArray pageForIndex:index]];
}

#pragma mark - Private methods

- (void)setShouldLoadDataForPage:(NSUInteger)page {
  if (!_pagedArray.pages[@(page)] && !_dataLoadingOperations[@(page)]) {
    // Don't load data if there already is a loading operation in progress
    [self loadDataForPage:page];
  }
}

- (void)loadDataForPage:(NSUInteger)page {
  NSIndexSet *indexes = [_pagedArray indexSetForPage:page];
  NSOperation *loadingOperation = [self loadingOperationForPage:page indexes:indexes];
  _dataLoadingOperations[@(page)] = loadingOperation;
  if ([self.delegate respondsToSelector:@selector(dataProvider:willLoadDataAtIndexes:)]) {
    [self.delegate dataProvider:self willLoadDataAtIndexes:indexes];
  }
  [_operationQueue addOperation:loadingOperation];
}

- (NSOperation *)loadingOperationForPage:(NSUInteger)page
                                 indexes:(NSIndexSet *)indexes {
  PEDataLoadingOperation *operation =
    [[PEDataLoadingOperation alloc] initWithIndexes:indexes
                             dataObjectsPageFetcher:_dataObjectsPageFetcher];
  // Remember to not retain self in block since we store the operation
  __weak typeof(self) weakSelf = self;
  __weak typeof(operation) weakOperation = operation;
  operation.completionBlock = ^{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
      [weakSelf dataOperation:weakOperation finishedLoadingForPage:page];
    }];
  };
  return operation;
}

- (void)preloadNextPageIfNeededForIndex:(NSUInteger)index {
  if (!_shouldLoadAutomatically) {
    return;
  }
  NSUInteger currentPage = [_pagedArray pageForIndex:index];
  NSUInteger preloadPage = [_pagedArray pageForIndex:index + _automaticPreloadMargin];
  if (preloadPage > currentPage && preloadPage <= _pagedArray.numberOfPages) {
    [self setShouldLoadDataForPage:preloadPage];
  }
}

- (void)dataOperation:(PEDataLoadingOperation *)operation finishedLoadingForPage:(NSUInteger)page {
  [_dataLoadingOperations removeObjectForKey:@(page)];
  [_pagedArray setObjects:operation.dataPage forPage:page];
  if ([self.delegate respondsToSelector:@selector(dataProvider:didLoadDataAtIndexes:)]) {
    [self.delegate dataProvider:self didLoadDataAtIndexes:operation.indexes];
  }
}

#pragma mark - Paged array delegate

- (void)pagedArray:(AWPagedArray *)pagedArray
   willAccessIndex:(NSUInteger)index
      returnObject:(__autoreleasing id *)returnObject {
  if ([*returnObject isKindOfClass:[NSNull class]] && self.shouldLoadAutomatically) {
    [self setShouldLoadDataForPage:[pagedArray pageForIndex:index]];
  } else {
    [self preloadNextPageIfNeededForIndex:index];
  }
}

@end
