#import <UIKit/UIKit.h>
#import "JCPullToRefreshView.h"
#import "JCLoadMoreView.h"

@interface UIViewController (JCAdditionsPage)

@property (nonatomic, strong) JCPullToRefreshView *pullToRefreshView;
@property (nonatomic, strong) JCLoadMoreView *loadMoreView;

@property (nonatomic, assign) NSInteger currentPage;// default 1

@property (nonatomic, assign) BOOL hasNextPage;// default YES

- (void)enabledPullToRefresh:(UIScrollView *)scrollView;
- (void)enabledLoadMore:(UIScrollView *)scrollView;
- (void)enabledPullToRefreshAndLoadMore:(UIScrollView *)scrollView;

//subclass must be overwrite this method, used to request data.
- (void)loadDatas;
- (void)refreshDatas;

- (void)endRefresh;
@end
