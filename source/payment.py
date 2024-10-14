from flask import Flask, request, jsonify
import uuid
from datetime import datetime

app = Flask(__name__)

@app.route('/payment', methods=['POST'])
def process_payment():
    try:
        data = request.get_json()
        amount = data.get('amount', None)
        
        if amount is None or not isinstance(amount, (int, float)) or amount <= 0:
            return jsonify({
                'status': 'fail',
                'message': 'Invalid amount provided',
                'transaction_id': str(uuid.uuid4()),
                'timestamp': datetime.utcnow().isoformat()
            }), 400
        
        # Here you would include your payment processing logic.
        # For this example, we'll assume all valid amounts process successfully.
        # curl -X POST -H "Content-Type: application/json" -d '{"amount": 100}' http://127.0.0.1:5000/payment
        
        return jsonify({
            'status': 'success',
            'message': 'Payment processed successfully',
            'transaction_id': str(uuid.uuid4()),
            'amount': amount,
            'currency': 'USD',
            'timestamp': datetime.utcnow().isoformat()
        }), 200
        
    except Exception as e:
        return jsonify({
            'status': 'fail',
            'message': str(e),
            'transaction_id': str(uuid.uuid4()),
            'timestamp': datetime.utcnow().isoformat()
        }), 500

if __name__ == '__main__':
    app.run(host='localhost',port=8992,debug=True)
