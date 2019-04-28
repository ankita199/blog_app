class ApplicationController < ActionController::Base
  include SessionConcern
  helper_method [:current_user,:logged_in?,:current_user?]
   # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end
