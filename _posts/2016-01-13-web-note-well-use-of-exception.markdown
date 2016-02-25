---

layout: post
title:  Web Note - Well Use Of Exception
date:   2016-01-12 17:10:00
categories: [j2ee]
tags: [j2ee, web-note， web-]

---
## 用好异常
获取调用方法信息的方式：

方法一. 利用方法的返回值。  
方法二. 利用调用方法时传递给方法的参数。  
方法三. 利用异常。

实际项目中一般用到方法一和方法三就足够了，正面的业务逻辑通过方法的返回值来进行参数的传递，如登陆时帐号和密码均正确的情况，反面的业务逻辑，或数据格式检查的业务逻辑通过异常来传递信息。

方法三实际代码如下：

~~~ Java
public class UserService {

    public User login(String name, String password) throws IllegalParamterException, ServiceException {
        IllegalParamterException illegalParamterException = new IllegalParamterException();
        if (StringUtils.isNullOrEmpty(name)) {
            illegalParamterException.addIllegalFields("name", "name is required");
        }

        if (StringUtils.isNullOrEmpty(password)) {
            illegalParamterException.addIllegalFields("password", "password is required");
        }

        if (illegalParamterException.hasIllegalField()) {
            throw illegalParamterException;
        }
        User user = new UserDao().getUserByName(name);
        if (user == null || !password.equals(user.getPassword())) {
            throw new ServiceException(1000, "Name or password wrong");
        } else {
            return user;
        }
    }
}

~~~
~~~ Java
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    String name = request.getParameter("name");
    String password = request.getParameter("password");

    User user = null;
    try {
        user = new UserService().login(name, password);
        user.setPassword(null);
        HttpSession httpSession = request.getSession();
        httpSession.setAttribute(Constants.USER, user);
        response.sendRedirect(request.getContextPath()+ "/showmybook");;
    } catch (IllegalParamterException e) {
        Map<String, String> illegalFields = e.getIllegalFields();
        request.setAttribute(Constants.ILLEGAL_FIELDS, illegalFields);
        request.getRequestDispatcher(LOGIN_PAGE).forward(request, response);
        return;
    } catch (ServiceException e) {
        request.setAttribute(Constants.TIP_MESSAGE, e.getMessage() + "[" + e.getCode() + "]");
        request.getRequestDispatcher(LOGIN_PAGE).forward(request, response);
    }
}
~~~
