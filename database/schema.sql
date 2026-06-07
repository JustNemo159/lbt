-- ============================================
-- LIBRARY MANAGEMENT SYSTEM - DATABASE SCHEMA
-- ============================================
-- Version: 2.0
-- Last Updated: 2026-06-07
-- Database: MySQL 8.0+

-- ============================================
-- 1. USERS TABLE - Quản lý người dùng
-- ============================================
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15),
    avatar VARCHAR(255),
    student_id VARCHAR(20) NOT NULL UNIQUE, -- MSSV/mã định danh (bắt buộc)
    role ENUM('ADMIN', 'LIBRARIAN', 'USER') DEFAULT 'USER' NOT NULL,
    is_active TINYINT(1) DEFAULT 1 NOT NULL,
    is_locked TINYINT(1) DEFAULT 0 NOT NULL, -- Khóa tài khoản (admin khóa thủ công)
    lock_reason VARCHAR(500), -- Lý do khóa
    lock_date DATETIME, -- Thời gian khóa
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_student_id (student_id),
    INDEX idx_role (role)
);

-- ============================================
-- 2. CATEGORIES TABLE - Danh mục sách lớn
-- ============================================
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(500),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_name (name)
);

-- ============================================
-- 3. SUBJECTS TABLE - Môn học (Subcategory)
-- ============================================
CREATE TABLE subjects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(500),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL ON UPDATE CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_subjects_category FOREIGN KEY (category_id) 
        REFERENCES categories (id) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE KEY uq_category_subject (category_id, name),
    INDEX idx_category_id (category_id),
    INDEX idx_name (name)
);

-- ============================================
-- 4. AUTHORS TABLE - Danh sách tác giả
-- ============================================
CREATE TABLE authors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL UNIQUE,
    nationality VARCHAR(100),
    birth_date DATE,
    bio TEXT,
    avatar_url VARCHAR(500),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_name (name)
);

-- ============================================
-- 5. PUBLISHERS TABLE - Nhà xuất bản
-- ============================================
CREATE TABLE publishers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL UNIQUE,
    address VARCHAR(255),
    phone VARCHAR(15),
    email VARCHAR(100),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_name (name)
);

-- ============================================
-- 6. BOOKS TABLE - Đầu sách (thông tin sách)
-- ============================================
CREATE TABLE books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(20) NOT NULL UNIQUE,
    title VARCHAR(255) NOT NULL,
    category_id INT NOT NULL,
    subject_id INT,
    publisher_id INT,
    publish_year INT,
    description TEXT,
    cover_image VARCHAR(500),
    price DECIMAL(12, 2) NOT NULL DEFAULT 0, -- Giá sách (dùng để tính phạt)
    total_copies INT DEFAULT 0 NOT NULL, -- Tổng số bản sao vật lý
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL ON UPDATE CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_books_category FOREIGN KEY (category_id) 
        REFERENCES categories (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_books_subject FOREIGN KEY (subject_id) 
        REFERENCES subjects (id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_books_publisher FOREIGN KEY (publisher_id) 
        REFERENCES publishers (id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT chk_price CHECK (price >= 0),
    CONSTRAINT chk_total_copies CHECK (total_copies >= 0),
    
    INDEX idx_title (title),
    INDEX idx_isbn (isbn),
    INDEX idx_category_id (category_id),
    INDEX idx_subject_id (subject_id)
);

-- ============================================
-- 7. BOOK_AUTHORS TABLE - Liên kết sách-tác giả
-- ============================================
CREATE TABLE book_authors (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    role ENUM('PRIMARY', 'CO_AUTHOR', 'TRANSLATOR', 'EDITOR') DEFAULT 'PRIMARY' NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    
    PRIMARY KEY (book_id, author_id),
    CONSTRAINT fk_ba_book FOREIGN KEY (book_id) 
        REFERENCES books (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_ba_author FOREIGN KEY (author_id) 
        REFERENCES authors (id) ON DELETE CASCADE ON UPDATE CASCADE,
    
    INDEX idx_author_id (author_id)
);

-- ============================================
-- 8. BOOK_LOCATIONS TABLE - Vị trí sách (gộp Area, Shelf, Slot)
-- ============================================
CREATE TABLE book_locations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    area VARCHAR(50) NOT NULL, -- "Khu A", "Khu B", "Tầng 1", "Tầng 2"
    shelf VARCHAR(20) NOT NULL, -- "K01", "K02"
    slot VARCHAR(20) NOT NULL, -- "N01", "N02"
    description VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL ON UPDATE CURRENT_TIMESTAMP,
    
    -- Unique constraint để không có duplicate location
    UNIQUE KEY uq_location (area, shelf, slot),
    INDEX idx_area (area),
    INDEX idx_shelf (shelf),
    INDEX idx_slot (slot)
);

-- ============================================
-- 9. BOOK_COPIES TABLE - Bản sao vật lý
-- ============================================
CREATE TABLE book_copies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    barcode VARCHAR(50) NOT NULL UNIQUE, -- Mã vạch duy nhất
    location_id INT, -- Vị trí hiện tại (area/shelf/slot)
    condition ENUM('GOOD', 'DAMAGED', 'LOST') DEFAULT 'GOOD' NOT NULL,
    status ENUM('AVAILABLE', 'BORROWED', 'DAMAGED', 'LOST', 'MAINTENANCE') DEFAULT 'AVAILABLE' NOT NULL,
    notes TEXT,
    purchase_date DATE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL ON UPDATE CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_bc_book FOREIGN KEY (book_id) 
        REFERENCES books (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_bc_location FOREIGN KEY (location_id) 
        REFERENCES book_locations (id) ON DELETE SET NULL ON UPDATE CASCADE,
    
    INDEX idx_book_id (book_id),
    INDEX idx_barcode (barcode),
    INDEX idx_status (status),
    INDEX idx_condition (condition)
);

-- ============================================
-- 10. BORROW_RECORDS TABLE - Lịch sử mượn sách
-- ============================================
CREATE TABLE borrow_records (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    book_copy_id INT NOT NULL,
    book_id INT NOT NULL, -- Lưu trữ thêm để dễ query
    borrow_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    max_renew_count INT DEFAULT 0, -- Số lần gia hạn tối đa được phép
    actual_renew_count INT DEFAULT 0, -- Số lần gia hạn thực tế
    status ENUM('BORROWING', 'RETURNED', 'OVERDUE', 'RECLAIMED') DEFAULT 'BORROWING' NOT NULL,
    note TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL ON UPDATE CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_br_user FOREIGN KEY (user_id) 
        REFERENCES users (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_br_book_copy FOREIGN KEY (book_copy_id) 
        REFERENCES book_copies (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_br_book FOREIGN KEY (book_id) 
        REFERENCES books (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_dates CHECK (return_date IS NULL OR return_date >= borrow_date),
    
    INDEX idx_user_id (user_id),
    INDEX idx_book_id (book_id),
    INDEX idx_status (status),
    INDEX idx_due_date (due_date),
    INDEX idx_return_date (return_date)
);

-- ============================================
-- 11. RENEW_RECORDS TABLE - Lịch sử gia hạn
-- ============================================
CREATE TABLE renew_records (
    id INT AUTO_INCREMENT PRIMARY KEY,
    borrow_record_id INT NOT NULL,
    renew_count INT NOT NULL, -- Lần gia hạn thứ mấy (1, 2, 3)
    old_due_date DATE NOT NULL,
    new_due_date DATE NOT NULL,
    renew_days INT NOT NULL, -- Số ngày gia hạn (+14, +7, +4)
    created_by INT NOT NULL, -- User ID của người gia hạn
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    
    CONSTRAINT fk_rr_borrow FOREIGN KEY (borrow_record_id) 
        REFERENCES borrow_records (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_rr_user FOREIGN KEY (created_by) 
        REFERENCES users (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    
    INDEX idx_borrow_record_id (borrow_record_id),
    INDEX idx_renew_count (renew_count)
);

-- ============================================
-- 12. RESERVATION_RECORDS TABLE - Đặt trước sách
-- ============================================
CREATE TABLE reservation_records (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    book_id INT NOT NULL,
    status ENUM('PENDING', 'READY', 'CLAIMED', 'CANCELLED', 'EXPIRED') DEFAULT 'PENDING' NOT NULL,
    queue_position INT NOT NULL DEFAULT 0, -- Vị trí trong hàng đợi
    request_date DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    expiry_date DATETIME, -- Hạn chót để hủy (3 ngày)
    ready_notification_sent_at DATETIME, -- Lúc gửi thông báo "sách ready"
    ready_expiry_date DATETIME, -- Hạn chót để lấy sách (1 ngày sau khi ready)
    claimed_date DATETIME, -- Lúc user nhận sách
    cancelled_reason VARCHAR(255),
    cancelled_at DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL ON UPDATE CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_rr_user FOREIGN KEY (user_id) 
        REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_rr_book FOREIGN KEY (book_id) 
        REFERENCES books (id) ON DELETE CASCADE ON UPDATE CASCADE,
    
    INDEX idx_user_id (user_id),
    INDEX idx_book_id (book_id),
    INDEX idx_status (status),
    INDEX idx_queue_position (queue_position),
    INDEX idx_request_date (request_date)
);

-- ============================================
-- 13. FINES TABLE - Quản lý tiền phạt
-- ============================================
CREATE TABLE fines (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    borrow_record_id INT,
    book_id INT NOT NULL,
    fine_type ENUM('OVERDUE', 'DAMAGED', 'LOST') NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    calculation_details VARCHAR(255), -- Chi tiết tính toán (vd: "8 ngày × 5000")
    status ENUM('UNPAID', 'PENDING_VERIFY', 'PAID', 'WAIVED') DEFAULT 'UNPAID' NOT NULL,
    payment_method ENUM('CASH', 'ONLINE', 'BANK_TRANSFER', 'QR_CODE') DEFAULT 'CASH',
    payment_date DATE,
    paid_by INT, -- Librarian hoặc Admin xác nhận thanh toán
    payment_note VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL ON UPDATE CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_fines_user FOREIGN KEY (user_id) 
        REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_fines_borrow FOREIGN KEY (borrow_record_id) 
        REFERENCES borrow_records (id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_fines_book FOREIGN KEY (book_id) 
        REFERENCES books (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_fines_paid_by FOREIGN KEY (paid_by) 
        REFERENCES users (id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT chk_amount CHECK (amount > 0),
    
    INDEX idx_user_id (user_id),
    INDEX idx_status (status),
    INDEX idx_fine_type (fine_type),
    INDEX idx_borrow_record_id (borrow_record_id)
);

-- ============================================
-- 14. NOTIFICATIONS TABLE - Thông báo
-- ============================================
CREATE TABLE notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    notification_type ENUM(
        'DUE_REMINDER_3DAYS',
        'DUE_REMINDER_1DAY',
        'OVERDUE',
        'FINE_CREATED',
        'RESERVATION_READY',
        'RESERVATION_EXPIRED',
        'BORROW_CONFIRMED',
        'PAYMENT_CONFIRMED',
        'ACCOUNT_LOCKED',
        'SYSTEM'
    ) DEFAULT 'SYSTEM' NOT NULL,
    is_read TINYINT(1) DEFAULT 0 NOT NULL,
    reference_type VARCHAR(50), -- 'borrow_record', 'reservation_record', 'fine'
    reference_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    read_at DATETIME,
    
    CONSTRAINT fk_notif_user FOREIGN KEY (user_id) 
        REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE,
    
    INDEX idx_user_id (user_id),
    INDEX idx_is_read (is_read),
    INDEX idx_notification_type (notification_type),
    INDEX idx_created_at (created_at)
);

-- ============================================
-- VIEWS - Các view để query dữ liệu dễ dàng
-- ============================================

-- View: Sách còn hàng
CREATE VIEW available_books_view AS
SELECT 
    b.id,
    b.isbn,
    b.title,
    c.name AS category,
    s.name AS subject,
    p.name AS publisher,
    b.publish_year,
    COUNT(bc.id) AS total_copies,
    SUM(CASE WHEN bc.status = 'AVAILABLE' THEN 1 ELSE 0 END) AS available_count
FROM books b
LEFT JOIN categories c ON b.category_id = c.id
LEFT JOIN subjects s ON b.subject_id = s.id
LEFT JOIN publishers p ON b.publisher_id = p.id
LEFT JOIN book_copies bc ON b.id = bc.book_id
GROUP BY b.id;

-- View: Sách quá hạn
CREATE VIEW overdue_books_view AS
SELECT 
    br.id AS borrow_id,
    u.id AS user_id,
    u.full_name,
    u.email,
    b.title,
    b.isbn,
    br.due_date,
    DATEDIFF(CURDATE(), br.due_date) AS overdue_days,
    (DATEDIFF(CURDATE(), br.due_date) * 5000) AS estimated_fine
FROM borrow_records br
JOIN users u ON br.user_id = u.id
JOIN books b ON br.book_id = b.id
WHERE br.status = 'BORROWING' 
    AND br.due_date < CURDATE();

-- View: Sách được mượn nhiều nhất (tháng này)
CREATE VIEW popular_books_view AS
SELECT 
    b.id,
    b.title,
    b.isbn,
    COUNT(br.id) AS borrow_count,
    YEAR(br.borrow_date) AS year,
    MONTH(br.borrow_date) AS month
FROM books b
LEFT JOIN borrow_records br ON b.id = br.book_id
WHERE YEAR(br.borrow_date) = YEAR(CURDATE())
    AND MONTH(br.borrow_date) = MONTH(CURDATE())
GROUP BY b.id
ORDER BY borrow_count DESC;

-- View: Danh sách reservation đang chờ
CREATE VIEW pending_reservations_view AS
SELECT 
    rr.id,
    rr.queue_position,
    u.full_name,
    u.email,
    b.title,
    b.isbn,
    rr.request_date,
    rr.expiry_date
FROM reservation_records rr
JOIN users u ON rr.user_id = u.id
JOIN books b ON rr.book_id = b.id
WHERE rr.status = 'PENDING'
ORDER BY rr.queue_position ASC;

-- View: Người dùng hoạt động (tính từ tần suất mượn, đúng hạn, không hỏng)
CREATE VIEW active_users_view AS
SELECT 
    u.id,
    u.full_name,
    u.student_id,
    COUNT(br.id) AS total_borrows,
    SUM(CASE WHEN br.status = 'RETURNED' AND br.return_date <= br.due_date THEN 1 ELSE 0 END) AS on_time_returns,
    COUNT(f.id) AS total_fines,
    (COUNT(br.id) - COUNT(f.id)) AS activity_score
FROM users u
LEFT JOIN borrow_records br ON u.id = br.user_id
LEFT JOIN fines f ON u.id = f.user_id
WHERE u.role = 'USER'
GROUP BY u.id
ORDER BY activity_score DESC;

-- ============================================
-- INDEXES - Tối ưu performance
-- ============================================

CREATE INDEX idx_borrow_records_user_date ON borrow_records(user_id, borrow_date);
CREATE INDEX idx_borrow_records_book_date ON borrow_records(book_id, borrow_date);
CREATE INDEX idx_fines_user_status ON fines(user_id, status);
CREATE INDEX idx_reservation_user_book ON reservation_records(user_id, book_id);
CREATE INDEX idx_book_copies_book_status ON book_copies(book_id, status);
CREATE INDEX idx_book_locations_area_shelf_slot ON book_locations(area, shelf, slot);

-- ============================================
-- CONSTRAINTS - Ràng buộc dữ liệu
-- ============================================

-- Constraint: Khi khóa tài khoản, phải có lý do
ALTER TABLE users ADD CONSTRAINT chk_lock_reason
    CHECK (is_locked = 0 OR (is_locked = 1 AND lock_reason IS NOT NULL));

-- Constraint: Giá sách phải lớn hơn 0
ALTER TABLE books ADD CONSTRAINT chk_price_positive
    CHECK (price > 0);

-- Constraint: Queue position phải >= 1
ALTER TABLE reservation_records ADD CONSTRAINT chk_queue_position
    CHECK (queue_position >= 1);

-- ============================================
-- DEFAULT SETTINGS TABLE (tùy chọn)
-- ============================================
CREATE TABLE system_settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    setting_key VARCHAR(50) NOT NULL UNIQUE,
    setting_value VARCHAR(255) NOT NULL,
    description VARCHAR(500),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_setting_key (setting_key)
);

-- Insert default settings
INSERT INTO system_settings (setting_key, setting_value, description) VALUES
('MAX_BORROW_DAYS', '14', 'Số ngày mượn tối đa mặc định'),
('MIN_BORROW_DAYS', '3', 'Số ngày mượn tối thiểu'),
('MAX_RENEW_TIMES', '3', 'Số lần gia hạn tối đa'),
('MAX_COPIES_PER_TYPE', '5', 'Tối đa số quyển mỗi loại sách một user có thể mượn'),
('OVERDUE_FINE_PER_DAY', '5000', 'Tiền phạt quá hạn/ngày (VNĐ)'),
('OVERDUE_FINE_MAX_PERCENT', '30', 'Tối đa phạt quá hạn (% giá sách)'),
('DAMAGED_FINE_PERCENT', '70', 'Phạt hỏng sách (% giá sách)'),
('LOST_FINE_PERCENT', '100', 'Phạt mất sách (% giá sách)'),
('RESERVATION_VALIDITY_DAYS', '3', 'Phiếu đặt có hiệu lực (ngày)'),
('RESERVATION_CLAIM_DAYS', '1', 'Người đặt có bao lâu để lấy sách sau khi ready (ngày)'),
('DUE_REMINDER_DAYS', '3', 'Nhắc nhở trả sách trước N ngày'),
('MAX_CONCURRENT_BORROWS', '5', 'Tối đa số sách một user có thể mượn cùng lúc (mỗi loại)');

-- ============================================
-- END OF SCHEMA
-- ============================================
