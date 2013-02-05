require 'backplane2'
include Backplane

require 'json'
require 'pp'
require "test/unit"
require 'webmock/test_unit'

class TestClient < Test::Unit::TestCase

  def setup
    @test_token = rand(36**16).to_s(36)
    test_refresh_token = rand(36**16).to_s(36)
    @client = Client.new("testhost.janrainbackplane.com")
    @testToken = AccessToken.new({ "token_type" => "Bearer", "access_token" => @test_token, "expires_in" => 28800, "scope" => "bus:test-bus channel:test-channel", "refresh_token" => test_refresh_token })
  end

  def test_postMessage
    payload = { "uuid" => "nothing" }
    testMessage = Message.new("test-bus", "test-channel", "test",  payload)

    stub_request(:post, "https://testhost.janrainbackplane.com/v2/message").with(:headers => {'Accept'=>'*/*', 'Authorization'=>"Bearer #{@test_token}", 'Content-Type'=>'application/json'}).to_return(:status => [201, "Created"], :body => "", :headers => {})
    response = @client.postMessage(testMessage, @testToken)
    assert_equal(201, response.code)
    assert_equal("Created", response.message)
    assert_equal(nil, response.body)
  end

  def test_getMessages
    stub_request(:get, "https://testhost.janrainbackplane.com/v2/messages").with(:headers => {'Authorization'=>"Bearer #{@test_token}", 'Content-Type'=>'application/json'}).to_return(:status => [200, "OK"], :body => '{"nextURL":"https://staging.janrainbackplane.com/v2/messages?since=2013-01-30T22:42:29.087Z-4sNCOuHO7F","messages":[{"messageURL":"https://staging.janrainbackplane.com/v2/message/2013-01-30T22:42:29.087Z-4sNCOuHO7F","source":"http://janrain.com","type":"test","bus":"steven-stg-janrain.com","channel":"YN4bUHo7euaX3nY2tpGSwnpGKPjU8Cvz","sticky":"false","expire":"2013-01-31T06:42:29Z"}],"moreMessages":false}', :headers => {'Content-Type' => 'application/json;charset=UTF-8'})
    response = @client.getMessages(@testToken)
    #puts response.code
    #puts response.message
    #puts response.body
    msg_frame = JSON.parse(response.body)
    assert_equal("https://staging.janrainbackplane.com/v2/messages?since=2013-01-30T22:42:29.087Z-4sNCOuHO7F", msg_frame['nextURL'])
    assert_equal(1, msg_frame['messages'].length)
    msg = Message.create(msg_frame['messages'].pop)
    assert(!msg.sticky)
    assert(!msg_frame['moreMessages'])
#    assert_equal('{"messageURL":"https://staging.janrainbackplane.com/v2/message/2013-01-30T22:42:29.087Z-4sNCOuHO7F","source":"http://janrain.com","type":"test","bus":"steven-stg-janrain.com","channel":"YN4bUHo7euaX3nY2tpGSwnpGKPjU8Cvz","sticky":"false","expire":"2013-01-31T06:42:29Z"}', response.body)
    assert_equal("https://staging.janrainbackplane.com/v2/message/2013-01-30T22:42:29.087Z-4sNCOuHO7F", msg.messageUrl, "Wrong message URL")
  end

  def test_anon_getSingleMessage
    message_id = "2013-01-30T22:42:29.087Z-4sNCOuHO7F"
    stub_request(:get, "https://testhost.janrainbackplane.com/v2/message/#{message_id}?access_token=#{@test_token}").with(:headers => {'Content-Type'=>'application/json' }).to_return(:status => [200, "OK"], :body => '{"messageURL":"https://staging.janrainbackplane.com/v2/message/2013-01-30T22:42:29.087Z-4sNCOuHO7F","source":"http://janrain.com","type":"test","bus":"steven-stg-janrain.com","channel":"YN4bUHo7euaX3nY2tpGSwnpGKPjU8Cvz","sticky":"false","expire":"2013-01-31T06:42:29Z"}', :headers => {'Content-Type' => 'application/json;charset=UTF-8'})
    response = @client.getSingleMessageAnon(@testToken, message_id)
    msg = Message.create(JSON.parse(response.body))
    assert(!msg.sticky)
    assert_equal("http://janrain.com", msg.source)
    assert_equal("test", msg.type)
    assert_equal("steven-stg-janrain.com", msg.bus)
    assert_equal("YN4bUHo7euaX3nY2tpGSwnpGKPjU8Cvz", msg.channel)
    assert_equal("2013-01-31T06:42:29Z", msg.expire)
    assert_equal("https://staging.janrainbackplane.com/v2/message/2013-01-30T22:42:29.087Z-4sNCOuHO7F", msg.messageUrl, "Wrong message URL")
  end

  def test_auth_getSingleMessage
  end
end
