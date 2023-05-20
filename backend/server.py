import requests
from flask import Flask, request

app = Flask(__name__)

cnt = 0

@app.route('/')
def toflutter():
    global cnt
    return str(cnt)

@app.route('/receive',methods=['POST'])
def receivefromadu():
    message = request.data.decode('utf-8')
    global cnt
    cnt = int(message)
    print('Received: ',message)
    return "FINE"

if __name__ == '__main__':
    app.run(host='0.0.0.0',debug=True)
