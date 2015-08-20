---

layout: post
title:  Java 连接 MySQL
date:   2015-06-30 22:10:00
categories: J2EE

---
1. 下载对应Java的MySQL驱动包，在[官方下载地址][MYSQL connector]{:target="_blank"}页面上选择Java对应的 Connector/J。进入下载页面，选择Platform为Platform Independent，下载压缩包，压缩包下的mysql-connector-java-XXX.jar即为我们需要的jar包。
2. 添加jar包
3. 完整代码如下

~~~

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class TestConnectMySQL {

    /**
     * Database URL        ---> "localhost"
     * Port                ---> "3306"
     * Schema(database)    ---> "test"
     * User                ---> "root" 
     * Password            ---> ""
     *                     
     * @param sql
     */
    public static void querySQL(String sql) {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        try {
            // Load driver
            Class.forName("com.mysql.jdbc.Driver");

            // Connect and get connection
            String url = "jdbc:mysql://localhost:3306/test";
            connection = DriverManager.getConnection(url, "root", "");

            // Prepare for the compiled sql statement
            preparedStatement = connection.prepareCall(sql);
            // preparedStatement.setString(1, "paramter");

            // Execute and get the resultSet
            resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                // int id = resultSet.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    public static void main(String[] args) {
        String sql = "SELECT * FROM `user`"; // 其中`为反引号，字段和表名都应该加上
        TestConnectMySQL.querySQL(sql);
    }
}

~~~

[MYSQL connector]: http://dev.mysql.com/downloads/connector/
