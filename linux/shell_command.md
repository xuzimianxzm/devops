## sed command

- The sed command usage is different between MacOS and Linux

```shell
# 查询  包含encryptedData: 到包含template:之间的所有行
sed -n '/encryptedData:/,/template:/p' sealed-secrets-dev.yaml

# 替换‘encryptedData:’ 为 ‘xxxxxxxxx’
sed  -n 's/encryptedData:/xxxxxxxxx/g;p' sealed-secrets-dev.yaml

# 查询  包含encryptedData: 到包含template:之间的所有行 ｜ 并 替换‘encryptedData:’ 为空字符串 ｜ 并 template:’ 为空字符串
cat sealed-secrets-dev.yaml | sed  -n '/encryptedData:/,/template:/p' | sed 's/encryptedData://g;p'  | sed 's/template://g;p'

# 取得所有encryptedData~template 之间的行，且去除所有空格
cat sealed-secrets-dev.yaml | sed  -n '/encryptedData:/,/template:/p' | sed '/encryptedData/d' | sed '/template/d' | sed '/^$/d'

# 匹配 所有sealedSecrets:到其下第一个空行之间的行
cat values-dev.yaml | sed -n '/sealedSecrets:/,/^$/p'

# 删除 所有sealedSecrets:到其下第一个空行之间的行
sed -i '' '/sealedSecrets:/,/^$/d' values-dev.yaml

# 删除 所有sealedSecrets:到其下第一个空行之间的行 且将原文件备份为".bak"后缀
sed -i '.bak' '/sealedSecrets:/,/^$/d' values-dev.yaml
```

### 想要在当前目录及子目录中查找所有的‘ \*.txt’文件，可以用：

```sh
$ find . -name "*.txt" -print
```

### 解压 rar 或 jar 到指定目录

```sh
tar -zxvf demo.jar -C /Your_path

unrar x xxx.rar
```

### 端口占用

```sh
lsof -i tcp:8080
kill -9 pid
```

### 设置 HTTP 代理

```sh
export http_proxy="http://localhost:888"
export https_proxy="http://localhost:port"
```
