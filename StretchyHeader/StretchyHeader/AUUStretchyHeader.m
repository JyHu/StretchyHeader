//
//  AUUStretchyHeader.m
//  StretchyHeader
//
//  Created by 胡金友 on 16/1/11.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "AUUStretchyHeader.h"

@interface UIView (_AUUView)

@property (assign, nonatomic) CGFloat p_viewXOrigin;
@property (assign, nonatomic) CGFloat p_viewYOrigin;
@property (assign, nonatomic) CGFloat p_viewWidth;
@property (assign, nonatomic) CGFloat p_viewHeight;

@end

@implementation UIView (_AUUView)

- (CGFloat)p_viewXOrigin { return self.frame.origin.x; }

- (void)setP_viewXOrigin:(CGFloat)p_viewXOrigin
{
    CGRect rect = self.frame;
    rect.origin.x = p_viewXOrigin;
    self.frame = rect;
}

- (CGFloat)p_viewYOrigin { return self.frame.origin.y; }

- (void)setP_viewYOrigin:(CGFloat)p_viewYOrigin
{
    CGRect rect = self.frame;
    rect.origin.y = p_viewYOrigin;
    self.frame = rect;
}

- (CGFloat)p_viewHeight { return self.frame.size.height; }

- (void)setP_viewHeight:(CGFloat)p_viewHeight
{
    CGRect rect = self.frame;
    rect.size.height = p_viewHeight;
    self.frame = rect;
}

- (CGFloat)p_viewWidth { return self.frame.size.width; }

- (void)setP_viewWidth:(CGFloat)p_viewWidth
{
    CGRect rect = self.frame;
    rect.size.width = p_viewWidth;
    self.frame = rect;
}

@end

@interface UIImage (_AUUImage)

@property (assign, nonatomic, readonly) CGFloat p_width;

@property (assign, nonatomic, readonly) CGFloat p_height;

- (CGFloat)scaledWithTargetHeight:(CGFloat)height;

- (CGFloat)scaledWithTargetWidth:(CGFloat)width;

@end

@implementation UIImage (_AUUImage)

- (CGFloat)p_width { return self.size.width; }

- (CGFloat)p_height { return self.size.height; }

- (CGFloat)scaledWithTargetHeight:(CGFloat)height { return self.p_width / self.p_height * height; }

- (CGFloat)scaledWithTargetWidth:(CGFloat)width { return self.p_height / self.p_width * width; }

@end








////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                                                                            //
//      ****************************************************************      //
//                                                                            //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////







@interface AUUStretchyHeader()


/**
 *  @author 胡金友, 16-01-11 11:09:14
 *
 *  @brief  关联的table，弱引用
 *
 *  @since 1.0
 */
@property (weak, nonatomic) UITableView *p_tableView;

/**
 *  @author 胡金友, 16-01-11 11:09:51
 *
 *  @brief  伸缩图片的背景容器
 *
 *  @since 1.0
 */
@property (retain, nonatomic) UIImageView *p_imageView;

/**
 *  @author 胡金友, 16-01-11 11:09:31
 *
 *  @brief  设置的不伸缩的时候，默认的可是高度占整个高度的比例
 *
 *  @since 1.0
 */
@property (assign, nonatomic) CGFloat p_visiblePercent;

/**
 *  @author 胡金友, 16-01-11 11:09:13
 *
 *  @brief  不伸缩的时候，默认的可视高度，计算出来的
 *
 *  @since 1.0
 */
@property (assign, nonatomic) CGFloat p_visibleHeight;

/**
 *  @author 胡金友, 16-01-11 11:09:35
 *
 *  @brief  背景容器高度，也是跟图片高度相同
 *
 *  @since 1.0
 */
@property (assign, nonatomic) CGFloat p_stretchyBackgroundHeight;

/**
 *  @author 胡金友, 16-01-11 11:09:58
 *
 *  @brief  用来伸缩展示的image
 *
 *  @since 1.0
 */
@property (retain, nonatomic) UIImage *p_stretchyImage;

/**
 *  @author JyHu, 16-01-11 12:01:24
 *
 *  可视的头部高度变化的时候回传信息的block
 *
 *  @since v1.0
 */
@property (copy, nonatomic) void (^heightChangedBlock)(CGFloat height);

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
    self = [self init];
    
    if (self)
    {
        self.p_visiblePercent = percent;
        self.p_tableView = tableView;
        
        [self initlization];
    }
    return self;
}

#pragma mark - layout methods

- (void)initlization
{
    self.p_stretchyBackgroundHeight = 300;  // 初始高度，在设置图片的时候需要重新计算
    self.headZoomIn = YES;                  // 默认的头部是可伸缩的
    
    self.frame = CGRectMake(0, -1 * self.p_stretchyBackgroundHeight,
                            self.p_tableView.p_viewWidth,
                            self.p_stretchyBackgroundHeight);
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor redColor];
    [self.p_tableView addSubview:self];
}

- (id)stretchyImage:(UIImage *)image
{
    if (image)
    {
        self.p_stretchyImage = image;
        
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.p_stretchyBackgroundHeight = [self.p_stretchyImage scaledWithTargetWidth:self.p_viewWidth];
    self.p_visibleHeight            = self.p_stretchyBackgroundHeight * self.p_visiblePercent;
    
    self.p_tableView.contentInset   = UIEdgeInsetsMake(self.p_visibleHeight - 64, 0, 0, 0);
    self.p_viewYOrigin              = -1 * self.p_stretchyBackgroundHeight;
    self.p_viewHeight               = self.p_stretchyBackgroundHeight;
    
    CGFloat extraHalfY = (self.p_stretchyBackgroundHeight - self.p_visibleHeight) / 2.0;
    
    self.p_imageView                = [[UIImageView alloc] init];
    self.p_imageView.image          = self.p_stretchyImage;
    self.p_imageView.contentMode    = UIViewContentModeScaleAspectFit;
    self.p_imageView.frame          = self.bounds;
    self.p_imageView.p_viewYOrigin  = extraHalfY;
    [self addSubview:self.p_imageView];
    
    self.p_tableView.scrollIndicatorInsets = UIEdgeInsetsMake(-64, 0, 0, 0);
    
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
         *  @author 胡金友, 16-01-11 10:09:27
         *
         *  @brief  在默认最大可见范围的时候往下拉，至背景高度区间
         *
         *  @since 1.0
         */
        self.p_imageView.p_viewYOrigin = (self.p_stretchyBackgroundHeight + offset.y) / 2.0;
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
            CGFloat scale = fabs(offset.y) / self.p_viewHeight;
            
            // 放大图片
            self.p_imageView.transform = CGAffineTransformScale(self.p_imageView.transform, scale, scale);
            
            // 每次放大的时候是以图片的中心放大，需要重设y坐标
            self.p_imageView.p_viewYOrigin = self.p_viewHeight - self.p_imageView.p_viewHeight;
        }
        else
        {
            /**
             *  @author 胡金友, 16-01-11 10:09:26
             *
             *  @brief  当偏移量超过背景高度的时候，把偏移量定在一个固定值
             *
             *  @since 1.0
             */
            self.p_tableView.contentOffset = CGPointMake(0, -1 * self.p_stretchyBackgroundHeight);
            self.p_imageView.p_viewYOrigin = 0;
        }
    }
    else if (offset.y < -64)
    {
        /**
         *  @author 胡金友, 16-01-11 10:09:44
         *
         *  @brief  矫正细微的偏移量
         *
         *  @since 1.0
         */
        self.p_viewYOrigin = -1 * self.p_stretchyBackgroundHeight;
        
        /**
         *  @author 胡金友, 16-01-11 10:09:27
         *
         *  @brief  在默认的最大可见范围往上提，不断缩小的时候
         *
         *  @since 1.0
         */
        self.p_imageView.p_viewYOrigin = (self.p_stretchyBackgroundHeight + offset.y) / 2.0;
    }
    else
    {
        /**
         *  @author 胡金友, 16-01-11 10:09:09
         *
         *  @brief  当往上提缩小到NavigationBar高度的临界值的时候，固定背景的frame
         *
         *  @since 1.0
         */
        self.p_viewYOrigin = -1 * self.p_stretchyBackgroundHeight + offset.y + 64;
    }
    
    
    if (self.heightChangedBlock)
    {
        /**
         *  @author JyHu, 16-01-11 14:01:31
         *
         *  每当header变化的时候都回传数据给使用者，便于做其他的效果
         *
         *  @since v1.0
         */
        self.heightChangedBlock(offset.y >= -64 ? 64 : fabs(offset.y));
    }
}

@end
