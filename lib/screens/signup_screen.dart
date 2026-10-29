
import 'package:flutter/material.dart';
import 'success_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _dateController = TextEditingController();

  String? _selectedCreatureType;
  DateTime? _birthDate;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _submitting = false;

  // Activity 10: Local preset signup tips
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

  Future<void> _getSignupTip() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
      _currentTip = null;
    });

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

  // Activity 11: Birth-date picker
  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2008),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );

    if (!mounted) return;

    if (picked != null) {
      setState(() {
        _birthDate = picked;
        _dateController.text =
            '${picked.month}/${picked.day}/${picked.year}';
      });
    }
  }

  // Activity 11: Validate, load, and navigate
  Future<void> _submit() async {
    if (_submitting) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text.trim();
    final creature = _selectedCreatureType!;

    // Extra defensive checks
    if (name.isEmpty || creature == null || creature.isEmpty) {
      return;
    }
    setState(() {
      _submitting = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SuccessScreen(
          userName: name,
          creatureType: creature,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Creature Registration'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Register Your Creature',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              // Full name
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

              // Password with visibility toggle
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
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

              // Confirm password
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword =
                            !_obscureConfirmPassword;
                      });
                    },
                  ),
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

              const SizedBox(height: 16),

              // Required creature dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedCreatureType,
                decoration: const InputDecoration(
                  labelText: 'Choose Your Creature',
                  prefixIcon: Icon(Icons.pets),
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Ghost',
                    child: Text('Ghost 👻'),
                  ),
                  DropdownMenuItem(
                    value: 'Bat',
                    child: Text('Bat 🦇'),
                  ),
                  DropdownMenuItem(
                    value: 'Black Cat',
                    child: Text('Black Cat 🐈‍⬛'),
                  ),
                  DropdownMenuItem(
                    value: 'Pumpkin Spirit',
                    child: Text('Pumpkin Spirit 🎃'),
                  ),
                  DropdownMenuItem(
                    value: 'Witch',
                    child: Text('Witch 🧙'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCreatureType = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a creature';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Required birth date
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Birth Date',
                  prefixIcon: Icon(Icons.cake),
                  suffixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                onTap: _pickBirthDate,
                validator: (_) {
                  if (_birthDate == null) {
                    return 'Please select your birth date';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Register button with loading indicator
              ElevatedButton(
                onPressed: _submitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(14),
                ),
                child: _submitting
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Register Creature',
                        style: TextStyle(fontSize: 18),
                      ),
              ),

              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 12),

              // Activity 10: Signup Tip Coach
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

              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),

              if (_currentTip != null && !_isLoading)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Preset demo tip—not live AI.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(_currentTip!),
                      ],
                    ),
                  ),
                ),

              if (_hasError && !_isLoading)
                Column(
                  children: [
                    const Text(
                      'No signup tip is available. Please try again.',
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
