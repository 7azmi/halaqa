# Masterlist CSV Review

## Data Columns
- Record_ID
- Student Name
- Teacher
- Age
- Last Surah
- Date
- Daily Memo
- Daily Review
- Attendance

## Data Quality Issues
- Mixed numeral systems in dates
- Static age field  (i was thinking of replacing the age by the date_of_birth if the age was not a neccessaty here)
- Decimal precision varies
- Teacher variations for same student
- Zero values with attendance

## Recommendations here is my recommendations 
- Calculate age from enrollment date as propossed in the ##Data Quality Issues
- Standardize decimal precision
- Track teacher changes historically
- Allow zero values, but flag for validation (could be ENUM table attended/absent/No progress with a note why no progress)

---

