import pika

try:
    connection = pika.BlockingConnection(
        pika.ConnectionParameters(host='127.0.0.1', port=9443)
    )
    print("OK")
    connection.close()
except Exception as e:
    print("FAIL")
