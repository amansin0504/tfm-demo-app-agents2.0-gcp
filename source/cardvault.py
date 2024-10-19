import random
import re
import sys
from flask import Flask, request, jsonify, render_template
import mysql.connector

app = Flask(__name__)

# Configuration for MySQL connection
db_config = {
    'user': 'root',
    'password': '',  # Assuming no password; change as necessary
    'host': '127.0.0.1',
    'database': 'dummy_db'
}

# Function to get credit card details for a user by user_id
# example - curl localhost:8996/get_credit_card
# example - curl localhost:8996/get_credit_card?user_id=10001
def get_credit_card_details(user_id=None):
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor(dictionary=True)
        if user_id is not None:
            query = "SELECT * FROM credit_cards WHERE user_id = %s"
            cursor.execute(query, (user_id,))
        else:
            query = "SELECT * FROM credit_cards"
            cursor.execute(query)
        result = cursor.fetchall()
        cursor.close()
        conn.close()
        return result
    except mysql.connector.Error as err:
        print(f"Error: {err}")
        return None

@app.route('/get_credit_card', methods=['GET'])
def get_credit_card():
    user_id = request.args.get('user_id')
    
    if user_id:
        try:
            user_id = int(user_id)
        except ValueError:
            return jsonify({"error": "user_id must be an integer"}), 400

        credit_card_details = get_credit_card_details(user_id)
    else:
        credit_card_details = get_credit_card_details()

    if credit_card_details is None:
        return jsonify({"error": "Could not retrieve data"}), 500

    if not credit_card_details:
        return jsonify({"message": "No data found"}), 404

    return jsonify(credit_card_details), 200

if __name__ == '__main__':
    app.run(host='localhost',port=8996,debug=True)