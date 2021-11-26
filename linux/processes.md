Process consists of:
  - Address space(Memory that the kernel assigns for the process to use. It is used to store the process code, libraries, variables and extra information)
  - Set of data structures within the kernel(Kernel data structures store data about the current state of the system. If a new process is created in the system, a kernel data structure is created that contains the details about the process.)

Thread is the segment of a process. A process can have multiple threads, all executing at the same time.

PID - Process ID
PPID - Parent Process ID. Linux creates new process in two steps. First clone existing process, and then exchange the program that is using the new process for a new one.

UID - User ID, user who created the process
EUID - read about setuiad

GID - Group ID, process can be a member of many groups
EGID - read about setgid

Niceness - how the process should be treated by the kernel compared to other processes. Range -20 to 19.

Signals - KILL -9, TERM -15

Zombie process - when application crashes, but the process stays. Cannot kill zombie process, solution is to reboot the system.

Commands and tools:
  - ps, pidof, top, pstree, kill, lsof, netstat, ldd, vmstat, strace, cron, /proc/pid/status
