# Add project-specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified
# in /Users/yourusername/flutter/packages/flutter_tools/gradle/flutter.gradle

# Optimize and obfuscate Flutter's own code
-optimizationpasses 3
-dontoptimize
-dontpreverify
-dontwarn
-dontnote

# Flutter-specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.** { *; }

# Add any additional ProGuard rules here.
