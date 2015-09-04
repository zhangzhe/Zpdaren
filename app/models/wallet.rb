class Wallet < ActiveRecord::Base
  belongs_to :supplier, foreign_key: :user_id
  belongs_to :admin, foreign_key: :user_id
end