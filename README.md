# CityCare Hospital - Doctor Appointment Scheduler

A complete doctor appointment scheduling web application built with **Python Flask**, **SQLite**, and **HTML/CSS/vanilla JavaScript**. Patients can register, find doctors, check live availability, and book appointments. Admins can manage doctors, appointments, schedules, payments, and reports. Doctor and receptionist portals are included as a superset of the core patient/admin workflow.

**Live demo:** https://doctorappointmentschedular.vercel.app

---

## Features

### Public website
- Clean responsive hospital landing page with live statistics
- Doctor directory with search by name/specialization and specialization filters
- Doctor profile cards with fee, qualification, room, and availability
- Patient login and self-registration

### Patient portal
- Personal dashboard with upcoming visits, completed visits, prescriptions, and unread notifications
- Search and filter doctors, view profiles, and book appointments
- Real-time slot availability with past slots disabled
- Duplicate slot protection with clear error messages
- View upcoming, past, and all appointments with full details
- Cancel upcoming appointments
- Notification inbox with mark-as-read support
- Medical records: prescriptions and payment history
- Update profile and change password

### Admin portal
- Dashboard with hospital-wide statistics, appointment trend chart, and specialization breakdown
- Add, edit, delete, activate, and deactivate doctors
- Add, edit, and delete receptionists
- View patients, appointment history, and prescriptions
- View and update all appointments
- View doctor schedules and booked-slot counts
- Payment workflow: receptionist records payment, admin verifies it
- Date-range reports with revenue, status, method, specialization, doctor, and top-patient breakdowns
- Print-friendly report view

### Doctor portal
- Dashboard with today's schedule and appointment stats
- Appointment list with status updates and patient details
- Create, edit, and remove availability windows
- Schedule view by date range
- Issue and review prescriptions
- Update professional profile

### Receptionist portal
- Dashboard with today's appointments and payment summary
- Check doctor availability by date
- Book appointments for existing or new patients (phone/token/walk-in)
- Manage patient records
- Record cash/card/UPI payments

### Security and data integrity
- Passwords hashed with Werkzeug (never stored in plain text)
- Session-based authentication with `HttpOnly` and `SameSite=Lax` cookies
- Server-side role-based access control for every API and protected page
- Server-side revalidation of doctor availability before saving a booking
- Past dates and invalid time slots rejected
- SQLite partial unique index prevents two active appointments for the same doctor/date/time
- Parameterized SQL queries throughout
- Booking, payment record, and notification are created atomically in one transaction

---

## Tech Stack

| Layer | Technology |
|---|---|
| Backend | Python 3, Flask 3 |
| Database | SQLite |
| Frontend | HTML5, CSS3, vanilla JavaScript (Fetch API) |
| Templating | Jinja2 |
| Password security | Werkzeug password hashing |
| Charts | Custom lightweight SVG/CSS (no chart library) |

No React, Node, or build tools are required. The frontend is served directly by Flask.

---

## Demo Accounts

| Role | Email | Password |
|---|---|---|
| Admin | `admin@citycare.com` | `admin123` |
| Doctor | `arjun.sharma@citycare.com` | `doctor123` |
| Receptionist | `reception@citycare.com` | `reception123` |
| Patient | `rahul@example.com` | `patient123` |

Additional seeded patients: `anjali@example.com`, `mohammed@example.com`, `divya@example.com` (all use `patient123`).

> The login page has a role selector. Choose the matching role for the account.

---

## Run Locally in VS Code

### 1. Prerequisites
- Python 3.10 or newer (tested on Python 3.13)
- VS Code with the Python extension (recommended)
- A web browser

Check Python from a terminal:

```bash
python --version
```

On macOS/Linux you may need `python3` instead of `python`.

### 2. Open the project
In VS Code: **File → Open Folder** and select the project folder (`doctor_appointment_schedular`).

### 3. Create and activate a virtual environment
Open the VS Code integrated terminal (**Terminal → New Terminal**) and run:

**Windows (Command Prompt / PowerShell)**
```bash
python -m venv venv
venv\Scripts\activate
```

**macOS / Linux**
```bash
python3 -m venv venv
source venv/bin/activate
```

If PowerShell blocks activation, run:
```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

### 4. Install dependencies
```bash
pip install -r requirements.txt
```

### 5. Start the application
```bash
python app.py
```

You should see:

```text
CityCare Hospital - Doctor Appointment Scheduler
Open http://127.0.0.1:5000 in your browser
SQLite database: ...\hospital.db
```

Open **http://127.0.0.1:5000** in your browser.

The database file `hospital.db` is created automatically on the first run and filled with demo data.

### 6. Optional: select the VS Code interpreter
Press `Ctrl+Shift+P`, run **Python: Select Interpreter**, and choose the interpreter inside `venv`.

---

## Reset the Demo Database

To wipe all data and restore the original demo doctors, patients, appointments, payments, and notifications:

```bash
python seed.py
```

Then restart the server if it was running.

To rebuild the database from scratch, delete `hospital.db` and run `python app.py`. The schema is recreated automatically and the demo data is seeded again because the admin table starts empty.

---

## Project Structure

```text
doctor_appointment_schedular/
├── app.py                  # Flask app, page routes, error handlers
├── db.py                   # SQLite connection and transaction helpers
├── helpers.py              # Validation, auth guards, availability, booking logic
├── schema.sql              # Database schema, constraints, and indexes
├── seed.py                 # Demo data generator and database reset
├── hospital.db             # SQLite database (generated)
├── requirements.txt
├── README.md
├── api/
│   ├── __init__.py
│   ├── auth.py             # Register, login, logout, me, change password
│   ├── public.py           # Public doctors, specializations, slots, stats
│   ├── patient.py          # Patient appointments, notifications, records
│   ├── doctor.py           # Doctor appointments, availability, prescriptions
│   ├── receptionist.py     # Reception bookings, patients, payments
│   └── admin.py            # Admin CRUD, appointments, payments, reports
├── static/
│   ├── css/
│   │   └── style.css       # Full responsive hospital theme
│   └── js/
│       ├── common.js       # API wrapper, toasts, modals, formatting helpers
│       ├── public.js       # Landing page doctor search
│       ├── patient.js      # Patient portal logic
│       ├── doctor.js       # Doctor portal logic
│       ├── receptionist.js # Receptionist portal logic
│       └── admin.js        # Admin portal logic
└── templates/
    ├── base.html
    ├── dashboard_base.html
    ├── error.html
    ├── index.html
    ├── login.html
    ├── register.html
    ├── partials/           # Icons, navigation, footer, sidebar
    ├── patient/            # Patient pages
    ├── doctor/             # Doctor pages
    ├── receptionist/       # Receptionist pages
    └── admin/              # Admin pages
```

---

## Database Tables

| Table | Purpose |
|---|---|
| `patients` | Patient accounts and profile details |
| `doctors` | Doctor accounts, specialization, fee, room, status |
| `receptionists` | Reception staff accounts |
| `admins` | Hospital administrator accounts |
| `doctor_availability` | Per-doctor date and time windows |
| `appointments` | Bookings with token, status, type, and reason |
| `payments` | One payment record per appointment |
| `prescriptions` | Doctor-issued prescriptions per appointment |
| `notifications` | Patient notifications |

The unique partial index `idx_appointments_unique_slot` enforces one active appointment per doctor/date/time combination for `Pending`, `Confirmed`, and `Completed` statuses. Cancelled appointments free the slot.

---

## Key API Endpoints

### Authentication
| Method | Endpoint | Description |
|---|---|---|
| POST | `/api/auth/register` | Register a patient |
| POST | `/api/auth/login` | Log in with role |
| POST | `/api/auth/logout` | Log out |
| GET | `/api/auth/me` | Current session user |
| POST | `/api/auth/change-password` | Change password |

### Public
| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/public/doctors?search=&specialization=` | Doctor directory |
| GET | `/api/public/doctors/<id>` | Doctor details and availability summary |
| GET | `/api/public/doctors/<id>/slots?date=YYYY-MM-DD` | Available slots |
| GET | `/api/public/specializations` | Specialization list |
| GET | `/api/public/stats` | Landing-page statistics |
| GET | `/api/public/hospital` | Hospital contact details |

### Patient
| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/patient/overview` | Dashboard data |
| GET | `/api/patient/appointments?type=upcoming\|history\|all` | Appointment list |
| POST | `/api/patient/appointments` | Book an appointment |
| GET | `/api/patient/appointments/<id>` | Appointment details |
| PATCH | `/api/patient/appointments/<id>/cancel` | Cancel an appointment |
| GET | `/api/patient/notifications` | Notification inbox |
| GET | `/api/patient/prescriptions` | Prescriptions |
| GET | `/api/patient/payments` | Payment history |
| GET/PUT | `/api/patient/profile` | View/update profile |

### Doctor
| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/doctor/overview` | Doctor dashboard |
| GET | `/api/doctor/appointments` | Appointments |
| PATCH | `/api/doctor/appointments/<id>/status` | Update appointment status |
| GET/POST | `/api/doctor/availability` | List/add availability |
| PUT/DELETE | `/api/doctor/availability/<id>` | Update/remove availability |
| GET | `/api/doctor/schedule` | Schedule by date range |
| GET/POST | `/api/doctor/prescriptions` | List/create prescriptions |
| GET/PUT | `/api/doctor/profile` | View/update profile |

### Receptionist
| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/receptionist/overview` | Reception dashboard |
| GET | `/api/receptionist/doctors` | Doctor list |
| GET | `/api/receptionist/doctors/<id>/availability?date=` | Slots for a date |
| GET/POST | `/api/receptionist/patients` | Search/register patients |
| GET/POST | `/api/receptionist/appointments` | List/book appointments |
| GET | `/api/receptionist/payments` | Payment records |
| PATCH | `/api/receptionist/payments/<id>` | Record payment |

### Admin
| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/admin/overview` | Hospital statistics |
| GET/POST | `/api/admin/doctors` | List/add doctors |
| PUT/DELETE | `/api/admin/doctors/<id>` | Update/delete doctors |
| GET/POST | `/api/admin/receptionists` | List/add receptionists |
| PUT/DELETE | `/api/admin/receptionists/<id>` | Update/delete receptionists |
| GET | `/api/admin/patients` | List/search patients |
| GET/DELETE | `/api/admin/patients/<id>` | Patient details/delete |
| GET | `/api/admin/appointments` | All appointments |
| PATCH | `/api/admin/appointments/<id>/status` | Update appointment status |
| GET | `/api/admin/schedules` | Doctor schedules |
| GET | `/api/admin/payments` | Payment records |
| PATCH | `/api/admin/payments/<id>/verify` | Verify a paid payment |
| GET | `/api/admin/reports?from=&to=` | Date-range report |

API errors return JSON in the form `{ "message": "..." }`. Unauthenticated API requests return `401`; wrong-role requests return `403`.

---

## Troubleshooting

**`python` is not recognized**
- On Windows try `py app.py` or reinstall Python with **Add Python to PATH** enabled.
- In VS Code, select the correct interpreter with `Ctrl+Shift+P → Python: Select Interpreter`.

**Port 5000 is already in use**
Run on another port:

**Windows**
```bash
set PORT=5001
python app.py
```

**macOS / Linux**
```bash
PORT=5001 python app.py
```

Then open `http://127.0.0.1:5001`.

**Database looks wrong after experimenting**
```bash
python seed.py
```
This resets `hospital.db` to the original demo state.

**Styles or scripts appear cached**
Hard-refresh the browser with `Ctrl+F5` (Windows) or `Cmd+Shift+R` (macOS).

---

## Deployment (Vercel)

The app can also run on Vercel as a serverless function:

- `api/index.py` exposes the Flask app; `vercel.json` rewrites all traffic to it.
- The Flask blueprint modules live in `routes/` (not `api/`) because Vercel treats every top-level `api/*.py` file as a separate serverless function.
- On Vercel the SQLite database is created in `/tmp` and the demo data is seeded automatically on cold start. Serverless file systems are temporary, so data added after a cold start is not permanent. For a permanent database, connect a managed service such as Turso or Neon.
- Deploy with `vercel --prod` from the project root, or import the GitHub repository into a Vercel project.

---

## Notes

- This project uses Flask's built-in development server and is intended for local learning/demo use. For production, use a WSGI server such as Gunicorn or Waitress and set a strong `SECRET_KEY` environment variable.
- The SQLite file stores all application data locally; no external database server is needed.
- Doctor availability is seeded for the next 21 days (Sundays closed). Use the doctor portal or reset the seed to refresh the available date range.
