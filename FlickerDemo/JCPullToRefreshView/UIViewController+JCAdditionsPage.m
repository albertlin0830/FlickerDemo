#import "UIViewController+JCAdditionsPage.h"
#import <objc/runtime.h>

static const void *pullToRefreshViewKey;
static const void *loadMoreViewKey;
static const void *currentPageKey;
static const void *hasNextPageKey;

@implementation UIViewController (JCAdditionsPage)

- (void)enabledPullToRefreshAndLoadMore:(UIScrollView *)scrollView
{
//    [self enabledPullToRefresh:scrollView];
    [self enabledLoadMore:scrollView];
}

- (void)enabledPullToRefresh:(UIScrollView *)scrollView
{
    if (!self.pullToRefreshView) {
        self.currentPage = 1;
        self.hasNextPage = YES;
        
        __weak __typeof(self) weakSelf = self;
        
        self.pullToRefreshView = [[JCPullToRefreshView alloc] initWithScrollView:scrollView];
        [self.pullToRefreshView setPullToRefreshCallback:^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf refreshDatas];
        }];
        
        [scrollView addSubview:self.pullToRefreshView];
    }
}

- (void)enabledLoadMore:(UIScrollView *)scrollView
{
    if (!self.loadMoreView) {
        self.currentPage = 1;
        self.hasNextPage = YES;
        
        __weak __typeof(self) weakSelf = self;
        
        self.loadMoreView = [[JCLoadMoreView alloc] initWithScrollView:scrollView];
        [self.loadMoreView setLoadMoreCallback:^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf loadDatas];
        }];
        
        [scrollView addSubview:self.loadMoreView];
    }
}

- (void)refreshDatas
{
    NSAssert(NO, @"subclass must be overwrite this method!");
}

- (void)loadDatas
{
    NSAssert(NO, @"subclass must be overwrite this method!");
}

- (void)endRefresh
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.pullToRefreshView.isRefreshing) {
            [self.pullToRefreshView endRefresh];
        }
        
        if (self.loadMoreView.isRefreshing) {
            [self.loadMoreView endRefresh];
        }
    });
}

#pragma mark -

- (JCPullToRefreshView *)pullToRefreshView
{
    return objc_getAssociatedObject(self, &pullToRefreshViewKey);
}

- (void)setPullToRefreshView:(JCPullToRefreshView *)pullToRefreshView
{
    objc_setAssociatedObject(self, &pullToRefreshViewKey, pullToRefreshView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (JCLoadMoreView *)loadMoreView
{
    return objc_getAssociatedObject(self, &loadMoreViewKey);
}

- (void)setLoadMoreView:(JCLoadMoreView *)loadMoreView
{
    objc_setAssociatedObject(self, &loadMoreViewKey, loadMoreView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)currentPage
{
    return [objc_getAssociatedObject(self, &currentPageKey) intValue];
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    objc_setAssociatedObject(self, &currentPageKey, [NSNumber numberWithInteger:currentPage], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hasNextPage
{
    return [objc_getAssociatedObject(self, &hasNextPageKey) boolValue];
}

- (void)setHasNextPage:(BOOL)hasNextPage
{
    objc_setAssociatedObject(self, &hasNextPageKey, [NSNumber numberWithBool:hasNextPage], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
