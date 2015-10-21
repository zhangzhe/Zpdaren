class CustomFailure < Devise::FailureApp
   def redirect_url
     case
     when params["controller"].include?("recruiters")
       new_recruiter_session_path
     when params["controller"].include?("supplier")
       new_supplier_session_path
     when params["controller"].include?("admin")
       new_admin_session_path
     end
   end

   # You need to override respond to eliminate recall
   def respond
     if http_auth?
       http_auth
     else
       redirect
     end
   end
 end
