require 'message2'

require 'json'
require "test/unit"
require 'uuid'

class ExamplePayload
  attr_reader(:uuid, :clientTimestamp)

  def initialize
    uuid_generator = UUID.new
    @uuid = uuid_generator.generate
    @clientTimestamp = Time.new.to_i
  end

  def to_json(*a)
    { :uuid => @uuid, :clientTimestamp => @clientTimestamp }.to_json(*a)
  end

  def to_s
    return "[clientTimestamp: "+clientTimestamp.to_s+" uuid: "+uuid+"]"
  end

end


class TestMessage < Test::Unit::TestCase

  def test_message
    payload = ExamplePayload.new
    message = Backplane::Message.new("test-bus", "test-channel", "test",  payload)
    assert_equal("test", message.type)
    assert_equal("test-bus", message.bus)
    assert_equal("test-channel", message.channel)
    assert_equal(payload, message.payload)
    assert_equal(false, message.sticky)
  end

end
