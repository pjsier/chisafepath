class Issue < ActiveRecord::Base

  has_and_belongs_to_many :categories
  mount_uploader :issuepic, IssuepicUploader

end
