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
| `sessionToken` | `String?` | — | Provide for saved-card flow only |

### `CorvusFrameStyle`

| Parameter | Type | Example |
|---|---|---|
| `backgroundColor` | `String` (hex) | `"#ffffff"` |
| `fontFamily` | `String` (CSS) | `"Arial"` |
| `fontSize` | `Int` | `15` |
| `fontColor` | `String` (hex) | `"#000000"` |

### `CorvusFrameOption`

| Parameter | Type | Description |
|---|---|---|
| `showCvv` | `Bool` | Show CVV input field |
| `hideCorvusPayLogo` | `Bool` | Hide CorvusPay branding |
| `locale` | `String` | Language: `"en"`, `"hr"`, `"rs"`, `"ba"`, `"sq"` |

**iOS:**
```swift
let config = CorvusFrameConfiguration(
    publicKey: "PK_test_...",
    style: CorvusFrameStyle(
        backgroundColor: "#ffffff",
        fontFamily: "Arial",
        fontSize: 15,
        fontColor: "#000000"
    ),
    option: CorvusFrameOption(
        showCvv: true,
        hideCorvusPayLogo: false,
        locale: "en"
    )
)
```

**Android:**
```kotlin
val config = CorvusFrameConfiguration(
    publicKey = "PK_test_...",
    style = CorvusFrameStyle(
        backgroundColor = "#ffffff",
        fontFamily = "Arial",
        fontSize = 15,
        fontColor = "#000000"
    ),
    option = CorvusFrameOption(
        showCvv = true,
        hideCorvusPayLogo = false,
        locale = "en"
    )
)
```

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

1. Collect cardholder billing details in the host app
2. POST to your backend → `initPayment` → receive `paymentId`
3. Wait for `onCardReady(true)` — card fields are valid
4. Call `finishPayment(paymentId)`
5. Handle `onCardPaymentResult` — on success, POST result to your backend → `checkPaymentResponse`
6. Backend returns the CorvusPay token

**iOS:**
```swift
// Step 4
Task { await corvusFrameView.finishPayment(paymentId: paymentId) }

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

**Android:**
```kotlin
// Step 4
corvusFrameView.finishPayment(paymentId)

// Step 5
override fun onCardPaymentResult(result: CardPaymentResult) {
    if (result.status.lowercase() == "ok") {
        lifecycleScope.launch { backend.checkPaymentResponse(result) }
    }
}
```

---

## Saved card (session token) flow

1. Have a `tokenValue` + `userCardProfilesId` from a previous payment
2. POST to your backend → `fetchSessionToken(tokenValue, userCardProfilesId)` → receive `sessionToken`
3. Pass `sessionToken` in `CorvusFrameConfiguration`
4. Continue from step 2 of the direct checkout flow

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
| Installments | `onInstallmentsCalculated(config: String)` | `onInstallmentsCalculated(String)` | Installment options computed (JSON) |
| Discount | `onCanDiscountedAmountBeUsed(canUse: Bool)` | `onCanDiscountedAmountBeUsed(Boolean)` | Discount eligibility result |
| Card info | `onCardInfo(cardInfo: String)` | `onCardInfo(String)` | Detected card type / BIN info (JSON) |
| **Result** | `onCardPaymentResult(result: CardPaymentResult)` | `onCardPaymentResult(CardPaymentResult)` | Payment complete |

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
