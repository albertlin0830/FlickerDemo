#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^LoadMoreCallback)(void);

@interface JCLoadMoreView : UIView

@property (nonatomic, readonly, assign) BOOL isRefreshing;

@property (nonatomic, strong) UIButton *bottomButton;

- (instancetype)initWithScrollView:(UIScrollView *)scrollView;

- (void)setLoadMoreCallback:(LoadMoreCallback)callback;

- (void)startRefresh;
- (void)endRefresh;

@end
