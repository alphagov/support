require 'webmock/cucumber'

WebMock.disable_net_connect!(:allow_localhost => true)

Before do
  stub_http_request(:post, %r{/api/v2/tickets}).to_return(status: 201, body: { ticket: { id: 12345 }})
  stub_http_request(:post, %r{/api/v2/users}).to_return(status: 201, body: { user: { id: 12345 }})
  stub_request(:get, %r{/users/search}).
        to_return(body: {users: [], previous_page: nil, next_page: nil, count: 0}.to_json, 
                  headers: {'Content-Type' => 'application/json'})
end
