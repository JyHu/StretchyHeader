//
//  ViewController.m
//  AspectHeader
//
//  Created by JyHu on 15/9/16.
//  Copyright (c) 2015年 JyHu. All rights reserved.
//

#import "ViewController.h"
//#import "AspectImageView.h"
#import "ColorImage.h"
#import "AddViewController.h"
#import "MoreViewController.h"
#import "ContentsViewController.h"
#import "AUUStretchyHeader.h"

@interface ViewController ()
<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (retain, nonatomic) AUUStretchyHeader *stretchyHeader;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self lucencyNavigationBar];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"More" style:UIBarButtonItemStyleDone target:self action:@selector(more)];
    
    
    /******************************* 伸缩头部视图简单的使用 *******************************/
    
//    self.stretchyHeader = [[AUUStretchyHeader stretchForTable:self.tableView] stretchyImage:[UIImage imageNamed:@"pic.jpg"]];
//    self.stretchyHeader = [[AUUStretchyHeader stretchForTable:self.tableView] stretchyImageWithURLString:@"http://beta2.hichao.com/v1/h264.png"];
    self.stretchyHeader = [[AUUStretchyHeader stretchForTable:self.tableView] stretchyImageWithURLString:@"http://pic4.nipic.com/20090805/1199250_002332425_2.jpg" imageSize:CGSizeMake(1024, 768)];
    [self.stretchyHeader stretchyHeaderHeightChanged:^(CGFloat height) {
        NSLog(@"%.2f", height);
    }];
    
    /**********************************************************************************/
}

/**
 *  @author JyHu, 16-01-10 21:01:33
 *
 *  使导航栏透明
 *
 *  @since v1.0
 */
- (void)lucencyNavigationBar
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsCompact];
    self.navigationController.navigationBar.barStyle = UIBaselineAdjustmentNone;
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    for (id view in self.navigationController.navigationBar.subviews)
    {
        if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")])
        {
            for (id i in [view subviews])
            {
                if ([i isKindOfClass:[UIImageView class]])
                {
                    [i removeFromSuperview];
                }
            }
        }
    }
    
    [[[[self.navigationController.navigationBar.subviews firstObject] subviews] firstObject] removeFromSuperview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reUsefulIdentifier = @"reUsefulIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reUsefulIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reUsefulIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"row at : %zd", indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:[[ContentsViewController alloc] init] animated:YES];
}

- (void)add
{
    [self.navigationController pushViewController:[[AddViewController alloc] init] animated:YES];
}

- (void)more
{
    [self.navigationController pushViewController:[[MoreViewController alloc] init] animated:YES];
}

@end
