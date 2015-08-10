class CardreaderController < ApplicationController
  require 'net/http'
  before_filter 'check_user'

  def check_user
    user_id = params[:user_id]
    @user = authenticate(user_id, request.path, nil)
  end

  def order_form
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

  def submit_order
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
    @card_reader = Cardreader.new({user_id: @user.id,
                    name: name,
                    email: email,
                    quantity: quantity,
                    shipping_method: shipping_method,
                    model_id: model
                                  })
    response = @card_reader.order_cardreader(order_params)
    #response = @card_reader.test_create(order_params)
    order_id = response["order_id"]
    @status = response["status"]
    @card_reader.order_id = order_id
    @card_reader.status = @status
    @card_reader.save
    redirect_to("/cardreader/order_summary/#{@user.id}/#{order_id}")
  end

  def order_summary
    @order_id = params[:order_id]
    order_params = {"order_id" => @order_id}
    @card_reader = Cardreader.find_by_order_id(@order_id)
    summary_response = @card_reader.find_cardreader(order_params)
    #summary_response = @card_reader.test_find(order_params)
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

    #order logistics
    @quantity = summary_response["quantity"]
    @status =  summary_response["status"]
  end





end