module DefaultValue
  def default_candidate_name
    Faker::Name.name if develop?
  end

  def default_mobile
    Faker::Number.number(11) if develop?
  end

  def default_email
    Faker::Internet.email if develop?
  end

  def default_tag_list
    Faker::Lorem.words(5).join(", ") if develop?
  end

  def default_jd_title
    "Ruby开发工程师#{rand(1000)}" if develop?
  end

  def default_bonus
    [4000, 5000, 6000, 7000, 8000].sample if develop?
  end

  def default_jd_description
    "既然在招聘 Rails，我们的要求有哪些呢，其实要求不高，很简单，你只需要对这些东西：

HTML/CSS/JS/Bootstrap,Less,CoffeeScript/AngularJS/NodeJS/PHP/ErLang/Haskell/MySQL/MongoDB/PostgreSQL/Emacs/Vi/Git/Linux/Shell/CDN/Ruby/Rails/TDD/BDD/DDD/Test/Rspec/Memcached/Faye/Omniauth/Sidekiq/Redis/Nginx/Unicorn/OOP/FP/Route/State_Machine/DSL/MQ/Cap/OAuth2.0/Trello/Slack/NewRelic/ （请帮忙找出至少 3 处拼写错误～）

听过或者用过或者熟悉一个，就可以啦，其次我们也是不介意你有以下的一些特征（包含但不限于）

有浓厚的编程兴趣，或者编程已经成为你的小三，甚至爱上代码，写代码可以些到下面有反应....
痴迷于软件技术，热爱代码如生命，热衷讨论新技术尝试各种新鲜应用。喜欢阅读软件开发高手的博客，书籍
你也有泰山崩于前，依然沐浴更衣焚香沏茶，诚心正意，手气键落 Hello World! 的气魄和魅力
智力超群，喜欢折腾，喜欢学习
喜欢研究产品,有责任心,专注、踏实、坚持做事的原则
背心+宽松大花裤衩+人字拖+头发油得发亮
穿着内衣坐在电脑前，直到凌晨，一如既往；
情愿坐在电脑前吃方便面，也不愿出去约会
打字比你思考还快；
知道如何使用文本编辑器编写 HTML；
无大屏不工作，从来不关电脑；
看到月经贴就忍不住要去吐槽一下；
觉得你是院系里或者你那个疙瘩里小有名气滴计算机小“牛”！
有完美主义 理想主义的“代码洁癖”！
也想站在互联网风口，和各个创业者一起做那头幸福的会飞的猪；
对行业数据有敏锐的洞察力；
也想看看传说中出美女比例最多的互联网公司是长啥样？
直接写二进制机器代码的，写源代码，是为了给其他开发人员作参考
宁愿使用浏览Html源码的方式浏览网页，也不愿意用浏览器
....
当然我们也有加分项：

资深全栈工程师；
个人博客；
雄厚的项目经验；
足够叼，足够 Geek；
一看就是有缘人；
在线作品案例；
Github 地址；
English 优异；
有设计能力、前端开发经验；
内推，内推成功者可以获得36氪独家冠名的销售的私人服务XXOO一次。"  if develop?
  end

  def develop?
    Rails.env == "development"
  end
end