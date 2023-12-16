from flask import Flask, request, jsonify
from flask_cors import CORS
from flask_mysqldb import MySQL
from dotenv import load_dotenv
from database import set_database
from os import getenv
from vehicleowners import get_all_vehicleOwners,get_all_vehicleownerslogin, create_vehicle_owner_login, get_by_vehicleowner_ID, update_vehicleOwners, delete_vehicleOwner, create_vehicleowners

app = Flask(__name__)
CORS(app)

app.config["MYSQL_HOST"] = getenv("MYSQL_HOST")
#app.config["MYSQL_PORT"] = int(getenv("MYSQL_PORT"))
app.config["MYSQL_USER"] = getenv("MYSQL_USER")
app.config["MYSQL_PASSWORD"] = getenv("MYSQL_PASSWORD")
app.config["MYSQL_DB"] = getenv("MYSQL_DB")
# to return results as dictionaries and not an array
app.config["MYSQL_CURSORCLASS"] = getenv("MYSQL_CURSORCLASS")
app.config["MYSQL_AUTOCOMMIT"] = True if getenv("MYSQL_AUTOCOMMIT") == "True" else False

mysql = MySQL(app)
set_database(mysql)

@app.route("/")
def hello_world():
    return "<p>Hello, World! WELL WELL WELl</p>"

@app.route("/vehicleowners/login", methods=["GET","POST"])
def vehicle_login():
    if request.method == "POST":
        data = request.get_json()
        print("Received data:", data)
        result = create_vehicle_owner_login(data)
    else:    
        result = get_all_vehicleownerslogin()
    return jsonify(result)

@app.route("/vehicleowners", methods=["GET", "POST"])
def vehicle_owners():
    if request.method == "POST":
        data = request.get_json()
        print("Received data:", data)
        result = create_vehicleowners(data)
    else:
        result = get_all_vehicleOwners()
    return jsonify(result)

@app.route("/vehicleowners/<vo_id>", methods=["GET", "PUT", "DELETE"])
def vehicleowner_ID(vo_id):
    if request.method == "PUT":
        data = request.get_json()
        result = update_vehicleOwners(vo_id, data)
    elif request.method == "DELETE":
        result = get_by_vehicleowner_ID(vo_id)
        if result is not None:
            result = delete_vehicleOwner(vo_id)
        else:
            result = {"error": "User not found"}
    else:
        result = get_by_vehicleowner_ID(vo_id)
    return jsonify(result)


    