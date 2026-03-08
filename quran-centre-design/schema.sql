-- Quran Centre Management System - PostgreSQL Schema

CREATE TABLE teachers (
    id SERIAL PRIMARY KEY,
    name_ar VARCHAR(100) NOT NULL,
    name_en VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    hire_date DATE,
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    name_ar VARCHAR(100) NOT NULL,
    name_en VARCHAR(100),
    birth_date DATE,
    current_teacher_id INTEGER REFERENCES teachers(id),
    enrollment_date DATE NOT NULL,
    parent_name VARCHAR(100),
    parent_phone VARCHAR(20),
    status VARCHAR(20) DEFAULT 'active',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Remove current_age column and add calculated age
ALTER TABLE students 
DROP COLUMN IF EXISTS current_age,
ADD COLUMN age_calculated INTEGER GENERATED ALWAYS AS (
    EXTRACT(YEAR FROM age(CURRENT_DATE, birth_date))
) STORED;

CREATE TABLE surahs (
    id SERIAL PRIMARY KEY,
    name_ar VARCHAR(100) NOT NULL,
    name_en VARCHAR(100),
    number INTEGER UNIQUE NOT NULL,
    verses_count INTEGER,
    juz_number INTEGER,
    revelation_type VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE hijri_calendar (
    id SERIAL PRIMARY KEY,
    hijri_date DATE UNIQUE NOT NULL,
    gregorian_date DATE NOT NULL,
    day INTEGER NOT NULL,
    month INTEGER NOT NULL,
    month_name_ar VARCHAR(50) NOT NULL,
    month_name_en VARCHAR(50) NOT NULL,
    year INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE daily_records (
    id SERIAL PRIMARY KEY,
    record_id VARCHAR(50) UNIQUE,
    student_id INTEGER NOT NULL REFERENCES students(id),
    teacher_id INTEGER NOT NULL REFERENCES teachers(id),
    hijri_date_id INTEGER NOT NULL REFERENCES hijri_calendar(id),
    last_surah_id INTEGER REFERENCES surahs(id),
    monthly_memorization DECIMAL(6,3) DEFAULT 0,
    daily_memorization DECIMAL(6,3) DEFAULT 0,
    monthly_review DECIMAL(6,3) DEFAULT 0,
    daily_review DECIMAL(6,3) DEFAULT 0,
    attendance BOOLEAN DEFAULT false,
    attendance_status_id INTEGER REFERENCES attendance_status(id),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(student_id, hijri_date_id)
);

CREATE TABLE student_teacher_history (
    id SERIAL PRIMARY KEY,
    student_id INTEGER NOT NULL REFERENCES students(id),
    teacher_id INTEGER NOT NULL REFERENCES teachers(id),
    start_date DATE NOT NULL,
    end_date DATE,
    reason VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Attendance status enhancement
CREATE TABLE attendance_status (
    id SERIAL PRIMARY KEY,
    status_code VARCHAR(20) UNIQUE,
    description TEXT
);

-- Surah progress tracking
ALTER TABLE surahs 
ADD COLUMN parts_count INTEGER DEFAULT 1,
ADD COLUMN default_parts INTEGER;

CREATE TABLE student_surah_progress (
    id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES students(id),
    surah_id INTEGER REFERENCES surahs(id),
    verses_memorized INTEGER,
    last_verse INTEGER,
    completed_date DATE,
    UNIQUE(student_id, surah_id)
);

-- Performance metrics view
CREATE OR REPLACE VIEW student_monthly_summary AS
SELECT 
    dr.student_id,
    DATE_TRUNC('month', h.gregorian_date) as month,
    SUM(dr.daily_memorization) as total_memorized,
    SUM(dr.daily_review) as total_reviewed,
    AVG(CASE WHEN dr.attendance THEN 1 ELSE 0 END) as attendance_rate
FROM daily_records dr
JOIN hijri_calendar h ON dr.hijri_date_id = h.id
GROUP BY dr.student_id, DATE_TRUNC('month', h.gregorian_date);

-- Classes/groups concept
CREATE TABLE classes (
    id SERIAL PRIMARY KEY,
    name_ar VARCHAR(100),
    name_en VARCHAR(100),
    teacher_id INTEGER REFERENCES teachers(id),
    schedule TEXT,
    room VARCHAR(50)
);

ALTER TABLE students ADD COLUMN class_id INTEGER REFERENCES classes(id);

-- Parent/guardian information
CREATE TABLE parents (
    id SERIAL PRIMARY KEY,
    name_ar VARCHAR(100),
    name_en VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    relationship VARCHAR(50)
);

CREATE TABLE student_parents (
    student_id INTEGER REFERENCES students(id),
    parent_id INTEGER REFERENCES parents(id),
    is_primary BOOLEAN DEFAULT false,
    PRIMARY KEY (student_id, parent_id)
);

-- Achievements/milestones
CREATE TABLE achievements (
    id SERIAL PRIMARY KEY,
    name_ar VARCHAR(100),
    name_en VARCHAR(100),
    criteria TEXT,
    badge_image VARCHAR(255)
);

CREATE TABLE student_achievements (
    student_id INTEGER REFERENCES students(id),
    achievement_id INTEGER REFERENCES achievements(id),
    awarded_date DATE NOT NULL,
    awarded_by INTEGER REFERENCES teachers(id)
);

-- Indexes
CREATE INDEX idx_teachers_status ON teachers(status);
CREATE INDEX idx_students_teacher ON students(current_teacher_id);
CREATE INDEX idx_students_status ON students(status);
CREATE INDEX idx_students_enrollment ON students(enrollment_date);
CREATE INDEX idx_surahs_number ON surahs(number);
CREATE INDEX idx_hijri_date ON hijri_calendar(hijri_date);
CREATE INDEX idx_gregorian_date ON hijri_calendar(gregorian_date);
CREATE INDEX idx_daily_student ON daily_records(student_id);
CREATE INDEX idx_daily_teacher ON daily_records(teacher_id);
CREATE INDEX idx_daily_date ON daily_records(hijri_date_id);
CREATE INDEX idx_daily_attendance ON daily_records(attendance);
CREATE INDEX idx_daily_monthly ON daily_records(monthly_memorization, monthly_review);
CREATE INDEX idx_student_teacher_history ON student_teacher_history(student_id, start_date);
CREATE INDEX idx_surah_progress_student ON daily_records(student_id);
CREATE INDEX idx_surah_progress_status ON daily_records(attendance);