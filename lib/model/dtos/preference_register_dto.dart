class PreferenceRegisterDto {
  final int preferenceId;
  final String type;

  PreferenceRegisterDto(this.preferenceId, this.type);

  Map toJson() => {
    'preferenceId': preferenceId,
    'type': type,
  };
}