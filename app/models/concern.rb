class Concern < ActiveRecord::Base
  belongs_to :supplier
  belongs_to :job
end
