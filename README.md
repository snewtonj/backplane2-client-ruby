Backplane2 Client Library for Ruby
=================================

This library integrates server side Backplane clients with the Backplane server protocol (https://github.com/janrain/janrain-backplane-2).

Installation
============

```
gem install backplane2-client-ruby
```


Usage
=====

You should have client credentials for a Backplane server, with a bus provisioned for your use. If you have admin access to a backplane server, the following steps will get you set up:

1. Provision a client (/v2/provision/client/update)
2. Provision a bus (/v2/provision/bus/update)
3. Grant client access to bus (/v2/provision/grant/add)

For more information see the [Backplane server readme](https://github.com/janrain/janrain-backplane-2/blob/master/README20.md).

Example:
=======
```ruby
require 'json'
require 'backplane2'

credentials = Backplane::UserCredentials.new('https://backplane1.janrainbackplane.com', 'client_id', 'secret') 

tokenReq = Backplane::TokenRequest.new(credentials)

tokenResponse = tokenReq.getToken('client_credentials', 'bus:mybusname')
authToken = Backplane::AccessToken.new(JSON.parse(tokenResponse))

# here we get a channel id using an anonymous token, just for demonstration purposes
# in production deployments the widget in the user's browser would get the channel name and pass it back
# to its server-side component, so the server code would never need to request an anonymous token or channel.
tokenResponse = tokenReq.getRegularToken('mybusname')
regularToken = Backplane::AccessToken.new(JSON.parse(tokenResponse))
scopes = regularToken.scopes

client = Backplane::Client.new('https://backplane1.janrainbackplane.com')

message =  Backplane::Message.new('mybusname', scopes['channel'], 'test', 'payload')
client.postMessage(message, authToken)

messages =  client.getMessages(authToken)
jj JSON.parse(messages)
```

Notes
=====

For testing, the following gems are necessary:
uuid
webmock
