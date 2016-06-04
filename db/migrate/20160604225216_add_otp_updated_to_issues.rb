class AddOtpUpdatedToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :otp_updated, :boolean, default: false
  end
end
