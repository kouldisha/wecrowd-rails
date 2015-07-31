class CardreaderController < ApplicationController
  require 'net/http'
  require 'openssl'

  before_filter 'check_user'

  def form
    params[:name] ||= "Test User"
    params[:company] ||= "WePay"
    params[:email] ||= "testuser@example.com"
    params[:phone] ||= "0000000000"
    params[:street_address] ||= "350 Convention Way"
    params[:suite_number] ||= "123"
    params[:city] ||= "Redwood City"
    params[:zipcode] ||= "94063"
    params[:state] ||= "California"
    params[:model] ||= 122012
    params[:quantity] ||= 2
    params[:shipping_method] ||= "GROUND"
  end

  def order
    @user = User.find_by_id(params[:user_id])
    account_id = @user.wepay_account_id
    name = params[:name]
    company = params[:company]
    email = params[:email]
    phone = params[:phone]
    street_address = params[:street_address]
    suite_number = params[:suite_number]
    city = params[:city]
    zipcode = params[:zipcode]
    state = params[:state]
    model = params[:model]
    quantity = params[:quantity]
    shipping_method = params[:shipping_method]

    shipping_address = {
        'street1' => street_address,
        'street2' => "",
        'state' => state,
        'city' => city,
        'zip' => zipcode
    }

    shipping_contact = {
        'name' => name,
        'company' => company,
        'phone' => phone,
        'email' => email
    }

    order_params = {
        'account_id' => account_id.to_s,
        'quantity' => quantity,
        'model' => model,
        'shipping_method' => shipping_method,
        'shipping_address' => shipping_address,
        'shipping_contact' => shipping_contact

    }

    #render json: order_params
    uri = URI.parse("http://53e9ec16.ngrok.io/order/card_reader/create")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.path, {'Content-Type' =>'application/json'})
    request.body = order_params.to_json
    response = http.request(request)
    summary_response = JSON.parse(response.body)
    #user's name
    @name = summary_response["shipping_contact"]["name"]

    #user's shipping information
    @company =  summary_response["shipping_contact"]["company"]
    @street1 = summary_response["shipping_address"]["street1"]
    @street2 = summary_response["shipping_address"]["street2"]
    @city = summary_response["shipping_address"]["city"]
    @state = summary_response["shipping_address"]["state"]
    @zipcode = summary_response["shipping_address"]["zip"]

    #user's contact information
    @phone = summary_response["shipping_contact"]["phone"]
    @email = summary_response["shipping_contact"]["email"]

    #shipping product information
    @order_id = summary_response["order_id"]
    @model = summary_response["model"]
    if(@model == 122012)
      @model_name = "iMag Pro"
    elsif (@model == 122698)
      @model_name = "Verifone Pinpad"
    elsif (@model == 121524)
      @model_name = "Unimag Pro"
    end
    @quantity = summary_response["quantity"]
    @status =  summary_response["status"]

    render :action => 'submitted', :user_id => @user.id

  end

  def submitted

  end


  def check_user
    user_id = params[:user_id]
    @user = authenticate(user_id, request.path, nil)
  end








end