from flask import Flask ,  request , make_response, jsonify
import json, os
import pdb
from datetime import datetime
app = Flask(__name__)  
import psycopg2
from psycopg2 import Error


 
 
def is_table_exists(conn, table_name):
    try : 
        query = """
            SELECT * FROM pg_catalog.pg_tables
            WHERE 
                schemaname != 'pg_catalog' AND 
                schemaname != 'information_schema' AND 
                tablename = %s
            ;    
        """
        cur = conn.cursor()
        # create table one by one
        table_list = cur.execute(query, (table_name,))
        if (table_list):
            return True
        return False
    except Exception as E:
        return False


def create_table():
    """ create tables in the PostgreSQL database"""

    try:
        # read the connection parameters
        # connect to the PostgreSQL server
        command = """CREATE TABLE  users ( name VARCHAR(255) PRIMARY KEY,dob VARCHAR(255) NOT NULL)"""
        conn = None
        conn = connect_to_db()
        if not (is_table_exists(conn, 'users')) :
            cur = conn.cursor()
            # create table one by one
            cur.execute(command)
            # close communication with the PostgreSQL database server
            cur.close()
            # commit the changes
            conn.commit()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)



def connect_to_db():
    try:
        connection = psycopg2.connect(user = os.environ["POSTGRES_USER"],
                                    password = os.environ["POSTGRES_PASSWORD"],
                                    host = os.environ["HOST"],
                                    port = "5432",
                                    database = os.environ["POSTGRES_DB"])
        return connection
    except Exception as E:
        print E
        return False

def check_user_existence(username, connection) :
    cursor = connection.cursor()
    create_table_query =  """select * from users where name = %s;"""
    cursor.execute(create_table_query, (username,))
    records = cursor.fetchall()
    return records

def update_user(dob, username, connection):
    try : 
        cursor = connection.cursor()
        query = """Update users set dob = %s where name =  %s"""
        cursor.execute(query, (dob, username))
        print "updated"
        connection.commit()
        return True
    except Exception as E:
        return False
    finally :
        if connection:
            connection.close()

def create_user(dob, username, connection) :
    try :
        cursor = connection.cursor()
        query = """ INSERT INTO users (name, dob) VALUES (%s,%s)"""
        cursor.execute(query, (username, dob))
        print "created"
        connection.commit()
        return True
    except Exception as E:
        return False
    finally :
        if connection: 
            connection.close()  

def calculate_days(month, day):
    now = datetime.now()
    birthday = datetime(now.year, int(month), int(day))
    return (birthday - now.today()).days + 1

@app.route('/hello/healthCheck') 
def healthCheck():
    res = make_response(jsonify({"message": "Healthy"}), 200)
    return res

 
@app.route('/hello/<username>', methods=["PUT"])  
def update(username):  
    try : 
        db_connection = connect_to_db()
        dob = request.json['dateOfBirth']
        user_record = check_user_existence(username, db_connection)
        if len(user_record) :
            response = update_user(dob, username, db_connection)
            if response :
                res = make_response(jsonify({"message": "Updated the user"}), 200)
            else :
                res = make_response(jsonify({"message": "Failed in updated the user"}), 404)               
        else :
            response =  create_user(dob, username, db_connection) 
            if response :        
                res = make_response(jsonify({"message": "Created the user"}), 200) 
            else : 
                res = make_response(jsonify({"message": "Failed in creating the user"}), 500)                   
        return res
    except Exception as E :
        print E


@app.route('/hello/<username>')  
def get(username): 
    try : 
        db_connection = connect_to_db()
        #pdb.set_trace()
        user_record = check_user_existence(username, db_connection)
        if (user_record) :
            user_info = user_record[0]
            dob = user_info[1]
            dob_split = dob.split('-')
            days = calculate_days(dob_split[1], dob_split[2])
            if (days < 0):
                days = 365+ days
            if (days == 1) :
                keyword = " day"
            else :
                keyword = " days"
            if (days == 0) :
                res = make_response(jsonify({"message": "Hello, "+username +"! Happy Birthday!"}), 200)        
            else :
                res = make_response(jsonify({"message": "Hello, "+username +"! Your birthday is in "+str(days)+keyword}), 200) 
            return res
        else :
            res = make_response(jsonify({"message": "user not found"}), 204)   
        return res
    except Exception as E:
        print E     
    finally :
        if db_connection:
            db_connection.close()
  
if __name__ =="__main__":  
    create_table()
    app.run(debug=True, host='0.0.0.0')
