### Helm 生成模板预览
helm install --dry-run --debug .  --name <release_name>

### 升级或安装部署文件
helm upgrade <release_name> charts --install --namespace <namespace>

### has no deployed releases
helm delete <release_name> --purge