require 'json'
require 'test/unit'
require 'webmock/test_unit'
require 'token'
require 'token_request'
require 'credential'
require 'pp'

class TestTokenRequest < Test::Unit::TestCase

  def setup
    @user = UserCredentials.new("testhost.janrain.com", "steven", "gojanrain")
    @req = Backplane::TokenRequest.new(@user)
  end

  def testToken
    refresh_token = rand(36**24).to_s(36)
    access_token = rand(36**24).to_s(36)
    scope = "bus:test-bus"
    expires_in = 28800
    return_body = ({
      "scope" => scope,
      "token_type" => "Bearer",
      "expires_in" => expires_in,
      "access_token" => access_token,
      "refresh_token" => refresh_token
    }).to_json
    stub_request(:post, "https://#{@user.user}:#{@user.password}@#{@user.hostname}/v2/token").
      with(:body => {"scope"=>"bus:steven-dev", "grant_type"=>"client_credentials"}).
      to_return(:status => 200, :body => return_body)
    token = @req.getToken('client_credentials', 'bus:steven-dev')
    assert_equal("Bearer", token.token_type)
    assert_equal(scope, token.scope)
    scopes = token.scopes
    assert_equal(1, scopes.length)
    assert_equal("test-bus", scopes['bus'])
    assert_equal(expires_in, token.expires_in)
    assert_equal(refresh_token, token.refresh_token)
    assert_equal(access_token, token.access_token)
  end

  def testRegularToken
    refresh_token = rand(36**24).to_s(36)
    access_token = rand(36**24).to_s(36)
    scope = "bus:test-bus channel:test-channel"
    expires_in = 28800
    return_body = "f("+({
      "scope" => scope,
      "expires_in" => expires_in,
      "access_token" => access_token,
      "refresh_token" => refresh_token,
      "token_type" => "Bearer"
    }).to_json+");"

    stub_request(:get, "https://testhost.janrain.com/v2/token?bus=steven-dev-bus.janrain.com&callback=f").to_return(:status => 200, :body => return_body, :headers => {})

    reg_token = @req.getRegularToken('steven-dev-bus.janrain.com')

    assert_equal("Bearer", reg_token.token_type)
    assert_equal(scope,reg_token.scope)
    scopes = reg_token.scopes
    assert_equal(2, scopes.length)
    assert_equal("test-channel", scopes['channel'])
    assert_equal("test-bus", scopes['bus'])
    assert_equal(expires_in,reg_token.expires_in)
    assert_equal(access_token, reg_token.access_token)
    assert_equal(refresh_token, reg_token.refresh_token)
  end

end
