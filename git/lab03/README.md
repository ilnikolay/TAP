## 1. Change to main branch
```bash
~/Work/tap-git$ git checkout main
Switched to branch 'main'
```
## 2. Edit the README.md and commit it:
```bash
~/Work/tap-git$ vi README.md 
~/Work/tap-git$ git add README.md 
~/Work/tap-git$ git commit -m "most important things added"
[main a05de09] most important things added
 1 file changed, 5 insertions(+)
```
## 3. Create new branch and make a pull request:
```bash
~/Work/tap-git$ git branch nikolay-lab03
~/Work/tap-git$ git checkout nikolay-lab03
Switched to branch 'nikolay-lab03'
```
## 4. Push the branch
```bash
~/Work/tap-git$ git push origin nikolay-lab03
To github.com:csuvikg/tap-git.git
   a05de09..8b1b100  nikolay-lab03 -> nikolay-lab03
```