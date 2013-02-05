require 'token'
include Backplane

require 'json'
require "test/unit"

class TestToken < Test::Unit::TestCase

  def test_token
    test_token = rand(36**16).to_s(36)
    test_refresh_token = rand(36**16).to_s(36)
    
    token = AccessToken.new({ "token_type" => "Bearer", "access_token" => test_token, "expires_in" => 28800, "scope" => "bus:test-bus channel:test-channel", "refresh_token" => test_refresh_token })
    assert_equal("Bearer", token.token_type)
    assert_equal(test_token, token.access_token)
    assert_equal(test_refresh_token, token.refresh_token)
    assert_equal(28800, token.expires_in)
    result_scopes = token.scopes
    assert_equal(2, result_scopes.length)
    assert_equal("test-bus", result_scopes['bus'])
    assert_equal("test-channel", result_scopes['channel'])
  end

end
