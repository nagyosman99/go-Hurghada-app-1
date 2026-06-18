import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_hurghada/config/theme/app_theme.dart';
import 'package:go_hurghada/l10n/arb/app_localizations.dart';
import 'package:go_hurghada/core/providers/app_provider.dart';
import 'package:go_hurghada/features/auth/presentation/viewmodels/profile_viewmodel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_hurghada/shared/widgets/app_network_image.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late ProfileViewModel _profileViewModel;
  String? _profileImagePath;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _profileViewModel = AppProvider.of(context).profileViewModel;
    final userProfile = _profileViewModel.state;
    _firstNameController = TextEditingController(text: userProfile.firstName);
    _lastNameController = TextEditingController(text: userProfile.lastName);
    _emailController = TextEditingController(text: userProfile.email);
    _profileImagePath ??= userProfile.profileImagePath;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );

    if (image != null) {
      setState(() {
        _profileImagePath = image.path;
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      _profileViewModel.updateProfile(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        profileImagePath: _profileImagePath,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myAccount),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                l10n.accountSettings,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Hero(
                          tag: 'profile_image',
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: const BoxDecoration(
                              color: AppColors.lightGrey,
                              shape: BoxShape.circle,
                            ),
                            child: _profileImagePath != null
                                ? ClipOval(
                                    child: _profileImagePath!.startsWith('http')
                                        ? AppNetworkImage(
                                            imageUrl: _profileImagePath!,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.file(
                                            File(_profileImagePath!),
                                            fit: BoxFit.cover,
                                          ),
                                  )
                                : const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: AppColors.textSecondary,
                                  ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 16,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Edit picture',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Form Fields
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(l10n.firstName, style: theme.textTheme.bodyMedium),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  hintText: '${l10n.firstName}...',
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusSmall,
                    ),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? '${l10n.firstName} is required'
                    : null,
              ),
              const SizedBox(height: 16),

              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(l10n.lastName, style: theme.textTheme.bodyMedium),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  hintText: '${l10n.lastName}...',
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusSmall,
                    ),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? '${l10n.lastName} is required'
                    : null,
              ),
              const SizedBox(height: 16),

              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  l10n.emailAddress,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: '${l10n.emailAddress}...',
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusSmall,
                    ),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '${l10n.emailAddress} is required';
                  }
                  if (!value.contains('@')) {
                    return 'Invalid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 48),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  child: Text(
                    AppLocalizations.of(context)?.saveChanges ?? 'Save changes',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
