class Watching < ActiveRecord::Base
  belongs_to :supplier
  belongs_to :job

  acts_as_paranoid
end
