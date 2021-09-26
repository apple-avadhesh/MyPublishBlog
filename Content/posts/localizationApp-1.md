---
date: 2021-09-26 16:40
description: 当我们使用一个英文app时，很多人第一时间会去查看是否有对应的中文版本。可见，在app中显示让使用者最亲切的语言文本是何等的重要。对于相当数量的app来说，如果能够将UI中显示的文本进行了本地化转换，基本上就完成了app的本地化工作。本文中，我们将探讨iOS开发中，如何实现显示文本的本地化工作。
tags: CloudKit,Core Data
title:  如何对iOS应用中的文本进行本地化
image: images/localizationApp-1.png
---

> 当我们使用一个英文app时，很多人第一时间会去查看是否有对应的中文版本。可见，在app中显示让使用者最亲切的语言文本是何等的重要。对于相当数量的app来说，如果能够将UI中显示的文本进行了本地化转换，基本上就完成了app的本地化工作。本文中，我们将探讨iOS开发中，如何实现显示文本的本地化工作。本文的[Demo](https://github.com/fatbobman/LocalizationDemoForBlogPost)采用SwiftUI编写。

## 文本本地化的原理 ##

作为一个程序员，如果让你考虑设计一套逻辑对原始文本针对不同语言的进行本地化转换，我想大多数人都会考虑使用字典（键值对）的解决方案。苹果也是采取了同样的处理，通过创建针对不同语言的多个字典，系统可以轻松的查找出一个原始文本（键）对应的本地化文本（值）。比如：

```swift
//en 
"hello" = "Hello";
```

```swift
//zh
"hello" = "你好";
```

这套方法就是本文中主要采取的针对文本的本地化手段。

系统在编译代码的时候，将`可以进行本地化操作的文本`进行了标记，当app运行在不同的语言环境（比如法文）时，系统会尝试尽量从法语的文本键值对文件中查找出对应的内容进行替换，如果找不到则会按照语言偏好列表的顺序继续查找。对于某些类型比如`LocalizedStringKey`上述动作时会自动完成，但是像代码中最常使用的`String`，则需要在代码中显式完成上述动作。

幸运的是，SwiftUI的绝大多数控件（部分目前有Bug）对于文本类型都会优先采用使用`LocalizedStringKey`的构造方法，这极大的减轻了开发者的手工处理工作量。

## 添加语言 ##

对于当代的编程语言和开发环境来说，国际化开发能力都已是必备功能。当我们在Xcode中创建一个项目后，缺省情况下，该app仅针对其对应的Development Language进行开发。

因此我们必须首先让项目知道，我们将对项目进行本地化的操作、并选择对应的语言。

在`Project Navigation`中，点击`PROJECT`，选择`Info` 可以在`Localizations`中进行语言的添加。

![image-20210624074810238](https://cdn.fatbobman.com/image-20210624074810238-4492091.png)

点击 + 号，选择我们将要增加的语言。

![image-20210623192036104](https://cdn.fatbobman.com/image-20210623192036104-4447237.png)

![image-20210623192106625](https://cdn.fatbobman.com/image-20210623192106625-4447268.png)

在这里我们只是告诉项目，我们将可能对列表中的语言进行本地化操作。但如何本地化、对那些文件、资源进行本地化，我们还需要对其单独设置。

> 启用 Use Base Internationalization，Xcode会修改你的项目文件夹结构。xib和storeyboard文件将被移动到Base.lproj文件夹，而字符串元素将被提取到项目区域设置文件夹。该选项针对使用storyboard的开发方式，如果你采用SwiftUI则无需关心。

*对于UIKit框架，Xcode会让你选择`storyboard`的关联方式，由于本文使用的[Demo项目](https://github.com/fatbobman/LocalizationDemoForBlogPost)为全SwiftUI架构，因此**不会**有如下的画面。*

![image-20210623200804552](https://cdn.fatbobman.com/image-20210623200804552-4450086.png)

## 创建文本字符串文件 ##

在苹果的开发环境中，对应我们上文中提到的`字符串文件`（文本键值对文件）的文件类型为`.strings`。我们可以在一个app中创建多个字符串文件，有些名字的字符串文件是有其特殊含义的。

* Localizable.strings

  UI默认对应的字符串文件。在不特别指明字符串文件名称的情况下，app都将从Localizable.strings中获取对应的本地化文本内容

* InfoPlist.strings

  对应Info.plist的字符串文件。通常用于app名称、权限警告提示等内容的本地化。

在`Project Navigation`中，我们选择新建文件

![image-20210624074918275](https://cdn.fatbobman.com/image-20210624074918275-4492159.png)

文件类型选择`Strings File`，将其命名为Localizable.strings

![image-20210623202900471](https://cdn.fatbobman.com/image-20210623202900471-4451341.png)

![image-20210624075200921](https://cdn.fatbobman.com/image-20210624075200921-4492322.png)

此时的`Localizable.strings`文件并没有被本地化，当前你的项目中只有一个文件，在该文件中进行文本键值对的定义，仅会针对项目的`开发语言`，通过右侧的`Localize...`按钮，我们可以选择生成`Localizable.strings`对应的语言（语言列表为项目中添加语言设定的列表）文件。

![image-20210624075240203](https://cdn.fatbobman.com/image-20210624075240203-4492361.png)

将右侧的两个语言都勾选上后

![image-20210623203721043](https://cdn.fatbobman.com/image-20210623203721043-4451842.png)

左侧`Project Navigation`中的Localizable.strins将变成如下状态：

![image-20210623203836721](https://cdn.fatbobman.com/image-20210623203836721-4451918.png)

`English`和`Chinese`目前是空文件状态，我们现在就可以在此创建对应的文本键值对了。

> 可以在此处下载[Demo](https://github.com/fatbobman/LocalizationDemoForBlogPost)项目

### 实战1：汉化账单表格列名 ###

![image-20210623204627826](https://cdn.fatbobman.com/image-20210623204627826-4452393.png)

本节我们尝试为ITEM、QUANTITY、UNIT PRICE和AMOUNT提供对应的中文本地化文本。

按照上面的键值对声明规则，我们在`Localizable.Strings(Chinses)`文件中添加如下内容：

```swift
"ITEM" = "种类";
"QUANTITY" = "数量";
"UNIT PRICE" = "单价";
"AMOUNT" = "合计";
```

打开`TableView`，在预览中添加本地化环境配置

```swift
 TableView()
            .environmentObject(Order.sampleOrder)
            .previewLayout(.sizeThatFits)
            .environment(\.locale,Locale(identifier: "zh"))
```

此时我们从Preview的区域会看到什么变化？**什么都没有变！**

原因是，我们在`字符串文件`中设定的`键`是有问题的。我们在app呈现中看到的`ITEM`在`TableView`中对应的代码如下：

```swift
 HStack{
            Text("Item")
                .frame(maxWidth:.infinity)
            Text("Quantity")
                .frame(maxWidth:.infinity)
            Text("Unit Price")
                .frame(maxWidth:.infinity)
            Text("Amount")
                .frame(maxWidth:.infinity)
        }
        .foregroundStyle(.primary)
        .textCase(.uppercase) //转换成大写
```

`Text`中会将`Item`用作查找的Key，但是我们定义是`ITEM`，因此没有找到对应的值。注意：字符串文件中的`键`是`大写小敏感`的。

将`chinese`文件修改如下：

```swift
"Item" = "种类";
"Quantity" = "数量";
"Unit Price" = "单价";
"Amount" = "合计";
```

此时预览窗口中，我们可以看到汉化后的结果：

![image-20210623210332114](https://cdn.fatbobman.com/image-20210623210332114-4453413.png)

恭喜你，到这里你已经掌握了文本本地化的大部分内容。

*不知道大家注意没有，目前的`English`文件是空的，`Chinese`文件我们也只对四个内容设置了对应的本地化文本。所有我们没有设置的内容，app都将显示我们在代码中设置的原始文本。*

> 在字符串文件中进行定义时，很容易出现两个错误，1：错误的输入了中文标点，2:忘记了后面的分号。

### 实战2：汉化付款按钮 ###

![image-20210623212059142](https://cdn.fatbobman.com/image-20210623212059142-4454460.png)

本节我们尝试将`Pay for 4 drinks`中的文字进行中文化。

该按钮在`ButtonGroupView`中的定义如下：

```swift
 Button {
      showPayResult.toggle()
    } label: {
      Text("Pay for \(order.totalQuantity) drinks")
    }
```

`Pay for \(order.totalQuantity) drinks`该如何在`Localizable.strings`文件中设置对应的`键`呢？

对于这种使用了字符串插值的`LocalizedString`，我们需要使用`字符串格式说明符`，苹果的[官方文档](https://developer.apple.com/library/archive/documentation/CoreFoundation/Conceptual/CFStrings/formatSpecifiers.html#//apple_ref/doc/uid/TP40004265)为我们提供了详细的对照用法说明。

代码中，`order.totalQuantity`对应的是`Int`（Swift在64位系统上`Int`对应的为`Int64`），因此我们需要在键值对中使用`%lld`来将其进行替换。在`Chinese`文件中做如下定义：

```swift
"Pay for %lld drinks" = "为%lld杯饮品付款";
```

![image-20210623213451585](https://cdn.fatbobman.com/image-20210623213451585-4455292.png)

这样我们就得到了想要的结果。当你尝试添加或减少饮料数量时，文本中的数量都会跟随变化。

> 请为你的插值选择正确对应的格式说明符，比如上面的例子如果设置为%d的话将被系统认为是另一个键而无法完成转换。

### 实战3：汉化App的程序名 ###

在Xcode项目中，我们通常会在`Info.plist`文件中对一些特定的系统参数进行配置，比如说`Bundle identifier`、`Bundle name`等。如果需要对其中的一些配置进行本地话处理的话，我们可以使用上文中提到的`InfoPlist.strings`

使用创建`Localizable.strings`文件同样的步骤，我们创建一个名为`InfoPlist.strings`的字符串文件（不要忘记为创建好的文件进行本地化操作，确认中文、英文都已被勾选）。

分别在InfoPlist.strings的`Chinese`和`English`文件中加入如下内容：

```swift
//chinese
"CFBundleDisplayName" = "肥嘟嘟酒吧";
//english
"CFBundleDisplayName" = "FatbobBar";
```

此时，再在模拟器或者真机上安装app，app的名称将会在不同的语言下显示对应的文字。

> 在最近两个版本的Xcode中，可以不直接设置Info.plist，通常在Target的Info中查看或修改值

![image-20210624075411064](https://cdn.fatbobman.com/image-20210624075411064-4492452.png)

> 我们需要本地化的配置无需一定要出现在info或Info.plist中，只要我们在InfoPlist.strings中对其进行了本地化键值对设定，app将会优先采用该设定。通常我们会在InfoPlist.strings中进行本地化的除了app的名称`CFBundleDisplayName`外，还有`CFBundleName`、`CFBundleShortVersionString`、`NSHumanReadableCopyright`以及各种系统权限的申请描述，比如`NSAppleMusicUsageDescription`、`NSCameraUsageDescription`等。更多关于info.plist参数的内容请查看[官方文档](https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Introduction/Introduction.html#//apple_ref/doc/uid/TP40009248-SW1)

### 实战4：本地化饮品名称 ###

在`Localizable(Chinese)`字符串文件中添加如下内容

```swift
"Orange Juice" = "橙汁";
"Tea" = "茶";
"Coffee" = "咖啡";
"Coke" = "快乐水";
"Sprite" = "透心凉";
```

*关于饮料的定义请查看`Model/Drink.swift`代码*

> 通过设置本地环境变量查看预览，或者将模拟器语言改成中文，亦或者在Scheme中将App Lanuguage改成中文。

执行app，我们并没有获得预期的效果。饮品的名称并**没有变成中文**。此时通过查看`Drink.swift`我们可以找出原因：对于已经明确了的`String`类型，Text是不会将其视作`LocalizedStringKey`的。

之前在`ItemRowView`中，我们通过如下代码显示饮品名称：

```swift
Text(item.drink.name)
          .padding(.leading,20)
          .frame(maxWidth:.infinity,alignment: .leading)
```

而饮品的名称在`Drink`中的定义如下

```swift
struct Drink:Identifiable,Hashable,Comparable{
    let id = UUID()
    let name:String //String 类型
    let price:Double
    let calories:Double
```

因此最简单的办法就是修改`ItemRowView`的代码

```swift
Text(LocalizedStringKey(item.drink.name))
         .padding(.leading,20)
         .frame(maxWidth:.infinity,alignment: .leading)
```

> 在某些情况下，我们只能获得`String`类型数据，可能会经常做类似的转换

再次运行，你讲可以看到表格中的饮品名称已经更改为正确的中文显示

![image-20210624090150062](https://cdn.fatbobman.com/image-20210624090150062-4496510.png)

同样对`ItemListView`中的代码进行修改：

```swift
//将
Button(drink.name)
//改成
Button(LocalizedStringKey(drink.name)) 
```

饮品添加列表的显示也正常了：

![image-20210624103137706](https://cdn.fatbobman.com/image-20210624103137706-4501898.png)

修改后的代码可以正常的显示饮料名称的中文了。

> 上面的方法在绝大多数的情况下都是很好的解决问题的手段，但并不适合完全依赖`Export Localizations...`生成用于本地化键值对的项目。目前Xcode15并不会输出使用LocalizdStringKey构造的文本。

为了能够更精确的对本地化后的文本进行排序，我们也可以对`Drink`的比较函数做近一步修改：

```swift
//将
lhs.name < rhs.name
//改为
NSLocalizedString(lhs.name,comment: "") < NSLocalizedString(rhs.name,comment: "")
```

> `NSLocalizedString`可以通过给定的文本`键`获取对应后的文本`值`

将`InfoView`中的

```swift
var list:String {
        order.list.map(\.drink.name).joined(separator: " ")
}
```

改为：

```swift
order.list.map{NSLocalizedString($0.drink.name, comment: "")}.joined(separator: " ")
```

![image-20210624104828379](https://cdn.fatbobman.com/image-20210624104828379-4502909.png)

> **我们难道不能直接当`Drink`的`name`定义为`LocalizedStringKey`类型吗？**
>
> 由于`LocalizedStringKey`不支持`Identifiable`,`Hashable`,`Comparable`协议，同时官方也没有提供任何`LocalizedStringKey`转换成`String`的方法。因此，如果我们想将`name`定义成`LocalizedStringKey`类型需要使用一些特殊手段（需通过Mirror，本文就不展开介绍了）。

## 创建字符串字典文件 ##

一些在中文里并不会存在的困扰，在其他一些语言中却是不小的问题。比较典型的如`复数`。如果你的app只有英文版并且只需应对较少名词时，或许可以将复数规则写死在代码里面。比如：

```swift
if cups <= 1 {
  cupstring = "cup"
}
else {
  cupstring == "cups"
}
```

但这一方面不利于代码的维护，另一方面对于某些具有复杂复数规则的语言（比如俄语，阿拉伯语等）灵活性就太差了。

为了解决如何定义不同语言的复数规则，苹果在`.strings`之外又提供了另一种解决方案`.stringdict`字符串字典文件。

它是一个带有`.stringsdict`文件扩展名的属性列表文件，对它的操作和编辑其他的属性列表完全一样（比如Info.plist）。

`.stringsdict`最初是为了解决复数问题而提出的，不过这几年又陆续增加了针对不同的数值显示不同的文本（通常用于屏幕尺寸的变化），以及针对特定平台（iphone、ipad、mac、tvos）显示对应的文本等功能。

![image-20210624135629220](https://cdn.fatbobman.com/image-20210624135629220-4514191.png)

*上图中，我们分别制定了使用`NSStringLocalizedFormatKey`的复数规则、`NSStringVariableWidthRuleType`可变宽度规则以及`NSStringDeviceSpecificRuleType`特定设备内容规则*

`.stringdict`的根节点为 `Strings Dictionary`，我们的规则都需要建立在它之下。我们需要为每个规则首先建立一个`Dictionary`。上图中，三条规则分别对应的`键`为`device %lld`、`GDP`、`book %lld cups`。程序在碰到满足这三个`键`定义的文本内容时，将使用其对应的规则来生成正确的本地化内容。

所以尽管看起来和`.strings`略有不同，但实际上内在的逻辑是一致的。

* 我们可以在其中制定任意数量的规则。
* 默认对应的字符串字典文件名为`Localizable.stringsdict`。
* `.stringdict`的执行优先级高于`.strings`，比如我们在两个文件中都对`GDP`做了定义，则只会使用`.stringdict`对应的内容

### 制定复数规则 ###

![编组@3x](https://cdn.fatbobman.com/%E7%BC%96%E7%BB%84@3x-4517241.png)

* 数量类别的含义取决于语言，并非所有语言都有相同的类别。

  例如，英语只使用`one`和`other`类别来表示复数形式。阿拉伯语对`zero`、`one`、`two`、`few`、`many`、`other`类别有不同的复数形式。虽然俄语也使用`many`类别，但数字`many`类别中的规则与阿拉伯语规则不同。

* 除`other`外，所有类别都是可选的。

  但是，如果您不为所有特定语言类别提供规则，您的文本在语法上可能不正确。相反，如果您为语言不使用的类别提供规则，则会忽略它并使用`other`格式字符串。

* 在`zero`、`one`、`two`、`few`、`many`、`other`格式字符串中使用`NSStringFormatValueTypeKey`格式说明符是可选的。比如上面的定义当数字为1时，返回的是one cup，不需要必须包含对应的%lld

> 如何在各个语言中定义复数规则请查看[UNICODE官方文档](https://unicode-org.github.io/cldr-staging/charts/latest/supplemental/language_plural_rules.html)

### 可变宽规则 ###

![nsstringvariablewidthruletype_pic@3x](https://cdn.fatbobman.com/nsstringvariablewidthruletype_pic@3x-4517922.png)

同复数和设备规则不同，系统不会自动适配返回值，需要用户在定义本地化文本时显式的进行标注，比如：

```swift
let gdp = (NSLocalizedString("GDP",comment: "") as NSString).variantFittingPresentationWidth(25)
Text(gdp) //返回 GDP(Billon Dollor)
let gdp = (NSLocalizedString("GDP",comment: "") as NSString).variantFittingPresentationWidth(100)
Text(gdp) //返回 GDP(anything you want to talk about)
```

没有完全相同的数字时，将返回最接近的内容。

它的使用场景，我感觉并非不可替代。毕竟在代码上的参与量多了些。

### 特定设备规则 ###

![nsstringdevicespecificruletype-pic@3x](https://cdn.fatbobman.com/nsstringdevicespecificruletype-pic@3x-4518788.png)

目前支持的设备类型有：appletv、apple watch、ipad、iphone、ipod、mac

使用者不需要在代码中进行介入，系统将根据使用者的硬件设备返回对应的内容

### 实战5：重新设定付款按钮 ###

使用复数规则完善付款按钮。

付款按钮的代码在`ButtonView`中:

```swift
Button {
     showPayResult.toggle()
   } label: {
      Text("Pay for \(order.totalQuantity) drinks")
  }
```

我们需要对`Pay for \(order.totalQuantity) drinks`进行设置。

首先创建`Localizable.stringsdict`文件

![image-20210624152114132](https://cdn.fatbobman.com/image-20210624152114132-4519275.png)

![image-20210624152245613](https://cdn.fatbobman.com/image-20210624152245613-4519367.png)

对于英文来说，我们需要设置zero、one、和other的情况。在`English`中进行如下设置：

![image-20210624152837921](https://cdn.fatbobman.com/image-20210624152837921-4519719.png)

中文，只需要设置zero和other

![image-20210624153559265](https://cdn.fatbobman.com/image-20210624153559265-4520160.png)

调整订单数量，按钮将根据不同的语言、不同的订单数量返回对应的本地化文本

## ![stringdict_button](https://cdn.fatbobman.com/stringdict_button-4520139.png) ##

我们在实战2中曾经在`Localizable.strings`中为`Pay for %lld drinks`设置了键值对，但由于`.stringdict`的优先级更高，所以系统将优先使用`NSStringPluralRuleType`规则。

### 实战6：戳我还是点我 ###

根据不同的设备，在添加饮料的按钮上显示不同的内容。

比如，我们可以在iphone、ipad上显示 `tap`、在appletv上显示`select`、在mac上显示`click`

在`Chinese`中添加

![image-20210624154950158](https://cdn.fatbobman.com/image-20210624154950158-4520992.png)

在`English`中添加

![image-20210624155049064](https://cdn.fatbobman.com/image-20210624155049064-4521050.png)

![local_text_finish](https://cdn.fatbobman.com/local_text_finish-4521583-4521584.png)

## Formatter 格式化输出 ##

仅对显示标签进行本地化是远远不够的。在应用中，还有大量的数字、日期、货币、度量单位、人名等等方面内容都有本地化的需求。

苹果投入了巨大的资源，为开发者提供了一个完整的解决方案——Formatter。

在今年（2021），苹果对Formatter做了进一步的升级，不仅提高了Swift下的调用便利性，而且允许开发者通过新增的`FormatStyle`协议创建双向的格式转换方式。

> Formatter涉及的内容非常多，单独编写一篇文章都未必介绍完全。下文中将通过Demo中的几个例子让大家有个基本的了解。

### 实战7: 日期、货币、百分比 ###

#### 日期 ####

  ![image-20210926143214864](https://cdn.fatbobman.com/image-20210926143214864-2637936.png)

```swift
Text(order.date,style: .date) //显示年月日          
Text(order.date.formatted(.dateTime.weekday())) //显示星期
```

在Demo中我们通过了两种方式来本地化日期的显示。

* Text本身支持日期的格式化输出，不过这种方式可定制性不高。

* 使用了新的FormatStyle来链式定义输出内容：

  `order.date.formatted(.dateTime.weekday())`将只显示星期几

#### 货币 ####

![image-20210926145606972](https://cdn.fatbobman.com/image-20210926145606972-2639368.png)

* 创建NumberFormatter

```swift
      private func currencyFormatter() -> NumberFormatter {
          let formatter = NumberFormatter()
          formatter.numberStyle = .currency
          formatter.maximumFractionDigits = 2
          if locale.identifier != "zh_CN" {
              formatter.locale = Locale(identifier: "en-us")
          }
          return formatter
      }
```

  Demo中仅提供两种货币的价格，当系统的的区域的设置不是中国大陆的话，则将货币设置为美元。

* 在Text中应用Formatter

```swift
Text(NSNumber(value: item.amount),formatter:currencyFormatter() )
```

由于在Text中，Formatter仅能用于NSObject，因此需要将Double转换成NSNumber。

目前FormatStyle提供的Currency可配置项太少，暂不采用。

#### 百分比 ####

![image-20210926150144189](https://cdn.fatbobman.com/image-20210926150144189.png)

```swift
 Text(order.tax.formatted(.percent))
```

直接使用formatStyle。

### 实战8: 度量单位、序列 ###

#### 卡路里 ####

使用MeasureMent定义能量单位。一个测量对象(MeasureMent object)代表一个数量和测量单位。测量类型提供了一个编程接口，用于将测量值转换为不同的单位，以及计算两个测量值之间的和或差。

![image-20210926150326836](https://cdn.fatbobman.com/image-20210926150326836.png)

```swift
init(name: String, price: Double, calories: Double) {
        self.name = String.localizedStringWithFormat(NSLocalizedString(name, comment: name))
        self.price = price
        self.calories = Measurement<UnitEnergy>(value:calories,unit: .calories) //设置时将原始数据设为calorie
    }
```

测量对象同样可以进行数据计算：

```swift
    var totalCalories:Measurement<UnitEnergy>{
        items.keys.map{ drink in
            drink.calories * Double(items[drink] ?? 0)
        }.reduce(Measurement<UnitEnergy>(value: 0, unit: .calories), +)
    }
```

创建描述MeasureMent的Formatter

```swift
    var measureFormatter:MeasurementFormatter{
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium
        return formatter
    }
```

在SwiftUI中显示

```swift
Text(order.totalCalories,formatter: measureFormatter)
```

#### 序列 ####

![image-20210926151111505](https://cdn.fatbobman.com/image-20210926151111505.png)

![image-20210926151203232](https://cdn.fatbobman.com/image-20210926151203232.png)

创建符合不同语言习惯的连字方式（标点、和或等）。

```swift
    var list:String {
        order.list.map{NSLocalizedString($0.drink.name, comment: "")}.formatted(.list(type: .and))
    }
```

## 其他 ##

### 使用tabname指定特定名称字符串文件 ###

可以创建多个字符串文件，当该文件名不是Localizabl时，我们需要指明文件名称，比如`Other.strings`

```swift
Text("Item",tableName: "Other")
```

`tableName`同样适用于`.stringdict`

### 指定其他Bundle中的字符串文件 ###

如果你的app中使用了包含多语言资源的其他Bundle时，可以指定使用其他Bundle中的字符串文件

```swift
import MultiLanguPackage // ML
Text("some text",bundle:ML.self)
```

在包含多语言资源的Package中，可以使用以下代码指定Bundle

```swift
Text("some text",bundle:Self.self) 
```

### markdown符号支持 ###

苹果在WWDC 2021上，宣布可以在Text中直接使用部分markdown符号。比如：

```swift
Text("**Hello** *\(year)*")
```

我们同样可以在字符串文件中使用markdown符号

```swift
"**Hello** *%lld*" = "**你好** *%lld*"；
```

另外，新增的`AttributedString`类型可以为文本带来更多的创造性。

## 总结 ##

本文原为我针对iOS的本地化主题系列文章中的一篇，不过由于琐事较多，始终没有最终完成。

其他内容，例如：资源本地化、本地化调试、本地化预览、本地化文件编辑、Formatter深入研究等，今后再一同探讨。

希望本文能够对你有所帮助。