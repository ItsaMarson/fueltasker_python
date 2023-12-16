from database import fetchall, fetchone, execute

def create_vehicle_owner_login(data):
    email_exist = fetchone("""SELECT * FROM vehicle_owners WHERE email = %s""", (data["email"],))
    
    if email_exist:
        return {"error": "Email is already registered"}
    
    cur = execute("""CALL create_login_vehicleowners(%s, %s, %s, %s)""",
                  (data["firstname"], data["lastname"],data["email"], data["password"]))
    row = cur.fetchone()
    if row is not None:
        data["vo_id"] = row["vo_id"]
    return data 

def create_vehicleowners(data):
    cur = execute("""CALL create_vehicleowners(%s, %s, %s, %s, %s, %s)""",
                  (data["firstname"],data["lastname"], data["email"],data["phonenumber"], data["username"],data["password"]))
    row = cur.fetchone()
    if row is not None:
        data["vo_id"] = row["vo_id"]
    return data 

def get_all_vehicleOwners():
  rv = fetchall("""SELECT * FROM vehicle_owners""")
  return rv

def get_all_vehicleownerslogin():
    rv = fetchall("""SELECT * FROM login_users""")
    return rv
    
def get_by_vehicleowner_ID(vo_id):
    rv = fetchone("""SELECT * FROM vehicle_owners WHERE vo_id = %s""", (vo_id,))
    return rv

def update_vehicleOwners(vo_id, data):
    cur = execute("""CALL update_vehicleowners(%s, %s, %s, %s, %s)""",
                  (vo_id ,data["firstname"], data["lastname"], data["phonenumber"], data["email"]))
    row = cur.fetchone()
    if row is not None and vo_id in row:
        data["vo_id"] = row["vo_id"]
    return data 

def delete_vehicleOwner(vo_id):
    cur = execute("""CALL delete_vehicleowner(%s)""", (vo_id,))
    row = cur.fetchone()

    