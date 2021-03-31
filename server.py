from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def index(path):
    return jsonify({'message': "hello world"})

if __name__ == '__main__':
    app_port = 8000
    env_port = os.environ.get('APP_PORT')
    if env_port != None:
        app_port = int(env_port)
    app.run(host='0.0.0.0', port=app_port)