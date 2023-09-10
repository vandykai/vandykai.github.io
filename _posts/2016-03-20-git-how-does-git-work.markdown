---

layout: post
title:  How Does Git Work
date:   2016-03-20 12:30:00
categories: [VCS]
tags: [vcs, git]

---
### Git 思想
git 旨在创建一个分布式版本控制工具，满足以下一些需求：

1. 我只想**单机**的工作着，备份我的工作的每次修改，那么你只需要用到git的本地仓库，把你工作的内容保存（即commit）到你的仓库中去。
2. 我们有一个**团队**，共同做着一些事情（开发，写文章...），我想同步我们之间的工作，好让别人清楚知道你做了什么。这时候好的办法是创建一个远程仓库，用来保存整个团队的工作内容，每个工作者再复制（即clone）远程仓库的内容作为本地仓库（既然是复制，那么你的仓库理应也可以作为远程仓库使用，事实上确实如此，只需要改一个地方，后面会阐述），平常每个工作者在自己的仓库中工作着，时不时看看别人工作的内容，更新这些新的工作内容到自己的本地仓库中来，看看和自己的工作有没有冲突，这里涉及到冲突的解决，暂不阐述。当你工作完成后，可以把自己的工作提交到远程仓库中去，这样别人就可以通过远程仓库看到你的工作内容了。

### 创建Git Repository
如果你用的是TortoiseGit创建（git create repository here...)一个新的创库的话，那么会弹框提示你是否Make it bare,分别对应git命令`git init` 和 `git init --bare`。

如果你仔细对比这两个命令创建的repository的话就会发现它们仅有congit/下的bare属性不同，一个是false，一个是true，如果还要说有什么不同，那就是没有bare属性的repository的目录被.git文件夹包裹了。

虽然仅有一个属性不同，但是这两个repository的作用却是不同，一个是本地工作repository，一个是专供远程提交的repository。对于本地工作repository，别人是不能推送（push）工作到你的repository的。所以congit/下的bare属性如果为true的话则这个repository可以充当远程repository，你只要把你的clone过来的repository或git init初始化的repository中的.git/config下的bare属性改为true就可以变成远程repository了，甚至都不需要把.git下的文件移出来到父目录下。远程repository今后的工作中并不会产生logs（用来记录运行记录）文件夹。

### Git 工作运行的目录结构

~~~
hooks                                   │hooks
    - applypatch-msg.sample             │    - applypatch-msg.sample
    - commit-msg.sample                 │    - commit-msg.sample
    - post-update.sample                │    - post-update.sample
    - pre-applypatch.sample             │    - pre-applypatch.sample
    - pre-commit.sample                 │    - pre-commit.sample
    - prepare-commit-msg.sample         │    - prepare-commit-msg.sample
    - pre-push.sample                   │    - pre-push.sample
    - pre-rebase.sample                 │    - pre-rebase.sample
    - update.sample                     │    - update.sample
info                                    │info
    - exclude                           │    - exclude
                                        │logs
                                        │    - refs
                                        │        - heads
                                        │            - master
                                        │    - HEAD
                                        │
objects                                 │objects
                                        │    - 80
                                        │        - 865964295ae2f11d27383e5f9c0b58a8ef21da
                                        │    - b0
                                        │        - 42d75a51e77fdac111e85eda5331470781b9de
                                        │    - d6
                                        │        - 70460b4b4aece5915caf5c68d12f560a9fe3e4
    - info                              │    - info
    - pack                              │    - pack
refs                                    │refs
    - heads                             │    - heads
                                        │        - master
    - tags                              │    - tags
                                        │COMMIT_EDITMSG
config                                  │config
description                             │description
HEAD                                    │HEAD
                                        │index
~~~

左上边是新建的一个仓库的目录结构，未提交任何东西，右上边是提交了一次文件后的仓库目录结构。把它们放在一起方便对比新增了哪些文件。

这些目录就是你的整个仓库的结构了，你可以把他们复制到任何地方用来备份你的仓库。

下面阐述每个目录、文件的作用。

1. hooks 目录下放置了许多脚本，也称钩子，这些脚本就像一些回调函数，会在你使用git的各个阶段被调用。从名字中可以看出大致被调用的阶段，你也可以自定义一些脚本用来实现诸如提交时发邮件，单元测试等需求。关于自定义钩子参见[链接][1]
2. info/exclude 文件用来忽略一些不想提交的文件，避免被git检测到，和.gitignore文件的作用类似，但是这个exclude文件不能被push到远程仓库中去，所以exclude中的规则不能被其他人共享。关于exclude的更多用法暂时还没了解到。
3. logs 记录git的运行记录，这里的文件信息仅供查看，并不会当作分支历史记录的依据，分支历史纪录的依据以树的形式存储在objects中。logs只需记录SHA-1值的变化，因为每次git提交操作都会在objects目录下生成与SHA-1值对应的文件，这些文件记录了具体变化。logs只需记录从哪个文件变到了哪个文件即可。子目录refs中的以分支命名的文件（包括本地分支和远程分支）记录每次提交的变化。HEAD则记录所有的操作（包括切换分支，rebase等，但是创建分支这里没有记录，很是奇怪）。refs/heads/master 记录主分支从创建开始的每次SHA-1更新变化，如果还有其它分支，这里也会有一个以其它分支命名的文件，记录分支从何处SHA-1值开始创建即其后的每次SHA-1更新变化。远程分支的push信息会记录在refs/heads/remotes目录下。
4. objects 相当于一个小型的文件数据库，你所有提交的东西（包括创建tag的注释信息，和注释的修改，总之就是需要记录的信息）都会存储在这里。看到这里你会恍然大悟，所有的SHA-1值在这里都有对应，形式为前2位十六进制数命名的文件夹加上后面38位十六进制数命名的文件，不直接使用文件的大概原因是为了方便检索，当提交次数多了以后，SHA-1值势必大大增加，文件夹树的形式提高了检索速度。文件中包含的内容后面阐述，大概相当于按SHA-1值获取提交内容的文件系统。
5. refs 相对于文件指针，指向某次提交的SHA-1值。包含每个分支的头和你建立的tags
6. COMMIT_EDITMSG 用来记录最后一次提交的注释。
7. config git的配置文件。
8. description
9. HEAD 指向当前的分支头指针，相当于C语言中指针的指针。
10. index 缓存更改的文件。

阐述目录结构后，你会发现git的工作原理其实非常简单，就是生成一个文件记录你的每次git操作，计算出该文件的SHA-1值，以SHA-1值唯一标识这个文件，再弄一些指针来指向这些SHA-1来充当分支头或者tag标记，最后再弄个log来记录你想要的每次变化路径，这些路径就是你的分支变化史了。

#### Git 记录文件探索
前面已经说了，git的所有操作记录都会保存在objects目录下的文件中，那么这些文件中到底都存储了些什么内容呢，直接以文本方式打开这些文件都是乱码，后来发现这些文件要使用`git cat-file -p (SHA-1)`命令来查看，其中可以不写完整（实测至少4位），只要能唯一标识文件即可。针对上述的第一次提交我们分别查看objects下增加的三个文件夹下的三个文件，SHA-1值是等于文件夹名加上文件名,在objects目录下（只要git目录下都可以）打开bash或命令提示窗口

~~~
$ git cat-file -p 80865964295ae2f11d27383e5f9c0b58a8ef21da
100644 blob d670460b4b4aece5915caf5c68d12f560a9fe3e4    test.txt

$ git cat-file -p b042d75a51e77fdac111e85eda5331470781b9de
tree 80865964295ae2f11d27383e5f9c0b58a8ef21da
author vandykai <wdkrgst@gmail.com> 1458547402 +0800
committer vandykai <wdkrgst@gmail.com> 1458547402 +0800

test comment

$ git cat-file -p d670460b4b4aece5915caf5c68d12f560a9fe3e4
test content

~~~

第一次提交的是test.txt文件，该文本文件中的内容是test content，提交时的comment是test comment

在text.txtw文件中换行添加内容added text再次提交，提交comment为added comment，提交后又新增了三个文件夹和三个文件，分别使用`git cat-file -p (SHA-1)`命令来查看这三个文件的内容结果如下

~~~
$ git cat-file -p 2ce18c9a25e15f30d684274b89d0ef29d032491e
tree 5a1e99b76770966d5975d2ba8aadf32c2bf550ea
parent b042d75a51e77fdac111e85eda5331470781b9de
author vandykai <wdkrgst@gmail.com> 1458567378 +0800
committer vandykai <wdkrgst@gmail.com> 1458567378 +0800

added comment

$ git cat-file -p 3a35a3b22ba503b003bbdf6066163a14d75b9a41
test content
added text

$ git cat-file -p 5a1e99b76770966d5975d2ba8aadf32c2bf550ea
100644 blob 3a35a3b22ba503b003bbdf6066163a14d75b9a41    test.txt

~~~
可以看到SHA-1值为2ce18c9a25e15f30d684274b89d0ef29d032491e的文件信息中有一个tree值和parent值，parent值就是上次提交的SHA-1值，链接起来就形成了单个分支的列表，多个分支形成了一棵git数。通过tree的值指向的文件里里面的记录可以找到更新的文件被存储在哪个文件里面，现在的tree值为5a1e99b76770966d5975d2ba8aadf32c2bf550ea，查看这个文件，发现更新的文件被存储在了3a35a3b22ba503b003bbdf6066163a14d75b9a41这个文件里面，提交的文件名是test.txt，100644是文件模式，查看3a35a3b22ba503b003bbdf6066163a14d75b9a41这个文件发现它存储了最新文件的内容，没有采取差异存储，与预计有点出路，后面私下再次实验了一把，更新（增加数行）了一个5MB多的文本文件，发现每次更新提交都会增加3MB多的文件，看来确实没有采用差异存储，只是压缩了文件，这一点还是很奇怪的。后来查了下[资料][2]发现要手工调用`git gc`命令来实现这种目的，当objects中的对象过多时，也会自动调用这个过程。这部分和index文件的作用留待以后研究。


[1]: https://git-scm.com/book/zh/v1/%E8%87%AA%E5%AE%9A%E4%B9%89-Git-Git%E6%8C%82%E9%92%A9
[2]: http://www.open-open.com/lib/view/open1328070620202.html
