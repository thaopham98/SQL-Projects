# SQL-Projects
This is where I stored most of my SQL related projects/codes, along with my setups for this topic.

## Setup

### MacOS
- Installation:
    - Docker
    - Azure Data Studio (retired)
    - Visual Studio Code (VSCode):
        - mssql extension
### Windows
- Installation:
    - SQL Server Management Studio 22 by Microsoft
    - Visual Studio Code (VSCode)

## Query

### Check Databases on Server
Displaying all databases on the server you're connecting to.
```
SELECT name FROM sys.databases ORDER BY name
```

## Handling `.DS_Store` file.<br>

Since I'm using MacOS, there are hidden files, `.DS_Store`, created by default to store information about the folder, such as its icon, position, and other metadata. These files are specific to macOS and are not necessary for other operating systems. Generally, **it's not recommended** to commit `.DS_Store` files to GitHub.<br>

### Handling by ignore `.DS_Store` files with CLI
1. cd to the root of the repository.
```
touch .gitignore
```
2. Opening the `.gitignore` file.<br>
```
nano .gitignore
```
3. Adding the `.DS_Store` rule to the file.<br>
`.DS_Store`<br>
The exact way to save the file depends on your text editor. In nano, you would press `Ctrl+X`, then `Y`, and then `Enter`.<br>
4. Commit to the Git.<br>
```
git add .gitignore
git commit -m "Created a `.gitinore` file to ignore `.DS_Store` files"
```
5. Sync the changes up-to-date with the remote repository.<br>
```
git fetch origin
git merge origin/main
```