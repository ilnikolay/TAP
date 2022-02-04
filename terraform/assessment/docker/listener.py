#!/usr/bin/python3

# import the psycopg2 database adapter for PostgreSQL
from psycopg2 import connect
import os
import sys
from http.server import BaseHTTPRequestHandler, HTTPServer
import json
if len(sys.argv) != 5:
    print("Please set corrent number of arguments")
else:
    def conn_stat():
        # instantiate a cursor object from the connection
        try:

    # declare a new PostgreSQL connection object
            conn = connect (
                dbname = sys.argv[1],
                user = sys.argv[2],
                host = sys.argv[3],
                password = sys.argv[4]
                )

    # return a dict object of the connection object's DSN parameters
            dsm_param = conn.get_dsn_parameters()
            info = json.dumps(dsm_param, indent=4)

            return info

        except Exception as err:
            return err

    class handler(BaseHTTPRequestHandler):
        def do_GET(self):
            self.send_response(200)
            self.send_header('Content-type','text/html')
            self.end_headers()

            message = str(conn_stat()+"\n")
            self.wfile.write(bytes(message, "utf8"))

    with HTTPServer(('', 80), handler) as server:
        server.serve_forever()
