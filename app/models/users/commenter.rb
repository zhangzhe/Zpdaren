class Commenter < User
  has_one :commenter_detail, :foreign_key => :user_id
end
