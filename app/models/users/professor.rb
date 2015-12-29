class Professor < User
  devise :registerable
  has_one :interview
end
