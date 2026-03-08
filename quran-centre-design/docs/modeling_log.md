# Database Schema Modeling Log

## Step 1: Load and Review Masterlist CSV
- Examined columns: Record_ID, Student Name, Teacher, Age, Last Surah, Date, Daily Memo, Daily Review, Attendance
- Noted patterns: Each row = daily record; attendance is binary; teacher assignment can change.
- Data issues: Mixed numeral systems, static age, decimal precision, teacher variations.

## Step 2: Identify Key Entities
- Students
- Teachers
- Daily Records (sessions)
- Surahs (reference)
- Hijri Dates (reference)
- Student-Teacher History

## Step 3: Initial Schema Sketch
- See ERD and YAML tables in app/README.md

## Step 4: Open Questions
- Are classes a separate entity or just teacher-student mapping?
- Is attendance always binary, or are there other states (late, excused)?
- How will frontend access daily records? By date, student, teacher, or class?
- Should age be calculated dynamically from birth/enrollment date?
- Are there additional metrics or derived fields needed for reporting?

## Step 5: Iterative Updates
- Update ERD and table definitions as new requirements emerge.
- Document feedback and changes.

---

*This log is a living document. Update as you explore and refine the schema.*