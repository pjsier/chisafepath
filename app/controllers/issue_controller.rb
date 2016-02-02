class IssueController < ApplicationController
  def create
    issue = params[:issue]
    puts "Success"

    render json: { status: 'ok' }
  end

  def index
  end
end
