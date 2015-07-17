// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
	
	$("#donation-button").click(function(e) {
		e.preventDefault();
		WePay.set_endpoint("stage");
		var response = WePay.credit_card.create({
			"client_id":        $(".donate-form input[name=client_id]").val(),
			"user_name":        $(".donate-form input[name=user_name]").val(),
			"email":            $(".donate-form input[name=user_email]").val(),
			"cc_number":        $(".donate-form input[name=cc_number]").val(),
			"cvv":              $(".donate-form input[name=cvv]").val(),
			"expiration_month": $(".donate-form select[name=expiration_month]").val(),
			"expiration_year":  $(".donate-form select[name=expiration_year]").val(),
			"address": {
				"zip": $(".donate-form input[name=zip]").val()
			}
		}, function(data) {
			if (data.error) {
				alert(data.error.error_description);
				// handle error response
			} else {
                $(".donate-form input[name=payment_method_id]").val(data.credit_card_id);
                $(".donate-form input[name=payment_method_type]").val("credit_card");
				$(".donate-form input[name=cc_number]").val('');
				$(".donate-form input[name=cvv]").val('');
				$(".donate-form select[name=expiration_month]").val('');
				$(".donate-form select[name=expiration_year]").val('');
				$("form.donate-form").submit();
			}
		});
		if (response.error) {
			alert(response.error_description);
		}
	});
});

$(function() {
    WePay.set_endpoint("stage");

    // Shortcuts
    var d = document;
    d.id = d.getElementById,
        valueById = function(id) {
            return d.id(id).value;
        };

    // For those not using DOM libraries
    var addEvent = function(e,v,f) {
        if (!!window.attachEvent) { e.attachEvent('on' + v, f); }
        else { e.addEventListener(v, f, false); }
    };


    var bank_account_ID = null;
    // Attach the event to the DOM
    addEvent(d.id('bank_popup'), 'click', function() {


            $("#cc_payment").show();
            $("#bank_popup").hide();
            $("#CCNUMBER").slideUp();
            $("#EXPDATE").slideUp();
            //document.getElementById("donation-button").disabled = true;
            $("#donation-button").prop("disabled", true);
            response = WePay.bank_account.create({
                "client_id": $(".donate-form input[name=client_id]").val()
        }, function(data) {
            if (data.error) {
                console.log(data);
            } else {
                $(".donate-form input[name=payment_method_id]").val(data.bank_account_id);
                $(".donate-form input[name=payment_method_type]").val("bank_account");
                $("#donation-button").prop("disabled", false);
                //$("#donation_button").enable();
            }
        }
    );
});
//})();
});