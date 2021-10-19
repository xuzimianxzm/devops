
### Jenv设置 jdk 环境变量
jenv add /Library/Java/JavaVirtualMachines/jdk1.8.0.111.jdk/Contents/Home/
jenv versions 获取所有jdk版本
jenv remove 移除指定版本jdk
jenv local 1.8.0.111 选择一个jdk版本
jenv global 1.8.0.111 设置默认的jdk版本
jenv which java 查看当前版本jdk的路径

### NVM 切换node 环境
nvm list 查看安装了所有的node版本
nvm use 版本号切换版本


### 安装Java，推荐使用asdf-vm
asdf-vm 是一个命令行工具，它可以让你同时安装多个版本的开发工具，版本间可以随时切换，还可以基于全局、目录、和当前 shell session 配置不同的版本。它以插件的形式支持开发工具，目前支持 .NET Core、Clojure、Deno、Groovy、Java、Kotlin、Maven、MySQL、Node.js、PHP、Python、Ruby、Scala、Yarn 等近 200 个，具体参见官方插件列表。有了它，你就不再需要另外安装gvm、nvm、rbenv和pyenv等工具了。

官网：https://asdf-vm.com
简介：https://github.com/macdao/ocds-guide-to-setting-up-mac#asdf-vm
胡皓写的入门：https://huhao.dev/posts/61efd12a/


### base64

base64 编码
````sh
echo -n  '明文' | base64
````

base64 解码
````sh
echo -n  'base64编码文本' | base64 -D
````