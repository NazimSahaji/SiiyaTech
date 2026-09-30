class AppStrings {
  final bool isBn;

  const AppStrings({this.isBn = false});

  // App & Navigation
  String get appTitle => isBn ? 'কেক বেক খরচ ক্যালকুলেটর' : 'Cake Bake Cost Calculator';
  String get tabCalculator => isBn ? 'ক্যালকুলেটর' : 'Calculator';
  String get tabPantry => isBn ? 'উপকরণ তালিকা' : 'Pantry';
  String get tabHistory => isBn ? 'অর্ডারের ইতিহাস' : 'Order History';

  // Language switch
  String get langCode => isBn ? 'বাং' : 'EN';
  String get switchLangTooltip => isBn ? 'Switch to English' : 'বাংলায় পরিবর্তন করুন';

  // Common actions
  String get save => isBn ? 'সংরক্ষণ' : 'Save';
  String get cancel => isBn ? 'বাতিল' : 'Cancel';
  String get delete => isBn ? 'মুছুন' : 'Delete';
  String get edit => isBn ? 'সম্পাদনা' : 'Edit';
  String get add => isBn ? 'যোগ করুন' : 'Add';
  String get close => isBn ? 'বন্ধ করুন' : 'Close';
  String get search => isBn ? 'অনুসন্ধান' : 'Search';
  String get reset => isBn ? 'রিসেট' : 'Reset';
  String get confirm => isBn ? 'নিশ্চিত করুন' : 'Confirm';
  String get back => isBn ? 'পেছনে' : 'Back';
  String get cost => isBn ? 'খরচ' : 'Cost';

  // Currency
  String get currency => '₹';
  String formatCurrency(num amount) {
    return '$currency${amount.toStringAsFixed(2)}';
  }

  // Order Details
  String get orderDetails => isBn ? 'অর্ডারের বিস্তারিত বিবরণ' : 'Order Details';
  String get customerName => isBn ? 'গ্রাহকের নাম' : 'Customer Name';
  String get enterCustomerName => isBn ? 'গ্রাহকের নাম লিখুন' : 'Enter customer name';
  String get cakeName => isBn ? 'কেকের নাম / ধরন' : 'Cake Name / Type';
  String get enterCakeName => isBn ? 'উদা: চকলেট ট্রাফেল ১ কেজি' : 'e.g., Chocolate Truffle 1kg';
  String get orderDate => isBn ? 'অর্ডারের তারিখ' : 'Order Date';
  String get notes => isBn ? 'বিশেষ নোট (ঐচ্ছিক)' : 'Special Notes (Optional)';
  String get enterNotes => isBn ? 'অতিরিক্ত কোনো নির্দেশনা থাকলে লিখুন' : 'Any special instructions or details';

  // Ingredients (Pantry)
  String get pantryTitle => isBn ? 'উপকরণ ভাঁড়ার (Pantry)' : 'Ingredients Pantry';
  String get addIngredient => isBn ? 'নতুন উপকরণ যোগ করুন' : 'Add New Ingredient';
  String get addIngredientTitle => isBn ? 'নতুন উপকরণ যোগ করুন' : 'Add New Ingredient';
  String get editIngredient => isBn ? 'উপকরণ সম্পাদন করুন' : 'Edit Ingredient';
  String get editIngredientTitle => isBn ? 'উপকরণ সম্পাদন করুন' : 'Edit Ingredient';
  String get ingredientName => isBn ? 'উপকরণের নাম' : 'Ingredient Name';
  String get enterIngredientName => isBn ? 'উদা: ময়দা, চিনি, মাখন' : 'e.g., Flour, Sugar, Butter';
  String get purchasePrice => isBn ? 'ক্রয় মূল্য ($currency)' : 'Purchase Price ($currency)';
  String get purchaseQuantity => isBn ? 'ক্রয় পরিমাণ' : 'Purchase Quantity';
  String get unit => isBn ? 'একক (Unit)' : 'Unit';
  String get ratePerUnit => isBn ? 'একক প্রতি দর' : 'Rate per unit';
  String get noIngredientsYet => isBn ? 'কোনো উপকরণ পাওয়া যায়নি' : 'No ingredients in pantry yet';
  String get addFirstIngredientMsg => isBn
      ? 'দ্রুত খরচ বের করতে আপনার প্রথম উপকরণটি যোগ করুন।'
      : 'Add your pantry items to easily calculate cake recipe costs.';
  String get deleteIngredientConfirm => isBn
      ? 'আপনি কি নিশ্চিত যে এই উপকরণটি মুছে ফেলতে চান?'
      : 'Are you sure you want to delete this ingredient?';

  // Recipe Builder
  String get recipeIngredients => isBn ? 'রেসিপির উপকরণসমূহ' : 'Recipe Ingredients';
  String get addIngredientToCake => isBn ? 'উপকরণ যুক্ত করুন' : 'Add Ingredient to Cake';
  String get selectIngredient => isBn ? 'উপকরণ নির্বাচন করুন' : 'Select an ingredient';
  String get usedAmount => isBn ? 'ব্যবহারের পরিমাণ' : 'Used Amount';
  String get noIngredientsInCake => isBn ? 'এখনও কোনো উপকরণ যোগ করা হয়নি' : 'No ingredients added to this cake yet';
  String get rawMaterialCost => isBn ? 'কাঁচামাল খরচ' : 'Raw Material Cost';

  // Baking & Electricity
  String get utilitySection => isBn ? 'ওভেন ও বিদ্যুৎ খরচ' : 'Baking & Electricity Utility';
  String get ovenWattage => isBn ? 'ওভেন ওয়াট (Watt)' : 'Oven Wattage (Watts)';
  String get bakingTemp => isBn ? 'বেকিং তাপমাত্রা (°C)' : 'Baking Temp (°C)';
  String get bakingTime => isBn ? 'বেকিং সময় (মিনিট)' : 'Baking Time (Minutes)';
  String get electricityRate => isBn ? 'বিদ্যুৎ রেট ($currency / kWh)' : 'Electricity Rate ($currency / kWh)';
  String get electricityCost => isBn ? 'বিদ্যুৎ খরচ' : 'Electricity Cost';
  String get kwhUsed => isBn ? 'ব্যবহৃত ইউনিট (kWh)' : 'Units Used (kWh)';

  // Packaging & Overhead
  String get packagingAndOverhead => isBn ? 'প্যাকেজিং ও অন্যান্য খরচ' : 'Packaging & Extra Overheads';
  String get packagingCost => isBn ? 'প্যাকেজিং খরচ (বক্স, ফিতা, বোর্ড)' : 'Packaging Cost (Box, Board, Ribbon)';
  String get overheadCost => isBn ? 'অতিরিক্ত খরচ (শ্রম, গ্যাস, ডেলিভারি)' : 'Extra Overhead (Labor, Transport, etc.)';

  // Pricing & Summary
  String get costSummary => isBn ? 'খরচ ও বিক্রয় মূল্যের হিসাব' : 'Cost & Selling Price Summary';
  String get totalCost => isBn ? 'মোট খরচ' : 'Total Cost';
  String get profitMargin => isBn ? 'লাভের মার্জিন (%)' : 'Profit Margin (%)';
  String get profitAmount => isBn ? 'লাভের পরিমাণ' : 'Profit Amount';
  String get sellingPrice => isBn ? 'চূড়ান্ত বিক্রয় মূল্য' : 'Final Selling Price';
  String get saveOrder => isBn ? 'অর্ডার সংরক্ষণ করুন' : 'Save Order';
  String get orderSavedSuccess => isBn ? 'অর্ডার সফলভাবে সংরক্ষিত হয়েছে!' : 'Order saved successfully!';
  String get pleaseFillRequired => isBn ? 'অনুগ্রহ করে গ্রাহক ও কেকের নাম লিখুন' : 'Please enter customer and cake name';
  String get addAtLeastOneIngredient => isBn ? 'অন্তত একটি উপকরণ যুক্ত করুন' : 'Please add at least one ingredient';

  // Order History
  String get orderHistory => isBn ? 'অর্ডারের ইতিহাস' : 'Order History';
  String get deleteOrder => isBn ? 'অর্ডার মুছুন' : 'Delete Order';
  String get searchPlaceholder => isBn ? 'গ্রাহক বা কেকের নাম দিয়ে খুঁজুন...' : 'Search by customer or cake name...';
  String get noOrdersFound => isBn ? 'কোনো অর্ডার পাওয়া যায়নি' : 'No orders found';
  String get deleteOrderConfirm => isBn
      ? 'আপনি কি নিশ্চিত যে এই অর্ডারটি মুছে ফেলতে চান?'
      : 'Are you sure you want to delete this order?';
  String get orderDeletedSuccess => isBn ? 'অর্ডার মুছে ফেলা হয়েছে' : 'Order deleted successfully';
  String get itemsCount => isBn ? 'উপকরণের সংখ্যা' : 'Items Count';
  String get breakdown => isBn ? 'খরচের বিভাজন' : 'Cost Breakdown';
  String get bakingBreakdown => isBn ? 'বেকিং বিবরণ' : 'Baking Parameters';
}
