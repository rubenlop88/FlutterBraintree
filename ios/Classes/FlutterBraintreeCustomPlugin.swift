import Flutter
import UIKit
import Braintree
import BraintreeDropIn

public class FlutterBraintreeCustomPlugin: BaseFlutterBraintreePlugin, FlutterPlugin, BTViewControllerPresentingDelegate, BTThreeDSecureRequestDelegate {
    var applePayClient: BTApplePayClient?
    var applePayFlutterResult: FlutterResult? // solo para apple pay
    var finishedApplePayWithResult: Bool = false
    
    static let supportedNetworks: [PKPaymentNetwork] = {
        var networks: [PKPaymentNetwork] = [.visa, .masterCard, .amex, .discover]
        
        if #available(iOS 10.1, *) {
            networks.append(.JCB)
        }
        
        return networks
    }()
    
    enum CallMethod: String {
        case requestPayPalDeviceData
        case requestDeviceData
        case threeDSecure
        case tokenizeCreditCard
        case requestPaypalNonce
        case canMakePaymentsWithApplePay
        case requestApplePayPayment
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_braintree.custom", binaryMessenger: registrar.messenger())
        
        let instance = FlutterBraintreeCustomPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard !isHandlingResult else {
            returnAlreadyOpenError(result: result)
            return
        }
        
        isHandlingResult = true
        
        if callRequiresBraintreeAuthorization(call: call) {
            handleAuthorizedCall(call, result: result)
        } else {
            handleUnauthorizedCall(call, result: result)
        }
    }
    
    private func handleUnauthorizedCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == CallMethod.canMakePaymentsWithApplePay.rawValue {
            
            let canMakePayments = PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: FlutterBraintreeCustomPlugin.supportedNetworks)
            handleCanMakePaymentsResult(canMakePayments: canMakePayments, error: nil, flutterResult: result)
            isHandlingResult = false
        } else {
            result(FlutterMethodNotImplemented)
            self.isHandlingResult = false
        }
    }
    
    private func handleAuthorizedCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let authorization = getAuthorization(call: call) else {
            returnAuthorizationMissingError(result: result)
            isHandlingResult = false
            return
        }
        
        let client = BTAPIClient(authorization: authorization)
        
        if call.method == CallMethod.requestPaypalNonce.rawValue {
            let driver = BTPayPalDriver(apiClient: client!)
            driver.viewControllerPresentingDelegate = self
            
            guard let requestInfo = dict(for: "request", in: call) else {
                isHandlingResult = false
                return
            }
            
            let amount = requestInfo["amount"] as? String;
            
            if amount == nil {
                let vaultRequest = BTPayPalRequest()
                vaultRequest.billingAgreementDescription = requestInfo["billingAgreementDescription"] as? String;
                vaultRequest.displayName = requestInfo["displayName"] as? String;
                
                driver.requestBillingAgreement(vaultRequest) { (nonce, error) in
                    self.handleResult(nonce: nonce, error: error, flutterResult: result)
                    self.isHandlingResult = false
                }
            } else {
                let paypalRequest = BTPayPalRequest(amount: amount!)
                paypalRequest.currencyCode = requestInfo["currencyCode"] as? String;
                paypalRequest.displayName = requestInfo["displayName"] as? String;
                paypalRequest.billingAgreementDescription = requestInfo["billingAgreementDescription"] as? String;
                
                driver.requestOneTimePayment(paypalRequest) { (nonce, error) in
                    self.handleResult(nonce: nonce, error: error, flutterResult: result)
                    self.isHandlingResult = false
                }
            }
            
        } else if call.method == CallMethod.tokenizeCreditCard.rawValue {
            let cardClient = BTCardClient(apiClient: client!)
            
            guard let cardRequestInfo = dict(for: "request", in: call) else {return}
            
            let card = BTCard(number: (cardRequestInfo["cardNumber"] as? String)!,
                              expirationMonth: (cardRequestInfo["expirationMonth"] as? String)!,
                              expirationYear: (cardRequestInfo["expirationYear"] as? String)!,
                              cvv: (cardRequestInfo["cvv"] as? String))
            
            card.shouldValidate = (cardRequestInfo["shouldValidate"] as? Bool) ?? false
            
            cardClient.tokenizeCard(card) { (nonce, error) in
                self.handleResult(nonce: nonce, error: error, flutterResult: result)
                self.isHandlingResult = false
            }
        } else if call.method == CallMethod.threeDSecure.rawValue {
            let paymentFlowDriver = BTPaymentFlowDriver(apiClient: client!)
            paymentFlowDriver.viewControllerPresentingDelegate = self
            
            guard let requestInfo = dict(for: "request", in: call) else {
                isHandlingResult = false
                return
            }
            
            let threeDSecureRequest = BTThreeDSecureRequest()
            
            if let amount = requestInfo["amount"] as? String {
                threeDSecureRequest.amount = NSDecimalNumber(string: amount)
            }
            
            if let nonce = requestInfo["nonce"] as? String {
                threeDSecureRequest.nonce = nonce
            }
            
            if let email = requestInfo["email"] as? String {
                threeDSecureRequest.email = email
            }
            
            if let addressInfo = requestInfo["address"] as? [String: Any] {
                let address = BTThreeDSecurePostalAddress()
                address.givenName = addressInfo["givenName"] as? String// ASCII-printable characters required, else will throw a validation error
                address.surname = addressInfo["surname"] as? String // ASCII-printable characters required, else will throw a validation error
                address.phoneNumber = addressInfo["phoneNumber"] as? String
                address.streetAddress = addressInfo["streetAddress"] as? String
                address.extendedAddress = addressInfo["extendedAddress"] as? String
                address.locality = addressInfo["locality"] as? String
                address.region = addressInfo["region"] as? String
                address.postalCode = addressInfo["postalCode"] as? String
                address.countryCodeAlpha2 = addressInfo["countryCodeAlpha"] as? String
                threeDSecureRequest.billingAddress = address
                
                // Optional additional information.
                // For best results, provide as many of these elements as possible.
                let info = BTThreeDSecureAdditionalInformation()
                info.shippingAddress = address
                threeDSecureRequest.additionalInformation = info
            }
            
            threeDSecureRequest.versionRequested = .version2
            
            threeDSecureRequest.threeDSecureRequestDelegate = self
            
            paymentFlowDriver.startPaymentFlow(threeDSecureRequest) { (btResult, error) in
                self.handleResult(nonce: (btResult as? BTThreeDSecureResult)?.tokenizedCard,
                                  error: error,
                                  flutterResult: result)
                self.isHandlingResult = false
            }
            
        } else if call.method == CallMethod.requestDeviceData.rawValue {
            BTDataCollector(apiClient: client!).collectCardFraudData { deviceData in
                self.handleDeviceDataResult(deviceData: deviceData, error: nil, flutterResult: result)
                self.isHandlingResult = false
            }
        } else if call.method == CallMethod.requestPayPalDeviceData.rawValue {
            let deviceData = PPDataCollector.collectPayPalDeviceData()
            handleDeviceDataResult(deviceData: deviceData, error: nil, flutterResult: result)
            isHandlingResult = false
        } else if call.method == CallMethod.requestApplePayPayment.rawValue {
            self.applePayClient = BTApplePayClient(apiClient: client!)
            self.applePayFlutterResult = result
            self.finishedApplePayWithResult = false
            
            guard let requestInfo = dict(for: "request", in: call),
                    let amount = requestInfo["amount"] as? String,
                    let countryCode = requestInfo["countryCode"] as? String,
                    let currencyCode = requestInfo["currencyCode"] as? String,
                    let merchantIdentifier = requestInfo["appleMerchantID"] as? String,
                    let summaryItem = requestInfo["displayName"] as? String
                else {
                isHandlingResult = false
                return
            }
            
            setupApplePayRequest(amount: amount, countryCode: countryCode,
                                 currencyCode: currencyCode, merchantIdentifier: merchantIdentifier,
                                 summaryItem: summaryItem, supportedNetworks: FlutterBraintreeCustomPlugin.supportedNetworks)
            
        } else {
            result(FlutterMethodNotImplemented)
            self.isHandlingResult = false
        }
    }
    
    private func callRequiresBraintreeAuthorization(call: FlutterMethodCall) -> Bool {
        if(call.method == CallMethod.canMakePaymentsWithApplePay.rawValue) {
            return false
        }
        
        return true
    }
    
    private func handleCanMakePaymentsResult(canMakePayments: Bool, error: Error?, flutterResult: FlutterResult) {
        if error != nil {
            returnBraintreeError(result: flutterResult, error: error!)
        } else {
            flutterResult(buildCanMakePaymentsDict(canMakePayments: canMakePayments));
        }
    }
    
    private func handleDeviceDataResult(deviceData: String, error: Error?, flutterResult: FlutterResult) {
        if error != nil {
            returnBraintreeError(result: flutterResult, error: error!)
        } else {
            flutterResult(buildDeviceDataDict(deviceData: deviceData));
        }
    }
    
    private func handleResult(nonce: BTPaymentMethodNonce?, error: Error?, flutterResult: FlutterResult) {
        if error != nil {
            returnBraintreeError(result: flutterResult, error: error!)
        } else if nonce == nil {
            flutterResult(nil)
        } else {
            flutterResult(buildPaymentNonceDict(nonce: nonce));
        }
    }
    
    public func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
        UIApplication.shared.keyWindow?.rootViewController?.present(viewController, animated: true)
    }
    
    public func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    public func onLookupComplete(_ request: BTThreeDSecureRequest, result: BTThreeDSecureLookup, next: @escaping () -> Void) {
        next()
    }
}


extension FlutterBraintreeCustomPlugin: PKPaymentAuthorizationViewControllerDelegate {
    public func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
        
        if !finishedApplePayWithResult, let flutterResult = self.applePayFlutterResult {
            handleResult(nonce: nil, error: nil, flutterResult: flutterResult)
        }
        
        isHandlingResult = false
    }
    
    @available(iOS 11.0, *)
    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController,
                                            didAuthorizePayment payment: PKPayment,
                                            handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        guard let applePayClient = self.applePayClient,
              let flutterResult = self.applePayFlutterResult else {
            finishedApplePayWithResult = true
            completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
            
            return
        }
        
        applePayClient.tokenizeApplePay(payment) { (nonce, error) in
            if error != nil {
                completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                self.finishedApplePayWithResult = true
                self.handleResult(nonce: nil, error: error, flutterResult: flutterResult)
                return
            }
            
            completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
            self.finishedApplePayWithResult = true
            self.handleResult(nonce: nonce, error: nil, flutterResult: flutterResult)
        }
    }
    
    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController,
                                            didAuthorizePayment payment: PKPayment,
                                            completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        guard let applePayClient = self.applePayClient,
            let flutterResult = self.applePayFlutterResult else {
                self.finishedApplePayWithResult = true
                completion(PKPaymentAuthorizationStatus.failure)
                return
        }
        
        applePayClient.tokenizeApplePay(payment) { (nonce, error) in
            if error != nil {
                completion(PKPaymentAuthorizationStatus.failure)
                self.finishedApplePayWithResult = true
                self.handleResult(nonce: nil, error: error, flutterResult: flutterResult)
                return
            }
            
            completion(PKPaymentAuthorizationStatus.success)
            self.finishedApplePayWithResult = true
            self.handleResult(nonce: nonce, error: nil, flutterResult: flutterResult)
        }
    }
    
    func setupApplePayRequest(amount: String, countryCode: String, currencyCode: String,
                              merchantIdentifier: String, summaryItem: String, supportedNetworks: [PKPaymentNetwork]) {
        guard let applePayClient = self.applePayClient,
            let flutterResult = self.applePayFlutterResult else {
                return
        }
        
        applePayClient.paymentRequest { (paymentRequest, error) in
            guard let paymentRequest = paymentRequest else {
                // handle error
                self.handleResult(nonce: nil, error: error, flutterResult: flutterResult)
                self.isHandlingResult = false
                return
            }

            // Set other PKPaymentRequest properties here
            paymentRequest.countryCode = countryCode
            paymentRequest.currencyCode = currencyCode
            paymentRequest.merchantIdentifier = merchantIdentifier
            paymentRequest.merchantCapabilities = .capability3DS
            paymentRequest.supportedNetworks = supportedNetworks
            
            paymentRequest.paymentSummaryItems = [
                PKPaymentSummaryItem(label: summaryItem, amount: NSDecimalNumber(string: amount))
            ]
            
            if let vc = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) as PKPaymentAuthorizationViewController? {
                vc.delegate = self
                UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
            } else {
                //InstabugLog.e("Error: Payment request is invalid.")
                //self.handleResult(nonce: nil, error: Error, flutterResult: flutterResult)
                self.isHandlingResult = false
            }
        }
        
    }
}
