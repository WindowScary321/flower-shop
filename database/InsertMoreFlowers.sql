USE FLOWER_SHOP;
GO

-- Thêm các danh mục nếu chưa tồn tại
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Hoa khai trương')
    INSERT INTO Categories (CategoryName, Description) VALUES (N'Hoa khai trương', N'Danh mục Hoa khai trương');
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Hoa Chúc Mừng')
    INSERT INTO Categories (CategoryName, Description) VALUES (N'Hoa Chúc Mừng', N'Danh mục Hoa Chúc Mừng');
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Hoa cưới')
    INSERT INTO Categories (CategoryName, Description) VALUES (N'Hoa cưới', N'Danh mục Hoa cưới');
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Hoa Valentine')
    INSERT INTO Categories (CategoryName, Description) VALUES (N'Hoa Valentine', N'Danh mục Hoa Valentine');
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Hoa Kỷ Niệm Ngày Cưới')
    INSERT INTO Categories (CategoryName, Description) VALUES (N'Hoa Kỷ Niệm Ngày Cưới', N'Danh mục Hoa Kỷ Niệm Ngày Cưới');
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Hoa 8/3')
    INSERT INTO Categories (CategoryName, Description) VALUES (N'Hoa 8/3', N'Danh mục Hoa 8/3');
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Hoa 20/10')
    INSERT INTO Categories (CategoryName, Description) VALUES (N'Hoa 20/10', N'Danh mục Hoa 20/10');
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'Hoa 20/11')
    INSERT INTO Categories (CategoryName, Description) VALUES (N'Hoa 20/11', N'Danh mục Hoa 20/11');

GO

-- Thêm các sản phẩm hoa mới
INSERT INTO Flowers (FlowerName, Unit, Price, Quantity, Image, Description, CategoryId, Discount) VALUES
(N'Giỏ hoa mộng mơ', N'Bó', 2700000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/August%202022/gio-hoa-mong-mo.jpg.webp', N'<p style="text-align:justify"><span style="font-size:14px">Giỏ hoa với tone màu xanh mát lạ mắt từ các loài hoa cúc mẫu đơn, green wicky kết hợp hài hòa cùng hoa hồng champagne và các loại hoa lá phụ cao cấp. Giỏ hoa là lựa chọn tuyệt vời để gửi tặng người thân, đối tác vào những dịp đặc biệt.</span></p>
<p style="text-align:justify"><span style="font-size:14px"><strong>Giỏ hoa Mộng Mơ được thiết kế từ:</strong></span></p>
<ul>
<li style="text-align:justify"><span style="font-size:14px">Cúc mẫu đơn xanh: 5 cành</span></li>
<li style="text-align:justify"><span style="font-size:14px">Cúc tia xanh: 5 cành</span></li>
<li style="text-align:justify"><span style="font-size:14px">Thuỷ Tiên vàng: 10 cành</span></li>
<li style="text-align:justify"><span style="font-size:14px">Thiên nga trắng: 10 cành</span></li>
<li style="text-align:justify"><span style="font-size:14px">Green wicky: 5 cành</span></li>
<li style="text-align:justify"><span style="font-size:14px">Cúc ping pong trắng: 5 cành </span></li>
<li style="text-align:justify"><span style="font-size:14px">Thủy tiên trắng: 10 cành</span></li>
<li style="text-align:justify"><span style="font-size:14px">Hồng Mondial: 15 cành</span></li>
<li style="text-align:justify"><span style="font-size:14px">Hoa cát tường: 10 cành</span></li>
<li style="text-align:justify"><span style="font-size:14px">Đồng tiền tia trắng: 10 cành</span></li>
<li style="text-align:justify"><span style="font-size:14px">Các loại hoa lá phụ khác: Cỏ tia, cỏ đồng tiền, cúc xanh nhí, lá bạc tròn, hoa cà rốt.</span></li>
</ul>
<p style="text-align:justify"><span style="font-size:14px"><strong>Lưu ý:</strong></span></p>
<p style="text-align:justify"><span style="font-size:14px"><em>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</em></span></p>
<p style="text-align:justify"><span style="font-size:14px"><em>** Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm.</em></span></p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa Chúc Mừng'), 0),
(N'Tia Hi Vọng', N'Bó', 1390000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/L%E1%BA%B5ng%20Hoa/tia-hi-vong-26.jpg.webp', N'<p style="text-align:justify"><span style="font-size:14px"><span style="font-family:Tahoma,Geneva,sans-serif">Lẵng <a href="https://www.flowercorner.vn/hoa-khai-truong" target="_blank">hoa khai trương</a> Tia Hi Vọng mang tông màu sáng đầy vui tươi, ngập tràn ánh nắng và niềm vui hân hoan sẽ giúp bạn gửi đến đối tác, doanh nghiệp những lời chúc chân thành và hoan hỉ nhất. Luôn tỏa sáng và hướng đến tương lai tươi đẹp cũng là ý nghĩa</span></span></p>
<p style="text-align:justify"><strong><span style="font-size:14px"><span style="font-family:Tahoma,Geneva,sans-serif">Lẵng <a href="https://www.flowercorner.vn/hoa-khai-truong" target="_blank">hoa khai trương</a> Tia Hi Vọng được thiết kế từ:</span></span></strong></p>
<ul>
<li style="text-align:justify"><span style="font-size:14px"><span style="font-family:Tahoma,Geneva,sans-serif">Green Wicky: 8 cành </span></span></li>
<li style="text-align:justify"><span style="font-size:14px"><span style="font-family:Tahoma,Geneva,sans-serif">Hoa hồng trắng: 10 cành </span></span></li>
<li style="text-align:justify"><span style="font-size:14px"><span style="font-family:Tahoma,Geneva,sans-serif">Hoa cẩm tú cầu xanh: 12 cành </span></span></li>
<li style="text-align:justify"><span style="font-size:14px"><span style="font-family:Tahoma,Geneva,sans-serif">Sen đá size lớn: 1</span></span></li>
<li style="text-align:justify"><span style="font-size:14px"><span style="font-family:Tahoma,Geneva,sans-serif">Cát tường trắng: 10</span></span></li>
<li style="text-align:justify"><span style="font-size:14px"><span style="font-family:Tahoma,Geneva,sans-serif">Các loại hoa lá phụ: cỏ đồng tiền, lác bạc, lá dương xỉ</span></span></li>
</ul>
<p>Lưu ý:</p>
<p>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</p>
<p>**Vì các loài hoa thay đổi theo mùa nên shop đảm bảo các loại hoa chính, còn các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm.</p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa Chúc Mừng'), 0),
(N'Lẵng Hoa Công Danh', N'Bó', 1190000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/Autumn_2024/ARRANG-4251.jpg.webp', N'<p style="text-align:justify">Lẵng hoa công danh được thiết kế với tone màu thật nhã nhặn từ hoa cát tường trắng tinh tế và thanh nhã, từ hoa tana vàng hiện đại, hoa tú cầu xanh mát. Màu vàng tượng trưng cho sự thịnh vượng, phát triển. Lẵng hoa công danh là lựa chọn hoàn hảo để dành tặng cho đối tác trong dịp khai trương, và cũng là lựa chọn phù hợp để làm quà tặng cho cấp trên trong dịp sinh nhật.</p>
<p style="text-align:justify"><strong>Lẵng Hoa Công Danh được thiết kế từ :</strong></p>
<ul>
<li>Cát tường trắng phun xanh: 12 cành </li>
<li>Cát tường phớt hồng: 10 cành </li>
<li>Hoa Cẩm Tú Cầu : 5 cành </li>
<li>Cúc Tana: 3 cành </li>
<li>Các loại lá phụ : lá bạc , lá bạc nhí .</li>
</ul>
<p>Lưu ý:</p>
<p>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</p>
<p>** Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm.</p>
<p style="text-align:justify"> </p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa Chúc Mừng'), 0),
(N'Bright sky', N'Bó', 940000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/L%E1%BA%B5ng%20Hoa/bright-sky.jpg.webp', N'<p style="text-align:justify">Ban mai nắng thu được tạo nên từ những bông hoa hồng kem, cẩm chướng đơn hồng xinh xắn. Lẵng hoa thích hợp dành tặng những dịp chúc mừng, mừng tân gia, trang trí nhà...</p>
<p style="text-align:justify"><strong>Bright sky được thiết kế từ:</strong></p>
<ul>
<li>Hoa hồng kem: 20</li>
<li>Hoa cẩm chướng đơn hồng: 15</li>
<li>Lá bạc nhí</li>
</ul>
<p> </p>
<p> </p>
<p> </p>
<p> </p>
<p> </p>
<p> </p>
<p> </p>
<p> </p>
<p> </p>
<p> </p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa Chúc Mừng'), 0),
(N'Lẵng Hoa Xanh Yêu Thương', N'Bó', 1490000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/L%E1%BA%B5ng%20Hoa/lang-hoa-xanh-yeu-thuong.jpg.webp', N'<p><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px">Giỏ hoa Xanh yêu thương được kết hợp từ hồng phun xanh, hoa đồng tiền trắng, hoa pingpong, hoa ly trắng và các loại lá phụ trang trí khác. Giỏ hoa thích hợp dành tặng cho những người thân yêu của bạn. Hãy làm cho người nhận cảm thấy hạnh phúc và được yêu thương khi nhận được giỏ hoa này nhé.</span></span></p>
<p><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px"><strong>Lẵng Hoa Xanh Yêu Thương được thiết kế từ:</strong></span></span></p>
<ul>
<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px">Hoa hồng trắng phun xanh: 15 cành </span></span></li>
<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px">Hoa đồng tiền trắng: 15 cành </span></span></li>
<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px">Hoa cát tường trắng: 10 cành</span></span></li>
<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px">Hoa cúc calimero trắng: 4 cành</span></span></li>
<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px">Hoa cúc ping pong trắng: 3 cành </span></span></li>
<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px">Hoa mõm sói trắng: 10 cành </span></span></li>
<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px">Cúc tia xanh: 5 cành </span></span></li>
<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px">Các loại hoa lá phụ: Lá chanh, lá bạc Trung</span></span></li>
</ul>
<p><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px"><strong>Lưu ý:</strong></span></span></p>
<p><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px"><em>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</em></span></span></p>
<p><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px"><em>** Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm.</em></span></span></p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa Chúc Mừng'), 0),
(N'Mẫu Đơn Cho Em', N'Bó', 1810000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/mau-don-hong-26.jpg.webp', N'<p style="text-align:justify">Hoa mẫu đơn được mệnh danh là "quốc sắc thiên hương", là loài hoa của sự vương giả, thanh cao và sắc đẹp bậc nhất. Một bông mẫu đơn khi nở rộ sẽ tỏa hương thơm ngát và kích thước vô cùng lớn.  Ý nghĩa hoa mẫu đơn thể hiện cho sức mạnh, quyền uy và sự vương giả, giàu sang phú quý. Chính vì vậy, nhiều người thường chọn mẫu đơn làm hoa khai trương hoặc tặng sinh nhật với mong ước người nhận sẽ đạt được nhiều hạnh phúc, thành công trong cuộc sống. </p>
<p style="text-align:justify"><strong>Bó Hoa Mẫu Đơn Cho Em được thiết kế từ</strong></p>
<ul>
<li>Hoa mẫu đơn: 3 cành</li>
<li>Thúy châu: 0.5</li>
<li>Cúc tana: 3 cành</li>
<li>Các loại hoa lá phụ</li>
</ul>
<p><em>*Sản phẩm cần đặt trước 1-2 ngày</em></p>
<p><em>*Sản phẩm chỉ có tại HCM.</em></p>
<p><em>Lưu ý</em></p>
<p><em>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</em></p>
<p><em>** Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm.</em></p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa Chúc Mừng'), 10),
(N'Riêng Mình Em', N'Bó', 710000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/bo-hoa-hong-do-rieng-minh-em.jpg.webp', N'<p>Bó hoa với thiết kế đặt biệt từ những cánh hồng đỏ tươi đầy rực rỡ cùng 1 cánh hồng trắng đầy tinh khôi nổi bật ngay giữa. Bó hoa tượng trưng cho thông điệp " Em là tình yêu duy nhất của cuộc đời anh, dù có chuyện gì xảy ra, dù buồn hay vui anh vẩn ở cạnh em đến cuối con đường". Đừng đợi chờ bạn nhé, hãy để bó hoa thay bạn nói những lời yêu thương ngọt ngào nhất.</p>
<p>Bó hoa bao gồm có:</p>
<ul>
<li>25 hoa  hồng đỏ</li>
</ul>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa Valentine'), 10),
(N'Bó Hoa Rực Rỡ', N'Bó', 2340000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/August%202023/bo-hoa-ruc-ro.jpg.webp', N'<p>Bó hoa gồm 100 bông hồng đỏ tươi rực rỡ được đặt trong viền hoa baby trắng tinh khiết kèm giấy gói tông nâu kem như một lời nhắn gửi yêu thương đầy chân thành nhưng cũng không kém phần mãnh liệt. Giữa cuộc sống đầy thử thách, bó hoa này sẽ thay bạn gửi lời yêu thương đến người tặng và tiếp thêm sức mạnh cho người ấy đấy.</p>
<p><strong>Bó Hoa Rực Rỡ được thiết kế từ:</strong></p>
<ul>
<li>100 bông hồng đỏ</li>
</ul>
<p>Lưu ý:</p>
<p>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</p>
<p>** Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm.</p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa Valentine'), 0),
(N'Kiều Diễm', N'Bó', 490000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/August%202023/bo-hoa-hong-do-kieu-diem.jpg.webp', N'<p style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px">Bó hoa được thiết kế với 12 bông hồng đỏ, chuỗi ngọc đỏ và lá bạc. Hoa hồng đỏ nồng nhiệt và rực rỡ là quà tặng hoàn hảo dành cho vợ, bạn gái trong những dịp đặc biệt.</span></span></p>
<p style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px"><strong>Bó Hoa Kiều Diễm được thiết kế từ</strong></span></span></p>
<ul>
<li style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px">Hoa hồng đỏ: 12 cành</span></span></li>
<li style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px">Chuỗi ngọc đỏ: 5 cành</span></span></li>
<li style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px">Các loại hoa lá phụ: Lá bạc</span></span></li>
</ul>
<p><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px"><strong><em>Lưu ý</em></strong></span></span></p>
<p><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px"><em>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</em></span></span></p>
<p><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px"><em>**Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm.</em></span></span></p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa Valentine'), 6),
(N'Ẩn Dấu', N'Bó', 490000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/bo-hoa-hong-do-an-dau-n.jpg.webp', N'<p style="text-align:justify"><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif">Bình <a href="https://www.flowercorner.vn/hoa-hong" target="_blank">hoa hồng</a> đỏ kết hợp cùng các loại hoa phụ đầy dễ thương và tinh tế. Hãy cùng <a href="https://www.flowercorner.vn/">FlowerCorner</a> nói lời yêu thương đến một người đặc biệt đã luôn ở cạnh bên, quan tâm chia sẻ và động viên bạn nhé.</span></span></p>
<p style="text-align:justify"><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><strong>Bó hoa Ẩn Dấu được thiết kế từ:</strong></span></span></p>
<ul>
<li><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif">Hoa hồng đỏ: 12 cành</span></span></li>
<li><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif">Các loại hoa lá phụ: Sao tím</span></span></li>
</ul>
<p><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><strong><em>Lưu ý:</em></strong></span></span></p>
<p><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><em>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</em></span></span></p>
<p><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><em>** Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm.</em></span></span></p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa Valentine'), 6),
(N'Ngày Rực Rỡ', N'Bó', 1390000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/August%202023/Ngay-Ruc-Ro.jpg.webp', N'<p><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif">Dù ở bất kỳ nơi nào thì hoa hồng đỏ đều xuất hiện với biểu tượng đại diện cho một tình yêu nồng nàn, lãng mạn, say đắm. Hoa hồng đỏ truyền tải những cảm xúc sâu sắc – có thể là tình yêu, sự mong đợi hoặc khát khao. Bó hoa Ngày Rực Rỡ với thiết kế từ 50 bông hoa hồng đỏ sẽ là món quà ý nghĩa và khó quên dành tặng nửa kia của bạn đấy.</span></span></p>
<p><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><strong>Bó hoa Ngày Rực Rỡ được thiết kế từ</strong></span></span></p>
<ul>
<li><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif">Hoa hồng đỏ: 50 cành</span></span></li>
<li><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif">Các loại hoa lá phụ: Lá bạc</span></span></li>
</ul>
<p><em>Lưu ý</em></p>
<p><em>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</em></p>
<p><em>** Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm.</em></p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa Valentine'), 0),
(N'Bó hoa 08.03 - 09', N'Bó', 820000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/Ch%C6%B0a%20c%C3%B3%20t%C3%AAn%20%28Trang%20web%29%20%2846%29.png.webp', N'<p>Bó hoa với thiết kế đặt biệt từ những cánh hồng đỏ tươi đầy rực rỡ cùng 1 cánh hồng trắng đầy tinh khôi nổi bật ngay giữa. Bó hoa tượng trưng cho thông điệp " Em là tình yêu duy nhất của cuộc đời anh, dù có chuyện gì xảy ra, dù buồn hay vui anh vẩn ở cạnh em đến cuối con đường". Đừng đợi chờ bạn nhé, hãy để bó hoa thay bạn nói những lời yêu thương ngọt ngào nhất.</p>
<p>Bó hoa bao gồm có:</p>
<ul>
<li>25 hoa hồng đỏ</li>
</ul>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa Valentine'), 0),
(N'Dreamy Love', N'Bó', 580000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/Ch%C6%B0a%20c%C3%B3%20t%C3%AAn%20%28Trang%20web%29%20%2879%29.png.webp', N'<p><strong>Bó Hoa Dreamy Love bao gồm:</strong></p>
<ul>
<li>Hoa hồng đỏ pháp: 15 cành</li>
</ul>
<p><strong><em>Lưu ý</em></strong></p>
<p><em>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</em></p>
<p><em>** Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm.</em></p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa Valentine'), 0),
(N'Ti Amo', N'Bó', 580000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/Ch%C6%B0a%20c%C3%B3%20t%C3%AAn%20%28Trang%20web%29%20%2847%29.png.webp', N'<p style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif">Bó hoa Ti Amo được thiết kế với từ 15 bông hoa hồng đỏ kết hợp với các loại lá phụ. Trong tình yêu, 15 bông hoa hồng đỏ mang thông điệp:"Tình yêu của Anh kéo dài theo năm tháng". Bó hoa Ti Amo là lựa chọn hoàn hảo để gửi tặng vợ, bạn gái trong ngày sinh nhật hay ngày lễ tình nhân valentine. </span></p>
<p style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><strong>Bó hoa Ti Amo được thiết kế từ</strong></span></p>
<ul>
<li><span style="font-family:Arial,Helvetica,sans-serif">Hoa hồng đỏ: 15 cành</span></li>
<li><span style="font-family:Arial,Helvetica,sans-serif">Các loại hoa lá phụ: Lá chanh</span></li>
</ul>
<p><span style="font-family:Arial,Helvetica,sans-serif"><strong><em>Lưu ý:</em></strong></span></p>
<p><span style="font-family:Arial,Helvetica,sans-serif"><em>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</em></span></p>
<p><span style="font-family:Arial,Helvetica,sans-serif"><em>** Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm.</em></span></p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa Valentine'), 0),
(N'Red Wine', N'Bó', 560000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/August%202023/bo-hoa-hong-do-red-wine.jpg.webp', N'<p style="text-align:justify"><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif">Hoa hồng vốn mang rất nhiều ý nghĩa về cuộc sống lẫn tình yêu. Như một ly rượu vang hảo hạn, bó hoa nở rộ mang sắc đỏ làm bao nàng ngất ngây và say mê. Đây sẽ là một món quà mang tính biểu tượng của một tình yêu vừa mạnh mẽ lại vừa trường tồn theo thời gian.</span></span></p>
<p style="text-align:justify"><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><strong>Bó Hoa Hồng Red Wine được thiết kế từ</strong></span></span></p>
<ul>
<li><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif">Hoa hồng đỏ: 15 cành</span></span></li>
<li><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif">Các loại hoa lá phụ</span></span></li>
</ul>
<p><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><strong><em>Lưu ý:</em></strong></span></span></p>
<p><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><em>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</em></span></span></p>
<p><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><em>** Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm.</em></span></span></p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa Valentine'), 5),
(N'Hồng Dịu Dàng', N'Bó', 570000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/hong-diu-dang-v3.jpg.webp', N'<p style="text-align:start"><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif">Có khi nhớ lắm một nụ cười ai đó nhưng ngại ngùng không muốn nói, có khi cần lắm một bàn tay ấm áp dịu dàng nhưng lại ở quá xa, có khi yêu lắm một ánh nhìn đầy đáng yêu, lãng mạn. Những giây phút ấy hẳn sẽ không bao giờ có thể quên, vì vật hãy tạo thêm những giây phút yêu đầu đầy hạnh phúc và bất ngờ cho người bạn yêu nhé. Tặng ngay cho người ấy một bó hoa lãng mạn với 15 hồng kem pastel thật ngọt ngào này nha.</span></span></p>
<p style="text-align:start"><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><strong>Bó hoa Hồng Dịu Dàng được thiết kế từ</strong></span></span></p>
<ul>
<li><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif">Hoa hồng kem: 15 cành</span></span></li>
<li><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif">Các loại hoa lá phụ: Cúc thạch thảo, cỏ đồng tiền</span></span></li>
</ul>
<p><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><strong><em>Lưu ý:</em></strong></span></span></p>
<p><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><em>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</em></span></span></p>
<p><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><em>** Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm.</em></span></span></p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa Valentine'), 7),
(N'Khúc Tình Ca', N'Bó', 760000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/August%202023/khuc-tinh-ca.jpg.webp', N'<p style="text-align:justify">Bó hoa tone hồng nhẹ nhàng được thiết kế từ các loài hoa cúc ping pong, hoa hồng kem dâu kết hợp với cát tường xoăn trắng là lựa chọn hoàn hảo để gửi đến những người phụ nữ mà bạn yêu thương vào những dịp đặc biệt.</p>
<p style="text-align:justify"><strong>Bó hoa Khúc Tình Ca được thiết kế từ:</strong></p>
<ul>
<li>Hoa cúc ping pong: 10 cành</li>
<li>Hoa hồng pastel: 5 cành</li>
<li>Hoa cát tường: 10 cành</li>
</ul>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa Kỷ Niệm Ngày Cưới'), 0),
(N'Capuchino Bé Nhỏ', N'Bó', 770000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/cappu-be-nho.jpg.webp', N'<p><strong>Bó hoa Capuchino Bé Nhỏ được thiết kế từ:</strong></p>
<p>Hoa capuchino: 25 cành</p>
<p><strong>Lưu ý:</strong></p>
<p>**Đối với các loại hoa nhập khẩu, Flowercorner.vn khuyến khích khách hàng đặt trước 1-2 ngày để đảm bảo sản phẩm được chuẩn bị chỉnh chu nhất.</p>
<p>**Do tính chất mùa vụ, một số loại hoa phụ có thể hết hàng do hết mùa. Trong trường này, FlowerCorner.vn sẽ chủ động thông báo cho khách hàng và thay thế bằng loại hoa, lá phụ tương tự.</p>
<p>**Vì sản phẩm được làm thủ công nên sản phẩm thực tế nhận được sẽ có đôi chút khác biệt so với hình mẫu. Flowercorner.vn cam kết sản phẩm thực tế sẽ giống khoảng 80% so với hình ảnh mẫu.</p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa Kỷ Niệm Ngày Cưới'), 0),
(N'Sweet Candy', N'Bó', 2860000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/Sweet-Candy-26.jpg.webp', N'<p>Sweet Candy là một bó hoa tuyệt vời dành tặng cho người thương của bạn trong những dịp đặc biệt với 100 đóa hồng Champagne ngọt ngào và quyến rũ.</p>
<p><strong>Bó hoa Sweet Candy được thiết kế từ  :</strong></p>
<ul>
<li>Tulip nhuộm tím nhạt: 10</li>
<li>Hồng môn mini tím: 3 cành </li>
<li>Hồng trằng cồ: 1</li>
<li>Phi yến tím nhạt: 2 cành </li>
<li>Thuỷ tiên trắng: 3 cành </li>
<li>Sao trắng: 5 </li>
<li>Sao xanh: 3 </li>
<li>Cát tường trắng xoăn: 5 cành </li>
<li>Clemantis hà lan </li>
</ul>
<p>Lưu ý:</p>
<p>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</p>
<p>** Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm.</p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa Kỷ Niệm Ngày Cưới'), 0),
(N'Tình Yêu Ngát Xanh', N'Bó', 820000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/August%202023/bo-hoa-hong-tinh-yeu-ngat-xanh-1.jpg.webp', N'<p style="text-align:justify">Hoa hồng với tông màu xanh vừa đẹp lại vừa dịu dàng, không mang vẻ kiêu sa như hồng đỏ, lãng mạn như hồng dâu nhưng <a href="https://www.flowercorner.vn/bo-hoa-hong-xanh">hoa hồng xanh</a> thể hiện một nét đẹp nhẹ nhàng, thanh thoát, mà cũng rất quyến rũ. Mỗi người phụ nữ đều có một nét đẹp riêng, bó hoa mang tông xanh dương này là một món quà cực kỳ phù hợp cho những người phụ nữ vừa thông minh hiện đại lại vừa quyến rũ nhẹ nhàng.</p>
<p style="text-align:justify"><strong>Bó hoaTình Yêu Ngát Xanh được thiết kế từ</strong></p>
<ul>
<li>Hoa hồng trắng phun xanh: 20 cành</li>
<li>Hoa baby trắng phun xanh: 150 gram</li>
<li>Các loại hoa lá phụ: Lá bạc</li>
</ul>
<p><em>Lưu ý</em></p>
<p><em>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</em></p>
<p><em>** Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm.</em></p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa Kỷ Niệm Ngày Cưới'), 0),
(N'Như Ý', N'Bó', 730000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/nhu-y-626.jpg.webp', N'<p style="text-align:justify"><span style="font-size:14px">Bó hoa Như Ý là sự kết hợp hoàn hảo giữa hoa sao xanh cùng với hoa chuông trắng. Một lựa chọn độc đáo, mới lạ để gửi tặng cho người ấy vào dịp sinh nhật, kỷ niệm ngày yêu, ngày cưới.</span></p>
<p style="text-align:justify"><span style="font-size:14px"><strong>Bó Hoa Như Ý được thiết kế từ</strong></span></p>
<ul>
<li><span style="font-size:14px">Hoa chuông trắng: 10</span></li>
<li><span style="font-size:14px">Hoa sao xanh: 10</span></li>
<li><span style="font-size:14px">Các loại hoa lá phụ</span></li>
</ul>
<p><span style="font-size:14px"><strong><em>Lưu ý:</em></strong></span></p>
<p><span style="font-size:14px"><em>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</em></span></p>
<p><span style="font-size:14px"><em>** Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm.</em></span></p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa Kỷ Niệm Ngày Cưới'), 0),
(N'Trang Nhã', N'Bó', 890000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/trang-nha-26.jpg.webp', N'<p style="text-align:justify">Lấy cảm hứng từ hình ảnh người con gái Việt Nam mang cốt cách dịu dàng, nết na và trang nhã, bó hoa Trang Nhã được ra đời với sự kết hợp hài hòa từ hoa hồng đỏ điểm xuyến thêm hoa baby trắng và mõm sói vàng, tạo nên một bó hoa khắc họa được rõ nét người phụ nữ Việt Nam thời hiện đại nhưng vẫn giữ được nét đẹp truyền thống.</p>
<p style="text-align:justify"><strong>Bó hoa </strong><strong>Trang Nhã được thiết kế từ</strong></p>
<ul>
<li>Hoa ly kép: 3 cành</li>
<li>Hoa cẩm chướng chùm: 10 cành</li>
<li>Các loại hoa lá phụ: cỏ suối, cỏ lan chi</li>
</ul>
<p><em>Lưu ý</em></p>
<p><em>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</em></p>
<p><em>** Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm.</em></p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa Kỷ Niệm Ngày Cưới'), 0),
(N'Gần Bên', N'Bó', 550000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/gan-ben.jpg.webp', N'<p style="text-align:justify"><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif">Bó hoa gần bên được thiết kế từ 12 cành hoa hồng xanh dương, loài hoa đại diện cho tình yêu vĩnh cửu, bền chặt. Bó hoa Gần Bên là lựa chọn hoàn hảo để tặng vợ, bạn gái vào dịp sinh nhật, hoặc bất cứ ngày lễ đặc biệt nào trong năm.</span></span></p>
<p style="text-align:justify"><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><strong>Bó Hoa Gần Bên được thiết kế từ</strong></span></span></p>
<ul>
<li><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif">Hoa hồng trắng phun xanh: 12 cành</span></span></li>
</ul>
<p><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><strong><em>Lưu ý:</em></strong></span></span></p>
<p><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><em>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</em></span></span></p>
<p><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><em>**Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm</em></span></span></p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa Kỷ Niệm Ngày Cưới'), 0),
(N'Năm Tháng', N'Bó', 740000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/nam-thang.jpg.webp', N'<p style="text-align:justify">Bó hoa Năm Tháng được thiết kế từ hoa hồng chùm kết hợp bướm gỗ. Đây là một trong những sản phẩm đang cực kỳ được ưa chuộng hiện nay. Đâu phải dễ tìm được một người yêu thương và luôn quan tâm đến mình, vì vậy hãy biết quí trọng và hãy để bó hồng giúp bạn gửi lời cảm ơn đầy chân thành đến họ nhé. Những bông hoa tươi ngọt ngào này tượng trưng cho tình yêu vừa đẹp, vừa ngọt ngào của bạn.</p>
<p style="text-align:justify"><strong>Bó Hoa Năm Tháng được thiết kế từ</strong></p>
<ul>
<li>Hoa hồng chùm: 10 cành</li>
<li>Bướm gỗ: 5 cành</li>
</ul>
<p><em>Lưu ý</em></p>
<p><em>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</em></p>
<p><em>** Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm.</em></p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa Kỷ Niệm Ngày Cưới'), 10),
(N'Yêu Thương Ngọt Ngào', N'Bó', 1490000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/Autumn_2024/yeu-thuong-ngot-ngao%20%281%29.jpg.webp', N'<p style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px">Bó hoa với thiết kế từ những bông hoa hồng lạc thần dễ thương đang rất được ưa chuộng. Bó hoa tượng trưng cho thông điệp "Em là tình yêu duy nhất và tình cảm của anh dành cho em là sâu sắc nhất, không chút tính toán hay do dự, có chuyện gì xảy ra, dù buồn hay vui anh vẩn ở cạnh em đến cuối con đường". Đừng đợi chờ bạn nhé, hãy để bó hoa thay bạn nói những lời yêu thương ngọt ngào nhất.</span></span></p>
<p style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px"><strong>Bó hoa Yêu Thương Ngọt Ngào được thiết kế từ:</strong></span></span></p>
<ul>
<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px">Hoa hồng Lạc Thần: 40 cành </span></span></li>
<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px">Hoa cát tường hồng phớt: 5 cành </span></span></li>
<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px">Các loại hoa lá phụ: Hoa voan, cỏ đồng tiền.</span></span></li>
</ul>
<p><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px"><strong>Lưu ý</strong></span></span></p>
<p><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px"><em>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</em></span></span></p>
<p><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px"><em>** Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm.</em></span></span></p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa Kỷ Niệm Ngày Cưới'), 0),
(N'Burning Love', N'Bó', 650000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/August%202023/bo-hoa-hong-do-burning-love.jpg.webp', N'<p><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif">Đẹp dịu dàng và trang nhã, bó hoa là sự lựa chọn thích hợp như một món quà thay lời tri ân gửi cho những người đã luôn yêu thương bạn. Bó hoa cũng có thể là lời cảm ơn đầy chân thành của những người con dành tặng cho mẹ của mình để đền đáp công ơn nuôi dạy của mẹ những tháng năm qua.</span></span></p>
<p><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><strong>Bó hoa Burning Love được thiết kế từ</strong></span></span></p>
<ul>
<li><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif">Hoa hồng đỏ: 20 cành</span></span></li>
<li><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif">Các loại hoa lá phụ: Lá bạc</span></span></li>
</ul>
<p><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><strong><em>Lưu ý:</em></strong></span></span></p>
<p><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><em>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</em></span></span></p>
<p><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><em>**Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm.</em></span></span></p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa 8/3'), 8),
(N'Ban Mai', N'Bó', 690000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/August%202023/bo-hoa-hong-ban-mai.jpg.webp', N'<p style="text-align:start"><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif">Tình yêu luôn là một tình cảm đầy diệu kì mà tinh khiết. Chỉ cần tình yêu, thế giới xung quanh bạn có thể trở thành một màu hồng đầy tươi sáng. Bó hoa được lấy cảm hứng từ vẻ đẹp của tình yêu đó, được tạo nên từ những cánh hồng với tông màu pastel cùng cát tường trắng và các loại hoa tươi nhất.</span></span></p>
<p style="text-align:start"><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><strong>Bó hoa Ban Mai được thiết kế từ</strong></span></span></p>
<ul>
<li><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif">Hoa hồng kem: 15 cành</span></span></li>
<li><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif">Hoa cát tường xanh: 5 cành</span></span></li>
<li><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif">Các loại hoa lá phụ: Lá bạc</span></span></li>
</ul>
<p><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><strong><em>Lưu ý:</em></strong></span></span></p>
<p><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><em>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</em></span></span></p>
<p><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><em>** Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm.</em></span></span></p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa 8/3'), 0),
(N'Enigma Roses', N'Bó', 2620000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/Spring%202024/enigma-roses.png.webp', N'<p><strong>Bó Hoa Enigma Roses bao gồm:</strong></p>
<ul>
<li>Hoa hồng đỏ pháp: 100 cành</li>
</ul>
<p><strong><em>Lưu ý</em></strong></p>
<p><em>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</em></p>
<p><em>** Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm.</em></p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa 8/3'), 0),
(N'Cuteness', N'Bó', 1700000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/August%202023/bo-hoa-hong-Cuteness.jpg.webp', N'<p>Hoa đồng đại diện cho hạnh phúc, niềm vui và may mắn, một bó hoa hồng ngọt ngào dễ thương  sẽ là một lời chúc mừng, chúc may mắn đầy ý nghĩa gửi đến những người đã luôn sát cánh bên bạn trong cuộc đời đấy. Yêu thương được thể hiện bằng hoa sẽ trở nên đầy ý nghĩa.</p>
<p><strong>Bó hoa Cuteness được thiết kế từ</strong></p>
<ul>
<li>Hoa hồng kem: 65 cành</li>
<li>Hoa baby trắng: 300 gram</li>
</ul>
<p><em>Lưu ý</em></p>
<p><em>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</em></p>
<p><em>** Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm.</em></p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa 8/3'), 0),
(N'Ngày Tươi Sáng', N'Bó', 510000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/Autumn_2024/ngay-tuoi-sang.jpg.webp', N'<p>Không mang trong mình nét kiêu sa, lộng lẫy nhưng hướng dương mang đến một vẻ đẹp đầy tươi sáng và rạng ngời. Hướng dương cũng là một lựa chon sáng suốt cho ngày tốt nghiệp của bạn bè, người thân như một lời chúc mừng cho một tương lai đầy tươi sáng, rộng mở và đầy may mắn. Hãy để người bạn yêu thương cảm nhận được sự quan tâm và tình yêu của bạn dành cho họ.</p>
<p><strong>Bó Hoa Ngày Tươi Sáng được thiết kế từ</strong></p>
<ul>
<li>Hoa Hướng Dương: 10 cành</li>
<li>Các loại hoa lá phụ: Sao tím, lá táo</li>
</ul>
<p><em>Lưu ý</em></p>
<p><em>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</em></p>
<p><em>** Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm</em></p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa 8/3'), 7),
(N'Hương Hè', N'Bó', 660000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/August%202023/gio-hoa-huong-duong-huong-he-1.jpg.webp', N'<p>Với màu sắc rực rỡ từ những bông hoa hướng dương tươi đẹp kết hợp với baby trắng lung linh, giỏ hoa sẽ đưa bạn và cô ấy trở lại những ngày xưa tốt đẹp khi bạn vẫn còn trẻ, tràn đầy sức sống và say đắm trong hoài bão. Không chỉ mang đến nét đẹp gần gũi, mộc mạc và thoang thoảng hương mùa hè, giỏ hoa Hương Hè sẽ giúp bạn thay lời gửi đến những điều chúc tốt đẹp nhất, mang đến niềm vui và đặc biệt là sự động viên đầy dễ thương đến người nhận. Đừng quên gửi kèm theo một lời nhắn nhỏ xinh để tăng thêm phần đặc biệt của món quà nhé.</p>
<p><strong>Giỏ hoa Hương Hè đươc thiết kế từ:</strong></p>
<ul>
<li>Hoa hướng dương: 10 cành </li>
<li>Hoa baby trắng: 100 gram </li>
<li>Các loại hoa lá phụ : Lá Bạc</li>
</ul>
<p>Lưu ý:</p>
<p>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</p>
<p>** Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm.</p>
<p> </p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa 8/3'), 0),
(N'My Sunshine', N'Bó', 450000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/Winter_2024/my-sunshine%20%281%29.jpg.webp', N'<p><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif">Đẹp rạng ngời nhưng vẫn mang trong mình nét mộc mạc đầy yêu thương, bó hoa này là món quà tuyệt vời dành tặng những ngưởi phụ nữ đã luôn quan tâm, yêu thương và lo lắng cho bạn. Bó hoa được tạo nên từ những đóa hướng dương đầy nắng, đẹp rực rỡ cùng hoa phụ sao tím thật xinh xắn, tạo nên cảm giác thoải mái tươi mát cho trong ngày thu. Chỉ cần một bó hoa đẹp thanh tao thế này là đủ cho ai đó vui vẻ cả tuần rồi đấy!</span></span></p>
<p><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><strong>Bó hoa My Sunshine được thiết kế từ</strong></span></span></p>
<ul>
<li><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif">Hoa hướng dương: 7 cành</span></span></li>
<li><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif">Các loại hoa lá phụ: Sao tím</span></span></li>
</ul>
<p><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><strong><em>Lưu ý</em></strong></span></span></p>
<p><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><em>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</em></span></span></p>
<p><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><em>** Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm.</em></span></span></p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa 8/3'), 0),
(N'Giọt Sương Mai', N'Bó', 560000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/August%202023/bo-hoa-giot-suong-mai.jpg.webp', N'<p><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Trong lành, tinh khiết và giản dị như những giọt sương mai. Như giọt sương mai trên đầu ngọn cỏ, Bó hoa Giọt Sương Mai là một món quà nhẹ nhàng và đầy chân thành dành cho những người bạn yêu thương. Bó hoa phù hợp với nhiều dịp như mừng sinh nhật, mừng khai trương, 20/10, 20/11...</span></span></p>
<p style="text-align:justify"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px"><strong>Bó Hoa Giọt Sương Mai được thiết kế từ</strong></span></span></p>
<ul>
<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Hoa hồng kem: 12 cành</span></span></li>
<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Hoa cẩm chướng trắng: 10 cành</span></span></li>
<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px">Các loại hoa lá phụ: Lá chanh</span></span></li>
</ul>
<p><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px"><strong><em>Lưu ý:</em></strong></span></span></p>
<p><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px"><em>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</em></span></span></p>
<p><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:14px"><em>**Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm.</em></span></span></p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa 8/3'), 19),
(N'Chung Đôi', N'Bó', 1390000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/August%202023/bo-hoa-hong-do-chung-doi.jpg.webp', N'<p><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px">Bó hoa gồm 50 hồng đỏ gồm những cánh hồng tươi rực rỡ nhất được gói theo tông giấy hồng dễ thương như một lời nhắn trao gửi yêu thương đầy chân thành nhất. Giữa cuộc sống đầy thử thách, một chút chia sẻ, trao gửi yêu thương nhất định sẽ làm ấm lòng và tiếp thêm sức mạnh cho bạn ấy đấy.</span></span></p>
<p><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px"><strong>Bó hoa Chung Đôi được thiết kế từ</strong></span></span></p>
<ul>
<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px">Hoa hồng đỏ: 50 cành</span></span></li>
<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px">Hoa baby trắng: 150 gram</span></span></li>
</ul>
<p><strong><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px">Lưu ý</span></span></strong></p>
<p><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px"><em>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</em></span></span></p>
<p><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px"><em>** Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm.</em></span></span></p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa 8/3'), 16),
(N'Your Day', N'Bó', 490000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/Autumn_2024/your-day-1.jpg.webp', N'<p style="text-align:justify"><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif">Hạnh phúc đôi khi không được tính bằng năm, bằng tháng mà hạnh phúc có thể đong đầy dù trong một khoảnh khắc. Hãy gửi đến người bạn yêu thương nhất những khoảnh khắc chứa đựng đầy yêu thương nhé. <a href="https://www.flowercorner.vn/bo-hoa">Bó hoa</a> gồm tông màu hồng lãng mạn của hồng kem kết hợp với vẻ đẹp đầy đáng yêu của cẩm chướng trắng.</span></span></p>
<p style="text-align:justify"><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif">Nếu bạn đang cần tìm một bó <a href="https://www.flowercorner.vn/hoa-chuc-mung-sinh-nhat">hoa tặng sinh nhật</a> hay tốt nghiệp, Your Day là một trong những lựa chọn mà bạn không nên bỏ qua.</span></span></p>
<p style="text-align:justify"><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><strong>Bó hoa Your Day được thiết kế từ</strong></span></span></p>
<ul>
<li><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif">Hoa hồng kem: 9 cành</span></span></li>
<li><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif">Hoa cẩm chướng trắng: 10 cành</span></span></li>
<li><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif">Các loại hoa lá phụ</span></span></li>
</ul>
<p><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><strong><em>Lưu ý:</em></strong></span></span></p>
<p><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><em>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</em></span></span></p>
<p><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><em>** Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm.</em></span></span></p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa 20/10'), 6),
(N'Duyên Dáng', N'Bó', 660000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/August%202023/bo-hoa-duyen-dang.jpg.webp', N'<p style="text-align:justify"><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif">Bó hoa Duyên Dáng gồm những bông hồng pastel kết hợp với cẩm chướng đỏ và những loại hoa phụ khác lạ, tạo nên nét đẹp và rạng ngời nhất. Đây chắc chắn sẽ là một món quà cực kì ấn tượng để gửi đến người bạn yêu thương. Những cánh đỏ quyến rũ sẽ mang lại một ngày tràn ngập những yêu thương rạng ngời.</span></span></p>
<p style="text-align:justify"><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><strong>Bó Hoa Duyễn Dáng được thiết kế từ</strong></span></span></p>
<ul>
<li><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif">Hoa hồng kem: 15 cành</span></span></li>
<li><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif">Hoa cát tường hồng: 5 cành</span></span></li>
<li><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif">Các loại hoa lá phụ: Lá bạc Trung</span></span></li>
</ul>
<p><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><strong><em>Lưu ý:</em></strong></span></span></p>
<p><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><em>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</em></span></span></p>
<p><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><em>** Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm.</em></span></span></p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa 20/10'), 0),
(N'Giỏ Hoa Nụ Cười', N'Bó', 690000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/August%202023/gio-hoa-nu-cuoi.jpg.webp', N'<p style="text-align:justify">Hướng dương luôn được biết đến như một loài hoa mang đến sự may mắn trong tình yêu, công việc hay sự nghiệp. Một <a href="https://www.flowercorner.vn/gio-hoa-dep" target="_blank">giỏ hoa</a> hướng dương là một lời chúc thành công đầy chân thành nhất. Đôi khi trong cuộc sống không cần gì nhiều lằm, chỉ một giỏ hoa xinh xắn bất ngờ sẽ là một lời động viên tâm hồn lớn lao đối với mỗi người đấy.</p>
<p style="text-align:justify">Giỏ hoa nụ cười phù hợp để làm quà tặng trong dịp sinh nhật, <a href="https://www.flowercorner.vn/hoa-khai-truong">hoa mừng khai trương</a> và tất cả những sự kiện đặc biệt trong năm.</p>
<p style="text-align:justify"><strong>Giỏ Hoa Nụ Cười được thiết kế từ :</strong></p>
<ul>
<li style="text-align:justify">Hướng dương: 15 cành </li>
<li style="text-align:justify">Các loài hoa lá phụ: Hoa Thạch thảo trắng, lá đuôi chồn .</li>
</ul>
<p><strong>Lưu ý:</strong></p>
<p><em>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</em></p>
<p><em>**Vì các loài hoa thay đổi theo mùa nên shop đảm bảo các loại hoa chính, còn các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm.</em></p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa 20/10'), 0),
(N'Thiên Lộc', N'Bó', 1360000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/Autumn_2024/thien-loc.jpg.webp', N'<p>Lẫng hoa Thiên Lộc được tạo nên từ những bông hoa hồng đỏ, hồng kem pastel và các loại lá phụ trang trí khác. Lẵng hoa thích hợp dành tặng những dịp chúc mừng, mừng khai trương, tân gia....</p>
<p><strong>Lẵng hoa </strong><strong>Thiên Lộc được thiết kế từ :</strong></p>
<ul>
<li>Hoa hồng đỏ : 25 cành </li>
<li>Hoa hồng kem pastel: 30 cành</li>
<li>Các loại hoa lá phụ: Hoa thạch thảo trắng, đuôi chồn</li>
</ul>
<p>Lưu ý:</p>
<p>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</p>
<p>** Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm.</p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa 20/10'), 13),
(N'Forever You', N'Bó', 950000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/Autumn_2024/forever-you.jpg.webp', N'<p><strong>Bó hoa Forever You được thiết kế từ:</strong></p>
<ul>
<li>Hoa hồng đỏ: 35 cành</li>
<li>Các loại hoa lá phụ khác: Hoa baby trắng, lá bạc Trung</li>
</ul>
<p><strong>Lưu ý: </strong></p>
<p>**Đối với các loại hoa nhập khẩu, Flowercorner.vn khuyến khích khách hàng đặt trước 1-2 ngày để đảm bảo sản phẩm được chuẩn bị chỉnh chu nhất.</p>
<p>**Do tính chất mùa vụ, một số loại hoa phụ có thể hết hàng do hết mùa. Trong trường này, FlowerCorner.vn sẽ chủ động thông báo cho khách hàng và thay thế bằng loại hoa, lá phụ tương tự.</p>
<p>**Vì sản phẩm được làm thủ công nên sản phẩm thực tế nhận được sẽ có đôi chút khác biệt so với hình mẫu. Flowercorner.vn cam kết sản phẩm thực tế sẽ giống khoảng 80% so với hình ảnh mẫu.</p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa 20/10'), 0),
(N'Toả Nắng', N'Bó', 770000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/L%E1%BA%B5ng%20Hoa/lang-hoa-chuc-mung-toa-sang.jpg.webp', N'<p><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px">Lẵng hoa là quà tặng hoàn hảo dành cho bạn bè, đối tác trong ngày lễ khai trương cửa hàng, công ty. Ngoài ra, bạn cũng có thể lựa chọn lẵng hoa này để gửi tặng sinh nhật cấp trên hoặc người thân.</span></span></p>
<p style="text-align:start"><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px"><strong>Lẵng Hoa Chúc Mừng Toả Nắng được thiết kế từ:</strong></span></span></p>
<ul style="list-style-type:disc">
<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px">Hoa hướng dương size nhỏ: 20 cành</span></span></li>
<li><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px">Các loại hoa lá phụ: Lá chanh, dương xỉ</span></span></li>
</ul>
<p><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px"><strong>Lưu ý:</strong></span></span></p>
<p><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px"><em>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</em></span></span></p>
<p><span style="font-family:Arial,Helvetica,sans-serif"><span style="font-size:16px"><em>** Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm.</em></span></span></p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa 20/11'), 9),
(N'The Hope', N'Bó', 220000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/bo-hoa-huong-duong-the-hope-2.jpg.webp', N'<p style="text-align:justify"><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif">The hope được thiết kế từ hoa hướng dương, loài hoa tượng trưng cho sự mạnh mẽ, niềm tin và tương lai tươi sáng. Bó hoa là sự lựa chọn để gửi tặng người thân, bạn bè trong dịp sinh nhật, lễ tốt nghiệp. Nếu bạn đang cần một bó <a href="https://www.flowercorner.vn/hoa-tang-tot-nghiep">hoa tặng tốt nghiệp</a> giá rẻ để tặng người thân, bạn bè thì The hope là sự lựa chọn hoàn hảo.</span></span></p>
<p style="text-align:justify"><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><strong>Bó hoa The Hope được thiết kế từ</strong></span></span></p>
<ul>
<li style="text-align:justify"><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif">Hoa hướng dương: 3 cành</span></span></li>
<li style="text-align:justify"><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif">Các loại hoa lá phụ: Lá bạc</span></span></li>
</ul>
<p><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><strong><em>Lưu ý:</em></strong></span></span></p>
<p><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><em>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</em></span></span></p>
<p><span style="font-size:14px"><span style="font-family:Arial,Helvetica,sans-serif"><em>**Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm</em></span></span></p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa 20/11'), 12),
(N'Nổi Bật', N'Bó', 1250000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/Gio%20Hoa/gio-hoa-noi-bat.jpg.webp', N'<p>Lẵng hoa Nổi Bật được tạo nên từ những bông hoa hồng đỏ, lá bạc, lá phụ trang trí. Lẵng hoa thích hợp dành tặng những dịp khai trương, chúc mừng, mừng tân gia....</p>
<p><strong>Lẵng hoa Nổi Bật được thiết kế từ:</strong></p>
<ul>
<li>Hoa hồng đỏ: 50 cành</li>
<li>Các loại hoa lá phụ: Lá bạc Trung</li>
</ul>
<p><em>Lưu ý:</em></p>
<p><em>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</em></p>
<p><em>** Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm.</em></p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa 20/11'), 23),
(N'Tỏa Sáng', N'Bó', 670000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/August%202023/lang-hoa-toa-sang.jpg.webp', N'<p style="text-align:justify">Được làm từ những bông hướng dương tươi nhất và điểm tô bởi những nhánh cúc calimero trắng, <a href="https://www.flowercorner.vn/lang-hoa">lẵng hoa</a> tỏa sáng rực rỡ và mang đầy sức sống, may mắn như nắng ngày hè. Đây sẽ là món quà vô cùng phù hợp nếu như bạn muốn tạo một ấn tượng đến đối tác, đồng nghiệp, bạn bè, hay những người mà bạn thương yêu quan tâm nhất.</p>
<p style="text-align:justify">Lẵng <a href="https://www.flowercorner.vn/hoa-khai-truong">hoa khai trương</a> tỏa sáng cũng là lựa chọn hoàn hảo để gửi tặng bạn bè, đối tác nhân dịp khai trương cửa hàng, công ty.</p>
<p style="text-align:justify"><strong>Mẫu hoa Tỏa Sáng được thiết kế từ :</strong></p>
<ul>
<li style="text-align:justify">Hoa hướng dương : 8 cành </li>
<li style="text-align:justify">Cúc calimero trắng : 5 cành </li>
<li style="text-align:justify">Các loại lá phụ :Thạch thảo trắng</li>
</ul>
<p>Lưu ý:</p>
<p>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</p>
<p>** Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm.</p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa 20/11'), 0),
(N'Be Happy', N'Bó', 720000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/August%202023/lang-hoa-be-happy.jpg.webp', N'<p style="text-align:justify">Giỏ hoa Be Happy được thiết kế từ hoa hướng dương kết hợp với hoa hồng kem và các loại hoa lá phụ. Giỏ hoa là lựa chọn hoàn hảo để dành tặng vợ, bạn gái, bạn bè và người thân trong dịp sinh nhật và trong những dịp đặc biệt trong năm.</p>
<p style="text-align:justify"><strong>Giỏ Hoa Be Happy được thiết kế từ</strong></p>
<ul>
<li>Hoa hướng dương: 5 cành</li>
<li>Hoa hồng kem: 15 cành </li>
<li style="text-align:justify">Các loại hoa lá phụ: Cúc thạch thảo trắng, lá đuôi chồn</li>
</ul>
<p>Lưu ý:</p>
<p>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</p>
<p>** Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm.</p>
<ul>
</ul>
<ul>
</ul>
<ul>
</ul>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa 20/11'), 10),
(N'Hồng Dễ Thương', N'Bó', 850000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/August%202023/bo-hoa-hong-do-hong-de-thuong.jpg.webp', N'<p>"Trời vừa rạng, nắng vừa lên" hoa hồng đỏ gồm những cánh hồng tươi rực rỡ nhất được gói theo tông giấy hồng dễ thương như một lời nhắn trao gửi yêu thương đầy chân thành nhất. Giữa cuộc sống đầy thử thách, một chút chia sẻ, trao gửi yêu thương nhất định sẽ làm ấm lòng và tiếp thêm sức mạnh cho bạn ấy đấy.</p>
<p><strong>Bó Hoa Hồng Dễ Thương được thiết kế từ</strong></p>
<ul>
<li>Hoa hồng đỏ: 20 cành</li>
<li>Các loại hoa lá phụ: hoa thúy châu</li>
</ul>
<p><em>Lưu ý:</em></p>
<p><em>**Do được làm thủ công, nên sản phẩm ngoài thực tế sẽ có đôi chút khác biệt so với hình ảnh trên website. Tuy nhiên, Flowercorner cam kết hoa sẽ giống khoảng 80% so với hình ảnh.</em></p>
<p><em>** Vì các loại hoa lá phụ sẽ có tùy vào thời điểm trong năm, Flowercorner đảm bảo các loại hoa chính, các loại hoa lá phụ sẽ thay đổi phù hợp giá cả và thiết kế sản phẩm.</em></p>', (SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'Hoa 20/11'), 0);
GO
