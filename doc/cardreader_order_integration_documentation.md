*** POS Portal Card Reader Order Form Integration into WeCrowd ***


In this branch, we are integrating POS Portal Card Reader Order Forms so a merchant can order card readers to accept donations to his/her campaigns.
 <br>
 <br>
In order to successfully add this functionality to WeCrowd, I've added a table to the database. The "cardreaders" table has columns for user_id (integer), name (string), email (string), model_id (integer), quantity (integer), shipping_method (string), order_id (integer), and status (string).

I've also added the corresponding model (cardreader.rb under app/models), controller (cardreader_controller.rb under app/controllers) and views (cardreader under app/views). 
<br>
<br>
<br>
<br>
The general flow behind ordering a card reader is the following:

The WeCrowd URL to began the order of a card reader will be: Rails.application.secrets.host + /cardreader/order_form/:user_id. (If you are running WeCrowd locally, then the base URL will be your local IP. On production, it would be wecrowd.wepay.com)
<br>
In the config/routes.rb, the lines correspond to the HTTP GET and POST requests for this page. 
    <br>
    <br>
    get '/cardreader/order_form/:user_id', :to => "cardreader#order_form"
    <br>
    <br>
    post '/cardreader/order_form/:user_id', :to => "cardreader#submit_order"
    <br>
    <br>
This means that if you go to the base URL and append /cardreader/order_form/:user_id, this will correspond to the "order_form" action/function in the cardreader_controller.  The "order_form" view is rendered from the app/views/cardreader directory.  From the controller, we just preload the order form fields for demo purposes.
    
The post URL corresponds to the "submit_order" action/function in the cardreader controller. This is triggered after the user enters the "Submit Order" button on the order form. The logic in the controller creates a CardReader object and saves it to the database. After making this @card_reader object, it calls the  "order_cardreader" function from the model (cardreader.rb) which makes an API call to WePay's "/order/card_reader/create" endpoint. We take the response and return back to the controller and store some more fields into our database. 
    
Next, we are redirected to the "cardreader#order_summary" action/function in the cardreader_controller. This renders the "order_summary.html.erb" view from the app/views/cardreader directory. All this occurs because of the following line in the config/routes.rb file:
<br>
<br>
        get '/cardreader/order_summary/:user_id/:order_id', :to => "cardreader#order_summary"
<br> 
<br>
        
Inside the "order_summary" action/function in the cardreader_controller.rb, we find the correct order to display by searching via the "order_id" parameter passed in the URL. Upon finding the order and thus the @card_reader object, we call the "find_cardreader" function in the model (cardreader.rb) which makes an API call to WePay's "/order/card_reader/find" endpoint. We take the response and return it back to the controller and display the corresponding fields on the summary page. 
    
If you return to the user page, there will be a table which displays all the card readers that the merchant has ordered. There is also a "New Order?" link which will render the original "order_form" page where the merchant can order a new card reader.


**IMPORTANT NOTE***
    Inside the cardreader model (cardreader.rb under app/models), there are two functions named "test_create" and "test_find". These functions were used to make test API calls to the API written by intern Jitesh Maiyuran which in turn made API calls directly to POS portal. Since all the API was not ready for production when first integrated into WeCrowd, we made local machine to local machine API calls via NGROK.
    These two functions will not work unless the NGROK server is correctly set up, running and the base URL is the one that's newly generated. These functions are still here for you to see how we made API calls to POS Portal without going through WePay.
    
    