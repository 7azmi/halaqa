# Quran Centre Management System - Database Schema

## Version: 1.0.0 Opne for changes and improvemnts
Last Updated: March 2026
Database: PostgreSQL 14+

---

## Overview

This database schema is designed to track student progress in a Quran memorization center. It handles daily recording of memorization and review metrics, attendance tracking, and historical performance analysis across multiple teachers and students.

The schema is normalized to eliminate redundancy while maintaining flexibility for future reporting requirements.

---

## Entity Relationship Summary

---

## Table Definitions

### 1. teachers

Stores information about instructors.

| Column   | Type       | Constraints      | Description                         |
|----------|------------|------------------|-------------------------------------|
| id       | SERIAL     | PRIMARY KEY      | Unique teacher identifier           |
|name_ar   |VARCHAR(100)| NOT NULL         | Teacher name in Arabic              |
|name_en   |VARCHAR(100)|                  | Teacher name in English (optional)  |
| phone    |VARCHAR(20) |                  | Contact number                      |
| email    |VARCHAR(100)|                  | Email address                       |
|hire_date | DATE       |                  | When teacher joined                 |
| status   |VARCHAR(20) | DEFAULT 'active' | active, inactive, on_leave          |
|created_at| TIMESTAMP  | DEFAULT CURRENT_TIMESTAMP | Record creation timestamp  |
|updated_at| TIMESTAMP  | DEFAULT CURRENT_TIMESTAMP | Last update timestamp      |

**Indexes:**
- `idx_teachers_status` ON teachers(status)

---

### 2. students

Stores student demographic and enrollment information.

| Column           | Type         | Constraints               | Description                             |
|------------------|--------------|---------------------------|-----------------------------------------|
|       id         |    SERIAL    |       PRIMARY KEY         | Unique student identifier               |
|     name_ar      | VARCHAR(100) |        NOT NULL           | Student name in Arabic                  |    
|     name_en      | VARCHAR(100) |                           | Student name in English                 |
|   birth_date     |    DATE      |                           | Date of birth (Gregorian)               |
|   current_age    |   INTEGER    |                           | Calculated or manually entered age      |
|current_teacher_id|   INTEGER    |  REFERENCES teachers(id)  | Current primary teacher                 |
| enrollment_date  |    DATE      |        NOT NULL           | Date student joined                     |
|   parent_name    | VARCHAR(100) |                           | Parent/guardian name                    |
|  parent_phone    | VARCHAR(20)  |                           | Contact number                          |
|     status       | VARCHAR(20)  |    DEFAULT 'active'       | active, inactive, graduated, transferred|
|     notes        |    TEXT      |                           | Additional information                  |
|   created_at     |  TIMESTAMP   | DEFAULT CURRENT_TIMESTAMP | Record creation timestamp               |
|   updated_at     |  TIMESTAMP   | DEFAULT CURRENT_TIMESTAMP | Last update timestamp                   |

**Indexes:**
- `idx_students_teacher` ON students(current_teacher_id)
- `idx_students_status` ON students(status)
- `idx_students_enrollment` ON students(enrollment_date)

---

### 3. surahs

Reference table for Quran chapters.

| Column        | Type       | Constraints   | Description                             |
|---------------|------------|---------------|-----------------------------------------|
| id            | SERIAL     | PRIMARY KEY   | Unique surah identifier                 |
| name_ar       |VARCHAR(100)| NOT NULL      | Surah name in Arabic                    |
| name_en       |VARCHAR(100)|               | Surah name in English (transliteration) |
| number        | INTEGER    |UNIQUE NOT NULL| Surah number in Quran (1-114)           |
| verses_count  | INTEGER    |               | Number of verses                        |
| juz_number    | INTEGER    |               | Juz/Juz' number (1-30)                  |
|revelation_type| VARCHAR(20)|               | Makki or Madani                         |
| created_at    | TIMESTAMP  |DEFAULT CURRENT_TIMESTAMP | Record creation timestamp    |

**Notes:** This table should be pre-populated with all 114 surahs.

**Indexes:**
- `idx_surahs_number` ON surahs(number)

---

### 4. hijri_calendar

Maps Hijri dates to Gregorian dates for consistent date handling.

| Column       | Type      | Constraints   | Description                                         |
|--------------|-----------|---------------|-----------------------------------------------------|
| id           | SERIAL    | PRIMARY KEY   | Unique date identifier                              |
| hijri_date   | DATE      |UNIQUE NOT NULL| Hijri date (stored as DATE but interpreted as Hijri)|
|gregorian_date| DATE      | NOT NULL      | Corresponding Gregorian date                        |
| day          | INTEGER   | NOT NULL      | Day of month (1-30)                                 |
| month        | INTEGER   | NOT NULL      | Month number (1-12)                                 |
| month_name_ar|VARCHAR(50)| NOT NULL      | Month name in Arabic                                |
| month_name_en|VARCHAR(50)| NOT NULL      | Month name in English                               |
| year         | INTEGER   | NOT NULL      | Hijri year                                          |
| created_at   | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Record creation timestamp               |

**Indexes:**
- `idx_hijri_date` ON hijri_calendar(hijri_date)
- `idx_gregorian_date` ON hijri_calendar(gregorian_date)

---

### 5. daily_records

Core table storing daily performance metrics for each student.

| Column           | Type             | Constraints | Description |
|------------------|------------------|-------------|------------------------------------------|
| id               | SERIAL           | PRIMARY KEY | Unique record identifier                 |
| record_id        | VARCHAR(50)      | UNIQUE      | Original STD-XXXX identifier from CSV    |
| student_id       | INTEGER          | NOT NULL    | Student this record belongs to           |
| teacher_id       | INTEGER          | NOT NULL    | Teacher who recorded this entry          |
| hijri_date_id    | INTEGER          | NOT NULL    | Date of record                           |
| last_surah_id    | INTEGER          | NOT NULL    | Last surah studied                       |
|daily_memorization| DECIMAL(6,3)     | DEFAULT 0   | Memorization achieved today              |
| daily_review     | DECIMAL(6,3)     | DEFAULT 0   | Review completed today                   |
| attendance       | BOOLEAN          |DEFAULT false| Whether student attended (true = present)|
| notes            | TEXT             |             | Any additional notes                     |
| created_at       | TIMESTAMP        | DEFAULT CURRENT_TIMESTAMP | Record creation timestamp  |
| updated_at       | TIMESTAMP        | DEFAULT CURRENT_TIMESTAMP | Last update timestamp      |
|                  |                  | 
| **CONSTRAINT**   |UNIQUE(student_id,| 
|                    hijri_date_id)   | One record per student per day      |

**Indexes:**
- `idx_daily_student` ON daily_records(student_id)
- `idx_daily_teacher` ON daily_records(teacher_id)
- `idx_daily_date` ON daily_records(hijri_date_id)
- `idx_daily_attendance` ON daily_records(attendance)
- `idx_daily_monthly` ON daily_records(monthly_memorization, monthly_review)

---

### 6. student_teacher_history

Tracks teacher changes over time for historical accuracy.

| Column    | Type       | Constraints | Description                             |
|-----------|------------|-------------|-----------------------------------------|
| id        |  SERIAL    | PRIMARY KEY | Unique history record                   |
| student_id| INTEGER    | NOT NULL    | Student                                 |
| teacher_id| INTEGER    | NOT NULL    | Teacher assigned                        |
| start_date| DATE       | NOT NULL    | When this assignment started            |
| end_date  | DATE       |             | When this assignment ended              |
| reason    |VARCHAR(100)|             | Reason for change (optional)            |
| created_at| TIMESTAMP  | DEFAULT CURRENT_TIMESTAMP | Record creation timestamp |

**Indexes:**
- `idx_student_teacher_history` ON student_teacher_history(student_id, start_date)

---

### 7. surah_progress

Tracks student progress through surahs over time.

| Column        | Type      | Constraints        | Description                        |
|---------------|-----------|--------------------|------------------------------------|
| id            | SERIAL    | PRIMARY KEY        | Unique progress record             |
| student_id    | INTEGER   | NOT NULL           | Student                            |
| surah_id      | INTEGER   | NOT NULL           | Surah being tracked                |
| start_date    | DATE      |                    | When student started this surah    |
|completion_date| DATE      |                    | When student completed this surah  |
| status        |VARCHAR(20)|DEFAULT'in_progress'| not_started, in_progress, completed|
| review_count  | INTEGER   | DEFAULT 0          | Number of times reviewed           |
| created_at    | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Record creation timestamp   |
| updated_at    | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Last update timestamp       |

**Indexes:**
- `idx_surah_progress_student` ON surah_progress(student_id)
- `idx_surah_progress_status` ON surah_progress(status)

---
