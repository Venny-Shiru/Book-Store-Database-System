-- Create the database
CREATE DATABASE BookStore;
USE BookStore;

-- Create tables with appropriate relationships

-- Country table
CREATE TABLE country (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL,
    country_code CHAR(2) NOT NULL UNIQUE
);

-- Address table
CREATE TABLE address (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    street_number VARCHAR(20),
    street_name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state_province VARCHAR(100),
    postal_code VARCHAR(20) NOT NULL,
    country_id INT NOT NULL,
    FOREIGN KEY (country_id) REFERENCES country(country_id)
);

-- Address status table
CREATE TABLE address_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    address_status VARCHAR(20) NOT NULL UNIQUE
);

-- Publisher table
CREATE TABLE publisher (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    publisher_name VARCHAR(255) NOT NULL,
    address_id INT,
    phone VARCHAR(20),
    email VARCHAR(100),
    FOREIGN KEY (address_id) REFERENCES address(address_id)
);

-- Book language table
CREATE TABLE book_language (
    language_id INT AUTO_INCREMENT PRIMARY KEY,
    language_code CHAR(8) NOT NULL UNIQUE,
    language_name VARCHAR(50) NOT NULL
);

-- Author table
CREATE TABLE author (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    author_name VARCHAR(255) NOT NULL,
    birth_date DATE,
    death_date DATE,
    biography TEXT
);

-- Book table
CREATE TABLE book (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    isbn13 CHAR(13) UNIQUE,
    language_id INT NOT NULL,
    num_pages INT,
    publication_date DATE,
    publisher_id INT,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    FOREIGN KEY (language_id) REFERENCES book_language(language_id),
    FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id)
);

-- Book-Author relationship (many-to-many)
CREATE TABLE book_author (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id),
    FOREIGN KEY (author_id) REFERENCES author(author_id)
);

-- Customer table
CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    date_created DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Customer address relationship table
CREATE TABLE customer_address (
    customer_id INT NOT NULL,
    address_id INT NOT NULL,
    status_id INT NOT NULL,
    date_from DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_to DATETIME,
    PRIMARY KEY (customer_id, address_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (address_id) REFERENCES address(address_id),
    FOREIGN KEY (status_id) REFERENCES address_status(status_id)
);

-- Shipping method table
CREATE TABLE shipping_method (
    method_id INT AUTO_INCREMENT PRIMARY KEY,
    method_name VARCHAR(100) NOT NULL,
    cost DECIMAL(10, 2) NOT NULL,
    estimated_days INT NOT NULL
);

-- Order status table
CREATE TABLE order_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(20) NOT NULL UNIQUE
);

-- Customer order table
CREATE TABLE cust_order (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    shipping_address_id INT NOT NULL,
    shipping_method_id INT NOT NULL,
    order_total DECIMAL(10, 2) NOT NULL,
    current_status_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (shipping_address_id) REFERENCES address(address_id),
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(method_id),
    FOREIGN KEY (current_status_id) REFERENCES order_status(status_id)
);

-- Order line items (books in an order)
CREATE TABLE order_line (
    line_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id)
);

-- Order history table
CREATE TABLE order_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    status_id INT NOT NULL,
    status_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (status_id) REFERENCES order_status(status_id)
);

-- Step 3: Create indexes for performance optimization
CREATE INDEX idx_book_title ON book(title);
CREATE INDEX idx_customer_names ON customer(last_name, first_name);
CREATE INDEX idx_order_date ON cust_order(order_date);
CREATE INDEX idx_author_name ON author(author_name);

-- Step 4: Insert sample data

-- Insert countries
INSERT INTO country (country_name, country_code) VALUES
('United States', 'US'),
('Canada', 'CA'),
('United Kingdom', 'UK'),
('Germany', 'DE'),
('France', 'FR');

-- Insert address statuses
INSERT INTO address_status (address_status) VALUES
('Current'),
('Previous'),
('Shipping'),
('Billing'),
('Business');

-- Insert book languages
INSERT INTO book_language (language_code, language_name) VALUES
('en', 'English'),
('fr', 'French'),
('de', 'German'),
('es', 'Spanish'),
('zh', 'Chinese');

-- Insert addresses
INSERT INTO address (street_number, street_name, city, state_province, postal_code, country_id) VALUES
('123', 'Main St', 'New York', 'NY', '10001', 1),
('456', 'Elm St', 'Toronto', 'ON', 'M5V 2H1', 2),
('789', 'Oxford St', 'London', NULL, 'W1D 1BS', 3),
('101', 'Berliner Allee', 'Berlin', NULL, '10115', 4),
('202', 'Rue de Rivoli', 'Paris', NULL, '75001', 5);

-- Insert publishers
INSERT INTO publisher (publisher_name, address_id, phone, email) VALUES
('Penguin Random House', 1, '212-555-1000', 'info@penguinrandomhouse.com'),
('HarperCollins', 2, '416-555-2000', 'info@harpercollins.com'),
('Oxford University Press', 3, '44-20-5551234', 'info@oup.com'),
('Springer', 4, '49-30-5554321', 'info@springer.de'),
('Hachette Livre', 5, '33-1-55554444', 'info@hachette.fr');

-- Insert authors
INSERT INTO author (author_name, birth_date, biography) VALUES
('J.K. Rowling', '1965-07-31', 'British author best known for the Harry Potter series'),
('Stephen King', '1947-09-21', 'American author of horror, supernatural fiction, suspense, and fantasy novels'),
('Agatha Christie', '1890-09-15', 'English writer known for her detective novels'),
('George Orwell', '1903-06-25', 'English novelist, essayist, journalist, and critic'),
('Jane Austen', '1775-12-16', 'English novelist known primarily for her six major novels');

-- Insert books
INSERT INTO book (title, isbn13, language_id, num_pages, publication_date, publisher_id, price, stock_quantity) VALUES
('Harry Potter and the Philosopher\'s Stone', '9780747532699', 1, 223, '1997-06-26', 1, 19.99, 150),
('The Shining', '9780385121675', 1, 447, '1977-01-28', 2, 15.99, 80),
('Murder on the Orient Express', '9780007119318', 1, 256, '1934-01-01', 3, 12.99, 65),
('1984', '9780140817744', 1, 328, '1949-06-08', 4, 11.99, 120),
('Pride and Prejudice', '9780141439518', 1, 432, '1813-01-28', 5, 9.99, 95);

-- Connect books to authors
INSERT INTO book_author (book_id, author_id) VALUES
(1, 1), -- J.K. Rowling wrote Harry Potter
(2, 2), -- Stephen King wrote The Shining
(3, 3), -- Agatha Christie wrote Murder on the Orient Express
(4, 4), -- George Orwell wrote 1984
(5, 5); -- Jane Austen wrote Pride and Prejudice

-- Insert customers
INSERT INTO customer (first_name, last_name, email, phone) VALUES
('John', 'Smith', 'john.smith@email.com', '555-123-4567'),
('Emily', 'Johnson', 'emily.j@email.com', '555-234-5678'),
('Michael', 'Brown', 'michael.b@email.com', '555-345-6789'),
('Sarah', 'Williams', 'sarah.w@email.com', '555-456-7890'),
('David', 'Jones', 'david.j@email.com', '555-567-8901');

-- Add customer addresses
INSERT INTO customer_address (customer_id, address_id, status_id) VALUES
(1, 1, 1), -- John Smith's current address
(2, 2, 1), -- Emily Johnson's current address
(3, 3, 1), -- Michael Brown's current address
(4, 4, 1), -- Sarah Williams's current address
(5, 5, 1); -- David Jones's current address

-- Insert shipping methods
INSERT INTO shipping_method (method_name, cost, estimated_days) VALUES
('Standard', 5.99, 7),
('Express', 12.99, 3),
('Overnight', 19.99, 1),
('International Economy', 15.99, 14),
('International Priority', 29.99, 5);

-- Insert order statuses
INSERT INTO order_status (status_name) VALUES
('Pending'),
('Processing'),
('Shipped'),
('Delivered'),
('Cancelled');

-- Create some customer orders
INSERT INTO cust_order (customer_id, shipping_address_id, shipping_method_id, order_total, current_status_id) VALUES
(1, 1, 1, 25.98, 3), -- John Smith ordered with standard shipping, shipped
(2, 2, 2, 28.98, 2), -- Emily Johnson ordered with express shipping, processing
(3, 3, 4, 28.98, 1), -- Michael Brown ordered with international economy, pending
(4, 4, 3, 39.98, 4), -- Sarah Williams ordered with overnight shipping, delivered
(5, 5, 5, 69.97, 5); -- David Jones ordered with international priority, cancelled

-- Fill order lines
INSERT INTO order_line (order_id, book_id, quantity, price) VALUES
(1, 1, 1, 19.99), -- John Smith ordered Harry Potter
(1, 3, 1, 12.99), -- John Smith also ordered Murder on the Orient Express
(2, 2, 1, 15.99), -- Emily Johnson ordered The Shining
(2, 4, 1, 11.99), -- Emily Johnson also ordered 1984
(3, 5, 1, 9.99),  -- Michael Brown ordered Pride and Prejudice
(3, 1, 1, 19.99), -- Michael Brown also ordered Harry Potter
(4, 1, 2, 19.99), -- Sarah Williams ordered 2 copies of Harry Potter
(5, 2, 1, 15.99), -- David Jones ordered The Shining
(5, 3, 1, 12.99), -- David Jones ordered Murder on the Orient Express
(5, 4, 1, 11.99), -- David Jones ordered 1984
(5, 5, 3, 9.99);  -- David Jones ordered 3 copies of Pride and Prejudice

-- Add order history
INSERT INTO order_history (order_id, status_id, status_date, notes) VALUES
(1, 1, '2023-04-01 10:00:00', 'Order placed'),
(1, 2, '2023-04-01 14:30:00', 'Payment confirmed'),
(1, 3, '2023-04-02 09:15:00', 'Order shipped via USPS'),
(2, 1, '2023-04-02 11:20:00', 'Order placed'),
(2, 2, '2023-04-02 15:45:00', 'Processing for shipment'),
(3, 1, '2023-04-03 09:30:00', 'Waiting for payment confirmation'),
(4, 1, '2023-04-03 14:00:00', 'Order placed'),
(4, 2, '2023-04-03 16:20:00', 'Processing for shipment'),
(4, 3, '2023-04-03 18:45:00', 'Order shipped via FedEx'),
(4, 4, '2023-04-04 10:30:00', 'Package delivered'),
(5, 1, '2023-04-04 11:15:00', 'Order placed'),
(5, 5, '2023-04-04 13:40:00', 'Customer cancelled order');

-- Step 5: Create users and assign privileges

-- Create admin user with full access
CREATE USER 'bookstore_admin'@'localhost' IDENTIFIED BY 'admin_password';
GRANT ALL PRIVILEGES ON BookStore.* TO 'bookstore_admin'@'localhost';

-- Create a read-only user for reporting
CREATE USER 'report_user'@'localhost' IDENTIFIED BY 'report_password';
GRANT SELECT ON BookStore.* TO 'report_user'@'localhost';

-- Create a sales staff user with limited access
CREATE USER 'sales_staff'@'localhost' IDENTIFIED BY 'sales_password';
GRANT SELECT ON BookStore.* TO 'sales_staff'@'localhost';
GRANT INSERT, UPDATE ON BookStore.customer TO 'sales_staff'@'localhost';
GRANT INSERT, UPDATE ON BookStore.customer_address TO 'sales_staff'@'localhost';
GRANT INSERT, UPDATE ON BookStore.address TO 'sales_staff'@'localhost';
GRANT INSERT, UPDATE ON BookStore.cust_order TO 'sales_staff'@'localhost';
GRANT INSERT, UPDATE ON BookStore.order_line TO 'sales_staff'@'localhost';
GRANT INSERT ON BookStore.order_history TO 'sales_staff'@'localhost';

-- Create inventory manager user
CREATE USER 'inventory_manager'@'localhost' IDENTIFIED BY 'inventory_password';
GRANT SELECT ON BookStore.* TO 'inventory_manager'@'localhost';
GRANT INSERT, UPDATE ON BookStore.book TO 'inventory_manager'@'localhost';
GRANT INSERT, UPDATE ON BookStore.author TO 'inventory_manager'@'localhost';
GRANT INSERT, UPDATE ON BookStore.book_author TO 'inventory_manager'@'localhost';
GRANT INSERT, UPDATE ON BookStore.publisher TO 'inventory_manager'@'localhost';

-- Apply the privileges
FLUSH PRIVILEGES;

-- Step 6: Sample queries for testing and demonstration

-- 1. Find all books by a specific author
SELECT b.book_id, b.title, b.isbn13, b.price
FROM book b
JOIN book_author ba ON b.book_id = ba.book_id
JOIN author a ON ba.author_id = a.author_id
WHERE a.author_name = 'J.K. Rowling';

-- 2. Get customer order history with status
SELECT c.first_name, c.last_name, co.order_id, co.order_date, 
       os.status_name, co.order_total
FROM customer c
JOIN cust_order co ON c.customer_id = co.customer_id
JOIN order_status os ON co.current_status_id = os.status_id
ORDER BY c.last_name, co.order_date DESC;

-- 3. Most popular books (by quantity ordered)
SELECT b.title, b.isbn13, SUM(ol.quantity) AS total_ordered
FROM book b
JOIN order_line ol ON b.book_id = ol.book_id
JOIN cust_order co ON ol.order_id = co.order_id
WHERE co.current_status_id != 5 -- Exclude cancelled orders
GROUP BY b.book_id
ORDER BY total_ordered DESC;

-- 4. Revenue by publisher
SELECT p.publisher_name, SUM(ol.price * ol.quantity) AS total_revenue
FROM publisher p
JOIN book b ON p.publisher_id = b.publisher_id
JOIN order_line ol ON b.book_id = ol.book_id
JOIN cust_order co ON ol.order_id = co.order_id
WHERE co.current_status_id != 5 -- Exclude cancelled orders
GROUP BY p.publisher_id
ORDER BY total_revenue DESC;

-- 5. Detailed order information
SELECT co.order_id, co.order_date, c.first_name, c.last_name, 
       b.title, ol.quantity, ol.price, (ol.quantity * ol.price) AS line_total,
       sm.method_name AS shipping_method, os.status_name AS order_status
FROM cust_order co
JOIN customer c ON co.customer_id = c.customer_id
JOIN order_line ol ON co.order_id = ol.order_id
JOIN book b ON ol.book_id = b.book_id
JOIN shipping_method sm ON co.shipping_method_id = sm.method_id
JOIN order_status os ON co.current_status_id = os.status_id
ORDER BY co.order_date DESC, co.order_id, b.title;

-- 6. Books low in stock (less than 10 copies)
SELECT b.book_id, b.title, b.isbn13, b.stock_quantity, p.publisher_name
FROM book b
JOIN publisher p ON b.publisher_id = p.publisher_id
WHERE b.stock_quantity < 10
ORDER BY b.stock_quantity;

-- 7. Customer spending analysis
SELECT c.customer_id, c.first_name, c.last_name, 
       COUNT(DISTINCT co.order_id) AS total_orders,
       SUM(co.order_total) AS total_spent,
       AVG(co.order_total) AS avg_order_value
FROM customer c
JOIN cust_order co ON c.customer_id = co.customer_id
WHERE co.current_status_id != 5 -- Exclude cancelled orders
GROUP BY c.customer_id
ORDER BY total_spent DESC;
