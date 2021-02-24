from http.server import HTTPServer, BaseHTTPRequestHandler
import urllib.request
import sys
import getopt
import logging

data = {'result': 'hello world'}
host = ("", 8080)


class Resquest(BaseHTTPRequestHandler):
    def do_GET(self):
        # url = self.processCommand()
        # file = urllib.request.urlopen(url)
        # html = file.read()
        logging.info("GET request,\nPath: %s\nHeaders:\n%s\n",
                     str(self.path), str(self.headers))
        self.send_response(200)
        self.send_header('Content-type', 'text/html;charset=utf-8')
        self.end_headers()
        self.wfile.write("GET request for {}, and return hello world".format(
            self.path).encode('utf-8'))
        # file.close()

    def processCommand(self):
        comandArgStrs = sys.argv[1:]
        comandArgTuples, others = getopt.getopt(comandArgStrs, "u:")
        for key, value in comandArgTuples:
            if key in ['-u']:
                return value
        return "https://www.baidu.com/"


if __name__ == '__main__':
    server = HTTPServer(host, Resquest)
    print("Starting server, listen at: %s:%s" % host)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        sys.exit(0)
