---

layout: post
title:  C - Dynamical Loading
date:   2016-05-13 14:58:00
categories: [Gramar]
tags: [gramar, c]

---

## 动态链接：

动态链接分为装载时动态链接和运行时动态链接，在64位环境下编译32位动态链接库如下（32位下只需去掉-m32 这个编译选项）

**libexample.h**

``` C
#ifndef _LIB_EXAMPLE_H_
#define _LIB_EXAMPLE_H_
#define SUCCESS 0
#define FAILURE (-1)
#ifdef __cplusplus
extern "C" {
#endif
int LibApi();
#ifdef __cplusplus
}
#endif
#endif /* _LIB_EXAMPLE_H_ */
```

**libexample.c**

``` C
#include <stdio.h>
#include "libexample.h"
int LibApi() {
    printf("This Is A Library Api!\n");
    return SUCCESS;
}
```

`gcc -shared libexample.c -o liblibexample.so -m32`

注意这里编译成的.so文件命名规则是源文件前面加上lib即libample -> liblibexample。
无论是装载时动态链接还是运行时动态链接，库文件的编译方法都是一样的，区别在于怎么使用它们。

**装载时的动态链接举例**

``` C
#include <stdio.h>
#include "libexample.h"
int main() {
  printf("This is a main program!\n");
  LibApi();
  return SUCCESS;
}
```
```
gcc main.c -o main -L/path/to/your/dir -llibexample -m32
# 编译main，/path/to/your/dir可用.代替。
# 注意这里只提供libexample的-L（库对应的接口头文件所在目录）和-l（库名，如liblibexample.so去掉lib和.so的部分）。
$ export LD_LIBRARY_PATH=$PWD
# 将当前目录加入默认路径，否则main找不到依赖的库文件，当然也可以将库文件copy到默认路径下。
$ ./main
```

**运行时的动态链接举例**

``` C
#include <stdio.h>
#include <dlfcn.h>

#define SUCCESS 0
#define FAILURE (-1)
int main() {
    printf("This is a main program!\n");
    void * handle = dlopen("liblibexample.so",RTLD_NOW);
    if(handle == NULL) {
        printf("open lib liblibexample.so error :%s\n",dlerror());
        return FAILURE;
    }
    int (*func)(void);
    char * error;
    func = dlsym(handle,"LibApi");
    if ((error = dlerror()) != NULL) {
        printf("LibApi not found:%s\n",error);
    }
    func();
    dlclose(handle);
    return SUCCESS;
}
```
```
gcc main.c -o main -ldl -m32
# -ldl选项，表示生成的对象模块使用运行时动态链接。
$ export LD_LIBRARY_PATH=$PWD
# 将当前目录加入默认路径，否则main找不到依赖的库文件，当然也可以将库文件copy到默认路径下。
$ ./main
```
