## 1. Create new account and new blank project in Gitlab
## 2. Follow their recomendations for repo migration:
```
~/Work/tap-git$ git remote rename origin old-origin
~/Work/tap-git$ git remote add origin git@gitlab.com:nikolayninov/git-lab04.git
~/Work/tap-git$ git push -u origin --all
remote: 
remote: To create a merge request for nikolay, visit:
remote:   https://gitlab.com/nikolayninov/git-lab04/-/merge_requests/new?merge_request%5Bsource_branch%5D=nikolay
remote: 
remote: 
remote: To create a merge request for nikolay-lab03, visit:
remote:   https://gitlab.com/nikolayninov/git-lab04/-/merge_requests/new?merge_request%5Bsource_branch%5D=nikolay-lab03
remote: 
To gitlab.com:nikolayninov/git-lab04.git
 * [new branch]      main -> main
 * [new branch]      nikolay -> nikolay
 * [new branch]      nikolay-lab03 -> nikolay-lab03
Branch 'main' set up to track remote branch 'main' from 'origin'.
Branch 'nikolay' set up to track remote branch 'nikolay' from 'origin'.
Branch 'nikolay-lab03' set up to track remote branch 'nikolay-lab03' from 'origin'
```
## 3. Here is the link for gitlab:
https://gitlab.com/nikolayninov/git-lab04