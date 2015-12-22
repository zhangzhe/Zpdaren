module Admins::ResumesHelper
  def options_for_post_state(params)
    available =  (params.try(:[], :resume).try(:[], :available) == 'false') ? false : true
    options_for_select([["求职中", true], ["暂时不找工作", false]], available ?  ["求职中", true] : ["暂时不找工作", false])
  end
end
