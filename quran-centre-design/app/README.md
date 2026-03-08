# Application Layer

This folder will contain application logic, scripts, or UI code for Quran Centre Management System.

# Backend Schema Modeling Process

## Step 1: Masterlist Data Review
- Columns: Record_ID, Student Name, Teacher, Age, Last Surah, Date, Daily Memo, Daily Review, Attendance

- Patterns: Each row = daily record for a student; attendance is binary; teacher assignment can change.

- Data issues: Mixed numeral systems, static age, decimal precision, teacher variations.

## Step 2: Key Entities Identified
- Students
- Teachers
- Daily Records (sessions)
- Surahs (reference)
- Hijri Dates (reference)
- Student-Teacher History



## Step 4: Draft Table Definitions (YAML style)

students:
  id: int (PK)
  name_ar: string
  age: int
  current_teacher_id: int (FK) from table teachers
  enrollment_date: date

teachers:
  id: int (PK)
  name_ar: string

surahs:
  id: int (PK)
  name_ar: string
  number: int

hijri_dates:
  id: int (PK)
  hijri_date: date
  gregorian_date: date

student_teacher_history:
  id: int (PK)
  student_id: int (FK) from table students
  teacher_id: int (FK) from table teachers
  start_date: date
  end_date: date

sessions/daily_records:
  id: int (PK)
  student_id: int (FK) from table students
  teacher_id: int (FK) from table teachers
  last_surah_id: int (FK)  from table surahs
  hijri_date_id: int (FK)  from table hijri_dates
  monthly_memorization: decimal
  daily_memorization: decimal
  monthly_review: decimal
  daily_review: decimal
  attendance: boolean (present 1 || absent 0)

## Step 5: CSV Review Notes
- Data completeness: All fields present, but age is static, date formats vary.
- Surah names: Arabic, ~30 distinct in sample, should reference all 114.
- Attendance: 0/1, but some days have progress even when absent.
- Monthly metrics: Accumulate over time, daily metrics are per day.

## Step 6: Open Questions (Resolved)
- Classes are not a separate entity; teacher-student mapping suffices for now.
- Attendance is binary (present/absent); can be extended if needed.
- Frontend will access daily records by student, teacher, and date.
- Age should be calculated dynamically from birth/enrollment date.
- Additional metrics can be added as reporting needs evolve.

---