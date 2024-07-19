# Azkaban镜像
当时最新版本是3.74.3，官方还没有docker化，因此自己作了一个。

azkaban-web-server没有高可用，docker化之后，部署到k8s上，至少可以实现挂掉后，自动恢复。

而azkaban-exec-server，因为后期还要在上面更新一些配置和python运行环境，就没有docker化。

# 历史
## 基于官方3.74.3版本
https://github.com/azkaban/azkaban/tree/3.74.3

## 支持SSL的SMTP，云厂商不开放25端口。
```shell
$ git diff
diff --git a/azkaban-common/src/main/java/azkaban/utils/EmailMessage.java b/azkaban-common/src/main/java/azkaban/utils/EmailMessage.java
index e5f81cc..9cdee77 100644
--- a/azkaban-common/src/main/java/azkaban/utils/EmailMessage.java
+++ b/azkaban-common/src/main/java/azkaban/utils/EmailMessage.java
@@ -178,6 +178,7 @@ public class EmailMessage {
     props.put("mail.smtp.connectiontimeout", _connectionTimeout);
     props.put("mail.smtp.starttls.enable", this._tls);
     props.put("mail.smtp.ssl.trust", this._mailHost);
+    props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");

     final JavaxMailSender sender = this.creator.createSender(props);
     final Message message = sender.createMessage();
```

## 集成LDAP认证
https://github.com/researchgate/azkaban-ldap-usermanager

但集成的时候有些问题，因此作了修改，但没做记录，已经忘记改了什么，只保留了最后生成的jar包。


## 支持飞书告警
https://github.com/twoyang0917/azkaban-feishu-alerter

为了支持飞书告警，又修改了Azkaban的源码。
https://github.com/twoyang0917/azkaban/tree/multi_alerter

# 构建
1. 从https://github.com/twoyang0917/azkaban/tree/multi_alerter分支编译得到azkaban-web-server-3.74.3.zip
2. 将azkaban-ldap-usermanager-1.2.1-SNAPSHOT.jar放到$AZKABAN_HOME/lib/目录下，集成LDAP认证。
3. 将azkaban-feishu-alerter-1.0-SNAPSHOT-dist.tar.gz放到$AZKBAN_HOME/plugins/alerter/目录下，支持飞书告警。
4. 以上步骤完成后，可以开始构建docker镜像。
