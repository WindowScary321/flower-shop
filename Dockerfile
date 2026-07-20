# Stage 0: Cung cấp thư viện Tomcat (Servlet API) cho Ant build
FROM tomcat:10.1.57-jre21-temurin-noble AS tomcat_libs

# Stage 1: Build file WAR bằng JDK (Bypass Ant để tránh lỗi thư viện NetBeans)
FROM eclipse-temurin:21-jdk AS builder
WORKDIR /app

# Lấy bộ thư viện Java EE của Tomcat
COPY --from=tomcat_libs /usr/local/tomcat/lib /usr/local/tomcat/lib

COPY . .

# Tự biên dịch và đóng gói WAR bằng công cụ chuẩn của Java (javac & jar)
RUN mkdir -p dist build/web/WEB-INF/classes build/web/WEB-INF/lib && \
    cp -r web/* build/web/ && \
    cp -r lib/* build/web/WEB-INF/lib/ 2>/dev/null || true && \
    cp -r src/java/* build/web/WEB-INF/classes/ 2>/dev/null || true && \
    find build/web/WEB-INF/classes/ -name "*.java" -type f -delete && \
    javac -encoding UTF-8 -cp "build/web/WEB-INF/lib/*:/usr/local/tomcat/lib/*" -d build/web/WEB-INF/classes $(find src/java -name "*.java") && \
    cd build/web && jar -cvf /app/dist/flower-shop.war .

# Triển khai trên Tomcat
FROM tomcat:10.1.57-jre25-temurin-noble

# Xóa các ứng dụng mặc định của Tomcat để dọn dẹp
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy file WAR đã được build từ stage builder vào thư mục webapps với tên ROOT.war để chạy ở trang chủ (/)
COPY --from=builder /app/dist/flower-shop.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
