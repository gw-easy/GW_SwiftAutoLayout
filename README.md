# GW_SwiftAutoLayout
## autoLayout链式swift版本，代码量少，操作简单。<br/>
> cocoapods  
```
platform :ios, '9.0'
pod "GW_SwiftAutoLayout"
```
### 1、新添加label之间基线对其，以应对UI设计图label之间对其比实际约束高的问题。<br/>
举例：label1的lastBaseline和label2的top的基线对其。label2.GWTopBaseLine(8, toView: label1, font: label2.font),需要指定顶部基线的字体大小。<br/>
