# CorvusFrame SDK

`CorvusFrameView` is a hosted, WebView-based card payment form embedded directly in your app. The host app loads the view with a configuration, initialises a payment server-side to obtain a `paymentId`, calls `finishPayment` when the user confirms, and receives the result via a delegate/listener callback.

Two integration flows are supported:

- **Direct checkout** — cardholder enters card details fresh
- **Saved card (session token)** — cardholder verifies a previously stored card

---

## Environment setup

Set the environment **before** calling `load`.

### iOS

```swift
// In AppDelegate or app entry point
CorvusWallet.environment = .test
// CorvusWallet.environment = .production
```

### Android

Pass the environment directly to `load`:

```kotlin
corvusFrameView.load(config, "test")
// or "production"
```

---

## Configuration

### `CorvusFrameConfiguration`

| Parameter | Type | Required | Description |
|---|---|---|---|
| `publicKey` | `String` | ✓ | Merchant public key (`PK_test_...` or `PK_live_...`) |
| `style` | `CorvusFrameStyle` | ✓ | Visual appearance |
| `option` | `CorvusFrameOption` | ✓ | Behaviour flags |
| `sessionToken` | `String?` | — | Provide for the saved-card flow only |

### `CorvusFrameStyle`

| Parameter | Type | Description |
|---|---|---|
| `backgroundColor` | `String` (hex) | Background color of the payment form. |
| `fontFamily` | `String` | Font family used by the form. |
| `fontSize` | `Int` | Font size used by the form. |
| `fontColor` | `String` (hex) | Color of labels and text. |
| `borderColor` | `String` (hex) | Border color of the form fields and container. |
| `inputFontColor` | `String` (hex) | Color of text entered into input fields. |
| `cvvCancelBtnBackgroundColor` | `String` (hex) | Background color of the CVV cancel button. |
| `cvvCancelBtnFontColor` | `String` (hex) | Text color of the CVV cancel button. |
| `cvvSuccessBtnBackgroundColor` | `String` (hex) | Background color of the CVV confirmation button. |
| `cvvSuccessBtnFontColor` | `String` (hex) | Text color of the CVV confirmation button. |
| `cvvInputBackgroundColor` | `String` (hex) | Background color of the CVV input field. |

Colors must be provided as hexadecimal values, for example `"#ffffff"`.

### `CorvusFrameOption`

| Parameter | Type | Description |
|---|---|---|
| `cvvOnly` | `Bool` | Set to `false` for the full card form. Set to `true` with `sessionToken` for saved-card CVV verification. |
| `hideCorvusPayLogo` | `Bool` | Hides CorvusPay branding when set to `true`. |
| `locale` | `String` | Language used for labels and validation messages, for example `"en"`. |
| `layout` | `String` | Form layout, for example `"default"` or `"stacked"`. |
| `showLabels` | `Bool` | Controls whether field labels are displayed. |
| `show3DSInFullScreen` | `Bool` | Displays 3D Secure in full screen when `true`. The default value is `true`. |

`showCvv` has been replaced with `cvvOnly`.

### iOS

```swift
let style = CorvusFrameStyle(
    backgroundColor: "#ffffff",
    fontFamily: "Arial",
    fontSize: 15,
    fontColor: "#000000",
    borderColor: "#cccccc",
    inputFontColor: "#000000",
    cvvCancelBtnBackgroundColor: "#ffffff",
    cvvCancelBtnFontColor: "#000000",
    cvvSuccessBtnBackgroundColor: "#000000",
    cvvSuccessBtnFontColor: "#ffffff",
    cvvInputBackgroundColor: "#ffffff"
)

let option = CorvusFrameOption(
    cvvOnly: false,
    hideCorvusPayLogo: false,
    locale: "en",
    layout: "default",
    showLabels: true,
    show3DSInFullScreen: true
)

let config = CorvusFrameConfiguration(
    publicKey: "PK_test_...",
    style: style,
    option: option,
    sessionToken: nil
)
```

On iOS, `show3DSInFullScreen` controls the 3D Secure presentation during `load(config:)`.

### Android

```kotlin
val config = CorvusFrameConfiguration(
    publicKey = "PK_test_...",
    style = CorvusFrameStyle(
        backgroundColor = "#ffffff",
        fontFamily = "Arial",
        fontSize = 15,
        fontColor = "#000000",
        borderColor = "#cccccc",
        inputFontColor = "#000000",
        cvvCancelBtnBackgroundColor = "#ffffff",
        cvvCancelBtnFontColor = "#000000",
        cvvSuccessBtnBackgroundColor = "#000000",
        cvvSuccessBtnFontColor = "#ffffff",
        cvvInputBackgroundColor = "#ffffff"
    ),
    option = CorvusFrameOption(
        cvvOnly = false,
        hideCorvusPayLogo = false,
        locale = "en",
        layout = "default",
        showLabels = true,
        show3DSInFullScreen = true
    ),
    sessionToken = null
)
```

On Android, the native 3DS presentation mode can also be selected:

```kotlin
corvusFrameView.threeDsPresentationMode =
    ThreeDsPresentationMode.FULLSCREEN
```

Available values are `ThreeDsPresentationMode.INLINE` and `ThreeDsPresentationMode.FULLSCREEN`. The default is `FULLSCREEN`.

---

## Adding CorvusFrameView to a screen

### iOS

`CorvusFrameView` manages its own height — do not add a height constraint.

```swift
let corvusFrameView = CorvusFrameView()
corvusFrameView.delegate = self
scrollView.addSubview(corvusFrameView)

// ...

corvusFrameView.load(config: config)
```

### Android

```xml
<com.corvuspay.sdk.views.CorvusFrameView
    android:id="@+id/corvusFrameView"
    android:layout_width="match_parent"
    android:layout_height="wrap_content" />
```

```kotlin
corvusFrameView.listener = this
corvusFrameView.load(config, "test")
```

---

## Direct checkout flow

1. Collect cardholder billing details in the host app.
2. POST to your backend → `initPayment` → receive `paymentId`.
3. Wait for `onCardReady(true)` — card fields are valid.
4. Call `finishPayment(paymentId)`.
5. Handle `onCardPaymentResult` — on success, POST result to your backend → `checkPaymentResponse`.
6. Backend returns the CorvusPay token.

### iOS

```swift
// Step 4
Task {
    await corvusFrameView.finishPayment(paymentId: paymentId)
}

// Step 5
func onCardPaymentResult(result: CardPaymentResult) {
    guard result.status.lowercased() == "ok" else {
        showError(result.displayMessage)
        return
    }

    Task {
        try await backend.checkPaymentResponse(result: result)
    }
}
```

### Android

```kotlin
// Step 4
corvusFrameView.finishPayment(paymentId)

// Step 5
override fun onCardPaymentResult(result: CardPaymentResult) {
    if (result.status.lowercase() == "ok") {
        lifecycleScope.launch {
            backend.checkPaymentResponse(result)
        }
    }
}
```

---

## Saved card (session token) flow

1. Have a `tokenValue` and `userCardProfilesId` from a previous payment.
2. POST to your backend → `fetchSessionToken(tokenValue, userCardProfilesId)` → receive `sessionToken`.
3. Pass `sessionToken` in `CorvusFrameConfiguration`.
4. Set `cvvOnly` to `true`.
5. Continue from step 2 of the direct checkout flow.

---

## `checkPaymentResponse` — required fields

Your backend call must include **all** of the following fields from `CardPaymentResult`:

| Field | Type | Notes |
|---|---|---|
| `paymentId` | `String` | |
| `status` | `String` | `"ok"` on success |
| `errorCode` | `String` | Empty string on success |
| `displayMessage` | `String` | |
| `signature` | `String` | |
| `approvalCode` | `String` | Required for backend signature verification |

---

## Delegate / Listener reference

All callbacks are dispatched on the main thread. All have empty default implementations.

| Callback | iOS | Android | When fired |
|---|---|---|---|
| Ready | `onReady()` | `onReady()` | Frame HTML has loaded |
| Card valid | `onCardReady(isReady: Bool)` | `onCardReady(Boolean)` | Card fields become valid (`true`) or invalid (`false`) |
| Form error | `onShowError(errorMsg: String)` | `onShowError(String)` | Form validation error shown in frame |
| Error cleared | `onClearError()` | `onClearError()` | Previous form error dismissed |
| Fatal error | `onError(errorMsg: String)` | `onError(String)` | Unrecoverable error inside the frame |
| Modal open | `onShowModal(height: Int, width: Int)` | `onShowModal(Int, Int)` | 3DS modal opening |
| Modal close | `onHideModal(height: Int, width: Int)` | `onHideModal(Int, Int)` | 3DS modal closed |
| Installments | `onInstallmentsCalculated(config: String)` | `onInstallmentsCalculated(String)` | Installment options computed as JSON |
| Discount | `onCanDiscountedAmountBeUsed(canUse: Bool)` | `onCanDiscountedAmountBeUsed(Boolean)` | Discount eligibility result |
| Card info | `onCardInfo(cardInfo: String)` | `onCardInfo(String)` | Detected card type or BIN information |
| Result | `onCardPaymentResult(result: CardPaymentResult)` | `onCardPaymentResult(CardPaymentResult)` | Payment complete |

---

## `CardPaymentResult` reference

| Property | Type | Description |
|---|---|---|
| `paymentId` | `String` | Matches the ID passed to `finishPayment` |
| `status` | `String` | `"ok"` on success |
| `errorCode` | `String` | Empty on success |
| `displayMessage` | `String` | User-facing message from the payment processor |
| `signature` | `String` | Backend signature for verification |
| `approvalCode` | `String` | Must be forwarded to `checkPaymentResponse` |