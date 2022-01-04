## 1. Cloning the repo:
```bash
$ git clone git@github.com:csuvikg/tap-git.git
Cloning into 'tap-git'...
```
## 2. Create a file name name.txt
```bash
~/Work/tap-git$ git add name.txt
~/Work/tap-git$ git commit -m "Adding name.txt"
```
## 3. Merge add-name branch
```bash
~/Work/tap-git$ git merge origin/add-name
CONFLICT (add/add): Merge conflict in name.txt
Auto-merging name.txt
Automatic merge failed; fix conflicts and then commit the result.
```
## 4. Edit the name.txt to fix the conflict and commit:
```
  1 <<<<<<< HEAD
  2 Nikolay
  3 =======
  4 Gabor Csuvik
  5 Georgi Fuchedzhiev
  6 >>>>>>> origin/add-name

~/Work/tap-git$ git commit -m "Fix the merge conflict"
[main 58ad438] Fix the merge conflict
```
## 5. Create new branch:
```bash
~/Work/tap-git$ git branch nikolay
~/Work/tap-git$ git branch
* main
  nikolay
~/Work/tap-git$ git checkout nikolay
Switched to branch 'nikolay'
```
## 6. Push my branch to the repo in github
```bash
~/Work/tap-git$ git push origin nikolay
remote: Create a pull request for 'nikolay' on GitHub by visiting:
remote:      https://github.com/csuvikg/tap-git/pull/new/nikolay
remote: 
To github.com:csuvikg/tap-git.git
 * [new branch]      nikolay -> nikolay
```