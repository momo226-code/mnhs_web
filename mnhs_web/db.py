import os
from dotenv import load_dotenv
import mysql.connector

load_dotenv()

# -------------------------
# CONFIGURATION
# -------------------------
cfg = dict(
    host=os.getenv("MYSQL_HOST"),
    port=int(os.getenv("MYSQL_PORT")),
    database=os.getenv("MYSQL_DB"),
    user=os.getenv("MYSQL_USER"),
    password=os.getenv("MYSQL_PASSWORD"),
)

def get_connection():
    return mysql.connector.connect(**cfg)

# -------------------------
# LIST PATIENTS
# -------------------------
def list_patients_ordered_by_last_name(limit=20):
    sql = """
    SELECT IID, FullName
    FROM Patient
    ORDER BY SUBSTRING_INDEX(FullName, ' ', -1), FullName
    LIMIT %s
    """
    with get_connection() as cnx:
        with cnx.cursor(dictionary=True) as cur:
            cur.execute(sql, (limit,))
            return cur.fetchall()


# -------------------------
# GET ALL PATIENTS (for dropdowns)
# -------------------------
def get_all_patients():
    sql = "SELECT IID, FullName FROM Patient ORDER BY FullName"
    with get_connection() as cnx:
        with cnx.cursor(dictionary=True) as cur:
            cur.execute(sql)
            return cur.fetchall()


# -------------------------
# GET ALL STAFF (for dropdowns)
# -------------------------
def get_all_staff():
    sql = "SELECT STAFF_ID, FullName FROM Staff ORDER BY FullName"
    with get_connection() as cnx:
        with cnx.cursor(dictionary=True) as cur:
            cur.execute(sql)
            return cur.fetchall()


# -------------------------
# GET ALL DEPARTMENTS (for dropdowns)
# -------------------------
def get_all_departments():
    sql = "SELECT DEP_ID, Name FROM Department ORDER BY DEP_ID"
    with get_connection() as cnx:
        with cnx.cursor(dictionary=True) as cur:
            cur.execute(sql)
            return cur.fetchall()


# -------------------------
# SCHEDULE APPOINTMENT
# -------------------------
def schedule_appointment(caid, iid, staff_id, dep_id, date_str, time_str, reason):
    ins_ca = """
    INSERT INTO ClinicalActivity(CAID, IID, STAFF_ID, DEP_ID, Date, Time)
    VALUES (%s, %s, %s, %s, %s, %s)
    """
    ins_appt = """
    INSERT INTO Appointment(CAID, Reason, Status)
    VALUES (%s, %s, 'Scheduled')
    """

    with get_connection() as cnx:
        try:
            with cnx.cursor() as cur:
                cur.execute(ins_ca, (caid, iid, staff_id, dep_id, date_str, time_str))
                cur.execute(ins_appt, (caid, reason))
            cnx.commit()
        except Exception:
            cnx.rollback()
            raise


# -------------------------
# LOW STOCK
# -------------------------
def low_stock():
    sql = """
    SELECT 
        H.Name AS Hospital,
        M.M_Name AS Medication,
        S.Qty,
        S.ReorderLevel
    FROM Medication M
    LEFT JOIN Stock S ON S.MID = M.MID
    LEFT JOIN Hospital H ON H.HID = S.HID
    WHERE S.Qty < S.ReorderLevel
       OR S.Qty IS NULL
    ORDER BY H.Name, M.M_Name;
    """
    with get_connection() as cnx:
        with cnx.cursor(dictionary=True) as cur:
            cur.execute(sql)
            return cur.fetchall()


# -------------------------
# STAFF SHARE (WINDOW FUNCTION)
# -------------------------
def staff_share():
    sql = """
    SELECT 
        S.STAFF_ID,
        S.FullName,
        H.Name AS Hospital,
        COUNT(A.CAID) AS TotalAppointments,
        ROUND(
            100 * COUNT(A.CAID) /
            SUM(COUNT(A.CAID)) OVER (PARTITION BY H.HID),
            2
        ) AS SharePct
    FROM Staff S
    JOIN ClinicalActivity CA ON CA.STAFF_ID = S.STAFF_ID
    JOIN Appointment A ON A.CAID = CA.CAID
    JOIN Work_in WI ON WI.STAFF_ID = S.STAFF_ID
    JOIN Department D ON D.DEP_ID = WI.DEP_ID
    JOIN Hospital H ON H.HID = D.HID
    GROUP BY S.STAFF_ID, S.FullName, H.Name, H.HID;
    """

    with get_connection() as cnx:
        with cnx.cursor(dictionary=True) as cur:
            cur.execute(sql)
            return cur.fetchall()


# -------------------------
# GET APPOINTMENTS
# -------------------------
def get_appointments():
    sql = """
    SELECT 
        A.CAID,
        A.Reason,
        A.Status,
        CA.Date,
        CA.Time,
        P.FullName AS Patient,
        S.FullName AS Staff,
        D.Name AS Department
    FROM Appointment A
    JOIN ClinicalActivity CA ON CA.CAID = A.CAID
    JOIN Patient P ON P.IID = CA.IID
    JOIN Staff S ON S.STAFF_ID = CA.STAFF_ID
    JOIN Department D ON D.DEP_ID = CA.DEP_ID
    ORDER BY CA.Date DESC, CA.Time DESC;
    """
    with get_connection() as cnx:
        with cnx.cursor(dictionary=True) as cur:
            cur.execute(sql)
            return cur.fetchall()
