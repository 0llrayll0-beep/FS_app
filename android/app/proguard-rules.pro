# Mantém todas as classes de ML Kit Text Recognition
-keep class com.google.mlkit.vision.text.** { *; }
-keep class com.google.mlkit.common.** { *; }

# Ignora avisos sobre classes ausentes
-dontwarn com.google.mlkit.vision.text.**
-dontwarn com.google.mlkit.common.**
