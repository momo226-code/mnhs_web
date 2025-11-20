from flask import Flask, render_template, request, redirect, url_for
from db import (
    list_patients_ordered_by_last_name,
    low_stock,
    staff_share,
    schedule_appointment,
    get_all_patients,
    get_all_staff,
    get_all_departments,
    get_appointments
)

app = Flask(__name__)

# -------------------------
# Home Page
# -------------------------
@app.route("/")
def home():
    return render_template("index.html")


# -------------------------
# Patients Page
# -------------------------
@app.route("/patients")
def patients():
    data = list_patients_ordered_by_last_name(100)
    return render_template("patients.html", patients=data)


# -------------------------
# Appointments Page
# -------------------------
@app.route("/appointments")
def appointments_page():
    data = get_appointments()
    return render_template("appointments.html", appts=data)


# -------------------------
# Low Stock Page
# -------------------------
@app.route("/low_stock")
def low_stock_page():
    data = low_stock()
    return render_template("low_stock.html", items=data)


# -------------------------
# Staff Share (Window Function)
# -------------------------
@app.route("/staff_share")
def staff_share_page():
    data = staff_share()
    return render_template("staff_share.html", staff=data)


# -------------------------
# Schedule Appointment (GET + POST)
# -------------------------
@app.route("/schedule_appt", methods=["GET", "POST"])
def schedule_appt_page():
    if request.method == "POST":
        caid = request.form["caid"]
        iid = request.form["iid"]
        staff_id = request.form["staff_id"]
        dep_id = request.form["dep_id"]
        date = request.form["date"]
        time = request.form["time"]
        reason = request.form["reason"]

        schedule_appointment(caid, iid, staff_id, dep_id, date, time, reason)
        return redirect(url_for("appointments_page"))

    # get valid lists for user
    patients = get_all_patients()
    staff = get_all_staff()
    departments = get_all_departments()

    return render_template(
        "schedule_form.html",
        patients=patients,
        staff=staff,
        departments=departments
    )


if __name__ == "__main__":
    app.run(debug=True)
