class Watching < ActiveRecord::Base
  belongs_to :supplier
  belongs_to :job
end
