Backplane2 Client Library for Ruby
=================================

This library integrates server side Backplane clients with the Backplane server protocol (https://github.com/janrain/janrain-backplane-2).

Installation
============


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
require 'backplane2'

credentials = UserCredentials.new('https://backplane1.janrainbackplane.com', 'client id', 'secret') 

tokenReq = Backplane::TokenRequest.new(credentials)
tokenResponse = req.getRegularToken('busname')
token = Backplane::AccessToken.new(JSON.parse(tokenResponse))

client = Backplane::Client.new('https://backplane1.janrainbackplane.com')

message =  Backplane::Message.new('mybusname', scopes['channel'], 'test', 'payload')
client.postMessage(message, token)

```

Notes
=====

For testing, the following gems are necessary:
uuid
webmock
