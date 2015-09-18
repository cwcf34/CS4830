require 'rubygems'
require 'oauth'
require 'json'

# You will need to set your application type to
# read/write on dev.twitter.com and regenerate your access
# token.  Enter the new values here:
consumer_key = OAuth::Consumer.new(
    "578ZZYvmKZCQ6FU1DiEoDBHK0",
    "PO1kC55DgfY2ojPzGQIcxaHIqk7cNvmbe8zdpraUtbBzdBufXT")
access_token = OAuth::Token.new(
    "1912722282-LvRzn2CxWYl2Y5EO8yM1QmJ5aARzYevanCiouaG",
    "LWykT9X8KChcjNP6Q3duG1ZyhsCBObHrrKZEL2vbUy5Ct")

# Note that the type of request has changed to POST.
# The request parameters have also moved to the body
# of the request instead of being put in the URL.
baseurl = "https://api.twitter.com"
path    = "/1.1/statuses/update.json"
address = URI("#{baseurl}#{path}")
request = Net::HTTP::Post.new address.request_uri
request.set_form_data(
  "status" => "What the hell is twitter...",
)

# Set up HTTP.
http             = Net::HTTP.new address.host, address.port
http.use_ssl     = true
http.verify_mode = OpenSSL::SSL::VERIFY_PEER

# Issue the request.
request.oauth! http, consumer_key, access_token
http.start
response = http.request request

# Parse and print the Tweet if the response code was 200
tweet = nil
if response.code == '200' then
  tweet = JSON.parse(response.body)
  puts "Successfully sent #{tweet["text"]}"
else
  puts "Could not send the Tweet! " +
  "Code:#{response.code} Body:#{response.body}"
end
