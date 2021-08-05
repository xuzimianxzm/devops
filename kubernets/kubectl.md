#### 1. kubectl 环境切换

配置 Kubectl 连接 AWS K8s 服务的环境：

```sh
  aws eks --region us-east-2 update-kubeconfig --name sw21-eks-cluster
```

切换为 minikube 集群环境：

```sh
   kubectl config use-context minikube
```

获取所有名称空间下的 pods

```sh
  kubectl get pods --all-namespaces
```

命令行登陆 aws,可以本地执行 docker 命令拉取镜像

```sh
aws ecr get-login --no-include-email | bash
```

#### 2. 查看指定 pod 的日志

```sh
kubectl logs <pod_name>
#类似 tail -f 的方式查看(tail -f 实时查看日志文件 tail -f 日志文件 log)
kubectl logs -f <pod_name> -c \<container-name>
kubectl logs --tail=100 -n <namespaece> -f <pod_name>
```

example:

```sh
# wide 输出额外信息
# yaml 以 yaml 格式显示结果
# name 仅输出资源名称
kubectl logs -n <namespaece> -f <pod_name> -o wide|yaml|name
```

#### 3. kubectl 描述对象

```sh
- kubectl describe nodes <node-name>
- kubectl describe -n <namespace> pods/\<pod-name>
```

#### 4. kubectl 删除对象

Kubernetes 1.9 以前在 RC 等对象被删除后，它们所创建的 Pod 副本都不会被删除，1.9 以后，这些 Pod 副本会被一起删除，如果不想一起删除，则添加--cascade=false 参数来取消这一默认特性

```sh
kubectl delete pods --all
kubectl delere -f pod.yaml 根据 pod.yaml 文件定义删除 pod
kubectl delete replicaset my-repset --casecade=false
```

#### 5. kubectl 创建或更新资源

```sh
- kubectl apply -f app.yaml 和 create 命令的区别是如果目标资源对象不存在则创建，存在则更新资源
```

#### 6. 在 pod 和本地之间复制

`````sh
- kubectl cp <pod_name>:/podResourcePath /localPath

#### 7. kubectl 给 node 节点打标签
````sh
- kubectl label nodes <node-name> \<label-key>=\<label-value>

#### 8. kubectl 进入 pod 环境
````sh
- kubectl exec -n kube-system -it fluentd-7pdk5 -- /bin/bash

#### 9. 将 k8s 服务映射到本地端口，如下命令将 http://localhost:7021 转向 k8s http://online_uri
````sh
kubectl port-forward svc/ServiceName 7021:80 -n <Namespace>
`````

#### 10. 获取指定的 secret

```sh
kubectl get secret secretName -n Namespace -o json | jq ‘.data’ | jq ‘map_values(@base64d)’
```

#### 11. 在线修改 k8s 资源

```sh
kubectl edit pod podName -n namespace -o yaml/json
```

- 在线修改 pod resource 配置

```sh
kubectl edit deploy <ServiceName> -n <Namespace>
```

##### 12. 轮替重启 Pod 资源(deployments,daemonsets,statefulsets)

```sh
kubectl set image deployment/frontend www=image:v2               # 滚动更新 "frontend" Deployment 的 "www" 容器镜像
kubectl rollout history deployment/frontend                      # 检查 Deployment 的历史记录，包括版本
kubectl rollout undo deployment/frontend                         # 回滚到上次部署版本
kubectl rollout undo deployment/frontend --to-revision=2         # 回滚到特定部署版本
kubectl rollout status -w deployment/frontend                    # 监视 "frontend" Deployment 的滚动升级状态直到完成
kubectl rollout restart deployment/frontend                      # 轮替重启 "frontend" Deployment

# 查看 rollout 命令
kubectl rollout --help
```

##### 更新资源

```sh
cat pod.json | kubectl replace -f -                              # 通过传入到标准输入的 JSON 来替换 Pod

# 强制替换，删除后重建资源。会导致服务不可用。
kubectl replace --force -f ./pod.json

# 为多副本的 nginx 创建服务，使用 80 端口提供服务，连接到容器的 8000 端口。
kubectl expose rc nginx --port=80 --target-port=8000

# 将某单容器 Pod 的镜像版本（标签）更新到 v4
kubectl get pod mypod -o yaml | sed 's/\(image: myimage\):.*$/\1:v4/' | kubectl replace -f -

kubectl label pods my-pod new-label=awesome                      # 添加标签
kubectl annotate pods my-pod icon-url=http://goo.gl/XXBTWq       # 添加注解
kubectl autoscale deployment foo --min=2 --max=10                # 对 "foo" Deployment 自动伸缩容
```

#### 13. 部分更新资源

```sh
# 部分更新某节点
kubectl patch node k8s-node-1 -p '{"spec":{"unschedulable":true}}'

# 更新容器的镜像；spec.containers[*].name 是必须的。因为它是一个合并性质的主键。
kubectl patch pod valid-pod -p '{"spec":{"containers":[{"name":"kubernetes-serve-hostname","image":"new image"}]}}'

# 使用带位置数组的 JSON patch 更新容器的镜像
kubectl patch pod valid-pod --type='json' -p='[{"op": "replace", "path": "/spec/containers/0/image", "value":"new image"}]'

# 使用带位置数组的 JSON patch 禁用某 Deployment 的 livenessProbe
kubectl patch deployment valid-deployment  --type json   -p='[{"op": "remove", "path": "/spec/template/spec/containers/0/livenessProbe"}]'

# 在带位置数组中添加元素
kubectl patch sa default --type='json' -p='[{"op": "add", "path": "/secrets/1", "value": {"name": "whatever" } }]'
```

#### 查看资源

```sh
# get 命令的基本输出
kubectl get services                          # 列出当前命名空间下的所有 services
kubectl get pods --all-namespaces             # 列出所有命名空间下的全部的 Pods
kubectl get pods -o wide                      # 列出当前命名空间下的全部 Pods，并显示更详细的信息
kubectl get deployment my-dep                 # 列出某个特定的 Deployment
kubectl get pods                              # 列出当前命名空间下的全部 Pods
kubectl get pod my-pod -o yaml                # 获取一个 pod 的 YAML

# describe 命令的详细输出
kubectl describe nodes my-node
kubectl describe pods my-pod

# 列出当前名字空间下所有 Services，按名称排序
kubectl get services --sort-by=.metadata.name

# 列出 Pods，按重启次数排序
kubectl get pods --sort-by='.status.containerStatuses[0].restartCount'

# 列举所有 PV 持久卷，按容量排序
kubectl get pv --sort-by=.spec.capacity.storage

# 获取包含 app=cassandra 标签的所有 Pods 的 version 标签
kubectl get pods --selector=app=cassandra -o \
  jsonpath='{.items[*].metadata.labels.version}'

# 检索带有 “.” 键值，例： 'ca.crt'
kubectl get configmap myconfig \
  -o jsonpath='{.data.ca\.crt}'

# 获取所有工作节点（使用选择器以排除标签名称为 'node-role.kubernetes.io/master' 的结果）
kubectl get node --selector='!node-role.kubernetes.io/master'

# 获取当前命名空间中正在运行的 Pods
kubectl get pods --field-selector=status.phase=Running

# 获取全部节点的 ExternalIP 地址
kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="ExternalIP")].address}'

# 列出属于某个特定 RC 的 Pods 的名称
# 在转换对于 jsonpath 过于复杂的场合，"jq" 命令很有用；可以在 https://stedolan.github.io/jq/ 找到它。
sel=${$(kubectl get rc my-rc --output=json | jq -j '.spec.selector | to_entries | .[] | "\(.key)=\(.value),"')%?}
echo $(kubectl get pods --selector=$sel --output=jsonpath={.items..metadata.name})

# 显示所有 Pods 的标签（或任何其他支持标签的 Kubernetes 对象）
kubectl get pods --show-labels

# 检查哪些节点处于就绪状态
JSONPATH='{range .items[*]}{@.metadata.name}:{range @.status.conditions[*]}{@.type}={@.status};{end}{end}' \
 && kubectl get nodes -o jsonpath="$JSONPATH" | grep "Ready=True"

# 不使用外部工具来输出解码后的 Secret
kubectl get secret my-secret -o go-template='{{range $k,$v := .data}}{{"### "}}{{$k}}{{"\n"}}{{$v|base64decode}}{{"\n\n"}}{{end}}'

# 列出被一个 Pod 使用的全部 Secret
kubectl get pods -o json | jq '.items[].spec.containers[].env[]?.valueFrom.secretKeyRef.name' | grep -v null | sort | uniq

# 列举所有 Pods 中初始化容器的容器 ID（containerID）
# 可用于在清理已停止的容器时避免删除初始化容器
kubectl get pods --all-namespaces -o jsonpath='{range .items[*].status.initContainerStatuses[*]}{.containerID}{"\n"}{end}' | cut -d/ -f3

# 列出事件（Events），按时间戳排序
kubectl get events --sort-by=.metadata.creationTimestamp

# 比较当前的集群状态和假定某清单被应用之后的集群状态
kubectl diff -f ./my-manifest.yaml

# 生成一个句点分隔的树，其中包含为节点返回的所有键
# 在复杂的嵌套JSON结构中定位键时非常有用
kubectl get nodes -o json | jq -c 'path(..)|[.[]|tostring]|join(".")'

# 生成一个句点分隔的树，其中包含为pod等返回的所有键
kubectl get pods -o json | jq -c 'path(..)|[.[]|tostring]|join(".")'

# 假设你的 Pods 有默认的容器和默认的名字空间，并且支持 'env' 命令，可以使用以下脚本为所有 Pods 生成 ENV 变量。
# 该脚本也可用于在所有的 Pods 里运行任何受支持的命令，而不仅仅是 'env'。
for pod in $(kubectl get po --output=jsonpath={.items..metadata.name}); do echo $pod && kubectl exec -it $pod env; done
```
