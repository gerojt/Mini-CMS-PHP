-- ========================
-- Roles de usuario (más flexible que ENUM)
-- ========================
CREATE TABLE roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,  -- 'admin', 'editor', etc.
    description VARCHAR(255)
);

-- Usuarios
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    role_id INT NOT NULL,
    name VARCHAR(120) NOT NULL,
    email VARCHAR(160) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    last_login TIMESTAMP NULL DEFAULT NULL,
    failed_login_attempts INT DEFAULT 0,
    locked_until DATETIME NULL DEFAULT NULL,
    reset_token VARCHAR(255) NULL DEFAULT NULL,
    reset_token_expiry DATETIME NULL DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE RESTRICT
);

-- ========================
-- Configuración general
-- ========================
CREATE TABLE settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    site_title VARCHAR(100),
    logo VARCHAR(255),
    favicon VARCHAR(255),
    banner VARCHAR(255),
    primary_color VARCHAR(7),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ========================
-- Páginas personalizadas
-- ========================
CREATE TABLE pages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    slug VARCHAR(120) NOT NULL UNIQUE,
    title VARCHAR(180) NOT NULL,
    content MEDIUMTEXT,
    meta_title VARCHAR(180),
    meta_description VARCHAR(255),
    featured_image VARCHAR(255),
    visible TINYINT(1) DEFAULT 1,
    sort_order INT(11) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ========================
-- Servicios y Categorías
-- ========================
CREATE TABLE service_categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE services (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(160) NOT NULL,
    slug VARCHAR(160) NOT NULL UNIQUE,
    excerpt VARCHAR(255),
    content MEDIUMTEXT,
    icon VARCHAR(80),
    image VARCHAR(255),
    visible TINYINT(1) DEFAULT 1,
    sort_order INT(11) DEFAULT 0,
    category_id INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES service_categories(id) ON DELETE SET NULL
);

-- ========================
-- Portfolio / Proyectos
-- ========================
CREATE TABLE projects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    slug VARCHAR(150) NOT NULL UNIQUE,
    summary VARCHAR(255),
    body MEDIUMTEXT,
    cover_image VARCHAR(255),
    project_year SMALLINT(5),
    location VARCHAR(160),
    created_by INT NULL,
    visible TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE project_images (
    id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    path VARCHAR(255) NOT NULL,
    caption VARCHAR(160),
    sort_order INT(11) DEFAULT 0,
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE
);

-- ========================
-- Sección "Quiénes somos"
-- ========================
CREATE TABLE about_us (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100),
    content TEXT,
    type ENUM('mision','vision','objetivos','descripcion') NOT NULL
);

-- ========================
-- Contacto
-- ========================
CREATE TABLE contact_info (
    id INT AUTO_INCREMENT PRIMARY KEY,
    phone VARCHAR(30),
    email VARCHAR(100),
    address VARCHAR(255),
    whatsapp VARCHAR(30),
    facebook VARCHAR(100),
    instagram VARCHAR(100),
    twitter VARCHAR(100)
);

CREATE TABLE contact_submissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(160) NOT NULL,
    email VARCHAR(160) NOT NULL,
    phone VARCHAR(60),
    message TEXT,
    status ENUM('new','read','archived') DEFAULT 'new',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========================
-- Auditoría y Seguridad
-- ========================
CREATE TABLE audit_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT(10),
    action VARCHAR(100) NOT NULL,
    table_name VARCHAR(100),
    record_id INT(10),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE user_tokens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT(10) NOT NULL,
    token VARCHAR(255) NOT NULL,
    expiry DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ========================
-- Logs de sesión (opcional pero útil)
-- ========================
CREATE TABLE user_sessions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    session_token VARCHAR(255) NOT NULL,
    ip_address VARCHAR(45),
    user_agent VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expired_at DATETIME NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);