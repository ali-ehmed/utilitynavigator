require 'test_helper'

class RequestCallBackTest < ActionMailer::TestCase
  test "call_request" do
    mail = RequestCallBack.call_request
    assert_equal "Call request", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
