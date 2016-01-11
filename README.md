# StretchyHeader


- 可以拉伸的table的头部视图，头部的宽度跟table的宽度一致，有两种头部的展示效果，**默认的为第二种**
	- 一种是静态的，头部拉伸到最大的高度后，就不会再拉伸，效果见图一
	- 另一种是可伸缩的，需要设置参数`headZoomIn`为YES，主要体现在头部在拉伸到最大高度后，下拉的时候还会按拉动的距离放大展示的图片，效果见图二
- 使用的时候，初始化方法有两个：
	- `flexibleForTable:`
	- `flexibleForTable:withVisiablePercent:`
		- 第一个参数`table`是要进行图片拉伸的图片加载到的`table`，
		- 第二个参数`percent`是想要在不拉伸的情况下需要展示的比例。
- 使用的时候，就一句代码，然后不用再做其他任何操作:
`self.stretchyHeader = [[AUUStretchyHeader stretchForTable:self.tableView] stretchyImage:[UIImage imageNamed:@"pic.jpg"]];`

----
		
**图一**


![静态图](stretch-static.gif)

----

**图二**


![伸缩图](stretch-scale.gif)