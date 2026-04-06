import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/supabase_service.dart';
import '../theme/level_up_theme.dart';
import '../widgets/level_up_card.dart';
import '../widgets/level_up_text_field.dart';

enum AuthScreenMode {
  signUp,
  signIn,
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    super.key,
    this.initialMode = AuthScreenMode.signUp,
  });

  final AuthScreenMode initialMode;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  late AuthScreenMode _mode;
  bool _isSubmitting = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;

  bool get _isSignUpMode => _mode == AuthScreenMode.signUp;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;

    if (SupabaseService.currentSession != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil('/app', (route) => false);
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      if (_isSignUpMode) {
        await SupabaseService.signUp(
          email: email,
          password: password,
          name: _nameController.text.trim(),
        );
      } else {
        await SupabaseService.signIn(
          email: email,
          password: password,
        );
      }

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushNamedAndRemoveUntil('/app', (route) => false);
    } on AuthException catch (error) {
      setState(() {
        _errorMessage = error.message;
      });
    } catch (error) {
      setState(() {
        _errorMessage = _friendlyErrorMessage(error);
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _setMode(AuthScreenMode mode) {
    if (_mode == mode) {
      return;
    }

    setState(() {
      _mode = mode;
      _errorMessage = null;
      _passwordController.clear();
      _confirmPasswordController.clear();
    });
  }

  String? _validateName(String? value) {
    if (!_isSignUpMode) {
      return null;
    }

    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Enter your name.';
    }

    if (trimmed.length < 2) {
      return 'Use at least 2 characters.';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Enter your email.';
    }

    if (!trimmed.contains('@') || !trimmed.contains('.')) {
      return 'Enter a valid email.';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if ((value ?? '').isEmpty) {
      return 'Enter your password.';
    }

    if ((value ?? '').length < 6) {
      return 'Use at least 6 characters.';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (!_isSignUpMode) {
      return null;
    }

    if ((value ?? '').isEmpty) {
      return 'Confirm your password.';
    }

    if (value != _passwordController.text) {
      return 'Passwords do not match.';
    }

    return null;
  }

  String _friendlyErrorMessage(Object error) {
    final message = error.toString().replaceFirst('Exception: ', '').trim();

    if (message.isEmpty) {
      return 'Something went wrong. Please try again.';
    }

    return message;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isAuthAvailable = SupabaseService.isInitialized;

    return Scaffold(
      backgroundColor: LevelUpTheme.cream,
      body: Stack(
        children: [
          Positioned(
            top: -120,
            right: -70,
            child: _BackgroundOrb(
              size: 260,
              color: LevelUpTheme.sage.withOpacity(0.12),
            ),
          ),
          Positioned(
            bottom: -110,
            left: -60,
            child: _BackgroundOrb(
              size: 240,
              color: LevelUpTheme.peach.withOpacity(0.15),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),
                      _buildHero(),
                      const SizedBox(height: 22),
                      LevelUpCard(
                        padding: const EdgeInsets.all(26),
                        radius: 30,
                        boxShadow: LevelUpTheme.elevatedShadow,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildModeToggle(),
                              const SizedBox(height: 24),
                              Text(
                                _isSignUpMode ? 'Create account' : 'Welcome back',
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: LevelUpTheme.charcoal,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _isSignUpMode
                                    ? 'Use your name, email, and password to get started.'
                                    : 'Use your email and password to continue.',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: LevelUpTheme.mutedForeground,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 20),
                              if (_isSignUpMode) ...[
                                LevelUpTextField(
                                  controller: _nameController,
                                  label: 'Name',
                                  hintText: 'Your name',
                                  icon: Icons.person_outline_rounded,
                                  enabled: !_isSubmitting && isAuthAvailable,
                                  validator: _validateName,
                                  textInputAction: TextInputAction.next,
                                  textCapitalization: TextCapitalization.words,
                                ),
                                const SizedBox(height: 16),
                              ],
                              LevelUpTextField(
                                controller: _emailController,
                                label: 'Email',
                                hintText: 'your@email.com',
                                icon: Icons.mail_outline_rounded,
                                enabled: !_isSubmitting && isAuthAvailable,
                                validator: _validateEmail,
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: const [AutofillHints.email],
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: 16),
                              LevelUpTextField(
                                controller: _passwordController,
                                label: 'Password',
                                hintText: '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022',
                                icon: Icons.lock_outline_rounded,
                                enabled: !_isSubmitting && isAuthAvailable,
                                validator: _validatePassword,
                                obscureText: _obscurePassword,
                                autofillHints: const [AutofillHints.password],
                                textInputAction: _isSignUpMode
                                    ? TextInputAction.next
                                    : TextInputAction.done,
                                onFieldSubmitted: (_) {
                                  if (!_isSignUpMode) {
                                    _submit();
                                  }
                                },
                                suffixIcon: IconButton(
                                  onPressed: _isSubmitting
                                      ? null
                                      : () {
                                          setState(() {
                                            _obscurePassword = !_obscurePassword;
                                          });
                                        },
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                ),
                              ),
                              if (_isSignUpMode) ...[
                                const SizedBox(height: 16),
                                LevelUpTextField(
                                  controller: _confirmPasswordController,
                                  label: 'Confirm password',
                                  hintText: '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022',
                                  icon: Icons.verified_user_outlined,
                                  enabled: !_isSubmitting && isAuthAvailable,
                                  validator: _validateConfirmPassword,
                                  obscureText: _obscureConfirmPassword,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) => _submit(),
                                  suffixIcon: IconButton(
                                    onPressed: _isSubmitting
                                        ? null
                                        : () {
                                            setState(() {
                                              _obscureConfirmPassword =
                                                  !_obscureConfirmPassword;
                                            });
                                          },
                                    icon: Icon(
                                      _obscureConfirmPassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                    ),
                                  ),
                                ),
                              ],
                              if (!isAuthAvailable) ...[
                                const SizedBox(height: 16),
                                _NoticeCard(
                                  backgroundColor:
                                      LevelUpTheme.gold.withOpacity(0.12),
                                  foregroundColor: const Color(0xFF8A5A12),
                                  text:
                                      'Account login is not available right now. Check your Supabase setup and try again.',
                                ),
                              ],
                              if (_errorMessage != null) ...[
                                const SizedBox(height: 16),
                                _NoticeCard(
                                  backgroundColor:
                                      colorScheme.errorContainer.withOpacity(0.72),
                                  foregroundColor: colorScheme.onErrorContainer,
                                  text: _errorMessage!,
                                ),
                              ],
                              const SizedBox(height: 22),
                              FilledButton(
                                onPressed:
                                    _isSubmitting || !isAuthAvailable ? null : _submit,
                                child: _isSubmitting
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        _isSignUpMode
                                            ? 'Create Account'
                                            : 'Sign In',
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Simple email access for the early build. More sign-in options can come later.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: LevelUpTheme.mutedForeground,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Column(
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            gradient: LevelUpTheme.authHeroGradient,
            borderRadius: BorderRadius.circular(30),
            boxShadow: LevelUpTheme.elevatedShadow,
          ),
          child: const Center(
            child: Icon(
              Icons.auto_awesome_rounded,
              size: 40,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Level Up',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: LevelUpTheme.charcoal,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Build habits, earn rewards, grow daily.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: LevelUpTheme.mutedForeground,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildModeToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: LevelUpTheme.muted,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ModeButton(
              label: 'Log In',
              isSelected: !_isSignUpMode,
              onTap: _isSubmitting ? null : () => _setMode(AuthScreenMode.signIn),
            ),
          ),
          Expanded(
            child: _ModeButton(
              label: 'Sign Up',
              isSelected: _isSignUpMode,
              onTap: _isSubmitting ? null : () => _setMode(AuthScreenMode.signUp),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            boxShadow: isSelected ? LevelUpTheme.cardShadow : const [],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isSelected
                  ? LevelUpTheme.charcoal
                  : LevelUpTheme.mutedForeground,
            ),
          ),
        ),
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.text,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: foregroundColor,
          fontSize: 13,
          height: 1.5,
        ),
      ),
    );
  }
}

class _BackgroundOrb extends StatelessWidget {
  const _BackgroundOrb({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
