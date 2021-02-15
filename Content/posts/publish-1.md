---
date: 2021-01-30 21:00
description: Publish是一款专门为Swift开发者打造的静态网站生成器。它使用Swift构建整个网站，并支持主题、插件和其他大量的定制选项。
 本文包含Publish的快速使用入门以及基本结构说明。
tags: Swift,Publish
title: 用Publish创建博客（一）——入门
---
> [Publish](https://github.com/JohnSundell/Publish)是一款专门为Swift开发者打造的静态网站生成器。它使用Swift构建整个网站，并支持主题、插件和其他大量的定制选项。
> 作为Swift开发者，通过Publish创建站点的开发过程和体验同开发其他程序很类似。

## 开篇 ##

### 开发者John Sundell ###

Publish的开发者John Sundell这些年一直致力于发表关于Swift的高质量文章、播客和视频。他的作品大多都发布在其独立运营的 [Swift by Sundell](https://swiftbysundell.com/)上。他开发了[Publish](https://github.com/JohnSundell/Publish)用以创建并管理自己的站点。

在开发Publish的过程中，他还开源了其他大量的基本库，比如[Ink](https://github.com/JohnSundell/Ink)（高效的Markdown解析器）、[Plot](https://github.com/JohnSundell/Plot)（创建HTML、XML、RSS的DSL）、[Sweep](https://github.com/JohnSundell/Sweep)（高效的字符串扫描库）、[Codextended](https://github.com/JohnSundell/Codextended)（Codable增强）等。它们不仅一起构建了强大的Publish，并且在各自的领域也是极为出色的开源库。

### 我为什么使用Publish ###

我在一年前恢复自己的这个博客时使用的是`Hexo`。Hexo在国内有非常好的群众基础，网上有大量优秀的教程，也有非常多的开发者贡献了自己创作的各种主题和插件。尽管Hexo让我相当满意，但由于我主要使用的语言是Swift，且对JavaScript非常不熟悉，因此想要对Hexo做更深入的定制或修改很困难。

作为开发者（即使是业余的），总希望对自己的项目有更全面的掌控，因此完全由Swift开发的Publish就成为了我的首选。

随着使用Publish对[肘子的Swift记事本](https://www.fatbobman.com)重建过程的深入，我感觉自己做出了正确的选择。Publish让我可以用开发普通app的思路和逻辑来创建站点，高效地完成我想要的各种定制和改动。

### 写本文的原因 ###

截至落笔时，Publish已经在Github上获得了3.1K的好评。但网络上对Publish的介绍并不多，尤其欠缺关于模板定制、插件开发方面的资料和交流。在Github上搜索相关的插件和模板的结果数量也非常有限。

造成上述的情况固然有Publish诞生时间较短、使用量不大，Swift圈子较小等原因，但我认为下面的情况也加剧了这一局面的形成：由于不同于其他的静态网站生成器，在Publish项目中，开发者可以用短小的代码实现各种功能。这种碎片化的代码其实是不利于分享且并不容易被搜索；另外，由于Publish中的模板和网站的功能具体实现绑定的较深，单独分享的模板的利用度也较低。

> 但Publish的这种特质也恰恰是其吸引人之处。

有鉴于此，我将用三篇文章（入门、如何写模板、如何写插件）完成对Publish的简绍，也希望国内的Swift开发者或爱好者们可以更多的了解和使用这个优秀的工具。

为了让大家能够快速上手，我已将本站点所用的代码（包括模板、自定义插件等）放置在[Github](https://github.com/fatbobman/PublishThemeForFatbobmanBlog)上，方便大家通过代码更快的了解和掌握Publish。

## 快速使用入门 ##

### 如何安装Publish ###

同大量的其他静态网站生成器一样，Publish提供了CLI。你可以通过命令行快速的完成创建模板、内容更新、远程发布等一系列操作。Publish目前可以运行在Mac和Linux上，由于其代码对操作系统的依存度极低，估计其后也出现在Windows平台上。

#### Mac下通过brew安装 ####

```bash
$brew install publish
```

#### 源代码安装 ####

```bash
$git clone https://github.com/JohnSundell/Publish.git
$cd Publish
$make
```

### 创建你的第一个项目 ###

让我们来创建一个新的Blog项目

```bash
$mkdir myblog
$cd myblog
$publish new
```

Publish将在myblog目录中创建我们所需的项目模板。它的基本构成大概如下：

```
|-- myblog
|   |-- Content
|           |–– posts
|                 |–– first-post.md
|                 |–– index.md
|           |–– index.md
|   |-- Resources
|   |-- Sources
|           |–– Myblog
|                  |–– main.swift
```

* Content

  在此放入你要在网站发布的文章、页面等使用markdown编写的文件。

* Resources

  项目主题需要的一些资源，比如css，图片等，目前为空。在你进行第一发布后，可以看到它包含了默认的FoundationTheme的styles.css文件。

* Source

  描述网站的代码。在`main.swift`中定义了网站的基本属性、创建工作流等。

### 编译及运行 ###

Swift是编译型语言，因此你的站点的代码在每次修改之后，都需在本机编译并运行才能完成内容的生成工作，好在这一切都只需要一条命令。

我们让Publish完成上述工作并启动内置的Web Server供我们浏览新创建的项目。

```bash
$publish run
```

第一次运行，Publish会自动从Github上获取所需的其他库，请稍等几分钟。

```bash
$ publish run
............
Publishing Myblog (6 steps)
[1/6] Copy 'Resources' files
[2/6] Add Markdown files from 'Content' folder
[3/6] Sort items
[4/6] Generate HTML
[5/6] Generate RSS feed
[6/6] Generate site map
✅ Successfully published Myblog
🌍 Starting web server at http://localhost:8000

Press ENTER to stop the server and exit
```

现在你就可以用浏览器访问 http://localhost:8000 来访问你的新站点了。

网站的全部内容都被生成并放置在了`Output`目录下。你只需要将其中的内容上传到你的服务器，或者通过简单的配置，比如：

```swift
.unwrap(.gitHub("fatbobman/fatbobman.github.io", useSSH: true), PublishingStep.deploy)
```

然后使用

```bash
$publish deploy
```

便可将内容发布到你的github.io上（具体配置后面说明）。

此时你在`Content` - `posts`中添加如下文件`second-post.md`

```
---
date: 2021-01-29 19:58
description: 我的第二篇文章
tags: publish,swift 
---
# Hello Wolrd
```

再度执行 `publish run` 便可以看到新文章已经出现在页面上了。

### 使用我提供的模板快速上手 ###

首先要确保已经安装了Publish CLI

```bash
$git clone https://github.com/fatbobman/PublishThemeForFatbobmanBlog.git
$cd PublishThemeForFatbobmanBlog
$publish run
```

## 更多关于Publish的知识 ##

本节的内容将介绍几个Publish中的概念，对于后面了解模板定制和功能扩展十分重要。

### Site ###

当你使用Publish来创建项目时，Publish会自动生成一个`Swift Package`。网站的生成和部署配置都是通过该包完成的，使用的都是原生的且类型安全的Swift代码。

下面的代码便是使用`publish new myblog`生成的`main.swift`（包的入口文件）中内容。

```swift
//Site的定义
struct Myblog: Website {
    enum SectionID: String, WebsiteSectionID {
        // 添加你需要的Section
        case posts
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // 在这里添加任何您想使用的特定站点元数据
    }

    // 你网站的一些配置xn'xi
    var url = URL(string: "https://your-website-url.com")!
    var name = "Myblog"
    var description = "A description of Myblog"
    var language: Language { .english }
    var imagePath: Path? { nil }
}
//可以在模板或插件等位置访问Site中的属性信息

// 执行入口。当前使用的是默认的模板，且使用的是Publish预置的生成、导出、发布流程。
// 工作流的定义，更多内容见Step
try Myblog().publish(withTheme: .foundation)
```

`Site`不仅定义了网站项目的基础配置信息，而且定义了网站从生成到发布的工作流程。

### Section ###

每个Section都会在`Output`下生成的一个子目录。在main.swift中，通过枚举的方式对`Section`进行定义。你可以把Section可以作为一组`Item`（文章）的容器，也可以仅指向某个`Page`（非Item的自有页面）。  当需要使用`Section`管理一组文章时，只需要在`Content`目录下创建同该`Section`名字相同的子目录即可，具体可以查看范例中`Content`下的`posts`和`project`。

`Section`的定义

```swift
enum SectionID: String, WebsiteSectionID {
     case posts //新创建的项目缺省只有这个，对应content-posts目录
     case links //可以自己添加，将属于该section的文章放置到对应的目录即可
     case about
}
```

在[肘子的Swift记事本](http://www.fatbobman.com)中，每个Section同时也对应着上方导航区的一个选项。`Section`可以有多种用途，在模板定制章节会做更多探讨。

### Item ###

保存在`Content--对应Sectioin`目录中的文章。每个`Item`都对应一个`Section`，无需特别设置，其保存在哪个`Section`的目录中，就属于哪个`Section`。如果该`Section`不需要作为文件容器，可以直接在`Content`中创建和`Section`同名的md文件。我提供的范例模板中，`about`就是这种形式。

### Page ###

不归属于任何`Section`的文章。`Page`不会出现在`Section`的`item`列表中，通常也不会出现在index（首页）列表中。在`content`下的不属于任何`Section`的目录中按如下结构添加文件即可创建`Page`。注意`Page`的创建路径和访问路径的关系。

```
| content -- 404
|             | -- index.md
```

你可以通过访问http://localhost:8000/404/index/查看

Page为我们提供一种构建自由页面的方法。比如你可以用它来创建不需要显示在列表中的文章，或者像范例模板的演示一样创建404😅。

### Content ###

在此特指`Item`、`Page`中的`content`属性。作为内容集，其范围包括文本（如标题和描述）、所属标签（tag）、转换后HTML代码、音频、视频等各种元数据。元数据需要在Markdonw文章的头部注明。

`Section`也有`Content`，它的内容对应着你在该`Section`对应的`Content`子目录中创建的index.md（如果有必要的话）。

在代码中将来还会碰到另一种`Content`,确切的说是`PublishingContext`。里面包含着整个项目的所有信息（Site、Sections、Items、Tags等），通过将它的实例传递给`Step`或者`Plugin`来完成修改或配置网站的各种工作。

### Metadata ###

Markdown文件的元数据，在文章（Markdown）文件的头部做出标识。分为两类，一种是Publish预置的。另一种是通过在`Site`中`ItemMetadata`自定义的。

```
---
date: 2021-01-29 19:58
description: A description of my first post.
tags: first, article
author: fat 
image: https://cdn.fatbobman.com/first-post.png
---
```

#### 预设 ####

* **title** 文字标题

  如果没有设置，Publish会直接查找文章正文中第一个Top-level Head` # `作为标题

* **description** 文章简介

* **date** 文章创作日期 

  如果没设置则直接使用文件的modificationDate

* **tags** 文章标签，每篇文章可以设置多个标签，为文章的组织多一个维度

* **image** 图片地址 比如可以用来在Item列表中显示一个文章的主题图片（需在模板中定义）

* **audio** 音频数据 

* **video** 视频数据

  音视频的定义过于复杂，如果确实需要可以自行定义。

#### 自定义 ####

```swift
struct ItemMetadata: WebsiteItemMetadata {
    // Add any site-specific metadata that you want to use here.
    var author:String
}
```

如果预置的`metadata`不足以满足你的需求，可以在`ItemMetadata`中自行定义。

#### 两种metadata的区别 ####

预设的`metadata`在Publish中是作为的属性存在的。

```swift
for item in content.allItems(sortedBy: \.date){
         print(item.title)
 }
```

自定义的`metadata`需通过如下方式获取

```swift
let author = (item.metadata as! Myblog.ItemMetadata).author
```

在模板中使用更方便

```swift
.text(item.metadata.author)
```

Publish中预设的`metadata`，`Item`并不要求必须填写。但是对于自定义的`metadata`则必须在`markdown`文档中添加。`index.md`、 `Page` 可以没有`metadata`（无论是否为自定义）

### Theme ###

Publish使用[Plot](https://github.com/fatbobman/PublishThemeForFatbobmanBlog)作为其HTML主题的描述引擎，开发者可以用非常Swift的方式来定义页面。如果使用过DSL类型的开发方式，会感觉非常亲切。比如下面的代码定义了Section List的布局呈现

```swift
func makeSectionHTML(
        for section: Section<Site>,
        context: PublishingContext<Site>
    ) throws -> HTML {
        HTML(
            .lang(context.site.language), //网页语言
            .head(for: section, on: context.site), //头文件，metadata、css等
            .body(
                .header(for: context, selectedSection: section.id), //网站的上部区域，范例中包括了Logo，以及导航条
                .wrapper(
                    .itemList(for: section.items, on: context.site) // 文章列表
                ),
                .footer(for: context.site) //最下方的版权区域
            )
        )
    }
```

在Theme中定义的布局细节仍需要在css中进行进一步设置。

上面代码中 `header`、`wrapper`等在Plot中都被称作`Node`,除了使用Publish中预置的大量`Node`外，我们可以使用自己编写的`Node`。 

更多关于Theme的内容，将在用Publish创建博客（二）中做详细介绍。

### Step ###

Publish采用工作流（Pipeline）的方式来明确定义各个环节的操作过程。从文件读取、markdown解析、HTML生成、RSS导出等等。通过`publish new`生成的`main.swift`中，尽管只使用了一条语句

```swift
try Myblog().publish(withTheme: .foundation)
```

但其背后对应着下面一系列操作步骤：

```swift
using: [
      .group(plugins.map(PublishingStep.installPlugin)),
      .optional(.copyResources()),
      .addMarkdownFiles(),
      .sortItems(by: \.date, order: .descending),
      .group(additionalSteps),
      .generateHTML(withTheme: theme, indentation: indentation),
      .unwrap(rssFeedConfig) { config in
      .generateRSSFeed(
               including: rssFeedSections,
                      config: config
                    )
          },
       .generateSiteMap(indentedBy: indentation),
       .unwrap(deploymentMethod, PublishingStep.deploy)
         ]
```

在多数的情况下，我们都会显式的将每一个操作步骤标明出来。每个步骤在Publish中被称为`Step`。Publish已经预置了不少`Step`供开发者使用。我么也可以将自己创建的`Step`注入到工作流中合适的位置以实现更多功能。

每个`Step`都会被传递一个`PublishContent`实例，该实例可用于更改网站中的各种元素（包括文件、文件夹、Item、Page等）。关于`PublishContent`同`Content`的不同，请见上文。

### Plugin ###

```swift
.installPlugin(.highlightJS()), //语法高亮
```

上面的代码在Publish工作流中通过名为`installPlugin`的`Step`来完成插件`highlightJS`的安装。

`Plugin`的开发和`Step`非常类似，都会获得一个`PublishContent`实例，并通过其完成相关工作。

比如说，你可以用`Step`来完成某些具有副作用的操作；用`Plugin`来完成类如`Modifier`（markdown的定制化解析）注入的工作。

对于自定义代码，从功能角度讲，两者都能实现对方的工作。因此在创建功能扩展时，采用`Step`还是`Plugin`取决于个人的偏好。

关于如何定制`Step`和`Plugin`将在用Publish创建博客（三）中做详细说明。

## Publish适合什么人 ##

Publish同当前主流的静态网站生成器相比还略有不足，如社区活跃度较低、开发时间较短、Swift语言用户量较小等。当前Publish较适合符合如下状况的朋友：

* 使用Swift语言的开发者或Swift的爱好者
* 欠缺Javascripte的经验，或者喜欢Javascripte free的风格
* 追求高效、简洁的网页呈现方式
* 希望能够完整掌握网站的各个环节并通过自己的双手逐步实现各项功能
* 善于尝鲜者

## Next ##

我将在用Publish创建博客（二）中探讨Theme的开发，在（三）中了解如何通过多种手段扩展Publish的功能。

如果你已经开始感兴趣，马上在Github上开通你的github.io站点，用Publish一键deploy属于自己的博客吧。
