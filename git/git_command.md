### 清理历史提交大文件记录

```sh
git count-objects -v # 查看 git 相关文件占用的空间
du -sh .git # 查看 .git 文件夹占用磁盘空间
du -d 1 -h  # 列出所有文件的大小
```

#### git 的历史文件都是存在一个文件里的，我们使用下面命令可以找出排名前五的文件

```sh
git rev-list --all | xargs -L1 git ls-tree -r --long | sort -uk3 | sort -rnk4 | head -10
```

#### 删除大文件,其中”xxx.file“是上一步中列出的大文件路径

```sh
git filter-branch --force --index-filter 'git rm -rf --cached --ignore-unmatch xxx.file' --prune-empty --tag-name-filter cat -- --all

git filter-branch --force --index-filter 'git rm -rf --cached --ignore-unmatch build-cache.tar.gz' --prune-empty --tag-name-filter cat -- --all
```

## 为git设置多个远程仓库地址

```sh
git remote set-url --add origin <new_url>
```
