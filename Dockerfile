# Stage 0: Cung cấp thư viện Tomcat (Servlet API) cho Ant build
FROM tomcat:10.1.57-jre21-temurin-noble AS tomcat_libs

# Stage 1: Build file WAR bằng JDK và Ant
FROM eclipse-temurin:21-jdk AS builder
RUN apt-get update && apt-get install -y ant wget
WORKDIR /app

# Lấy bộ thư viện Java EE của Tomcat bỏ vào Builder
COPY --from=tomcat_libs /usr/local/tomcat /usr/local/tomcat

# Tải công cụ CopyLibs của NetBeans để hỗ trợ biên dịch file WAR
RUN wget -qO /tmp/copylibstask.jar https://repo1.maven.org/maven2/org/netbeans/api/org-netbeans-modules-java-j2seproject-copylibstask/RELEASE126/org-netbeans-modules-java-j2seproject-copylibstask-RELEASE126.jar

COPY . .
# Chạy build Ant và chỉ định đường dẫn Tomcat cho NetBeans
RUN ant -Dj2ee.server.home=/usr/local/tomcat -Dlibs.CopyLibs.classpath=/tmp/copylibstask.jar

# Triển khai trên Tomcat
FROM tomcat:10.1.57-jre25-temurin-noble

# Xóa các ứng dụng mặc định của Tomcat để dọn dẹp
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy file WAR đã được build từ stage builder vào thư mục webapps
COPY --from=builder /app/dist/flower-shop.war /usr/local/tomcat/webapps/flower-shop.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
