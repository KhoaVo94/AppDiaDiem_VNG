#1. Xử lý tối ưu:
- sử dụng google maps api place autocomplete cho việc tìm kiếm và chọn địa điểm
- Sử dụng NSOperation xử lý đa luồng cho việc load dữ liệu thô lớn và phức tạp, hình ảnh được xử lý đa luồng theo kiểu lazy load giúp 
luồng chính của ứng dụng không bị quá tải và trì trệ, xem thêm ở : 
http://www.raywenderlich.com/76341/use-nsoperation-nsoperationqueue-swift.

# 2. Cách sử dụng và test ứng dụng:
- Chọn địa điểm:
  Ở màn hình Place Detail click icon Search, gõ địa điểm cần tìm kiếm
  Trong kết quả tìm kiếm, chọn địa điểm mong muốn
  Màn hình Place Detail sẽ load ra các thông tin bao gồm: hình ảnh(nếu có), tên địa điểm, số điện thoại, website, địa chỉ,
  các reviews của địa điểm đó (nếu có).
- Địa điểm xung quanh:
  Sau khi đã chọn 1 địa điểm ở màn hình Place Detail
  Tiếp theo chọn màn hình Place Nearby xem các địa điểm xung quanh của địa điểm được chọn, danh sách các địa điểm xung quanh sẽ được load
  ở table view và việc hiện hình ảnh được thể hiện theo lazy load.
  Chỉ khi dòng của table view đã hiện ra trên màn hình thì mới được load
  Các thông tin của một cell bao gồm: hình ảnh, tên địa điểm, địa chỉ, khoảng cách tới địa điểm được chọn.
