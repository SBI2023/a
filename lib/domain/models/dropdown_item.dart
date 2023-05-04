class DropdownItem {
  final String label;

  DropdownItem({required this.label});

  Map<String, dynamic> toMap() {
    return {
      'label': label,
    };
  }

  factory DropdownItem.fromMap(Map<String, dynamic> map) {
    return DropdownItem(
      label: map['label'],
    );
  }
}
