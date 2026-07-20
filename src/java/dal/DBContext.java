package dal;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author FPT University - PRJ30X
 */
public class DBContext implements AutoCloseable {
    protected Connection connection;
    public DBContext() {
        //@Students: You are not allowed to edit this method  
        try {
            String url = System.getenv("DB_URL");
            String user = System.getenv("DB_USER");
            String pass = System.getenv("DB_PASSWORD");
            
            if (url == null || url.trim().isEmpty() || user == null || pass == null) {
                Properties properties = new Properties();
                InputStream inputStream = getClass().getClassLoader().getResourceAsStream("ConnectDB.properties");
                if (inputStream != null) {
                    try {
                        properties.load(inputStream);
                    } catch (IOException ex) {
                        Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                user = properties.getProperty("userID");
                pass = properties.getProperty("password");
                url = properties.getProperty("url");
            }
            
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url, user, pass);
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public void close() {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }
}
