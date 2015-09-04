class Admin < User
  devise :database_authenticatable, :trackable
  has_one :wallet, foreign_key: :user_id
end
