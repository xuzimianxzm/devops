## 将手动在aws上创建的资源导入到本地
* 用于解决terraform代码添加新资源，而该资源已经在aws上先行手动建立了，执行terraform出冲突错误，执行类似下面命令，将手动建立的资源和服务器上的terraform 建立绑定关系
terraform import -var-file environment/nonprod.tfvars "aws_ecr_repository.repo[\"payment-management-service\"]" payment-management-service
