-- ============================================
-- LIBRARY MANAGEMENT SYSTEM - SAMPLE DATA
-- ============================================
-- Insertion script for testing and demo
-- Database: MySQL 8.0+

-- ============================================
-- 1. INSERT CATEGORIES (Danh mục sách)
-- ============================================
INSERT INTO categories (name, description) VALUES
('Fiction', 'Sách tiểu thuyết, văn học'),
('Non-fiction', 'Sách khoa học, tham khảo'),
('Technology', 'Sách công nghệ thông tin'),
('Business', 'Sách kinh doanh, quản lý'),
('Education', 'Sách giáo dục, học tập'),
('Arts', 'Sách về nghệ thuật, thiết kế'),
('Science', 'Sách khoa học tự nhiên'),
('History', 'Sách lịch sử');

-- ============================================
-- 2. INSERT SUBJECTS (Môn học - Subcategory)
-- ============================================
INSERT INTO subjects (category_id, name, description) VALUES
-- Technology subjects
(3, 'Programming', 'Lập trình máy tính'),
(3, 'Web Development', 'Phát triển web'),
(3, 'Database', 'Cơ sở dữ liệu'),
(3, 'Artificial Intelligence', 'Trí tuệ nhân tạo'),

-- Education subjects
(5, 'Mathematics', 'Toán học'),
(5, 'Physics', 'Vật lý'),
(5, 'Chemistry', 'Hóa học'),
(5, 'Literature', 'Văn học'),

-- Business subjects
(4, 'Management', 'Quản lý'),
(4, 'Marketing', 'Tiếp thị'),
(4, 'Finance', 'Tài chính'),

-- Science subjects
(7, 'Biology', 'Sinh học'),
(7, 'Geology', 'Địa chất học');

-- ============================================
-- 3. INSERT AUTHORS (Tác giả)
-- ============================================
INSERT INTO authors (name, nationality, birth_date, bio) VALUES
('Robert C. Martin', 'American', '1952-12-05', 'Tác giả nổi tiếng về clean code và software craftsmanship'),
('Erich Gamma', 'German', '1961-03-16', 'Co-author của "Design Patterns" book'),
('Richard Helm', 'American', NULL, 'Co-author của "Design Patterns" book'),
('Ralph Johnson', 'American', NULL, 'Co-author của "Design Patterns" book'),
('John Vlissides', 'American', '1961-01-01', 'Co-author của "Design Patterns" book'),
('Steve McConnell', 'American', '1962-12-10', 'Tác giả về software engineering'),
('Andrew Hunt', 'American', NULL, 'Co-author của "The Pragmatic Programmer"'),
('David Thomas', 'American', NULL, 'Co-author của "The Pragmatic Programmer"'),
('Nguyễn Nhật Ánh', 'Vietnamese', '1955-10-25', 'Nhà văn Việt Nam nổi tiếng'),
('Trần Hữu Tước', 'Vietnamese', NULL, 'Tác giả Việt Nam');

-- ============================================
-- 4. INSERT PUBLISHERS (Nhà xuất bản)
-- ============================================
INSERT INTO publishers (name, address, phone, email) VALUES
('Prentice Hall', 'USA', '+1-800-927-0117', 'contact@prenticehall.com'),
('Addison-Wesley', 'USA', '+1-201-236-7000', 'contact@aw.com'),
('O\'Reilly Media', 'USA', '+1-707-827-7000', 'contact@oreilly.com'),
('Pragmatic Bookshelf', 'USA', '+1-919-847-9884', 'contact@pragprog.com'),
('Nhà xuất bản Trẻ', 'Vietnam', '+84-28-3929-3945', 'info@nxbtre.com'),
('Nhà xuất bản Văn học', 'Vietnam', '+84-24-3825-6645', 'info@nxbvanhoq.com'),
('Packt Publishing', 'UK', '+44-121-262-2444', 'contact@packt.com'),
('Manning Publications', 'USA', '+1-203-662-6500', 'contact@manning.com');

-- ============================================
-- 5. INSERT USERS (Người dùng)
-- ============================================
INSERT INTO users (username, password, full_name, email, phone, student_id, role) VALUES
-- Admins
('admin1', '$2y$10$...(hashed_password_1)', 'Nguyễn Văn Admin', 'admin1@library.edu.vn', '0987654321', 'AD001', 'ADMIN'),
('admin2', '$2y$10$...(hashed_password_2)', 'Trần Thị Admin', 'admin2@library.edu.vn', '0987654322', 'AD002', 'ADMIN'),

-- Librarians
('librarian1', '$2y$10$...(hashed_password_3)', 'Phạm Thủ Thư 1', 'librarian1@library.edu.vn', '0912345678', 'LB001', 'LIBRARIAN'),
('librarian2', '$2y$10$...(hashed_password_4)', 'Hoàng Thủ Thư 2', 'librarian2@library.edu.vn', '0912345679', 'LB002', 'LIBRARIAN'),
('librarian3', '$2y$10$...(hashed_password_5)', 'Lê Thủ Thư 3', 'librarian3@library.edu.vn', '0912345680', 'LB003', 'LIBRARIAN'),

-- Regular Users (Students)
('student001', '$2y$10$...(hashed_password_6)', 'Lý Thế Hàn', 'student001@student.edu.vn', '0901111111', 'SV001', 'USER'),
('student002', '$2y$10$...(hashed_password_7)', 'Đinh Hữu Huy', 'student002@student.edu.vn', '0901111112', 'SV002', 'USER'),
('student003', '$2y$10$...(hashed_password_8)', 'Trương Thị Tú Anh', 'student003@student.edu.vn', '0901111113', 'SV003', 'USER'),
('student004', '$2y$10$...(hashed_password_9)', 'Đỗ Minh Tuấn', 'student004@student.edu.vn', '0901111114', 'SV004', 'USER'),
('student005', '$2y$10$...(hashed_password_10)', 'Phạm Hương Ly', 'student005@student.edu.vn', '0901111115', 'SV005', 'USER'),
('student006', '$2y$10$...(hashed_password_11)', 'Vũ Thanh Hà', 'student006@student.edu.vn', '0901111116', 'SV006', 'USER'),
('student007', '$2y$10$...(hashed_password_12)', 'Bùi Khoa Dương', 'student007@student.edu.vn', '0901111117', 'SV007', 'USER'),
('student008', '$2y$10$...(hashed_password_13)', 'Tô Thị Thanh Tuyền', 'student008@student.edu.vn', '0901111118', 'SV008', 'USER');

-- ============================================
-- 6. INSERT BOOK_LOCATIONS (Vị trí sách - Khu vực/Kệ/Ngăn)
-- ============================================
INSERT INTO book_locations (area, shelf, slot, description) VALUES
-- Khu A - Sách Technology
('Khu A', 'K01', 'N01', 'Lập trình'),
('Khu A', 'K01', 'N02', 'Lập trình'),
('Khu A', 'K02', 'N01', 'Web Development'),
('Khu A', 'K02', 'N02', 'Web Development'),
('Khu A', 'K03', 'N01', 'Database'),
('Khu A', 'K03', 'N02', 'Database'),

-- Khu B - Sách Education
('Khu B', 'K01', 'N01', 'Toán học'),
('Khu B', 'K01', 'N02', 'Toán học'),
('Khu B', 'K02', 'N01', 'Vật lý'),
('Khu B', 'K02', 'N02', 'Vật lý'),
('Khu B', 'K03', 'N01', 'Hóa học'),
('Khu B', 'K03', 'N02', 'Hóa học'),

-- Khu C - Sách Business
('Khu C', 'K01', 'N01', 'Quản lý'),
('Khu C', 'K01', 'N02', 'Quản lý'),
('Khu C', 'K02', 'N01', 'Marketing'),
('Khu C', 'K02', 'N02', 'Marketing'),

-- Khu D - Sách Fiction & Literature
('Khu D', 'K01', 'N01', 'Tiểu thuyết'),
('Khu D', 'K01', 'N02', 'Tiểu thuyết'),
('Khu D', 'K02', 'N01', 'Văn học'),
('Khu D', 'K02', 'N02', 'Văn học');

-- ============================================
-- 7. INSERT BOOKS (Sách)
-- ============================================
INSERT INTO books (isbn, title, category_id, subject_id, publisher_id, publish_year, description, price, total_copies) VALUES
-- Technology Books
('9780132350884', 'Clean Code: A Handbook of Agile Software Craftsmanship', 3, 1, 1, 2008, 
 'Một cuốn sách không thể bỏ qua về cách viết code sạch và dễ hiểu', 450000, 5),

('9780201633610', 'Design Patterns: Elements of Reusable Object-Oriented Software', 3, 1, 1, 1994, 
 'Cơ sở về các design patterns trong lập trình hướng đối tượng', 550000, 4),

('9780135957052', 'The Pragmatic Programmer: Your Journey to Mastery', 3, 1, 4, 2019, 
 'Hướng dẫn trở thành lập trình viên chuyên nghiệp', 480000, 3),

('9781491952023', 'Learning Web Design', 3, 2, 3, 2018, 
 'Sách về thiết kế web và phát triển web', 420000, 4),

('9780134685991', 'Effective Java', 3, 1, 1, 2018, 
 'Hướng dẫn viết code Java hiệu quả', 480000, 3),

-- Education Books
('9780131101920', 'Calculus: Early Transcendentals', 5, 5, 1, 2010, 
 'Sách giáo khoa Giải tích cao cấp', 380000, 6),

('9780393614602', 'Physics for Scientists and Engineers', 5, 6, 2, 2018, 
 'Vật lý dành cho các nhà khoa học và kỹ sư', 520000, 4),

('9780134998671', 'Chemistry: The Central Science', 5, 7, 1, 2021, 
 'Hóa học căn bản cho sinh viên', 450000, 5),

-- Business Books
('9780062301499', 'Thinking, Fast and Slow', 4, 9, 8, 2013, 
 'Tâm lý học nhận thức và ra quyết định trong kinh doanh', 380000, 3),

('9781491954028', 'Marketing Metrics', 4, 10, 3, 2016, 
 'Các chỉ số đánh giá hiệu quả marketing', 340000, 2),

-- Literature/Fiction Books
('9780061120084', 'To Kill a Mockingbird', 1, 8, 2, 2006, 
 'Tiểu thuyết kinh điển về công lý và nhân quyền', 280000, 3),

('9789654618072', 'Tuổi thơ dữ dội', 1, 8, 5, 1995, 
 'Tiểu thuyết của Nguyễn Nhật Ánh về tuổi thơ', 150000, 8);

-- ============================================
-- 8. INSERT BOOK_AUTHORS (Liên kết sách-tác giả)
-- ============================================
INSERT INTO book_authors (book_id, author_id, role) VALUES
-- Clean Code
(1, 1, 'PRIMARY'),

-- Design Patterns
(2, 2, 'PRIMARY'),
(2, 3, 'CO_AUTHOR'),
(2, 4, 'CO_AUTHOR'),
(2, 5, 'CO_AUTHOR'),

-- The Pragmatic Programmer
(3, 7, 'PRIMARY'),
(3, 8, 'CO_AUTHOR'),

-- Learning Web Design
(4, 6, 'PRIMARY'),

-- Effective Java
(5, 1, 'PRIMARY'),

-- Calculus
(6, 3, 'PRIMARY'),

-- Physics
(7, 4, 'PRIMARY'),

-- Chemistry
(8, 5, 'PRIMARY'),

-- Thinking, Fast and Slow
(9, 6, 'PRIMARY'),

-- Marketing Metrics
(10, 7, 'PRIMARY'),

-- To Kill a Mockingbird
(11, 8, 'PRIMARY'),

-- Tuổi thơ dữ dội
(12, 9, 'PRIMARY');

-- ============================================
-- 9. INSERT BOOK_COPIES (Bản sao vật lý)
-- ============================================
INSERT INTO book_copies (book_id, barcode, location_id, condition, status, purchase_date) VALUES
-- Clean Code copies
(1, 'BC001', 1, 'GOOD', 'AVAILABLE', '2022-01-15'),
(1, 'BC002', 1, 'GOOD', 'BORROWED', '2022-01-15'),
(1, 'BC003', 1, 'GOOD', 'AVAILABLE', '2022-01-15'),
(1, 'BC004', 1, 'GOOD', 'BORROWED', '2022-02-20'),
(1, 'BC005', 1, 'DAMAGED', 'DAMAGED', '2022-01-15'),

-- Design Patterns copies
(2, 'DP001', 2, 'GOOD', 'AVAILABLE', '2021-05-10'),
(2, 'DP002', 2, 'GOOD', 'BORROWED', '2021-05-10'),
(2, 'DP003', 2, 'GOOD', 'AVAILABLE', '2021-06-15'),
(2, 'DP004', 2, 'GOOD', 'AVAILABLE', '2021-06-15'),

-- The Pragmatic Programmer copies
(3, 'PP001', 3, 'GOOD', 'AVAILABLE', '2023-03-01'),
(3, 'PP002', 3, 'GOOD', 'AVAILABLE', '2023-03-01'),
(3, 'PP003', 3, 'GOOD', 'BORROWED', '2023-03-01'),

-- Learning Web Design copies
(4, 'WD001', 4, 'GOOD', 'AVAILABLE', '2023-07-20'),
(4, 'WD002', 4, 'GOOD', 'BORROWED', '2023-07-20'),
(4, 'WD003', 4, 'GOOD', 'AVAILABLE', '2023-07-20'),
(4, 'WD004', 4, 'GOOD', 'AVAILABLE', '2023-07-20'),

-- Effective Java copies
(5, 'EJ001', 1, 'GOOD', 'AVAILABLE', '2023-02-10'),
(5, 'EJ002', 1, 'GOOD', 'AVAILABLE', '2023-02-10'),
(5, 'EJ003', 1, 'GOOD', 'BORROWED', '2023-02-10'),

-- Calculus copies
(6, 'CA001', 7, 'GOOD', 'AVAILABLE', '2022-08-05'),
(6, 'CA002', 7, 'GOOD', 'BORROWED', '2022-08-05'),
(6, 'CA003', 7, 'GOOD', 'AVAILABLE', '2022-08-05'),
(6, 'CA004', 7, 'GOOD', 'AVAILABLE', '2022-09-10'),
(6, 'CA005', 7, 'GOOD', 'AVAILABLE', '2022-09-10'),
(6, 'CA006', 7, 'GOOD', 'BORROWED', '2022-09-10'),

-- Physics copies
(7, 'PH001', 9, 'GOOD', 'AVAILABLE', '2023-01-15'),
(7, 'PH002', 9, 'GOOD', 'AVAILABLE', '2023-01-15'),
(7, 'PH003', 9, 'GOOD', 'BORROWED', '2023-01-15'),
(7, 'PH004', 9, 'GOOD', 'AVAILABLE', '2023-01-15'),

-- Chemistry copies
(8, 'CH001', 11, 'GOOD', 'AVAILABLE', '2023-04-20'),
(8, 'CH002', 11, 'GOOD', 'BORROWED', '2023-04-20'),
(8, 'CH003', 11, 'GOOD', 'AVAILABLE', '2023-04-20'),
(8, 'CH004', 11, 'GOOD', 'AVAILABLE', '2023-04-20'),
(8, 'CH005', 11, 'GOOD', 'AVAILABLE', '2023-04-20'),

-- Thinking, Fast and Slow copies
(9, 'TFS001', 13, 'GOOD', 'AVAILABLE', '2023-06-10'),
(9, 'TFS002', 13, 'GOOD', 'BORROWED', '2023-06-10'),
(9, 'TFS003', 13, 'GOOD', 'AVAILABLE', '2023-06-10'),

-- Marketing Metrics copies
(10, 'MM001', 15, 'GOOD', 'AVAILABLE', '2023-05-15'),
(10, 'MM002', 15, 'GOOD', 'AVAILABLE', '2023-05-15'),

-- To Kill a Mockingbird copies
(11, 'TKM001', 17, 'GOOD', 'AVAILABLE', '2022-10-20'),
(11, 'TKM002', 17, 'GOOD', 'BORROWED', '2022-10-20'),
(11, 'TKM003', 17, 'GOOD', 'AVAILABLE', '2022-10-20'),

-- Tuổi thơ dữ dội copies
(12, 'TTD001', 19, 'GOOD', 'AVAILABLE', '2021-12-01'),
(12, 'TTD002', 19, 'GOOD', 'AVAILABLE', '2021-12-01'),
(12, 'TTD003', 19, 'GOOD', 'BORROWED', '2021-12-01'),
(12, 'TTD004', 19, 'GOOD', 'AVAILABLE', '2021-12-01'),
(12, 'TTD005', 19, 'GOOD', 'AVAILABLE', '2021-12-01'),
(12, 'TTD006', 19, 'GOOD', 'AVAILABLE', '2021-12-01'),
(12, 'TTD007', 19, 'GOOD', 'AVAILABLE', '2021-12-01'),
(12, 'TTD008', 19, 'GOOD', 'BORROWED', '2021-12-01');

-- ============================================
-- 10. INSERT BORROW_RECORDS (Lịch sử mượn)
-- ============================================
INSERT INTO borrow_records (user_id, book_copy_id, book_id, borrow_date, due_date, return_date, max_renew_count, actual_renew_count, status) VALUES
-- Student 1 - Đang mượn
(6, 2, 1, '2026-06-01', '2026-06-15', NULL, 3, 0, 'BORROWING'),
(6, 8, 2, '2026-06-02', '2026-06-16', NULL, 3, 1, 'BORROWING'),

-- Student 2 - Đã trả
(7, 3, 1, '2026-05-20', '2026-06-03', '2026-06-02', 3, 0, 'RETURNED'),
(7, 10, 3, '2026-05-25', '2026-06-08', '2026-06-08', 3, 0, 'RETURNED'),

-- Student 3 - Đang mượn
(8, 11, 3, '2026-06-03', '2026-06-17', NULL, 3, 0, 'BORROWING'),
(8, 14, 4, '2026-06-04', '2026-06-18', NULL, 3, 0, 'BORROWING'),

-- Student 4 - Quá hạn
(9, 17, 5, '2026-05-15', '2026-05-29', NULL, 3, 0, 'OVERDUE'),

-- Student 5 - Đã trả đúng hạn
(10, 18, 6, '2026-05-10', '2026-05-24', '2026-05-24', 3, 0, 'RETURNED'),
(10, 21, 7, '2026-05-18', '2026-06-01', '2026-06-01', 3, 0, 'RETURNED'),

-- Student 6 - Đang mượn
(11, 24, 8, '2026-06-05', '2026-06-19', NULL, 3, 0, 'BORROWING'),

-- Student 7 - Đã trả
(12, 26, 9, '2026-05-22', '2026-06-05', '2026-06-05', 3, 0, 'RETURNED'),

-- Student 8 - Đang mượn
(13, 28, 10, '2026-06-06', '2026-06-20', NULL, 3, 0, 'BORROWING');

-- ============================================
-- 11. INSERT RENEW_RECORDS (Lịch sử gia hạn)
-- ============================================
INSERT INTO renew_records (borrow_record_id, renew_count, old_due_date, new_due_date, renew_days, created_by) VALUES
(2, 1, '2026-06-16', '2026-06-30', 14, 1);

-- ============================================
-- 12. INSERT RESERVATION_RECORDS (Đặt sách)
-- ============================================
INSERT INTO reservation_records (user_id, book_id, status, queue_position, request_date, expiry_date) VALUES
-- Pending reservations
(7, 1, 'PENDING', 1, '2026-06-06 10:30:00', '2026-06-09 23:59:59'),
(9, 1, 'PENDING', 2, '2026-06-06 14:15:00', '2026-06-09 23:59:59'),

-- Ready reservations
(10, 2, 'READY', 1, '2026-06-03 08:00:00', '2026-06-07 23:59:59'),

-- Claimed reservations
(11, 3, 'CLAIMED', 1, '2026-05-28 09:00:00', '2026-06-05 15:30:00');

-- ============================================
-- 13. INSERT FINES (Tiền phạt)
-- ============================================
INSERT INTO fines (user_id, borrow_record_id, book_id, fine_type, amount, calculation_details, status, payment_method) VALUES
-- Overdue fine for student 4
(9, 4, 5, 'OVERDUE', 90000, '18 ngày × 5,000 = 90,000', 'UNPAID', 'CASH'),

-- Paid fine
(7, 2, 1, 'OVERDUE', 35000, '7 ngày × 5,000 = 35,000', 'PAID', 'CASH');

-- ============================================
-- 14. INSERT NOTIFICATIONS (Thông báo)
-- ============================================
INSERT INTO notifications (user_id, title, message, notification_type, is_read, reference_type, reference_id) VALUES
-- Due reminders
(6, 'Nhắc nhở trả sách', 'Sách "Clean Code" của bạn sắp hết hạn vào 2026-06-15', 'DUE_REMINDER_3DAYS', 0, 'borrow_record', 1),
(8, 'Nhắc nhở trả sách', 'Sách "Learning Web Design" của bạn sắp hết hạn vào 2026-06-18', 'DUE_REMINDER_1DAY', 0, 'borrow_record', 3),

-- Overdue notifications
(9, 'Sách quá hạn', 'Sách "Effective Java" của bạn đã quá hạn trả. Vui lòng trả sách sớm nhất.', 'OVERDUE', 0, 'borrow_record', 4),

-- Fine notifications
(9, 'Thông báo phạt', 'Bạn đã bị phạt 90,000 VND do trả sách muộn. Vui lòng thanh toán.', 'FINE_CREATED', 0, 'fine', 1),

-- Reservation ready
(10, 'Sách đã sẵn sàng', 'Sách "Design Patterns" bạn đặt trước đã có sẵn. Vui lòng tới lấy trong 1 ngày.', 'RESERVATION_READY', 0, 'reservation_record', 3),

-- Account locked
(9, 'Tài khoản bị khóa', 'Tài khoản của bạn đã bị khóa vì quá hạn trả sách. Liên hệ thủ thư để biết thêm chi tiết.', 'ACCOUNT_LOCKED', 0, 'user', 9),

-- Payment confirmed
(7, 'Xác nhận thanh toán', 'Thanh toán phạt 35,000 VND của bạn đã được xác nhận. Cảm ơn!', 'PAYMENT_CONFIRMED', 1, 'fine', 2);

-- ============================================
-- STATISTICS QUERIES
-- ============================================
-- Query: Số sách còn hàng
SELECT COUNT(*) as 'Sách còn hàng' FROM book_copies WHERE status = 'AVAILABLE';

-- Query: Số sách đang được mượn
SELECT COUNT(*) as 'Sách đang mượn' FROM book_copies WHERE status = 'BORROWED';

-- Query: Sách quá hạn
SELECT 
    br.id, 
    u.full_name, 
    b.title, 
    br.due_date,
    DATEDIFF(CURDATE(), br.due_date) as 'Ngày quá hạn'
FROM borrow_records br
JOIN users u ON br.user_id = u.id
JOIN books b ON br.book_id = b.id
WHERE br.status = 'BORROWING' AND br.due_date < CURDATE();

-- Query: Người dùng nợ phạt
SELECT 
    u.full_name, 
    SUM(f.amount) as 'Tổng tiền phạt'
FROM fines f
JOIN users u ON f.user_id = u.id
WHERE f.status IN ('UNPAID', 'PENDING_VERIFY')
GROUP BY f.user_id;

-- Query: Sách được mượn nhiều nhất
SELECT 
    b.title, 
    COUNT(br.id) as 'Số lần mượn'
FROM borrow_records br
JOIN books b ON br.book_id = b.id
GROUP BY br.book_id
ORDER BY COUNT(br.id) DESC
LIMIT 10;

-- ============================================
-- END OF SAMPLE DATA
-- ============================================
