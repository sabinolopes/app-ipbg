// The order of the values is the display order in the contact list.
enum Role { pastor, elder, deacon }

// Position on the board: the Conselho for the pastor and elders, the Junta
// Diaconal for deacons. The order of the values is the display order.
enum BoardPosition { president, vicePresident, firstSecretary, secondSecretary }

class Contact {
  const Contact({
    required this.id,
    required this.name,
    required this.role,
    this.boardPosition,
    this.phone,
    this.email,
    this.photoUrl,
  });

  final String id;
  final String name;
  final Role role;
  final BoardPosition? boardPosition;
  final String? phone;
  final String? email;
  final String? photoUrl;
}

/// Role first, then board members by position, then everyone else by name.
List<Contact> sortContacts(List<Contact> contacts) {
  return [...contacts]..sort(_compareContacts);
}

int _compareContacts(Contact first, Contact second) {
  final roleDifference = first.role.index.compareTo(second.role.index);
  if (roleDifference != 0) return roleDifference;

  final positionDifference = _positionOrder(first)
      .compareTo(_positionOrder(second));
  if (positionDifference != 0) return positionDifference;

  return first.name.toLowerCase().compareTo(second.name.toLowerCase());
}

// Contacts without a position come after every board member.
int _positionOrder(Contact contact) {
  return contact.boardPosition?.index ?? BoardPosition.values.length;
}
