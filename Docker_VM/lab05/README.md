1. Create a shell script that:
   a) builds todo-manager (source code in app directory)
   b) runs 3 instances of todo-manager on ports 3001, 3002, 3003
   c) the instances must share the DB (which is located in /etc/todos)
   d) every hour backups the DB content to the host
Verify that database is shared by testing all 3 instances in the browser.

2. To prove that backup is set correctly, create another shell script that:
   a) destroys todo-vol
   b) recreates volume todo-vol
   c) restore data from backup
