# StretchyHeader



###效果

可以拉伸的table的头部视图，头部的宽度跟table的宽度一致，有两种头部的展示效果，**默认的为第二种**

- 一种是静态的，头部拉伸到最大的高度后，就不会再拉伸，`headZoomIn=NO`，效果见图一
- 另一种是可伸缩的，主要体现在头部在拉伸到最大高度后，下拉的时候还会按拉动的距离放大展示的图片，`headZoomIn=YES`，效果见图二

###使用方法

- 使用的时候，初始化方法有两个：
	- `stretchForTable:`
	- `stretchForTable:visiablePercent:`
		- 第一个参数`table`是要进行图片拉伸的图片加载到的`table`，
		- 第二个参数`percent`是想要在不滑动的情况下需要展示的图片部分占整个图片实际高度比例。

- 图片展示是按图片的宽度以图片的中间为准，滑到最小的时候也是展示中间的64像素的位置，所以使用的时候可以注意设计一下图片。对于图片的设置，提供了三个方法：
	1. 直接展示图片
		`stretchyImage:`
	1. 展示网络图片
		- `stretchyImageWithURLString:imageSize:`
		- `stretchyImageWithURLString:placeHolderImage:imageSize:`
		
		`imageSize`表示图片的实际大小，这个必须按实际设置，否则最后加载出来后会出现有压缩或拉伸的情况；
        `placeHolderImage`表示在网络图片还没加载出来之前临时展示的图片，如果不设置的话，默认展示一种纯色的背景色（RGB:54,100,139）；
        支持`SDWebImage`第三方的使用，如果项目中添加了SD，则会自动的引入并使用SD进行图片的加载与缓存；否则使用GCD异步加载，但是暂不提供图片的缓存。
        
- 使用的时候，就一句代码，然后不用再做其他任何操作:
	- 使用已经下载好的本地图片：`self.stretchyHeader = [[AUUStretchyHeader stretchForTable:self.tableView] stretchyImage:[UIImage imageNamed:@"pic.jpg"]];`
	- 或者使用网络图片：`self.stretchyHeader = [[AUUStretchyHeader stretchForTable:self.tableView] stretchyImageWithURLString:@"http://pic37.nipic.com/20140209/8821914_163234218136_2.jpg" imageSize:CGSizeMake(1024, 640)]`

###注意

默认已经提供一个`containerView`视图用来添加展示自定义的控件内容，它的`frame`就是头部展示视图的可视高度。所以如果想要添加自定义的内容，最好是加载到`containerView`上，不要加载到`AUUStretchHeader`上，因为这个的`frame`不可控。


----

----


###附图

----

----

**RGB:54,100,139**

![color](http://ww3.sinaimg.cn/large/8acb15f3jw1ezyvsrz6tuj201o00g08b.jpg)

------

**图一**


![静态图](stretch-static.gif)

----

**图二**


![伸缩图](stretch-scale.gif)


-----

-----


###TODO

1. 自定义异步图片下载的图片缓存
2. 增加异步加载图片时的效果
3. 优化导航栏的切换控制
4. 其他暂未想到的部分