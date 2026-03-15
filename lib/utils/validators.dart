String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return "Email is Mandatory";
  }
  if (!value.contains('@') || !value.endsWith('.com')) {
    return "Pls enter valid email Id";
  }
  return null;
}
