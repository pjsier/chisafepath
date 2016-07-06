require 'rails_helper'

describe ImageCleanupJob do
  let(:issue_img) do
    extend ActionDispatch::TestProcess
    fixture_file_upload('files/test_image.jpg', 'image/jpg')
  end

  it "does not delete images created within the past 2 days" do
    stub_request(:delete, /chisafepath.s3.amazonaws.com/).
      with(headers: {'Accept'=>'*/*',
        'Accept-Encoding'=>'',
        'Content-Length'=>'0',
        'Content-Type'=>'',
        'Host'=>'chisafepath.s3.amazonaws.com'
      }).to_return(status: 200, body: "", headers: {})

    Image.create_from_upload(issue_img)
    expect(Image.all.count).to eq(1)
    ImageCleanupJob.perform_now
    expect(Image.all.count).to eq(1)
  end

  it "deletes images created earlier than the past two days" do
    stub_request(:delete, /chisafepath.s3.amazonaws.com/).
      with(headers: {'Accept'=>'*/*',
        'Accept-Encoding'=>'',
        'Content-Length'=>'0',
        'Content-Type'=>'',
        'Host'=>'chisafepath.s3.amazonaws.com'
      }).to_return(status: 200, body: "", headers: {})

    created_image = Image.create_from_upload(issue_img)
    expect(Image.all.count).to eq(1)

    created_image.created_at = 3.days.ago
    created_image.save!

    ImageCleanupJob.perform_now
    expect(Image.all.count).to eq(0)
  end
end
