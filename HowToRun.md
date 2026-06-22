# Cách chạy dự án
- Thêm maven wrapper:
    ```
    mvn wrapper:wrapper
    ```
- Cài đặt dependency:
    ```
    mvn dependency:resolve
    ```
- Chạy live server:
    ```
    mvn cargo:run
    ```
- Reload server (sửa file html, jsp, css, js)
    ```
    mvn war:exploded
    ```
- Reload server (sửa file java, servlet)
    ```
    mvn compile war:exploded
    ```