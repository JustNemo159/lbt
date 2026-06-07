-- ============================================
-- LIBRARY MANAGEMENT SYSTEM - COMPLETE SETUP
-- ============================================
-- Full database creation + sample data
-- Database: MySQL 8.0+
-- Usage: Copy-paste directly into DBeaver or MySQL client

-- ============================================
-- DROP EXISTING DATABASE (Optional - uncomment if needed)
-- ============================================
-- DROP DATABASE IF EXISTS library_management;
-- CREATE DATABASE library_management CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- USE library_management;

-- ============================================
-- 1. CREATE CATEGORIES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(500),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_name (name)
);

-- ============================================
-- 2. CREATE SUBJECTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS subjects (
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
-- 3. CREATE AUTHORS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS authors (
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
-- 4. CREATE PUBLISHERS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS publishers (
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
-- 5. CREATE USERS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15),
    avatar VARCHAR(255),
    student_id VARCHAR(20) NOT NULL UNIQUE,
    role ENUM('ADMIN', 'LIBRARIAN', 'USER') DEFAULT 'USER' NOT NULL,
    is_active TINYINT(1) DEFAULT 1 NOT NULL,
    is_locked TINYINT(1) DEFAULT 0 NOT NULL,
    lock_reason VARCHAR(500),
    lock_date DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_student_id (student_id),
    INDEX idx_role (role)
);

-- ============================================
-- 6. CREATE BOOKS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(20) NOT NULL UNIQUE,
    title VARCHAR(255) NOT NULL,
    category_id INT NOT NULL,
    subject_id INT,
    publisher_id INT,
    publish_year INT,
    description TEXT,
    cover_image VARCHAR(500),
    price DECIMAL(12, 2) NOT NULL DEFAULT 0,
    total_copies INT DEFAULT 0 NOT NULL,
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
-- 7. CREATE BOOK_AUTHORS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS book_authors (
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
-- 8. CREATE BOOK_LOCATIONS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS book_locations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    area VARCHAR(50) NOT NULL,
    shelf VARCHAR(20) NOT NULL,
    slot VARCHAR(20) NOT NULL,
    description VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL ON UPDATE CURRENT_TIMESTAMP,
    
    UNIQUE KEY uq_location (area, shelf, slot),
    INDEX idx_area (area),
    INDEX idx_shelf (shelf),
    INDEX idx_slot (slot)
);

-- ============================================
-- 9. CREATE BOOK_COPIES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS book_copies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    barcode VARCHAR(50) NOT NULL UNIQUE,
    location_id INT,
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
-- 10. CREATE BORROW_RECORDS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS borrow_records (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    book_copy_id INT NOT NULL,
    book_id INT NOT NULL,
    borrow_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    max_renew_count INT DEFAULT 0,
    actual_renew_count INT DEFAULT 0,
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
-- 11. CREATE RENEW_RECORDS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS renew_records (
    id INT AUTO_INCREMENT PRIMARY KEY,
    borrow_record_id INT NOT NULL,
    renew_count INT NOT NULL,
    old_due_date DATE NOT NULL,
    new_due_date DATE NOT NULL,
    renew_days INT NOT NULL,
    created_by INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    
    CONSTRAINT fk_rr_borrow FOREIGN KEY (borrow_record_id) 
        REFERENCES borrow_records (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_rr_user FOREIGN KEY (created_by) 
        REFERENCES users (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    
    INDEX idx_borrow_record_id (borrow_record_id),
    INDEX idx_renew_count (renew_count)
);

-- ============================================
-- 12. CREATE RESERVATION_RECORDS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS reservation_records (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    book_id INT NOT NULL,
    status ENUM('PENDING', 'READY', 'CLAIMED', 'CANCELLED', 'EXPIRED') DEFAULT 'PENDING' NOT NULL,
    queue_position INT NOT NULL DEFAULT 0,
    request_date DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    expiry_date DATETIME,
    ready_notification_sent_at DATETIME,
    ready_expiry_date DATETIME,
    claimed_date DATETIME,
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
-- 13. CREATE FINES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS fines (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    borrow_record_id INT,
    book_id INT NOT NULL,
    fine_type ENUM('OVERDUE', 'DAMAGED', 'LOST') NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    calculation_details VARCHAR(255),
    status ENUM('UNPAID', 'PENDING_VERIFY', 'PAID', 'WAIVED') DEFAULT 'UNPAID' NOT NULL,
    payment_method ENUM('CASH', 'ONLINE', 'BANK_TRANSFER', 'QR_CODE') DEFAULT 'CASH',
    payment_date DATE,
    paid_by INT,
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
-- 14. CREATE NOTIFICATIONS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS notifications (
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
    reference_type VARCHAR(50),
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
-- 15. CREATE SYSTEM_SETTINGS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS system_settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    setting_key VARCHAR(50) NOT NULL UNIQUE,
    setting_value VARCHAR(255) NOT NULL,
    description VARCHAR(500),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_setting_key (setting_key)
);

-- ============================================
-- START INSERTING SAMPLE DATA
-- ============================================

-- ============================================
-- INSERT CATEGORIES
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
-- INSERT SUBJECTS
-- ============================================
INSERT INTO subjects (category_id, name, description) VALUES
(3, 'Programming', 'Lập trình máy tính'),
(3, 'Web Development', 'Phát triển web'),
(3, 'Database', 'Cơ sở dữ liệu'),
(3, 'Artificial Intelligence', 'Trí tuệ nhân tạo'),
(5, 'Mathematics', 'Toán học'),
(5, 'Physics', 'Vật lý'),
(5, 'Chemistry', 'Hóa học'),
(5, 'Literature', 'Văn học'),
(4, 'Management', 'Quản lý'),
(4, 'Marketing', 'Tiếp thị'),
(4, 'Finance', 'Tài chính'),
(7, 'Biology', 'Sinh học'),
(7, 'Geology', 'Địa chất học');

-- ============================================
-- INSERT AUTHORS
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
-- INSERT PUBLISHERS
-- ============================================
INSERT INTO publishers (name, address, phone, email) VALUES
('Prentice Hall', 'USA', '+1-800-927-0117', 'contact@prenticehall.com'),
('Addison-Wesley', 'USA', '+1-201-236-7000', 'contact@aw.com'),
('OReilly Media', 'USA', '+1-707-827-7000', 'contact@oreilly.com'),
('Pragmatic Bookshelf', 'USA', '+1-919-847-9884', 'contact@pragprog.com'),
('Nha xuat ban Tre', 'Vietnam', '+84-28-3929-3945', 'info@nxbtre.com'),
('Nha xuat ban Van hoc', 'Vietnam', '+84-24-3825-6645', 'info@nxbvanhoq.com'),
('Packt Publishing', 'UK', '+44-121-262-2444', 'contact@packt.com'),
('Manning Publications', 'USA', '+1-203-662-6500', 'contact@manning.com');

-- ============================================
-- INSERT USERS
-- ============================================
INSERT INTO users (username, password, full_name, email, phone, student_id, role) VALUES
('admin1', '$2y$10$hashed_password_1', 'Nguyen Van Admin', 'admin1@library.edu.vn', '0987654321', 'AD001', 'ADMIN'),
('admin2', '$2y$10$hashed_password_2', 'Tran Thi Admin', 'admin2@library.edu.vn', '0987654322', 'AD002', 'ADMIN'),
('librarian1', '$2y$10$hashed_password_3', 'Pham Thu Thu 1', 'librarian1@library.edu.vn', '0912345678', 'LB001', 'LIBRARIAN'),
('librarian2', '$2y$10$hashed_password_4', 'Hoang Thu Thu 2', 'librarian2@library.edu.vn', '0912345679', 'LB002', 'LIBRARIAN'),
('librarian3', '$2y$10$hashed_password_5', 'Le Thu Thu 3', 'librarian3@library.edu.vn', '0912345680', 'LB003', 'LIBRARIAN'),
('student001', '$2y$10$hashed_password_6', 'Ly The Han', 'student001@student.edu.vn', '0901111111', 'SV001', 'USER'),
('student002', '$2y$10$hashed_password_7', 'Dinh Huu Huy', 'student002@student.edu.vn', '0901111112', 'SV002', 'USER'),
('student003', '$2y$10$hashed_password_8', 'Truong Thi Tu Anh', 'student003@student.edu.vn', '0901111113', 'SV003', 'USER'),
('student004', '$2y$10$hashed_password_9', 'Do Minh Tuan', 'student004@student.edu.vn', '0901111114', 'SV004', 'USER'),
('student005', '$2y$10$hashed_password_10', 'Pham Huong Ly', 'student005@student.edu.vn', '0901111115', 'SV005', 'USER'),
('student006', '$2y$10$hashed_password_11', 'Vu Thanh Ha', 'student006@student.edu.vn', '0901111116', 'SV006', 'USER'),
('student007', '$2y$10$hashed_password_12', 'Bui Khoa Duong', 'student007@student.edu.vn', '0901111117', 'SV007', 'USER'),
('student008', '$2y$10$hashed_password_13', 'To Thi Thanh Tuyen', 'student008@student.edu.vn', '0901111118', 'SV008', 'USER');

-- ============================================
-- INSERT BOOK_LOCATIONS
-- ============================================
INSERT INTO book_locations (area, shelf, slot, description) VALUES
('Khu A', 'K01', 'N01', 'Lap trinh'),
('Khu A', 'K01', 'N02', 'Lap trinh'),
('Khu A', 'K02', 'N01', 'Web Development'),
('Khu A', 'K02', 'N02', 'Web Development'),
('Khu A', 'K03', 'N01', 'Database'),
('Khu A', 'K03', 'N02', 'Database'),
('Khu B', 'K01', 'N01', 'Toan hoc'),
('Khu B', 'K01', 'N02', 'Toan hoc'),
('Khu B', 'K02', 'N01', 'Vat ly'),
('Khu B', 'K02', 'N02', 'Vat ly'),
('Khu B', 'K03', 'N01', 'Hoa hoc'),
('Khu B', 'K03', 'N02', 'Hoa hoc'),
('Khu C', 'K01', 'N01', 'Quan ly'),
('Khu C', 'K01', 'N02', 'Quan ly'),
('Khu C', 'K02', 'N01', 'Marketing'),
('Khu C', 'K02', 'N02', 'Marketing'),
('Khu D', 'K01', 'N01', 'Tieu thuyet'),
('Khu D', 'K01', 'N02', 'Tieu thuyet'),
('Khu D', 'K02', 'N01', 'Van hoc'),
('Khu D', 'K02', 'N02', 'Van hoc');

-- ============================================
-- INSERT BOOKS
-- ============================================
INSERT INTO books (isbn, title, category_id, subject_id, publisher_id, publish_year, description, price, total_copies) VALUES
('9780132350884', 'Clean Code: A Handbook of Agile Software Craftsmanship', 3, 1, 1, 2008, 'Mot cuon sach khong the bo qua ve cach viet code sach va de hieu', 450000, 5),
('9780201633610', 'Design Patterns: Elements of Reusable Object-Oriented Software', 3, 1, 1, 1994, 'Co so ve cac design patterns trong lap trinh huong doi tuong', 550000, 4),
('9780135957052', 'The Pragmatic Programmer: Your Journey to Mastery', 3, 1, 4, 2019, 'Huong dan tro thanh lap trinh vien chuyen nghiep', 480000, 3),
('9781491952023', 'Learning Web Design', 3, 2, 3, 2018, 'Sach ve thiet ke web va phat trien web', 420000, 4),
('9780134685991', 'Effective Java', 3, 1, 1, 2018, 'Huong dan viet code Java hieu qua', 480000, 3),
('9780131101920', 'Calculus: Early Transcendentals', 5, 5, 1, 2010, 'Sach giao khoa Giai tich cao cap', 380000, 6),
('9780393614602', 'Physics for Scientists and Engineers', 5, 6, 2, 2018, 'Vat ly danh cho cac nha khoa hoc va ky su', 520000, 4),
('9780134998671', 'Chemistry: The Central Science', 5, 7, 1, 2021, 'Hoa hoc can ban cho sinh vien', 450000, 5),
('9780062301499', 'Thinking, Fast and Slow', 4, 9, 8, 2013, 'Tam ly hoc nhan thuc va ra quyet dinh trong kinh doanh', 380000, 3),
('9781491954028', 'Marketing Metrics', 4, 10, 3, 2016, 'Cac chi so danh gia hieu qua marketing', 340000, 2),
('9780061120084', 'To Kill a Mockingbird', 1, 8, 2, 2006, 'Tieu thuyet kinh dien ve cong ly va nhan quyen', 280000, 3),
('9789654618072', 'Tuoi tho du doi', 1, 8, 5, 1995, 'Tieu thuyet cua Nguyen Nhat Anh ve tuoi tho', 150000, 8);

-- ============================================
-- INSERT BOOK_AUTHORS
-- ============================================
INSERT INTO book_authors (book_id, author_id, role) VALUES
(1, 1, 'PRIMARY'),
(2, 2, 'PRIMARY'),
(2, 3, 'CO_AUTHOR'),
(2, 4, 'CO_AUTHOR'),
(2, 5, 'CO_AUTHOR'),
(3, 7, 'PRIMARY'),
(3, 8, 'CO_AUTHOR'),
(4, 6, 'PRIMARY'),
(5, 1, 'PRIMARY'),
(6, 3, 'PRIMARY'),
(7, 4, 'PRIMARY'),
(8, 5, 'PRIMARY'),
(9, 6, 'PRIMARY'),
(10, 7, 'PRIMARY'),
(11, 8, 'PRIMARY'),
(12, 9, 'PRIMARY');

-- ============================================
-- INSERT BOOK_COPIES
-- ============================================
INSERT INTO book_copies (book_id, barcode, location_id, condition, status, purchase_date) VALUES
(1, 'BC001', 1, 'GOOD', 'AVAILABLE', '2022-01-15'),
(1, 'BC002', 1, 'GOOD', 'BORROWED', '2022-01-15'),
(1, 'BC003', 1, 'GOOD', 'AVAILABLE', '2022-01-15'),
(1, 'BC004', 1, 'GOOD', 'BORROWED', '2022-02-20'),
(1, 'BC005', 1, 'DAMAGED', 'DAMAGED', '2022-01-15'),
(2, 'DP001', 2, 'GOOD', 'AVAILABLE', '2021-05-10'),
(2, 'DP002', 2, 'GOOD', 'BORROWED', '2021-05-10'),
(2, 'DP003', 2, 'GOOD', 'AVAILABLE', '2021-06-15'),
(2, 'DP004', 2, 'GOOD', 'AVAILABLE', '2021-06-15'),
(3, 'PP001', 3, 'GOOD', 'AVAILABLE', '2023-03-01'),
(3, 'PP002', 3, 'GOOD', 'AVAILABLE', '2023-03-01'),
(3, 'PP003', 3, 'GOOD', 'BORROWED', '2023-03-01'),
(4, 'WD001', 4, 'GOOD', 'AVAILABLE', '2023-07-20'),
(4, 'WD002', 4, 'GOOD', 'BORROWED', '2023-07-20'),
(4, 'WD003', 4, 'GOOD', 'AVAILABLE', '2023-07-20'),
(4, 'WD004', 4, 'GOOD', 'AVAILABLE', '2023-07-20'),
(5, 'EJ001', 1, 'GOOD', 'AVAILABLE', '2023-02-10'),
(5, 'EJ002', 1, 'GOOD', 'AVAILABLE', '2023-02-10'),
(5, 'EJ003', 1, 'GOOD', 'BORROWED', '2023-02-10'),
(6, 'CA001', 7, 'GOOD', 'AVAILABLE', '2022-08-05'),
(6, 'CA002', 7, 'GOOD', 'BORROWED', '2022-08-05'),
(6, 'CA003', 7, 'GOOD', 'AVAILABLE', '2022-08-05'),
(6, 'CA004', 7, 'GOOD', 'AVAILABLE', '2022-09-10'),
(6, 'CA005', 7, 'GOOD', 'AVAILABLE', '2022-09-10'),
(6, 'CA006', 7, 'GOOD', 'BORROWED', '2022-09-10'),
(7, 'PH001', 9, 'GOOD', 'AVAILABLE', '2023-01-15'),
(7, 'PH002', 9, 'GOOD', 'AVAILABLE', '2023-01-15'),
(7, 'PH003', 9, 'GOOD', 'BORROWED', '2023-01-15'),
(7, 'PH004', 9, 'GOOD', 'AVAILABLE', '2023-01-15'),
(8, 'CH001', 11, 'GOOD', 'AVAILABLE', '2023-04-20'),
(8, 'CH002', 11, 'GOOD', 'BORROWED', '2023-04-20'),
(8, 'CH003', 11, 'GOOD', 'AVAILABLE', '2023-04-20'),
(8, 'CH004', 11, 'GOOD', 'AVAILABLE', '2023-04-20'),
(8, 'CH005', 11, 'GOOD', 'AVAILABLE', '2023-04-20'),
(9, 'TFS001', 13, 'GOOD', 'AVAILABLE', '2023-06-10'),
(9, 'TFS002', 13, 'GOOD', 'BORROWED', '2023-06-10'),
(9, 'TFS003', 13, 'GOOD', 'AVAILABLE', '2023-06-10'),
(10, 'MM001', 15, 'GOOD', 'AVAILABLE', '2023-05-15'),
(10, 'MM002', 15, 'GOOD', 'AVAILABLE', '2023-05-15'),
(11, 'TKM001', 17, 'GOOD', 'AVAILABLE', '2022-10-20'),
(11, 'TKM002', 17, 'GOOD', 'BORROWED', '2022-10-20'),
(11, 'TKM003', 17, 'GOOD', 'AVAILABLE', '2022-10-20'),
(12, 'TTD001', 19, 'GOOD', 'AVAILABLE', '2021-12-01'),
(12, 'TTD002', 19, 'GOOD', 'AVAILABLE', '2021-12-01'),
(12, 'TTD003', 19, 'GOOD', 'BORROWED', '2021-12-01'),
(12, 'TTD004', 19, 'GOOD', 'AVAILABLE', '2021-12-01'),
(12, 'TTD005', 19, 'GOOD', 'AVAILABLE', '2021-12-01'),
(12, 'TTD006', 19, 'GOOD', 'AVAILABLE', '2021-12-01'),
(12, 'TTD007', 19, 'GOOD', 'AVAILABLE', '2021-12-01'),
(12, 'TTD008', 19, 'GOOD', 'BORROWED', '2021-12-01');

-- ============================================
-- INSERT BORROW_RECORDS
-- ============================================
INSERT INTO borrow_records (user_id, book_copy_id, book_id, borrow_date, due_date, return_date, max_renew_count, actual_renew_count, status) VALUES
(6, 2, 1, '2026-06-01', '2026-06-15', NULL, 3, 0, 'BORROWING'),
(6, 8, 2, '2026-06-02', '2026-06-16', NULL, 3, 1, 'BORROWING'),
(7, 3, 1, '2026-05-20', '2026-06-03', '2026-06-02', 3, 0, 'RETURNED'),
(7, 10, 3, '2026-05-25', '2026-06-08', '2026-06-08', 3, 0, 'RETURNED'),
(8, 11, 3, '2026-06-03', '2026-06-17', NULL, 3, 0, 'BORROWING'),
(8, 14, 4, '2026-06-04', '2026-06-18', NULL, 3, 0, 'BORROWING'),
(9, 17, 5, '2026-05-15', '2026-05-29', NULL, 3, 0, 'OVERDUE'),
(10, 18, 6, '2026-05-10', '2026-05-24', '2026-05-24', 3, 0, 'RETURNED'),
(10, 21, 7, '2026-05-18', '2026-06-01', '2026-06-01', 3, 0, 'RETURNED'),
(11, 24, 8, '2026-06-05', '2026-06-19', NULL, 3, 0, 'BORROWING'),
(12, 26, 9, '2026-05-22', '2026-06-05', '2026-06-05', 3, 0, 'RETURNED'),
(13, 28, 10, '2026-06-06', '2026-06-20', NULL, 3, 0, 'BORROWING');

-- ============================================
-- INSERT RENEW_RECORDS
-- ============================================
INSERT INTO renew_records (borrow_record_id, renew_count, old_due_date, new_due_date, renew_days, created_by) VALUES
(2, 1, '2026-06-16', '2026-06-30', 14, 1);

-- ============================================
-- INSERT RESERVATION_RECORDS
-- ============================================
INSERT INTO reservation_records (user_id, book_id, status, queue_position, request_date, expiry_date) VALUES
(7, 1, 'PENDING', 1, '2026-06-06 10:30:00', '2026-06-09 23:59:59'),
(9, 1, 'PENDING', 2, '2026-06-06 14:15:00', '2026-06-09 23:59:59'),
(10, 2, 'READY', 1, '2026-06-03 08:00:00', '2026-06-07 23:59:59'),
(11, 3, 'CLAIMED', 1, '2026-05-28 09:00:00', '2026-06-05 15:30:00');

-- ============================================
-- INSERT FINES
-- ============================================
INSERT INTO fines (user_id, borrow_record_id, book_id, fine_type, amount, calculation_details, status, payment_method) VALUES
(9, 7, 5, 'OVERDUE', 90000, '18 ngay x 5,000 = 90,000', 'UNPAID', 'CASH'),
(7, 4, 1, 'OVERDUE', 35000, '7 ngay x 5,000 = 35,000', 'PAID', 'CASH');

-- ============================================
-- INSERT NOTIFICATIONS
-- ============================================
INSERT INTO notifications (user_id, title, message, notification_type, is_read, reference_type, reference_id) VALUES
(6, 'Nhac nho tra sach', 'Sach Clean Code cua ban sap het han vao 2026-06-15', 'DUE_REMINDER_3DAYS', 0, 'borrow_record', 1),
(8, 'Nhac nho tra sach', 'Sach Learning Web Design cua ban sap het han vao 2026-06-18', 'DUE_REMINDER_1DAY', 0, 'borrow_record', 3),
(9, 'Sach qua han', 'Sach Effective Java cua ban da qua han tra. Vui long tra sach som nhat.', 'OVERDUE', 0, 'borrow_record', 7),
(9, 'Thong bao phat', 'Ban da bi phat 90,000 VND do tra sach muon. Vui long thanh toan.', 'FINE_CREATED', 0, 'fine', 1),
(10, 'Sach da san sang', 'Sach Design Patterns ban dat truoc da co san. Vui long toi lay trong 1 ngay.', 'RESERVATION_READY', 0, 'reservation_record', 3),
(9, 'Tai khoan bi khoa', 'Tai khoan cua ban da bi khoa vi qua han tra sach. Lien he thu thu de biet them chi tiet.', 'ACCOUNT_LOCKED', 0, 'user', 9),
(7, 'Xac nhan thanh toan', 'Thanh toan phat 35,000 VND cua ban da duoc xac nhan. Cam on!', 'PAYMENT_CONFIRMED', 1, 'fine', 2);

-- ============================================
-- INSERT SYSTEM SETTINGS
-- ============================================
INSERT INTO system_settings (setting_key, setting_value, description) VALUES
('MAX_BORROW_DAYS', '14', 'So ngay muon toi da mac dinh'),
('MIN_BORROW_DAYS', '3', 'So ngay muon toi thieu'),
('MAX_RENEW_TIMES', '3', 'So lan gia han toi da'),
('MAX_COPIES_PER_TYPE', '5', 'Toi da so quyen moi loai sach mot user co the muon'),
('OVERDUE_FINE_PER_DAY', '5000', 'Tien phat qua han/ngay (VND)'),
('OVERDUE_FINE_MAX_PERCENT', '30', 'Toi da phat qua han (% gia sach)'),
('DAMAGED_FINE_PERCENT', '70', 'Phat hong sach (% gia sach)'),
('LOST_FINE_PERCENT', '100', 'Phat mat sach (% gia sach)'),
('RESERVATION_VALIDITY_DAYS', '3', 'Phieu dat co hieu luc (ngay)'),
('RESERVATION_CLAIM_DAYS', '1', 'Nguoi dat co bao lau de lay sach sau khi ready (ngay)'),
('DUE_REMINDER_DAYS', '3', 'Nhac nho tra sach truoc N ngay'),
('MAX_CONCURRENT_BORROWS', '5', 'Toi da so sach mot user co the muon cung luc (moi loai)');

-- ============================================
-- SUCCESS MESSAGE
-- ============================================
-- Database va du lieu mau da duoc tao thanh cong!
-- Hay su dung cac query sau de kiem tra:

-- Query 1: Kiem tra so sach con hang
SELECT COUNT(*) as SoSachConHang FROM book_copies WHERE status = 'AVAILABLE';

-- Query 2: Kiem tra so sach dang duoc muon
SELECT COUNT(*) as SoSachDangMuon FROM book_copies WHERE status = 'BORROWED';

-- Query 3: Danh sach sach qua han
SELECT br.id, u.full_name, b.title, br.due_date, 
       DATEDIFF(CURDATE(), br.due_date) as NgayQuaHan
FROM borrow_records br
JOIN users u ON br.user_id = u.id
JOIN books b ON br.book_id = b.id
WHERE br.status = 'BORROWING' AND br.due_date < CURDATE();

-- Query 4: Nguoi dung no phat
SELECT u.full_name, SUM(f.amount) as TongTienPhat
FROM fines f
JOIN users u ON f.user_id = u.id
WHERE f.status IN ('UNPAID', 'PENDING_VERIFY')
GROUP BY f.user_id;

-- Query 5: Sach duoc muon nhieu nhat
SELECT b.title, COUNT(br.id) as SoLanMuon
FROM borrow_records br
JOIN books b ON br.book_id = b.id
GROUP BY br.book_id
ORDER BY COUNT(br.id) DESC
LIMIT 10;

-- ============================================
-- END OF SETUP
-- ============================================
