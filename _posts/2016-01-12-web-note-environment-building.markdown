---

layout: post
title:  Web Note - Environment Build
date:   2016-01-12 17:10:00
categories: [j2ee]
tags: [j2ee, web-note， web-environment]

---
## Java Web 环境介绍
### 1. 环境搭建
#### 准备工具
1. JDK (windows 下配置JDK_HOME或JAVA_HOME或JRE_HOME)
2. Tomcat (windows 下配置 CATALINA_HOME)
3. Eclipse
4. MySQL

**tips**：有一软件xampp集成了常用软件如Tomcat和MySQL等，可以尝试替换看看。
#### 配置环境
1. 若想在命令行下直接使用上述软件的命令，需要在环境变量下配置命令路径（过程略）。
2. Eclipse环境配置
    1. Eclipse->Window->Preferences->Java->Installed JREs 将jre路径改为刚才安装的jdk路径，这样便可以查看java源代码。
    2. Eclipse->Window->Preferences->Server—>Runtime Environments 添加刚刚安装的Tomcat作为Server。
    3. code style的配置如编码（建议utf8），换行符的设置（建议类Unix），制表符的宽度（建议4），显示空白符，显示行号，用空格替换制表符等，自己根据实际style来配置。

### 2. Eclipse技巧
1. 查看Tomcat运行时目录：在任意代码编写的界面 右键->Run As->Run Configurations->Apache Tomcat->Arguments->VM Arguments 里可查看Dwtp.deploy变量的值即为Tomcat运行时deploy目录。
