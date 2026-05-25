/// All user-facing strings in the app.
abstract final class AppStrings {
  static const String appName = 'eTax Revenue Tracker';
  static const String appTagline = 'Powered by Byteworks';

  // ── Auth ───────────────────────────────────────────────────
  static const String signIn = 'Sign in';
  static const String signInTitle = 'Welcome back';
  static const String signInSubtitle = 'Sign in to your eTax account';
  static const String forgotPassword = 'Forgot password?';
  static const String noAccount = "Don't have an account? ";
  static const String signUp = 'Sign up';
  static const String createAccount = 'Create account';
  static const String registerTitle = 'Create your account';
  static const String registerSubtitle = 'Join millions of Nigerian taxpayers';
  static const String alreadyHaveAccount = 'Already have an account? ';
  static const String termsText = 'I agree to the ';
  static const String termsLink = 'Terms & Privacy Policy';
  static const String forgotPasswordTitle = 'Forgot password?';
  static const String forgotPasswordSubtitle =
      'Enter your email and we\'ll send you a reset link';
  static const String sendResetLink = 'Send reset link';
  static const String checkYourEmail = 'Check your email';
  static const String resetLinkSent =
      'A password reset link has been sent to your email address';
  static const String backToLogin = 'Back to login';

  // ── Form fields ────────────────────────────────────────────
  static const String email = 'Email address';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm password';
  static const String fullName = 'Full name';
  static const String phoneNumber = 'Phone number';
  static const String stateOfResidence = 'State of residence';
  static const String selectState = 'Select your state';

  // ── Dashboard ──────────────────────────────────────────────
  static const String goodMorning = 'Good morning';
  static const String goodAfternoon = 'Good afternoon';
  static const String goodEvening = 'Good evening';
  static const String totalPaid = 'Total paid';
  static const String outstanding = 'Outstanding';
  static const String receipts = 'Receipts';
  static const String recentTransactions = 'Recent transactions';
  static const String seeAll = 'See all';
  static const String payNow = 'Pay now';
  static const String tinCopied = 'TIN copied to clipboard';
  static const String history = 'History';

  // ── Payments ───────────────────────────────────────────────
  static const String paymentHistory = 'Payment history';
  static const String searchPayments = 'Search payments...';
  static const String noSearchResults = 'No results found';
  static const String allPayments = 'All';
  static const String paidPayments = 'Paid';
  static const String pendingPayments = 'Pending';
  static const String failedPayments = 'Failed';
  static const String allPaymentsLoaded = 'All payments loaded ✓';
  static const String noPaymentsFound = 'No payments found';
  static const String paymentSuccessful = 'Payment successful';
  static const String paymentPending = 'Payment pending';
  static const String paymentFailed = 'Payment failed';
  static const String receiptNumber = 'Receipt no.';
  static const String issuingAuthority = 'Enugu State Internal Revenue Service';
  static const String shareReceipt = 'Share receipt';
  static const String date = 'Date';
  static const String levyType = 'Levy type';
  static const String description = 'Description';
  static const String taxId = 'Tax ID';
  static const String issuedBy = 'Issued by';
  static const String selectYear = 'Select year';
  static const String payTaxSubtitle = 'Pay your taxes in a few easy steps';
  static const String done = 'Done';
  // ── Pay Tax ────────────────────────────────────────────────
  static const String payTax = 'Pay tax';
  static const String selectLevyType = 'Select levy type';
  static const String assessmentYear = 'Assessment year';
  static const String amount = 'Amount (₦)';
  static const String referenceNumber = 'Reference number';
  static const String notes = 'Notes (optional)';
  static const String makePayment = 'Make payment';
  static const String paymentSubmitted = 'Payment submitted successfully';
  static const String viewReceipt = 'View receipt';
  static const String payAnother = 'Pay another';
  static const String paymentError = 'Payment failed. Please try again.';

  // ── Profile ────────────────────────────────────────────────
  static const String profile = 'Profile';
  static const String notifications = 'Notifications';
  static const String logout = 'Logout';
  static const String noNotifications = 'No notifications yet';
  static const String noNotificationsSubtitle =
      'You\'ll see your tax alerts and updates here';
  static const String logoutConfirm = 'Are you sure you want to logout?';
  static const String cancel = 'Cancel';

  // ── Errors ─────────────────────────────────────────────────
  static const String somethingWentWrong = 'Something went wrong';
  static const String noInternet = 'No internet connection';
  static const String noInternetSubtitle =
      'Check your connection and try again';
  static const String retry = 'Retry';
  static const String serverError = 'Server error. Please try again later.';
  static const String sessionExpired = 'Session expired. Please login again.';

  // ── Security ───────────────────────────────────────────────
  static const String deviceCompromised =
      'This action is not supported on your device configuration.';
  static const String biometricPrompt =
      'Authenticate to access your tax account';
  static const String biometricNotAvailable =
      'Biometric authentication is not available on this device.';

  // ── Validation ─────────────────────────────────────────────
  static const String fieldRequired = 'This field is required';
  static const String invalidEmail = 'Enter a valid email address';
  static const String invalidPhone = 'Enter a valid Nigerian phone number';
  static const String passwordTooShort =
      'Password must be at least 8 characters';
  static const String passwordNoNumber =
      'Password must contain at least one number';
  static const String passwordNoUppercase =
      'Password must contain at least one uppercase letter';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  static const String invalidAmount = 'Enter a valid amount';
  static const String amountTooLow = 'Amount must be greater than 0';
  static const String amountTooHigh = 'Amount cannot exceed ₦10,000,000';
  static const String acceptTerms = 'Please accept the terms to continue';

  // ── Offline ────────────────────────────────────────────────
  static const String offlineBanner = 'You are offline';
  static const String offlineBannerSubtitle =
      'Showing cached data. Connect to see latest updates.';
  static const String cacheExpired = 'Data may be outdated. Pull to refresh.';
}
