#rails外部依赖 
1、postgresql数据库

  系统的数据库为postgresql
  
* 正式环境（阿里云服务器）

  postgresql数据库和rails应用在一台服务器上

* 灵雀云测试环境

  docker容器运行postgesql镜像对外提供数据库服务，服务的域名：postgresql-zpdaren.myalauda.cn（登录灵雀云就可以查看到）不要使用域名对应的ip（ip可能会变）

2、redis

  使用redis做系统缓存，目前缓存微信ticket、access_token、发送邮件消息、微信推送消息等
  
* 正式环境（阿里云服务器）

  redis、postgrsql以及rails应用都运行在同一台阿里云服务器上。

  redis的安装路径：/data/redis-3.0.6

  redis配置文件路径：/data/redis-3.0.6/redis.conf，安装redis默认会生成这样一个配置文件，当然你可以不使用这个默认配置文件，使用自定义当然是可以的啦。在启动redis时候指定自定义配置文件路径就行。

  我们使用的就是默认的配置文件，当然是修改了一些配置的：

  daemonize yes，daemonize默认值是no

  logfile /data/redis-3.0.6/log/redis.log，制定redis日志路径，这个log目录是没有的，自己创建的
  
  bind 127.0.0.1 只允许本机访问，前面说了，redis和rails跑在一台机器上

  其他使用默认配置。
  
  redis启动：在redis安装路径中（/data/redis-3.0.6）执行src/redis-server，就可以启动redis了，当然是使用默认配置启动的，指定配置启动执行src/redis-server redis.conf就ok
  redis关闭：在redis安装路径中（/data/redis-3.0.6）执行src/redis-cli shutdown
  
  redis官网：
  
  http://redis.io/
  
  ruby gem
  
  https://github.com/redis/redis-rb
  
* 灵雀云测试环境
  
  使用公用的redis镜像起了一个docker服务给rails提供缓存服务，服务域名：redis-zpdaren.myalauda.cn（登录灵雀云就可以查看到）不要使用域名对应的ip（ip可能会变）

3、sidekiq

  使用sidekiq处理消息队列中的消息

  bundle exec sidekiq 启动sidekiq处理消息队列中的消息，后台运行bundle exec sidekiq -d，指定配置文件bundle exec sidekiq -C config/sidekiq.yml，更多参数通过sidekiq -h查看
  
  https://zpdaren.com/sidekiq是sidekiq的管理页面，这么机密的东西当然是只有管理员才能看的呀
  
  sidekiq文档：
  
  github：https://github.com/mperham/sidekiq/
  
  Wiki：https://github.com/mperham/sidekiq/wiki/Getting-Started
  
#收费规则：

1. 20%作为押金
2. 每看一份简历抽取佣金的千分之五
3. 我们的收益 = 20% - 查看简历数量*0.5%
4. 看简历给HR20%

### 4000 红包

* 招聘方看了10份简历

* 我们收益 20% * 4000 - 4000 * 0.5% * 10 * 20% = 800 - 40 = 760

* HR提供一份简历 4000 * 0.5% * 20% = 4  




