//
//  AUUStretchyHeader.h
//  StretchyHeader
//
//  Created by JyHu on 16/1/11.
//  Copyright © 2016年 JyHu. All rights reserved.
//



#import <UIKit/UIKit.h>





/**
 *  @author JyHu, 16-01-11 10:01:24
 *
 *  可以伸缩的头部视图，秩序设置一张图片，即可自动的完成伸缩的过程。
 *
 *  头部的高度是根据图片计算得出，图片要铺展到table得宽度，然后按比例计算高度，即为顶部的高度。
 *
 *  如果用户需要添加自己的一些视图控件，需要加载到containerView上，如果加在self上，将不好控制位置。
 *
 *  @since v1.0
 */



@interface AUUStretchyHeader : UIView

/**
 *  @author JyHu, 16-01-11 10:01:37
 *
 *  初始化方法
 *
 *  @param table 要加载到得table
 *
 *  @return self
 *
 *  @since v1.0
 */
+ (id)stretchForTable:(UITableView *)table;

/**
 *  @author JyHu, 16-01-11 10:01:00
 *
 *  初始化方法
 *
 *  @param table   要加载到的table
 *  @param percent 在不弹动的时候可见的比例，0 ~ 1.0，默认2/3
 *
 *  @return self
 *
 *  @since v1.0
 */
+ (id)stretchForTable:(UITableView *)table visiablePercent:(CGFloat)percent;

/**
 *  @author JyHu, 16-01-11 10:01:46
 *
 *  添加到table上要展示的图片
 *
 *  @param image 图片
 *
 *  @return self
 *
 *  @since v1.0
 */
- (id)stretchyImage:(UIImage *)image;

/**
 *  @author JyHu, 16-01-13 03:01:18
 *
 *  可以加载网络图片,如果使用SDWebImage，可以做到的效果更好
 *
 *  @param imageURLString 网络图片地址
 *  @param size           图片的大小，需要事先设置好，不然在网络不好的时候滑动会出现跳动的情况
 *
 *  @return self
 *
 *  @since v1.0
 */
- (id)stretchyImageWithURLString:(NSString *)imageURLString imageSize:(CGSize)size;

/**
 *  @author JyHu, 16-01-13 03:01:44
 *
 *  可以加载网络图片,如果使用SDWebImage，可以做到的效果更好
 *
 *  @param imageURLString 图片网络地址
 *  @param image          暂时显示的图片
 *  @param size           图片的大小，需要预先设置好，不然在网络不好的时候滑动会出现跳动的情况
 *
 *  @return self
 *
 *  @since v1.0
 */
- (id)stretchyImageWithURLString:(NSString *)imageURLString placeHolderImage:(UIImage *)image imageSize:(CGSize)size;

/**
 *  @author JyHu, 16-01-11 10:01:14
 *
 *  是否支持图片放大
 *
 *  @since v1.0
 */
@property (assign, nonatomic) BOOL headZoomIn;

/**
 *  @author JyHu, 16-01-11 10:01:28
 *
 *  导航栏是否透明，主要是为了设置table的verticalIndicator的位置
 *
 *  @since v1.0
 */
@property (assign, nonatomic) BOOL opaqueNavigationBar;

/**
 *  @author JyHu, 16-01-11 10:01:58
 *
 *  顶部高度每次变化的时候回传信息的block，可以用来更新containerView上得视图
 *
 *  @param heightChanged 回传的block
 *
 *  @since v1.0
 */
- (void)stretchyHeaderHeightChanged:(void (^)(CGFloat height))heightChanged;

/**
 *  @author JyHu, 16-01-13 20:01:10
 *
 *  预留出来的附加视图，使用者可以将自定义的一些视图加在这个view上
 *
 *  @since v1.0
 */
@property (retain, nonatomic) UIView *containerView;

@end
