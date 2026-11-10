// The order of the values is the display order in the contact list.
enum Role { pastor, elder, deacon }

class Contact {
  const Contact({
    required this.id,
    required this.name,
    required this.role,
    this.phone,
    this.email,
    this.photoUrl,
  });

  final String id;
  final String name;
  final Role role;
  final String? phone;
  final String? email;
  final String? photoUrl;
}

List<Contact> sortContacts(List<Contact> contacts) {
  return [...contacts]..sort(_compareContacts);
}

int _compareContacts(Contact first, Contact second) {
  final roleDifference = first.role.index.compareTo(second.role.index);
  if (roleDifference != 0) return roleDifference;

  return first.name.toLowerCase().compareTo(second.name.toLowerCase());
}
