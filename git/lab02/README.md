## 1. Create new file changes.md and commit it on branch nikolay:
```bash
~/Work/tap-git$ vi changes.md
~/Work/tap-git$ git add changes.md
~/Work/tap-git$ git commit -m "Add changes.md"
[nikolay 90e1c10] Add changes.md
 1 file changed, 1 insertion(+)
 create mode 100644 changes.md
```
## 2. Revert the previous commit:
```bash
 ~/Work/tap-git$ git log  --oneline
90e1c10 (HEAD -> nikolay) Add changes.md
~/Work/tap-git$ git revert 90e1c10
Removing changes.md
[nikolay ccc76ce] Revert "Add changes.md"
 1 file changed, 1 deletion(-)
 delete mode 100644 changes.md
```
## 3. Create a changelog.md and commit it:
```bash
~/Work/tap-git$ vi changelog.md
~/Work/tap-git$ git add changelog.md
~/Work/tap-git$ git commit -m "Add changelog.md file"
[nikolay fc13d45] Add changelog.md file
 1 file changed, 1 insertion(+)
 create mode 100644 changelog.md
```
## 4. Drop the create and revert commits:
```bash
~/Work/tap-git$ git log  --oneline
fc13d45 (HEAD -> nikolay) Add changelog.md file
ccc76ce Revert "Add changes.md"
90e1c10 Add changes.md
58ad438 (origin/nikolay, main) Fix the merge conflict
```
### We need to work on the last 3 commits:
```bash
~/Work/tap-git$ git rebase -i HEAD~3
Successfully rebased and updated refs/heads/nikolay.
  1 pick 90e1c10 Add changes.md
  2 d ccc76ce Revert "Add changes.md"
  3 d fc13d45 Add changelog.md file
```
### We can see that commits are dropped:
```bash
~/Work/tap-git$ git log  --oneline
90e1c10 (HEAD -> nikolay) Add changes.md
58ad438 (origin/nikolay, main) Fix the merge conflict
```
## 5. Push the changes to my branch:
```bash
~/Work/tap-git$ git push origin nikolay
To github.com:csuvikg/tap-git.git
   58ad438..90e1c10  nikolay -> nikolay
```