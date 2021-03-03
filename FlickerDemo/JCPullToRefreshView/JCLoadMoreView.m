#import "JCLoadMoreView.h"
#import "FBKVOController.h"
#import "UIViewController+JCAdditionsPage.h"
#import "UIButton+JCAdditions.h"

#define kDefaultHeight 50.0f
#define kDefaultDistance 10.0f

@interface JCLoadMoreView()

@property (nonatomic, assign) UIEdgeInsets contentInset;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIViewController *viewController;

@property (nonatomic, copy) LoadMoreCallback callback;

@end

@implementation JCLoadMoreView

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
{
    if (self = [super init]) {
        self.layer.masksToBounds = YES;
        
        _scrollView = scrollView;
        _contentInset = UIEdgeInsetsMake(-1, -1, -1, -1);
        
        _viewController = [self jc_getViewController];
        
        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomButton.frame = CGRectMake(15, 10, [UIScreen mainScreen].bounds.size.width-30, 40);
        [_bottomButton setTitle:@"" forState:UIControlStateNormal];
        [_bottomButton setTitle:@"正在載入" forState:UIControlStateSelected];
        [_bottomButton setTitle:@"無其他最新資料" forState:UIControlStateDisabled];
        [_bottomButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _bottomButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_bottomButton addTarget:self action:@selector(loadMore:) forControlEvents:UIControlEventTouchUpInside];
        _bottomButton.layer.cornerRadius = 5.0f;
        _bottomButton.layer.masksToBounds = YES;
        _bottomButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _bottomButton.layer.borderWidth = 0.5f;
        [self addSubview:_bottomButton];
        
        [self.KVOController observe:_scrollView keyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld action:@selector(observeContentOffset:)];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (UIEdgeInsetsEqualToEdgeInsets(self.contentInset, UIEdgeInsetsMake(-1, -1, -1, -1))) {
        self.contentInset = self.scrollView.contentInset;
    }
}

- (void)startRefresh
{
    if (self.isRefreshing) {
        return;
    }
    
    self.bottomButton.selected = YES;
    self.bottomButton.enabled = YES;
    
    [self.bottomButton.activityView startAnimating];
    
    _isRefreshing = YES;
    
    [UIView animateWithDuration:0.3f animations:^{
        [self displayingLoadMoreView];
    } completion:^(BOOL finished) {
        if (self.callback) {
            self.callback();
        }
    }];
}

- (void)endRefresh
{
    self.bottomButton.selected = NO;
    self.bottomButton.enabled = YES;
    
    [self.bottomButton.activityView stopAnimating];
    
    self.frame = CGRectZero;
   
    [UIView animateWithDuration:0.3f animations:^{
        
    } completion:^(BOOL finished) {
        self.scrollView.contentInset = self.contentInset;

        _isRefreshing = NO;
    }];
}

- (void)setLoadMoreCallback:(LoadMoreCallback)callback
{
    self.callback = callback;
}

#pragma mark - private method

- (void)observeContentOffset:(NSDictionary *)change
{
    if (!self.isRefreshing) {
        //The contentSize is big enough, and the rolling direction is downward
        if (self.scrollView.contentSize.height >= self.scrollView.bounds.size.height && [change[NSKeyValueChangeNewKey] CGPointValue].y > [change[NSKeyValueChangeOldKey] CGPointValue].y) {
            if ((self.scrollView.contentSize.height - self.scrollView.bounds.size.height + self.contentInset.bottom + kDefaultDistance) <= self.scrollView.contentOffset.y) {
                self.frame = CGRectMake(0.f, self.scrollView.contentSize.height, self.scrollView.frame.size.width, kDefaultHeight);
                
                if (self.viewController.hasNextPage) {
                    [self startRefresh];
                }
                else {
                    self.bottomButton.enabled = NO;
                    
                    [self displayingLoadMoreView];
                }
            }
        }
    }
}

- (void)loadMore:(UIButton *)btn
{
    if (!self.isRefreshing) {
        [self startRefresh];
    }
}

- (void)displayingLoadMoreView
{
    UIEdgeInsets inset = self.contentInset;
    inset.bottom += kDefaultHeight;
    self.scrollView.contentInset = inset;
    
    [self.scrollView setContentOffset:CGPointMake(0.f, (self.scrollView.contentSize.height-self.scrollView.bounds.size.height) + self.contentInset.bottom + kDefaultHeight) animated:NO];
}

- (UIViewController *)jc_getViewController
{
    UIResponder *responder = [self.scrollView nextResponder];
    
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    
    return nil;
}

@end
