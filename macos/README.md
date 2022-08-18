### Install Jdk

Recommended：
```sh
brew install openjdk

brew info openjdk # or run 'brew list' to check how many jdks have install in brew 
# The previous command will show the jdk install address by brew,such as: /opt/homebrew/Cellar/openjdk@17/17.0.4

jenv add /opt/homebrew/Cellar/openjdk@17/17.0.4

```

```sh
brew install openjdk
sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
# export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk.jdk/Contents/Home"
java --version
```