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
