<p align="center">
<img  src="https://www.corvuspay.com/wp-content/uploads/2019/10/CorvusPay-all-color@2x.png" alt="" /> 
</p>

# **Content**
- [Installation](#**installation**)
- [Usage](#**usage**)
     - [Intro](#intro)
     - [Checkout](#checkout)
     - [Installments](#installments)
     - [Callback](#callback)
     - [Logging](#logging)
   
   ---

## Swift Package Manager
### Introduction
CorvusWalletSDK version 2.0.x+ supports installation via [Swift Package Manager](https://swift.org/package-manager/).

### Installation
In Xcode go to: ```File -> Swift Packages -> Add Package Dependency...```

![Step 1](https://github.com/amit-kremer93/resources/blob/main/1.png)

Enter the CorvusWalletSDK GitHub repository - ```https://github.com/corvuspay/iOS-sdk```

![Step 2](https://github.com/amit-kremer93/resources/blob/main/2.png)

Select the SDK version

![Step 3](https://github.com/amit-kremer93/resources/blob/main/3.png)

Select the CorvusWalletSDK library

![Step 4](https://github.com/amit-kremer93/resources/blob/main/4.png)

In your ```AppDelegate``` file: import AppsFlyerLib module

![Step 5](https://github.com/amit-kremer93/resources/blob/main/5.png)

Start to use CorvusWallet SDK

![Step 6](https://github.com/amit-kremer93/resources/blob/main/6.png)

# **Installation (without swift package manage)**
1. Drag **CorvusWalletSDK.xcframework** into your target `Project -> General -> Frameworks, Libraries, and Embedded Content` 

2. Open your **Info.plist**
   
a) Add **LSApplicationQueriesSchemes:corvuswallet**
           
<img src="https://lh3.googleusercontent.com/a-KnSWHOlGt4htiKjKBphnJ_ByYZ7dZmpZWhlsDnqhkgnXctXxbJJjbTRG-ELKH0kXS3y4S40frynO04dQj2EUqDvOsE5pa0CQaC4HfaCWuJQm_S6PThxc1fyBZrPbPdObAUyZC7=w800" alt="" />
            
**NOTE**: `Required if your app wants to open the CorvusWallet app` 

b) Add **callback handling**

<img src="https://lh3.googleusercontent.com/cyHiQ9Hb6bmA2ylBpx6aKp5kfpZsTv-rAiTc7U3fpGnyxqqU53oC5ut5cgS2CEk_dewXQrmN7fWn2roB7S-5BmSgyPr_nDINUknyZuO031b_koik8vJOAO4gDUCpXUSMr89GXZJ3=w800" alt="" />

# **Usage**

## Intro
**CorvusPay SDK** provides simple integration of CorvusPay services into your applications, allowing fast & secure transactions through our payment gateway.

The SDK will use the CorvusPay mobile app by default if the user has it installed. Otherwise, the web interface will be opened from within your app and handle the process from there.

With the SDK, we specify the checkout parameters which will be visible to the customer while handling their transaction on the checkout screen. 

  **e.g.** ` We can specify custom installment payment, set up a discount amount for the transaction, and much more.` 

To use the SDK, we need to initialize the checkout process and set up all the required parameters.

&nbsp;
## Checkout

### Checkout initialization
To start a checkout process, we call the SDK `checkout` method, with a Checkout object and a completion block:
```swift
CorvusWallet.checkout(with checkout: Checkout, completion: ((String?, CheckoutResult) -> Void)?)
```

&nbsp;
### Checkout object
A `Checkout` object is used to define purchase information. Here is the breakdown of the required and optional properties:

#### Required:
- **storeId**: Store ID provided by Corvus
- **orderNumber**: unique order identifier value
- **language**: Language 
- **cart**: an array of CartItem objects you want to create a checkout process for
- **currency**: Currency you want to use for the checkout process
- **amount**: total cost of the purchase
- **signature**: Requests must be signed/verified using HMAC-SHA256 where the key is a value known to the CorvusPay and the merchant. More details available in official integration manual. To create the String that needs to be signed, please use `CorvusWallet.createSignatureString(for: Checkout)`

#### Optional:
- **discountAmount**: total amount after discount
- **installments**: InstallmentsParams
- **bestBefore**: 
       - By setting it, the merchant specifies when the purchase time for the transaction expires (Int64 format)
       - Maximum time a merchant may specify is 900 seconds into the future
       - If not settled or if the value is out of the allowed range, it is set to 900 seconds
- **cardholder**: Cardholder
- **installmentsMap**: InstallmentMap
- **completion**: 
      - Completion block that gets called when checkout if finished
      - Contains order number and CheckoutResult

&nbsp;
## Installments

If you want to use custom payment options, you need to define custom behavior for the checkout process. 
There are 4 ways to initiate installment payment and you can use **only one**. 

1. **installments_map** 
2. **payment_all_dynamic**
3. **payment_all**
4. **number_of_installments**

If more than one option is used, either option with a lower priority will be ignored or the checkout process will complete with a `CheckoutResult.validationFailed` without starting the checkout process.

`Number_of_installments`, `payment_all`, and `payment_all_dynamic` are grouped in a subgroup and handled in the class `InstallmentsParams`. 

In the [`Checkout`](#checkout) object, they represent the [installments](#installments) parameter, while the installements_map represents the [installments_map](#installmentsMap) parameter.

 **NOTE:**  `Before sent to the CorvusWallet Checkout process, the installment configuration is cross-referenced with the server store configuration.` 

&nbsp;
### *Installments Map*
`InstallmentMap` has priority over the `InstallmentsParams`. If both are sent, the checkout will either fail or ignore the `InstallmentsParams`. 

To set up custom discounts, use `DiscountsBuilder`  and define the desired bargain price for each installment.
`build()` returns an array of objects of type `Discount` which contains our discount configuration.
To set up a discount configuration for each card type, use `InstallmentsMapBuilder` and define the desired card type and discounts. 
`build()` returns an object of type `InstallmentsMap` which contains our installment payment configuration for each card type.

**e.g.**  `Friday discounts for Visa and Diners` 
```swift
let fridayDiscounts = DiscountsBuilder.add(numberOfInstallments: 1, amount: 1000, discountedAmount: 950)
                                      .add(numberOfInstallments: 2, amount: 1000, discountedAmount: 950) 
                                      
let customInstallmentsMap = InstallmentsMapBuilder()
    .create(withCard: .visa, withDiscounts: fridayDiscounts)
    .create(withCard: .diners, withDiscounts: fridayDiscounts)
    .build()

return customInstallmentsMap

```
**NOTE:** `Use this for the most complex customizations of the payments configurations.`

&nbsp;
### *Payment All Dynamic*
  **Dynamic** number of installments for different card types
  `InstallmentsParams.createWithDynamicPayment(_ paymentAllDynamic: DynamicInstallmentsParams)`

  **DynamicInstallmentsParams**: 
  parameter which specifies flexible installment payment for each card type
       
To set up dynamic payments for each card type, use `DynamicInstallmentsBuilder` and define the desired card type properties. 
`build()` returns an object of type `DynamicInstallmentsParams` which we send as our payment_all_dynamic parameter.

**e.g.**  `Visa `
```swift
let dynamicInstallments = DynamicInstallmentsBuilder
    .setupVisaDynamic(oneTime: true, lowerBound: 2, upperBound: 99)
    .build()

let installments = InstallmentsParams.createWithDynamicPayment(dynamicInstallments) 
```

&nbsp;
### *Payment All*
**Flexible** installments for all card types
`InstallmentsParams.createWithPaymentAll(oneTimePayment: Bool, lowerBound: Int, upperBound: Int)`

- **oneTimePayment**: one time payment is enabled
- **lowerBound**: min number of installments
- **upperBound**: max number of installments
    
**e.g.** 
```swift
  let installments = InstallmentsParams.createWithPaymentAll(oneTimePayment: true, lowerBound: 2, upperBound: 99)
```
  &nbsp;
### *Number Of Installments*
**Fixed** predefined number of installments to be used for this checkout process
`InstallmentsParams.createWithFixedNumberOfInstallments(_ numberOfInstallments: Int)`:
- **numberOfInstallments**: number of installments your transaction will be handled with
     
**e.g.** 
```swift
let installments = InstallmentsParams.createWithFixedNumberOfInstallments(2)
```

&nbsp;
## Callback

In the AppDelegate add:
```swift
func application(_ app: UIApplication, open url: URL, 
                 options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    return CorvusWallet.handleWalletAppCallback(url: url)     
}
```
&nbsp;
## Logging
Set `CorvusWallet.logLevel`, preferably in `AppDelegate didFinishLaunchingWithOptions`

&nbsp;
## Environment
Set `CorvusWallet.environment`, preferably in `AppDelegate didFinishLaunchingWithOptions`
