#!/usr/bin/ruby

require 'oauth'

$consumer_key = OAuth::Consumer.new(
	"Consumer Key",
	"Consumer Secret"
)
$access_token = OAuth::Token.new(
	"Api Token",
	"Api Secret"
)
