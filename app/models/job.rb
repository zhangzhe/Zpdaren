class Job < ActiveRecord::Base
  belongs_to :recruiter, :foreign_key => :user_id
  has_one :company, through: :recruiter
  has_many :resumes, through: :deliveries
  has_many :deliveries do
    def any_available_for_final_payment?
      self.each do |delivery|
        return true if delivery.available_for_final_payment?
      end
      return false
    end
  end
  has_many :attentions
  has_many :suppliers, through: :attentions
  has_many :refund_requests

  validates_presence_of :title, :description, :bonus, :tag_list
  validates_length_of :title, maximum: 50
  validates_numericality_of :bonus, greater_than_or_equal_to: 1000

  delegate :name, :id, to: :company, prefix: true

  scope :deposit_paid, -> { where('state' => 'deposit_paid')}
  scope :approved, -> { where('state' => 'approved')}
  scope :available, -> { where('state in (?)', ['submitted', 'deposit_paid', 'approved']) }
  scope :in_hiring, -> { where.not('state in (?)', ['freezing', 'finished']) }

  include SimilarEntity

  acts_as_taggable
  acts_as_taggable_on :skills, :interests

  include AASM
  aasm.attribute_name :state
  aasm do
    state :submitted, :initial => true
    state :deposit_paid
    state :approved
    state :final_payment_paid
    state :finished
    state :freezing

    event :pay do
      transitions :from => :submitted, :to => :deposit_paid
    end

    event :freeze do
      transitions :from => [:submitted, :deposit_paid, :approved], :to => :freezing
    end

    event :active do
      transitions :from => :freezing, :to => :submitted
    end

    event :approve, :after => :notify_recruiter_and_deliver_matching_resumes do
      transitions :from => :deposit_paid, :to => :approved
    end

    event :pay_final_payment do
      transitions :from => :approved, :to => :final_payment_paid
    end

    event :complete, :after => :pay_and_notify_supplier do
      transitions :from => :final_payment_paid, :to => :finished
    end
  end

  def editable?
     !["final_payment_paid", "finished", "freezing"].include?(self.state)
  end

  def unread_deliveries
    self.deliveries.unread
  end

  def approved_deliveries
    self.deliveries.approved
  end

  def resumes_bonus_for(supplier)
    count = 0
    resumes_from(supplier).map(&:deliveries).flatten.each do |delivery|
      if delivery.paid?
        count += 1
      end
    end
    return (count * bonus_for_each_resume)
  end

  def resumes_count_from(supplier)
    resumes_from(supplier).count
  end

  def resumes_from(supplier)
    self.resumes.where(:supplier_id => supplier.id)
  end

  def deliveries_from(supplier)
    self.deliveries.where("resume_id in (?)", supplier.resumes.map {|resume| resume.id })
  end

  def bonus_for_each_resume
    if bonus
      (0.005 * bonus).to_i
    else
      0
    end
  end

  def bonus_for_entry
    (bonus * 0.8).to_i
  end

  def original_deposit
    (bonus * 0.2).to_i
  end

  def company
    recruiter.company
  end

  def company_name
    company.name
  end

  def company_description
    company.description
  end

  def delivery!(resume)
    Delivery.create(:resume_id => resume.id, :job_id => self.id)
  end

  def watch_by?(supplier)
    suppliers.include?(supplier)
  end

  def view_pay(pay)
    if self.deposit < pay
      return '余额不足'
    else
      return self.update_attribute(:deposit, self.deposit - pay)
    end
  end

  def can_refund?
    (self.deposit_paid? || self.approved?) && refund_requests.find_by_state(:submitted).nil?
  end

  def deliver_matching_resumes
    matching_resumes.each do |resume|
      self.delivery!(resume) if (resume.auto_delivery? && !Delivery.find_by_resume_id_and_job_id(resume.id, self.id))
    end
  end

  def matching_resumes
    similar_entity(Resume)
  end

  def similar_jobs
    similar_entity(Job)
  end

  def update_and_approve!(job_params)
    self.attributes = job_params
    if self.changed? and self.save
      RecruiterMailer.edit_job_notify(self).deliver_now
    end
    self.approve!
  end

  def in_hiring?
    !['freezing', 'finished'].include?(self.state)
  end

  def available_for_final_payment?
    self.approved? && self.deliveries.any_available_for_final_payment?
  end

  class << self
    def waiting_approved
      deposit_paid
    end

    def default_title
      "Ruby开发工程师#{rand(1000)}" if Rails.env = "develop"
    end

    def default_bonus
      [4000, 5000, 6000, 7000, 8000].sample if Rails.env = "develop"
    end

    def default_tag_list
      Faker::Lorem.words(5).join(", ") if Rails.env = "develop"
    end

    def default_description
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
  内推，内推成功者可以获得36氪独家冠名的销售的私人服务XXOO一次。"  if Rails.env = "develop"
    end
  end

  private
  def notify_recruiter_and_deliver_matching_resumes
    RecruiterMailer.email_jd_approved(recruiter, self).deliver_now
    deliver_matching_resumes
  end

  def pay_and_notify_supplier
    # choose resume and pay the supplier
    notify_supplier
  end

  def notify_supplier
    Weixin.notify_resume_paid(resume, job) if resume.supplier.weixin
  end
end
