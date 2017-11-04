# Eason检测App说明文档

## 登录
- 通过efun后台账号和密码登录<br>
<br>![](/Users/efun/Desktop/检测App文档/screenshot/登录界面.png)

## 主界面
- 通过顶部按钮或滑动屏幕切换不同区域游戏列表，其中包含最新游戏、亚欧游戏、港台游戏、韩国游戏
- 可以通过左上角“齿轮”icon按钮进入`设置界面`
- 通过右上角按钮进入`搜索界面`
- 点击其中一款游戏进入本游戏`数据记录界面`<br>
<br>![](/Users/efun/Desktop/检测App文档/screenshot/主界面.png)

## 设置界面
*主界面 -> 点击左上角按钮* 

- 测试模式重置UUID开关：默认关闭，用于进行测试模式时候重置UUID
- 测试模式重置用户信息开关：默认关闭，当进行测试模式时把游戏中统计数据，用户数据、储值记录等所有数据清除
- 指定game code测试按钮：默认关闭，若打开此开关，会有弹框要求输入指定game code，所有的游戏都会为指定game code来进行测试和保存记录，可以再次点击关闭此模式
- 注销：退出登录<br>
<br>![](/Users/efun/Desktop/检测App文档/screenshot/设置界面.png)
![](/Users/efun/Desktop/检测App文档/screenshot/自定义gamecode.png)

## 搜索界面
*主界面 -> 点击右上角按钮* 

- 通过在顶部的搜索栏输入，相关游戏的名字或game code来进行搜索
<br>
<br>![](/Users/efun/Desktop/检测App文档/screenshot/搜索界面.png)

## 数据记录界面
*主界面 -> 选中其中一款游戏*

- 选中游戏的测试数据按时间来排列，可以点击查看具体内容
	- 右滑其中一行，显示删除按钮，可以点击删除选中的游戏

	<br>![](/Users/efun/Desktop/检测App文档/screenshot/删除测试记录.png)	
- 右下角“+”悬浮按钮可以点击，选择测试模式，`注意在选中之前需要先杀死目标测试游戏的app`
	- 上： 进入网络调试模式 -> 进入目标游戏app
	- 下： 游戏测试模式 -> 目标游戏app<br>
<br>![](/Users/efun/Desktop/检测App文档/screenshot/数据记录界面.png)

- 进入游戏Demo界面后，便可进行调试，若左上角显示“绿色按钮”证明已经成功进入测试模式，否则失败
	- 测试完毕，点击左上角绿色按钮进入数据传递界面
	- `注意在切换之前需要先杀死目标测试游戏的app`<br>
<br>![](/Users/efun/Desktop/检测App文档/screenshot/返回结果数据.png)
![](/Users/efun/Desktop/检测App文档/screenshot/传递数据界面.png)

## 查看测试结果界面
*主界面 -> 选中其中一款游戏 -> 选中其中一条数据记录* 

- 此界面展示了测试的结果包括：崩溃日志、iCloud信息、调用API信息、Plist文件信息、游戏语言
- 以上数据结果均可点击查看详情
<br>
<br>![](/Users/efun/Desktop/检测App文档/screenshot/数据内容页面.png)
