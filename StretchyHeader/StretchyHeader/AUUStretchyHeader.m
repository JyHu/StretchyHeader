//
//  AUUStretchyHeader.m
//  StretchyHeader
//
//  Created by JyHu on 16/1/11.
//  Copyright © 2016年 JyHu. All rights reserved.
//

#import "AUUStretchyHeader.h"

#if defined(__has_include) && __has_include("UIImageView+WebCache.h")
#   define _HasSD
#endif

#ifdef _HasSD
#   import "UIImageView+WebCache.h"
#else
#   if defined(__has_include) && __has_include(<UIImageView+WebCache.h>)
#       define _HasSD
#   endif
#   ifdef _HasSD
#   import <UIImageView+WebCache.h>
#   endif
#endif



@interface UIView (_AUUView)

@property (assign, nonatomic) CGFloat _viewXOrigin;
@property (assign, nonatomic) CGFloat _viewYOrigin;
@property (assign, nonatomic) CGFloat _viewWidth;
@property (assign, nonatomic) CGFloat _viewHeight;

@end

@implementation UIView (_AUUView)

- (CGFloat)_viewXOrigin { return self.frame.origin.x; }

- (void)set_viewXOrigin:(CGFloat)_viewXOrigin
{
    CGRect rect = self.frame;
    rect.origin.x = _viewXOrigin;
    self.frame = rect;
}

- (CGFloat)_viewYOrigin { return self.frame.origin.y; }

- (void)set_viewYOrigin:(CGFloat)_viewYOrigin
{
    CGRect rect = self.frame;
    rect.origin.y = _viewYOrigin;
    self.frame = rect;
}

- (CGFloat)_viewHeight { return self.frame.size.height; }

- (void)set_viewHeight:(CGFloat)_viewHeight
{
    CGRect rect = self.frame;
    rect.size.height = _viewHeight;
    self.frame = rect;
}

- (CGFloat)_viewWidth { return self.frame.size.width; }

- (void)set_viewWidth:(CGFloat)_viewWidth
{
    CGRect rect = self.frame;
    rect.size.width = _viewWidth;
    self.frame = rect;
}

@end



/**
 *  @author JyHu, 16-01-14 09:01:32
 *
 *  根据目标宽度，比例计算高度
 *
 *  @param size  要计算的size大小
 *  @param width 目标宽度
 *
 *  @return 希望的高度
 *
 *  @since v1.0
 */
extern CGFloat scaledSizeWithTargetWidth(CGSize size, CGFloat width);

CGFloat scaledSizeWithTargetWidth(CGSize size, CGFloat width)
{
    return size.height / size.width * width;
}





////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                                                                            //
//      ****************************************************************      //
//                                                                            //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////







@interface AUUStretchyHeader()


/**
 *  @author JyHu, 16-01-11 11:09:14
 *
 *  @brief  关联的table，弱引用
 *
 *  @since 1.0
 */
@property (weak, nonatomic) UITableView *p_tableView;

/**
 *  @author JyHu, 16-01-11 11:09:51
 *
 *  @brief  伸缩图片的背景容器
 *
 *  @since 1.0
 */
@property (retain, nonatomic) UIImageView *p_imageView;

/**
 *  @author JyHu, 16-01-11 11:09:31
 *
 *  @brief  设置的不伸缩的时候，默认的可是高度占整个高度的比例
 *
 *  @since 1.0
 */
@property (assign, nonatomic) CGFloat p_visiblePercent;

/**
 *  @author JyHu, 16-01-11 11:09:13
 *
 *  @brief  不伸缩的时候，默认的可视高度，计算出来的
 *
 *  @since 1.0
 */
@property (assign, nonatomic) CGFloat p_visibleHeight;

/**
 *  @author JyHu, 16-01-11 11:09:35
 *
 *  @brief  背景容器高度，也是跟图片高度相同
 *
 *  @since 1.0
 */
@property (assign, nonatomic) CGFloat p_stretchyBackgroundHeight;

/**
 *  @author JyHu, 16-01-11 12:01:24
 *
 *  可视的头部高度变化的时候回传信息的block
 *
 *  @since v1.0
 */
@property (copy, nonatomic) void (^heightChangedBlock)(CGFloat height);

/**
 *  @author JyHu, 16-01-13 03:01:17
 *
 *  如果加载网络图片，需要展示一个等待提示器
 *
 *  @since v1.0
 */
@property (retain, nonatomic) UIActivityIndicatorView *indicatorView;

@end



@implementation AUUStretchyHeader

#pragma mark - initlization methods

+ (id)stretchForTable:(UITableView *)table
{
    return [[AUUStretchyHeader alloc] initWithTableView:table];
}

+ (id)stretchForTable:(UITableView *)table visiablePercent:(CGFloat)percent
{
    return [[AUUStretchyHeader alloc] initWithTableView:table withVisiablePercent:percent];
}

- (id)initWithTableView:(UITableView *)tableView
{
    return [self initWithTableView:tableView withVisiablePercent:2.0 / 3.0];
}

- (id)initWithTableView:(UITableView *)tableView withVisiablePercent:(CGFloat)percent
{
    self = [super init];
    
    if (self)
    {
        self.p_visiblePercent = percent;
        self.p_tableView = tableView;
        
        [self initlization];
    }
    
    return self;
}


/**
 *  @author JyHu, 16-01-13 16:01:17
 *
 *  一些必要参数的设置
 *
 *  @since v1.0
 */
- (void)initlization
{
    self.p_stretchyBackgroundHeight = 300;  // 初始高度，在设置图片的时候需要重新计算
    self.headZoomIn = YES;                  // 默认的头部是可伸缩的
    
    self.frame = CGRectMake(0, -1 * self.p_stretchyBackgroundHeight,
                            self.p_tableView._viewWidth,
                            self.p_stretchyBackgroundHeight);
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    [self.p_tableView addSubview:self];
    
    self.p_imageView = [[UIImageView alloc] init];
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.containerView.backgroundColor = [UIColor clearColor];
}


#pragma mark - layout methods

- (id)stretchyImage:(UIImage *)image
{
    if (image)
    {
        [self setupWithImage:image];
    }
    
    return self;
}

- (id)stretchyImageWithURLString:(NSString *)imageURLString imageSize:(CGSize)size
{
    return [self stretchyImageWithURLString:imageURLString placeHolderImage:nil imageSize:size];
}

- (id)stretchyImageWithURLString:(NSString *)imageURLString placeHolderImage:(UIImage *)image imageSize:(CGSize)size
{
    [self setupWithImageSize:size];
    
    /**
     初始化一个视图等待指示器，加载到self的subView上，不加载到containerView上，是因为，避免指示器被用户加载的视图挡住
     */
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.indicatorView startAnimating];
    [self addSubview:self.indicatorView];
    
#ifdef _HasSD
    
    /**
     *  @author JyHu, 16-01-13 20:01:40
     *
     *  使用SDWebImage来做图片的下载和缓存
     *
     *  @since v.0
     */
    
    if ([self.p_imageView respondsToSelector:@selector(sd_setImageWithURL:placeholderImage:completed:)])
    {
        // SD新版的加载图片的方法
        [self.p_imageView sd_setImageWithURL:[NSURL URLWithString:imageURLString]
                            placeholderImage:image
                                   completed:^(UIImage *image,
                                               NSError *error,
                                               SDImageCacheType cacheType,
                                               NSURL *imageURL) {
                                       
            self.indicatorView.hidden = YES;
        }];
    }
    else if ([self.p_imageView respondsToSelector:@selector(setImageWithURL:placeholderImage:completed:)])
    {
#   pragma clang diagnostic push
        
#   pragma clang diagnostic ignored "-Wdeprecated-declarations"
        // SD旧版的加载图片的方法，需要取消掉警告提示
        __weak AUUStretchyHeader *weakSelf = self;
        [self.p_imageView setImageWithURL:[NSURL URLWithString:imageURLString]
                         placeholderImage:image
                                completed:^(UIImage *image,
                                            NSError *error,
                                            SDImageCacheType cacheType) {
                                    
            weakSelf.indicatorView.hidden = YES;
        }];
#   pragma clang diagnostic pop
    }
    else
    {
#endif
        __weak AUUStretchyHeader *weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURLString]];
            UIImage *downloadImage = [UIImage imageWithData:imageData];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.p_imageView.image = downloadImage;
                weakSelf.indicatorView.hidden = YES;
            });
        });
#ifdef _HasSD
    }
#endif
    
    return self;
}

/**
 *  @author JyHu, 16-01-13 16:01:52
 *
 *  设置图片
 *
 *  @param image 要设置的图片
 *
 *  @since v1.0
 */
- (void)setupWithImage:(UIImage *)image
{
    self.p_imageView.image = image;
    [self setupWithImageSize:image.size];
}

/**
 *  @author JyHu, 16-01-13 16:01:10
 *
 *  根据图片的大小来布局页面
 *
 *  @param size 图片的设计大小
 *
 *  @since v1.0
 */
- (void)setupWithImageSize:(CGSize)size
{
    self.p_stretchyBackgroundHeight = scaledSizeWithTargetWidth(size, self._viewWidth);
    self.p_visibleHeight = self.p_stretchyBackgroundHeight * self.p_visiblePercent;
    
    self.p_tableView.contentInset   = UIEdgeInsetsMake(self.p_visibleHeight - 64, 0, 0, 0);
    self._viewYOrigin              = -1 * self.p_stretchyBackgroundHeight;
    self._viewHeight               = self.p_stretchyBackgroundHeight;
    
    CGFloat extraHalfY = (self.p_stretchyBackgroundHeight - self.p_visibleHeight) / 2.0;
    
    self.p_imageView.backgroundColor = [UIColor colorWithRed:(54/255.0) green:(100/255.0) blue:(139/255.0) alpha:1];
    self.p_imageView.contentMode    = UIViewContentModeScaleAspectFit;
    self.p_imageView.frame          = self.bounds;
    self.p_imageView._viewYOrigin  = extraHalfY;
    [self addSubview:self.p_imageView];
    
    self.p_tableView.scrollIndicatorInsets = UIEdgeInsetsMake(-64, 0, 0, 0);
    
    [self addSubview:self.containerView];
    
    [self trigger];
    
    [self.p_tableView addObserver:self
                       forKeyPath:@"contentOffset"
                          options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                          context:nil];
}

- (void)setOpaqueNavigationBar:(BOOL)opaqueNavigationBar
{
    _opaqueNavigationBar = opaqueNavigationBar;
    
    // 设置table指示条的最顶部在可视视图的最顶部
    self.p_tableView.scrollIndicatorInsets = UIEdgeInsetsMake(opaqueNavigationBar ? 0 : -64, 0, 0, 0);
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        [self trigger];
    }
}

#pragma mark - notify methods

- (void)stretchyHeaderHeightChanged:(void (^)(CGFloat))heightChanged

{
    self.heightChangedBlock = heightChanged;
}

#pragma mark - trigger methods

/**
 *  @author JyHu, 16-01-11 22:01:08
 *
 *  Trigger for header view scale layout
 *
 *  @since v1.0
 */
- (void)trigger
{
    if (self.headZoomIn)
    {
        // 如果支持顶部放大的话，在每次放大之前都必须清空之前的transform，否则会出现累计放大的情况
        self.p_imageView.transform = CGAffineTransformIdentity;
        self.clipsToBounds = YES;
    }
    
    CGPoint offset = self.p_tableView.contentOffset;
    
    if (offset.y < -1 *self.p_stretchyBackgroundHeight * self.p_visiblePercent &&
        offset.y > -1 * _p_stretchyBackgroundHeight)
    {
        /**
         *  @author JyHu, 16-01-11 10:09:27
         *
         *  @brief  在默认最大可见范围的时候往下拉，至背景高度区间
         *
         *  @since 1.0
         */
        self.p_imageView._viewYOrigin = (self.p_stretchyBackgroundHeight + offset.y) / 2.0;
    }
    else if (offset.y < -1 * self.p_stretchyBackgroundHeight)
    {
        if (self.headZoomIn)
        {
            /**
             *  @author JyHu, 16-01-11 14:01:15
             *
             *  如果支持顶部放大的时候，需要放大顶部的图片
             *
             *  @since v1.0
             */
            self.clipsToBounds = NO;
            
            // 扩大的比例
            CGFloat scale = fabs(offset.y) / self._viewHeight;
            
            // 放大图片
            self.p_imageView.transform = CGAffineTransformScale(self.p_imageView.transform, scale, scale);
            
            // 每次放大的时候是以图片的中心放大，需要重设y坐标
            self.p_imageView._viewYOrigin = self._viewHeight - self.p_imageView._viewHeight;
        }
        else
        {
            /**
             *  @author JyHu, 16-01-11 10:09:26
             *
             *  @brief  当偏移量超过背景高度的时候，把偏移量定在一个固定值
             *
             *  @since 1.0
             */
            self.p_tableView.contentOffset = CGPointMake(0, -1 * self.p_stretchyBackgroundHeight);
            self.p_imageView._viewYOrigin = 0;
        }
    }
    else if (offset.y < -64)
    {
        /**
         *  @author JyHu, 16-01-11 10:09:44
         *
         *  @brief  矫正细微的偏移量
         *
         *  @since 1.0
         */
        self._viewYOrigin = -1 * self.p_stretchyBackgroundHeight;
        
        /**
         *  @author JyHu, 16-01-11 10:09:27
         *
         *  @brief  在默认的最大可见范围往上提，不断缩小的时候
         *
         *  @since 1.0
         */
        self.p_imageView._viewYOrigin = (self.p_stretchyBackgroundHeight + offset.y) / 2.0;
    }
    else
    {
        /**
         *  @author JyHu, 16-01-11 10:09:09
         *
         *  @brief  当往上提缩小到NavigationBar高度的临界值的时候，固定背景的frame
         *
         *  @since 1.0
         */
        self._viewYOrigin = -1 * self.p_stretchyBackgroundHeight + offset.y + 64;
    }
    
    /**
     *  @author JyHu, 16-01-13 20:01:54
     *
     *  当前头部视图的可视高度
     *
     *  @since v1.0
     */
    CGFloat headerHeight = (offset.y >= -64 ? 64 : fabs(offset.y));
    
    if (self.heightChangedBlock)
    {
        /**
         *  @author JyHu, 16-01-11 14:01:31
         *
         *  每当header变化的时候都回传数据给使用者，便于做其他的效果
         *
         *  @since v1.0
         */
        self.heightChangedBlock(headerHeight);
    }
    
    self.containerView.frame = CGRectMake(0, self.p_stretchyBackgroundHeight - headerHeight, self.p_tableView._viewWidth, headerHeight);
    
    /**
     *  @author JyHu, 16-01-13 17:01:16
     *
     *  如果有等待视图的话，需要动态的设置它在除去statusBar后居中
     *
     *  @since v1.0
     */
    if (self.indicatorView != nil && self.indicatorView.superview == self)
    {
        self.indicatorView.center = CGPointMake(self._viewWidth / 2.0,
                                                self.p_stretchyBackgroundHeight - headerHeight / 2.0 + 10);
    }
}

@end
