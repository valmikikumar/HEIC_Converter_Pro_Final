import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../services/local_storage_service.dart';
import '../../services/purchase_service.dart';
import '../conversion/conversion_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isPro = false;
  int _conversionCount = 0;
  int _remainingConversions = 50;
  bool _isLoading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final isPro = await LocalStorageService.isPro();
    final count = await LocalStorageService.getConversionCount();
    final remaining = await LocalStorageService.getRemainingConversions();

    setState(() {
      _isPro = isPro;
      _conversionCount = count;
      _remainingConversions = remaining;
      _isLoading = false;
    });
  }

  Future<void> _pickFiles() async {
    try {
      final canConvert = await LocalStorageService.canConvert();
      if (!canConvert) {
        _showUpgradeDialog();
        return;
      }

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['heic', 'heif'],
        allowMultiple: true,
      );

      if (result == null || result.files.isEmpty) return;

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConversionScreen(selectedFiles: result.files),
        ),
      ).then((_) => _loadData());
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking files: $e')),
      );
    }
  }

  void _showUpgradeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upgrade to Pro'),
        content: const Text(
          'You have reached your free conversion limit (50). Upgrade to Pro for unlimited conversions!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _selectedIndex = 1);
            },
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('HEIC Converter Pro'),
        actions: [
          if (_isPro)
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'PRO',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: _selectedIndex == 0
            ? _buildHomeTab()
            : _selectedIndex == 1
                ? _buildProTab()
                : const SettingsScreen(),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.star),
            label: 'Pro',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    Icons.image,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Convert HEIC Files',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Convert HEIC/HEIF images to JPG, PNG, or PDF',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _pickFiles,
                    icon: const Icon(Icons.file_upload),
                    label: const Text('Select Files'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Usage',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Conversions Used'),
                      Text(
                        _isPro ? 'Unlimited' : '$_conversionCount / 50',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  if (!_isPro) ...[
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: _conversionCount / 50,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$_remainingConversions conversions remaining',
                      style: TextStyle(
                        color: _remainingConversions < 10
                            ? Colors.red
                            : Colors.grey,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildFeaturesList(),
        ],
      ),
    );
  }

  Widget _buildFeaturesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Features',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        _buildFeatureCard(
          Icons.high_quality,
          'High Quality',
          'Maintain original image quality',
        ),
        _buildFeatureCard(
          Icons.speed,
          'Fast Conversion',
          'Quick batch processing',
        ),
        _buildFeatureCard(
          Icons.offline_bolt,
          'Works Offline',
          'No internet required',
        ),
        _buildFeatureCard(
          Icons.shield,
          'Private',
          'All processing done locally',
        ),
      ],
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
      ),
    );
  }

  Widget _buildProTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          if (!_isPro) ...[
            Card(
              color: Colors.amber.shade50,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 64,
                      color: Colors.amber,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Upgrade to Pro',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Get unlimited conversions and remove ads',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    _buildPricingOption(
                      'Monthly',
                      '\$4.99',
                      'per month',
                      PurchaseService.proMonthlyId,
                    ),
                    const SizedBox(height: 12),
                    _buildPricingOption(
                      'Yearly',
                      '\$39.99',
                      'per year (Save 33%)',
                      PurchaseService.proYearlyId,
                      isPopular: true,
                    ),
                    const SizedBox(height: 12),
                    _buildPricingOption(
                      'Lifetime',
                      '\$99.99',
                      'one-time payment',
                      PurchaseService.proLifetimeId,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _loadProducts,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 16,
                        ),
                      ),
                      child: const Text('View Purchase Options'),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _restorePurchases,
                      child: const Text('Restore Purchases'),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 64,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'You\'re Pro!',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Enjoy unlimited conversions',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pro Features',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildProFeature('Unlimited conversions'),
                  _buildProFeature('No ads'),
                  _buildProFeature('All output formats'),
                  _buildProFeature('Batch processing'),
                  _buildProFeature('Priority support'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProFeature(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildPricingOption(
    String title,
    String price,
    String subtitle,
    String productId, {
    bool isPopular = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isPopular ? Colors.amber : Colors.grey.shade300,
          width: isPopular ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: Text(
          price,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> _loadProducts() async {
    try {
      final products = await PurchaseService.loadProducts();
      if (products.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('In-app purchases not available on this device'),
          ),
        );
        return;
      }

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Choose Plan'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: products
                  .map((product) => ListTile(
                        title: Text(product.title),
                        subtitle: Text(product.description),
                        trailing: Text(product.price),
                        onTap: () {
                          Navigator.pop(context);
                          _purchaseProduct(product);
                        },
                      ))
                  .toList(),
            ),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading products: $e')),
      );
    }
  }

  Future<void> _purchaseProduct(product) async {
    final success = await PurchaseService.purchaseProduct(product);
    if (success) {
      await _loadData();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Purchase successful!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _restorePurchases() async {
    try {
      await PurchaseService.restorePurchases();
      await _loadData();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Purchases restored'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Restore failed: $e')),
      );
    }
  }
}
