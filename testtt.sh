from http.server import HTTPServer, BaseHTTPRequestHandler

class HeaderHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/plain")
        self.end_headers()

        headers_received = "\n".join(f"{k} = {v}" for k, v in self.headers.items())
        self.wfile.write(headers_received.encode())

port = 8213
server = HTTPServer(('0.0.0.0', port), HeaderHandler)
print(f"Header test server running on port {port}")
server.serve_forever()
