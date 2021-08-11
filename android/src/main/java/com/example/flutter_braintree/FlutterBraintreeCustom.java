package com.example.flutter_braintree;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import androidx.appcompat.app.AppCompatActivity;

import com.braintreepayments.api.BraintreeFragment;
import com.braintreepayments.api.Card;
import com.braintreepayments.api.DataCollector;
import com.braintreepayments.api.GooglePayment;
import com.braintreepayments.api.PayPal;
import com.braintreepayments.api.ThreeDSecure;
import com.braintreepayments.api.Venmo;
import com.braintreepayments.api.interfaces.BraintreeCancelListener;
import com.braintreepayments.api.interfaces.BraintreeErrorListener;
import com.braintreepayments.api.interfaces.BraintreeResponseListener;
import com.braintreepayments.api.interfaces.ConfigurationListener;
import com.braintreepayments.api.interfaces.PaymentMethodNonceCreatedListener;
import com.braintreepayments.api.internal.SignatureVerification;
import com.braintreepayments.api.models.CardBuilder;
import com.braintreepayments.api.models.Configuration;
import com.braintreepayments.api.models.GooglePaymentRequest;
import com.braintreepayments.api.models.PayPalRequest;
import com.braintreepayments.api.models.PaymentMethodNonce;
import com.braintreepayments.api.models.ThreeDSecureAdditionalInformation;
import com.braintreepayments.api.models.ThreeDSecurePostalAddress;
import com.braintreepayments.api.models.ThreeDSecureRequest;
import com.google.android.gms.wallet.TransactionInfo;
import com.google.android.gms.wallet.WalletConstants;

import java.util.HashMap;

public class FlutterBraintreeCustom extends AppCompatActivity
        implements PaymentMethodNonceCreatedListener, BraintreeCancelListener, BraintreeErrorListener, BraintreeResponseListener<String> {
    private BraintreeFragment braintreeFragment;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_flutter_braintree_custom);
        try {
            Intent intent = getIntent();
            String type = intent.getStringExtra("type");

            braintreeFragment = BraintreeFragment.newInstance(this, intent.getStringExtra("authorization"));
            if (type.equals("tokenizeCreditCard")) {
                tokenizeCreditCard();
            } else if (type.equals("requestPaypalNonce")) {
                requestPaypalNonce();
            } else if (type.equals("threeDSecure")) {
                threeDSecureRequest();
            } else if (type.equals("requestDeviceData")) {
                requestDeviceData();
            } else if (type.equals("requestPayPalDeviceData")) {
                requestPayPalDeviceData();
            } else if (type.equals("canMakePaymentsWithGooglePay")) {
                isReadyToPlayWithGooglePlay();
            } else if (type.equals("canMakePaymentsWithVenmo")) {
                isVenmoEnabled();
            } else if (type.equals("requestVenmoNonce")) {
                requestVenmoNonce();
            } else if(type.equals("requestGooglePayPayment")) {
                requestGooglePayPayment();
            }  else {
                throw new Exception("Invalid request type: " + type);
            }
        } catch (Exception e) {
            Intent result = new Intent();
            result.putExtra("error", e);
            setResult(2, result);
            finish();
        }
    }

    protected void requestGooglePayPayment() {
        Intent intent = getIntent();

        GooglePaymentRequest googlePaymentRequest = new GooglePaymentRequest()
                .transactionInfo(TransactionInfo.newBuilder()
                        .setTotalPrice(intent.getStringExtra("totalPrice"))
                        .setCurrencyCode(intent.getStringExtra("currencyCode"))
                        .setTotalPriceStatus(WalletConstants.TOTAL_PRICE_STATUS_FINAL)
                        .build())
                .billingAddressRequired(intent.getBooleanExtra("billingAddressRequired", false));

        if (intent.getStringExtra("googleMerchantID") != null) {
            googlePaymentRequest = googlePaymentRequest.googleMerchantId(intent.getStringExtra("googleMerchantID"));
        }

        GooglePayment.requestPayment(braintreeFragment, googlePaymentRequest);
    }

    protected void isReadyToPlayWithGooglePlay() {
        GooglePayment.isReadyToPay(braintreeFragment, new BraintreeResponseListener<Boolean>() {
            @Override
            public void onResponse(Boolean isReadyToPay) {
                HashMap<String, Object> responseMap = new HashMap<String, Object>();
                responseMap.put("canMakePayments", isReadyToPay);

                Intent result = new Intent();
                result.putExtra("type", "canMakePaymentsResponse");
                result.putExtra("canMakePayments", responseMap);

                setResult(RESULT_OK, result);
                finish();

            }
        });
    }

    protected void requestVenmoNonce() {
        Venmo.authorizeAccount(braintreeFragment, true);
    }

    protected void isVenmoEnabled() {
        boolean venmoEnabled = Venmo.isVenmoInstalled(getApplicationContext());

        HashMap<String, Object> responseMap = new HashMap<String, Object>();
        responseMap.put("canMakePayments", venmoEnabled);

        Intent result = new Intent();
        result.putExtra("type", "canMakePaymentsResponse");
        result.putExtra("canMakePayments", responseMap);

        setResult(RESULT_OK, result);
        finish();
    }

    protected void requestDeviceData() {
        DataCollector.collectDeviceData(braintreeFragment, this);
    }

    protected void requestPayPalDeviceData() {
        DataCollector.collectPayPalDeviceData(braintreeFragment, this);
    }

    protected void threeDSecureRequest() {
        Intent intent = getIntent();

        ThreeDSecureRequest threeDSecureRequest = new ThreeDSecureRequest()
                .amount(intent.getStringExtra("amount"))
                .email(intent.getStringExtra("email"))
                .nonce(intent.getStringExtra("nonce"))
                .versionRequested(ThreeDSecureRequest.VERSION_2);

        HashMap<String, String> addressInfo = (HashMap<String, String>) intent.getSerializableExtra("address");

        if (addressInfo != null) {
            ThreeDSecurePostalAddress address = new ThreeDSecurePostalAddress()
                    .givenName(addressInfo.get("givenName")) // ASCII-printable characters required, else will throw a validation error
                    .surname(addressInfo.get("surname")) // ASCII-printable characters required, else will throw a validation error
                    .phoneNumber(addressInfo.get("phoneNumber"))
                    .streetAddress(addressInfo.get("streetAddress"))
                    .extendedAddress(addressInfo.get("extendedAddress"))
                    .locality(addressInfo.get("locality"))
                    .region(addressInfo.get("region"))
                    .postalCode(addressInfo.get("postalCode"))
                    .countryCodeAlpha2(addressInfo.get("countryCodeAlpha"));

            // For best results, provide as many additional elements as possible.
            ThreeDSecureAdditionalInformation additionalInformation = new ThreeDSecureAdditionalInformation()
                    .shippingAddress(address);

            threeDSecureRequest = threeDSecureRequest
                    .billingAddress(address)
                    .additionalInformation(additionalInformation);
        }

        ThreeDSecure.performVerification(braintreeFragment, threeDSecureRequest);
    }

    protected void tokenizeCreditCard() {
        Intent intent = getIntent();
        CardBuilder builder = new CardBuilder()
                .cardNumber(intent.getStringExtra("cardNumber"))
                .expirationMonth(intent.getStringExtra("expirationMonth"))
                .expirationYear(intent.getStringExtra("expirationYear"))
                .validate(intent.getBooleanExtra("shouldValidate", false));

        if (intent.getStringExtra("cvv") != null) {
            builder = builder.cvv(intent.getStringExtra("cvv"));
        }

        Card.tokenize(braintreeFragment, builder);
    }

    protected void requestPaypalNonce() {
        Intent intent = getIntent();
        PayPalRequest request = new PayPalRequest(intent.getStringExtra("amount"))
                .currencyCode(intent.getStringExtra("currencyCode"))
                .displayName(intent.getStringExtra("displayName"))
                .billingAgreementDescription(intent.getStringExtra("billingAgreementDescription"))
                .intent(PayPalRequest.INTENT_AUTHORIZE);

        if (intent.getStringExtra("amount") == null) {
            // Vault flow
            PayPal.requestBillingAgreement(braintreeFragment, request);
        } else {
            // Checkout flow
            PayPal.requestOneTimePayment(braintreeFragment, request);
        }
    }

    @Override
    public void onPaymentMethodNonceCreated(PaymentMethodNonce paymentMethodNonce) {
        HashMap<String, Object> nonceMap = new HashMap<String, Object>();
        nonceMap.put("nonce", paymentMethodNonce.getNonce());
        nonceMap.put("typeLabel", paymentMethodNonce.getTypeLabel());
        nonceMap.put("description", paymentMethodNonce.getDescription());
        nonceMap.put("isDefault", paymentMethodNonce.isDefault());
        
        Intent result = new Intent();
        result.putExtra("type", "paymentMethodNonce");
        result.putExtra("paymentMethodNonce", nonceMap);
        setResult(RESULT_OK, result);
        finish();
    }

    @Override
    public void onCancel(int requestCode) {
        setResult(RESULT_CANCELED);
        finish();
    }

    @Override
    public void onError(Exception error) {
        Intent result = new Intent();
        result.putExtra("error", error);
        setResult(2, result);
        finish();
    }

    @Override
    public void onResponse(String deviceData) {
        HashMap<String, Object> responseMap = new HashMap<String, Object>();
        responseMap.put("deviceData", deviceData);

        Intent result = new Intent();
        result.putExtra("type", "deviceDataResponse");
        result.putExtra("deviceData", responseMap);

        setResult(RESULT_OK, result);
        finish();
    }
}
