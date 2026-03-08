-- Sample Data for Quran Centre
// i can delete the email and phone number if you want but ai suggest to keep them for testing purposes

INSERT INTO teachers (name_ar, name_en, phone, email, hire_date, status) VALUES
('محمد', 'Mohammed', '0501234567', 'mohammed@example.com', '2024-01-01', 'active'),
('خليل', 'Khalil', '0502345678', 'khalil@example.com', '2024-01-02', 'active');

INSERT INTO students (name_ar, name_en, birth_date, current_teacher_id, enrollment_date, status) VALUES
('أحمد جمال الربيعي', 'Ahmed Jamal Al-Rubaie', '2014-05-10', 1, '2024-02-01', 'active'),
('أحمد عبدالوهاب هدوان', 'Ahmed Abdulwahab Hadwan', '2013-03-15', 2, '2024-02-02', 'active');

INSERT INTO surahs (name_ar, name_en, number, verses_count, juz_number, revelation_type) VALUES
('المرسلات', 'Al-Mursalat', 77, 50, 29, 'Makki'),
('المجادلة', 'Al-Mujadila', 58, 22, 28, 'Madani');

INSERT INTO hijri_calendar (hijri_date, gregorian_date, day, month, month_name_ar, month_name_en, year) VALUES
('1447-05-01', '2026-01-01', 1, 5, 'جماد الأول', 'Jumada I', 1447),
('1447-06-01', '2026-02-01', 1, 6, 'جماد الثاني', 'Jumada II', 1447);

INSERT INTO daily_records (record_id, student_id, teacher_id, hijri_date_id, last_surah_id, monthly_memorization, daily_memorization, monthly_review, daily_review, attendance) VALUES
('STD-1447-05-01-413', 1, 1, 1, 1, 0.0, 0.0, 0.0, 0.0, false),
('STD-1447-06-01-460', 1, 1, 2, 1, 0.0, 0.0, 0.0, 0.0, false);