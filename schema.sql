PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS patients (
  patient_id INTEGER PRIMARY KEY AUTOINCREMENT,
  name       TEXT NOT NULL,
  age        INTEGER NOT NULL CHECK (age BETWEEN 1 AND 120),
  gender     TEXT NOT NULL CHECK (gender IN ('Male', 'Female', 'Other')),
  phone      TEXT NOT NULL,
  address    TEXT NOT NULL,
  email      TEXT NOT NULL UNIQUE,
  password   TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT (datetime('now', 'localtime'))
);

CREATE TABLE IF NOT EXISTS doctors (
  doctor_id        INTEGER PRIMARY KEY AUTOINCREMENT,
  name             TEXT NOT NULL,
  phone            TEXT NOT NULL,
  specialization   TEXT NOT NULL,
  email            TEXT NOT NULL UNIQUE,
  password         TEXT NOT NULL,
  qualification    TEXT NOT NULL DEFAULT 'MBBS, MD',
  experience_years INTEGER NOT NULL DEFAULT 0,
  consultation_fee REAL NOT NULL DEFAULT 500,
  room_no          TEXT NOT NULL DEFAULT '',
  bio              TEXT NOT NULL DEFAULT '',
  status           TEXT NOT NULL DEFAULT 'Active' CHECK (status IN ('Active', 'Inactive')),
  created_at       TEXT NOT NULL DEFAULT (datetime('now', 'localtime'))
);

CREATE TABLE IF NOT EXISTS receptionists (
  receptionist_id INTEGER PRIMARY KEY AUTOINCREMENT,
  name            TEXT NOT NULL,
  phone           TEXT NOT NULL,
  address         TEXT NOT NULL,
  gender          TEXT NOT NULL CHECK (gender IN ('Male', 'Female', 'Other')),
  email           TEXT NOT NULL UNIQUE,
  password        TEXT NOT NULL,
  status          TEXT NOT NULL DEFAULT 'Active' CHECK (status IN ('Active', 'Inactive')),
  created_at      TEXT NOT NULL DEFAULT (datetime('now', 'localtime'))
);

CREATE TABLE IF NOT EXISTS admins (
  admin_id      INTEGER PRIMARY KEY AUTOINCREMENT,
  hospital_name TEXT NOT NULL,
  address       TEXT NOT NULL,
  email         TEXT NOT NULL UNIQUE,
  password      TEXT NOT NULL,
  created_at    TEXT NOT NULL DEFAULT (datetime('now', 'localtime'))
);

CREATE TABLE IF NOT EXISTS doctor_availability (
  availability_id INTEGER PRIMARY KEY AUTOINCREMENT,
  doctor_id       INTEGER NOT NULL REFERENCES doctors(doctor_id) ON DELETE CASCADE,
  available_date  TEXT NOT NULL,
  start_time      TEXT NOT NULL,
  end_time        TEXT NOT NULL,
  slot_duration   INTEGER NOT NULL DEFAULT 30,
  created_at      TEXT NOT NULL DEFAULT (datetime('now', 'localtime')),
  UNIQUE (doctor_id, available_date, start_time, end_time)
);

CREATE TABLE IF NOT EXISTS appointments (
  appointment_id     INTEGER PRIMARY KEY AUTOINCREMENT,
  patient_id         INTEGER NOT NULL REFERENCES patients(patient_id) ON DELETE CASCADE,
  doctor_id          INTEGER NOT NULL REFERENCES doctors(doctor_id),
  receptionist_id    INTEGER REFERENCES receptionists(receptionist_id),
  appointment_date   TEXT NOT NULL,
  appointment_time   TEXT NOT NULL,
  token_number       INTEGER NOT NULL,
  booking_type       TEXT NOT NULL DEFAULT 'Online'
                     CHECK (booking_type IN ('Online', 'Token', 'Phone', 'Walk-in')),
  appointment_status TEXT NOT NULL DEFAULT 'Confirmed'
                     CHECK (appointment_status IN ('Pending', 'Confirmed', 'Completed', 'Cancelled')),
  reason             TEXT NOT NULL DEFAULT '',
  created_at         TEXT NOT NULL DEFAULT (datetime('now', 'localtime'))
);

-- Guarantees that no two patients can hold the same doctor/date/time slot.
CREATE UNIQUE INDEX IF NOT EXISTS idx_appointments_unique_slot
  ON appointments (doctor_id, appointment_date, appointment_time)
  WHERE appointment_status IN ('Pending', 'Confirmed', 'Completed');

CREATE INDEX IF NOT EXISTS idx_appointments_doctor ON appointments (doctor_id, appointment_date);
CREATE INDEX IF NOT EXISTS idx_appointments_patient ON appointments (patient_id, appointment_date);
CREATE INDEX IF NOT EXISTS idx_availability_doctor ON doctor_availability (doctor_id, available_date);

CREATE TABLE IF NOT EXISTS payments (
  payment_id     INTEGER PRIMARY KEY AUTOINCREMENT,
  appointment_id INTEGER NOT NULL UNIQUE REFERENCES appointments(appointment_id) ON DELETE CASCADE,
  amount         REAL NOT NULL,
  payment_method TEXT NOT NULL CHECK (payment_method IN ('Cash', 'Card', 'UPI', 'Online')),
  payment_status TEXT NOT NULL DEFAULT 'Pending' CHECK (payment_status IN ('Pending', 'Paid', 'Verified')),
  verified_by    INTEGER REFERENCES admins(admin_id),
  recorded_by    INTEGER REFERENCES receptionists(receptionist_id),
  payment_date   TEXT,
  created_at     TEXT NOT NULL DEFAULT (datetime('now', 'localtime'))
);

CREATE TABLE IF NOT EXISTS prescriptions (
  prescription_id  INTEGER PRIMARY KEY AUTOINCREMENT,
  appointment_id   INTEGER NOT NULL UNIQUE REFERENCES appointments(appointment_id) ON DELETE CASCADE,
  doctor_id        INTEGER NOT NULL REFERENCES doctors(doctor_id),
  patient_id       INTEGER NOT NULL REFERENCES patients(patient_id) ON DELETE CASCADE,
  medicine_details TEXT NOT NULL,
  instructions     TEXT NOT NULL DEFAULT '',
  created_at       TEXT NOT NULL DEFAULT (datetime('now', 'localtime'))
);

CREATE TABLE IF NOT EXISTS notifications (
  notification_id     INTEGER PRIMARY KEY AUTOINCREMENT,
  patient_id          INTEGER NOT NULL REFERENCES patients(patient_id) ON DELETE CASCADE,
  message             TEXT NOT NULL,
  notification_status TEXT NOT NULL DEFAULT 'Unread' CHECK (notification_status IN ('Unread', 'Read')),
  created_at          TEXT NOT NULL DEFAULT (datetime('now', 'localtime'))
);

CREATE INDEX IF NOT EXISTS idx_notifications_patient ON notifications (patient_id, notification_status);
