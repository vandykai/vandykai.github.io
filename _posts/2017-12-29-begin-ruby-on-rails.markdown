---

layout: post
title:  Ruby On Rails
date:   2017-12-23 12:30:00
categories: [Web]
tags: [web, ruby, ruby-on-rails]

---

## 安装
1. 安装ruby
2. 安装sqlite3

    ~~~
    sudo apt-get install sqlite3
    sudo apt-get install libsqlite3-dev
    ~~~

3. 安装rails

    ~~~
    gem install rails
    rails --version
    ~~~
4. 使用rails创建博客

    ~~~
    rails new blog
    ~~~
5. 启动web服务器

    ~~~
    cd blog
    bin/rails server
    ~~~

## 错误及处理
~~~
/var/lib/gems/2.3.0/gems/bundler-1.16.1/lib/bundler/runtime.rb:84:in `rescue in block (2 levels) in require': There was an error while trying to load the gem 'uglifier'. (Bundler::GemRequireError)
Gem Load Error is: Could not find a JavaScript runtime. See https://github.com/rails/execjs for a list of available runtimes.
Backtrace for gem load error is:
/var/lib/gems/2.3.0/gems/execjs-2.7.0/lib/execjs/runtimes.rb:58:in `autodetect'
/var/lib/gems/2.3.0/gems/execjs-2.7.0/lib/execjs.rb:5:in `<module:ExecJS>'
/var/lib/gems/2.3.0/gems/execjs-2.7.0/lib/execjs.rb:4:in `<top (required)>'
/var/lib/gems/2.3.0/gems/uglifier-4.1.1/lib/uglifier.rb:5:in `require'
/var/lib/gems/2.3.0/gems/uglifier-4.1.1/lib/uglifier.rb:5:in `<top (required)>'
/var/lib/gems/2.3.0/gems/bundler-1.16.1/lib/bundler/runtime.rb:81:in `require'
/var/lib/gems/2.3.0/gems/bundler-1.16.1/lib/bundler/runtime.rb:81:in `block (2 levels) in require'
/var/lib/gems/2.3.0/gems/bundler-1.16.1/lib/bundler/runtime.rb:76:in `each'
/var/lib/gems/2.3.0/gems/bundler-1.16.1/lib/bundler/runtime.rb:76:in `block in require'
/var/lib/gems/2.3.0/gems/bundler-1.16.1/lib/bundler/runtime.rb:65:in `each'
/var/lib/gems/2.3.0/gems/bundler-1.16.1/lib/bundler/runtime.rb:65:in `require'
/var/lib/gems/2.3.0/gems/bundler-1.16.1/lib/bundler.rb:114:in `require'
/home/ez/blog/config/application.rb:7:in `<top (required)>'
/var/lib/gems/2.3.0/gems/railties-5.1.4/lib/rails/commands/server/server_command.rb:133:in `require'
...
...

~~~
~~~
原因：没有JavaScript runtime
解决方法：sudo apt-get install nodejs
~~~