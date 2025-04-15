# Git commands 

1. git init
2. Set your git identity- git config --global user.name "tsterns12"
3. git config --global user.email "talia.sternbach@mail.mcgill.ca"
4. Add remote github repo link- git remote add origin "<<link>>"
5. Since most of the R projects have a README.md you've to take a pull first- git pull origin main --allow--unrelated--histories
6. Add and Commit the changed files- git add . (this adds everything - use name of file instead of . if just changed file)
7. Push changes to github- git push -u origin main
8. If step 7 doesn't work use force- git push -u origin main --force 
