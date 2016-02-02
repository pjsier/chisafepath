class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # Found from this link: https://coderwall.com/p/8z7z3a/rails-4-solution-for-can-t-verify-csrf-token-authenticity-json-requests
  protect_from_forgery with: :null_session,
      if: Proc.new { |c| c.request.format =~ %r{application/json} }
end
