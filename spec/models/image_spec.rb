require 'rails_helper'

describe Image do
  let(:issue_img) do
    extend ActionDispatch::TestProcess
    fixture_file_upload('files/test_image.jpg', 'image/jpg')
  end

  describe "create_from_upload" do
    it "should create an image from an upload" do
      Image.create_from_upload(issue_img)
      expect(Image.all.count).to eq(1)
    end
  end

  describe "remove_aws_img" do
    it "should delete images" do
      stub_request(:delete, /chisafepath.s3.amazonaws.com/).
        with(headers: {'Accept'=>'*/*',
          'Accept-Encoding'=>'',
          'Content-Length'=>'0',
          'Content-Type'=>'',
          'Host'=>'chisafepath.s3.amazonaws.com'
        }).to_return(status: 200, body: "", headers: {})

      created_image = Image.create_from_upload(issue_img)
      expect(Image.all.count).to eq(1)
      created_image.remove_aws_img
      expect(Image.all.count).to eq(0)
    end
  end
end
