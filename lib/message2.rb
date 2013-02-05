module Backplane
  class Message 
    attr_reader(:bus, :channel, :type, :sticky, :payload, :messageUrl, :source, :expire)

    def initialize(bus, channel, type, payload, sticky=false)
      @bus = bus
      @channel = channel
      @type = type
      @sticky = sticky == "true"
      @payload = payload
    end

    def self.create(h)
      m = new(h['bus'], h['channel'], h['type'], h['payload'], h['sticky'])
      m.create(h)
      return m
    end

    def to_json(*a)
        {
         :bus => @bus,
         :channel => @channel,
         :type => @type,
         :sticky => @sticky,
         :payload => @payload
      }.to_json(*a)
    end

    def create(h)
      @messageUrl = h['messageURL']
      @source = h['source']
      @expire = h['expire']
    end


  end
end
