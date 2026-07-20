FROM tomcat:10.1.57-jre25-temurin-noble

# Xóa các ứng dụng mặc định của Tomcat để dọn dẹp
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy file WAR đã được build vào thư mục webapps
COPY dist/flower-shop.war /usr/local/tomcat/webapps/flower-shop.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
