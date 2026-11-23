class CropDiagnosisResult {
  final String id;
  final String cropName;
  final String diagnosisName;
  final String scientificName;
  final String severity; // 'مرتفع', 'متوسط', 'خفيف'
  final int confidencePercentage;
  final String symptomSummary;
  final List<String> immediateActions;
  final List<String> chemicalTreatments;
  final List<String> organicTreatments;
  final String irrigationAdvice;
  final String localAvailabilityNote;
  final DateTime timestamp;

  CropDiagnosisResult({
    required this.id,
    required this.cropName,
    required this.diagnosisName,
    required this.scientificName,
    required this.severity,
    required this.confidencePercentage,
    required this.symptomSummary,
    required this.immediateActions,
    required this.chemicalTreatments,
    required this.organicTreatments,
    required this.irrigationAdvice,
    required this.localAvailabilityNote,
    required this.timestamp,
  });
}

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? attachedImagePath;
  final CropDiagnosisResult? diagnosisResult;
  final bool isThinking;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.attachedImagePath,
    this.diagnosisResult,
    this.isThinking = false,
  });
}
