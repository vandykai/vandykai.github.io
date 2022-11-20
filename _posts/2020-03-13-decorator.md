---

layout: post
title:  python 装饰器
date:   2020-03-13 22:49:00
categories: [Python]
tags: [AI, NLP]

---

python中的函数和变量一样，可以赋值给一个变量如：
```python
def func():
    print("hello")
fun_p = func
```

所以python中的函数也可以当作函数的参数传入。

python 中的函数也可以嵌套定义

```python
def func1(value):
    def func2():
        print("func2:", value)
    return func2

fun_p = func1("go")
print(fun_p())
```

`> func2: go`

并且内部的函数还可以使用外部函数的变量

```python
def decorator(func):
    def wrap_func():
        print("before")
        func()
        print("after")  
    return wrap_func
```

  这里已经实现了一个装饰者的设计模式了。

这样调用：
```python
func = decorator(func)
```

fun 就被装饰了，python提供了一个更好的简便写法来写上述语句那就是
```python
@decorator
def func():
    print("hello")
fun_p = func
```
`@`符号是装饰器的语法糖，

但是这样的装饰器还有一点点问题，那就是
```python
print(fun_p.__name__)
```

`> wrap_func`

为了解决这个问题，python的functools里有一个装饰器@wraps(func)，我们只要这样定义装饰器就没问题了：
```python
from functools import wraps
def decorator(func):
    @wraps(func)
    def wrap_func():
        print("before")
        func()
        print("after")  
    return wrap_func
```


@wraps接受的是传入的函数变量，并加入了复制函数名称、注释文档、参数列表等等的功能。这可以让我们在被装饰的函数拥有装饰之前的函数的属性。

如果装饰器是要装饰一个带有参数的函数，那么定义如下：
```python
from functools import wraps
def decorator(func):
    @wraps(func)
    def wrap_func(args):
        print("before")
        print(args)
        func(args)
        print("after")  
    return wrap_func
@decorator
def func(value):
    print("func", value)
func("go")
```

```
>before
>go
>func go
>after
```

可以看到上面定义的装饰器在使用时是不带参数的，如@decorator， 但是@wraps 确可以接受一个参数，这是怎么做到的呢，定义decorator时已经传递了一个函数作为参数，难道再传递一个？可以试试会发生什么，^_^。
一个有效的做法是，再包裹一层就可以了

```python
from functools import wraps
def decorator_out(name="decorator_out"):
    def decorator(func):
        @wraps(func)
        def wrap_func(args):
            print("before")
            print(args)
            print(name)
            func(args)
            print("after")  
        return wrap_func
    return decorator
@decorator_out(name="decorator_out") # 此处name参数为可选
def func(value):
    print("func", value)
func("go")
```

```
>before
>go
>decorator_out
>func go
>after
```

此外也有更加灵活的装饰器类

```python
from functools import wraps
 
class logit(object):
    def __init__(self, logfile='out.log'):
        self.logfile = logfile
 
    def __call__(self, func):
        @wraps(func)
        def wrapped_function(*args, **kwargs):
            log_string = func.__name__ + " was called"
            print(log_string)
            # 打开logfile并写入
            with open(self.logfile, 'a') as opened_file:
                # 现在将日志打到指定的文件
                opened_file.write(log_string + '\n')
            # 现在，发送一个通知
            self.notify()
            return func(*args, **kwargs)
        return wrapped_function
 
    def notify(self):
        # logit只打日志，不做别的
        pass
```

并且它可以被继承：

```python
class email_logit(logit):
    '''
    一个logit的实现版本，可以在函数调用时发送email给管理员
    '''
    def __init__(self, email='admin@myproject.com', *args, **kwargs):
        self.email = email
        super(email_logit, self).__init__(*args, **kwargs)
 
    def notify(self):
        # 发送一封email到self.email
        # 这里就不做实现了
        pass
```

```python
@logit() # 此处logfile参数为可选，相当于构造logit
def myfunc1():
    pass
a = myfunc1()
```