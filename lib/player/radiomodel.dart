class RadioModel {
  bool isSelected;
  final String buttonText;
  final String text;

  RadioModel(this.isSelected, this.buttonText, this.text);

  static List<RadioModel> sampleData = [
    RadioModel(false, 'A', 'Auto'),
    RadioModel(false, 'B', 'High'),
    RadioModel(false, 'C', 'Medium'),
    RadioModel(false, 'D', 'Low')
  ];
}
