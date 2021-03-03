#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^PullToRefreshCallback)(void);

@interface JCPullToRefreshView : UIView

@property (nonatomic, readonly, assign) BOOL isRefreshing;

//when pull-to-refresh display image
@property (nonatomic, strong) UIImageView *imageView;

- (instancetype)initWithScrollView:(UIScrollView *)scrollView;

- (void)setPullToRefreshCallback:(PullToRefreshCallback)callback;

- (void)startRefresh;
- (void)endRefresh;

@end
