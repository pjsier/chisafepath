require 'rails_helper'

describe Issue do
  it "should belong to image" do
    issue = Issue.reflect_on_association(:image)
    expect(issue.macro).to eql(:belongs_to)
  end
end
