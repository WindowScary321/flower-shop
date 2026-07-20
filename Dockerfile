# Build file WAR bằng JDK và Ant
FROM eclipse-temurin:21-jdk AS builder
RUN apt-get update && apt-get install -y ant
WORKDIR /app
COPY . .
RUN ant

# Triển khai trên Tomcat
FROM tomcat:10.1.57-jre25-temurin-noble

# Xóa các ứng dụng mặc định của Tomcat để dọn dẹp
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy file WAR đã được build từ stage builder vào thư mục webapps
COPY --from=builder /app/dist/flower-shop.war /usr/local/tomcat/webapps/flower-shop.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
