
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fun Signup App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: true,
      ),
      home: const SignupPage(),
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final TextEditingController _nameController =
      TextEditingController();
  final TextEditingController _emailController =
      TextEditingController();
  final TextEditingController _passwordController =
      TextEditingController();

  // Task A: Local preset signup tips
  final Map<String, List<String>> _presetTips = {
    'password_help': [
      'Use a unique password for every account.',
      'Never share your password with anyone.',
      'Enable two-factor authentication when available.',
    ],
  };

  final String _tipCategory = 'password_help';

  bool _isLoading = false;
  bool _hasError = false;
  bool _simulateMissingTips = false;

  String? _currentTip;
  int _tipIndex = 0;

  // Task A: Simulate a local signup tip
  Future<void> _getSignupTip() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _currentTip = null;
    });

    // Simulated loading; no internet or AI service
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    final tips = _simulateMissingTips
        ? <String>[]
        : (_presetTips[_tipCategory] ?? <String>[]);

    setState(() {
      _isLoading = false;

      if (tips.isEmpty) {
        _hasError = true;
      } else {
        _currentTip = tips[_tipIndex % tips.length];
        _tipIndex++;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fun Signup App'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Create Your Account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              // Full Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }

                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Password
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }

                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Task C: Confirm Password
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }

                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Task C: Personalized success
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final name = _nameController.text.trim();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Welcome, $name! '
                          'Your demo signup was successful!',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(14),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 18),
                ),
              ),

              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 12),

              // Task A: Local Signup Tip Coach
              const Text(
                'Signup Tip Coach',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text('Category: $_tipCategory'),

              const SizedBox(height: 12),

              ElevatedButton.icon(
                onPressed: _isLoading ? null : _getSignupTip,
                icon: const Icon(Icons.lightbulb_outline),
                label: const Text('Get a signup tip'),
              ),

              // Task A: Loading state
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),

              // Task A: Success state
              if (_currentTip != null && !_isLoading)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Preset demo tip—not live AI.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(_currentTip!),
                      ],
                    ),
                  ),
                ),

              // Task A: Error and retry
              if (_hasError && !_isLoading)
                Column(
                  children: [
                    const Text(
                      'No signup tip is available. '
                      'Please try again.',
                      style: TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _getSignupTip,
                      child: const Text('Retry'),
                    ),
                  ],
                ),

              const SizedBox(height: 16),

              // Task A: Test missing tip data
              SwitchListTile(
                title: const Text('Simulate missing tips'),
                subtitle: const Text(
                  'Testing only: trigger the local error case',
                ),
                value: _simulateMissingTips,
                onChanged: (value) {
                  setState(() {
                    _simulateMissingTips = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
