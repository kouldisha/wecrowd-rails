class Cardreader < ActiveRecord::Base
  require "net/http"
  require "uri"
  belongs_to :user

  def order_cardreader(order_params)
    account_id = self.user.wepay_account_id.to_s
    response = WEPAY.call("/order/card_reader/create", account_id, order_params)
    return response
  end

  def find_cardreader(order_params)
    account_id = self.user.wepay_account_id.to_s
    response = WEPAY.call("/order/card_reader/find", account_id, order_params)
    return response
  end

  def test_create(order_params)
    account_id = self.user.wepay_account_id.to_s
    order_params[:account_id] = account_id
    uri = URI.parse("http://8d6471e9.ngrok.io/order/card_reader/create")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path, {'Content-Type' =>'application/json'})
    request.body = order_params.to_json
    response = http.request(request)
    summary_response = JSON.parse(response.body)
    return summary_response

  end
  def test_find(order_params)
    #account_id = self.user.wepay_account_id
    #order_params[:account_id] = account_id
    uri = URI.parse("http://8d6471e9.ngrok.io/order/card_reader/find")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path, {'Content-Type' =>'application/json'})
    request.body = order_params.to_json
    response = http.request(request)
    summary_response = JSON.parse(response.body)
    return summary_response
  end
end