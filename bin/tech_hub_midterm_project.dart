
import 'dart:io';
import 'dart:convert';

// Event class
class Event {
  Event({
    required this.title,
    required this.datetime,
    required this.location,
    required this.description,
    required this.attendance,
  });

  String title;
  DateTime datetime;
  String location;
  String description;
  List<Attendee> attendance = [];

  // Convert Event to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'datetime': datetime.toIso8601String(),
      'location': location,
      'description': description,
      'attendance': attendance.map((attendee) => attendee.toJson()).toList(),
    };
  }

  // Convert JSON to Event
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'],
      datetime: DateTime.parse(json['datetime']),
      location: json['location'],
      description: json['description'],
      attendance: (json['attendance'] as List<dynamic>)
          .map((item) => Attendee.fromJson(item))
          .toList(),
    );
  }

  @override
  String toString() {
    return "\nEvent title: $title, \nDateTime: $datetime, \nLocation: $location, \nDescription: $description";
  }
}

// Attendee class
class Attendee {
  Attendee({required this.name, required this.isPresent});

  String name;
  bool isPresent;

  // Convert Attendee to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isPresent': isPresent,
    };
  }

  // Convert JSON to Attendee
  factory Attendee.fromJson(Map<String, dynamic> json) {
    return Attendee(
      name: json['name'],
      isPresent: json['isPresent'],
    );
  }

  @override
  String toString() {
    return "\nName: $name, IsPresent: $isPresent";
  }
}

// Event Manager class
class EventManager {
  final List<Event> events = [];

  // Method to add an event
  void addEvent(Event event) {
    events.add(event);
    print("New Event Added");
  }

  // Method to edit an event
  void editEvent(int eventId, Event updatedEvent) {
    if (eventId >= 0 && eventId < events.length) {
      events[eventId] = updatedEvent;
      print("Event Updated Successfully");
    } else {
      print("Event id:$eventId not found");
    }
  }

  // Method to delete an event
  void deleteEvent(int eventId) {
    if (eventId >= 0 && eventId < events.length) {
      events.removeAt(eventId);
      print("Event Deleted Successfully");
    } else {
      print("Event id:$eventId not found");
    }
  }

  // Method to get an event by index
  void getEvent(int eventId) {
    if (eventId >= 0 && eventId < events.length) {
      print(events[eventId]);
    } else {
      print("Event id:$eventId not found");
    }
  }

  // Method to register an attendee to an event
  void registerAttendee(int eventId, Attendee attendee) {
    if (eventId >= 0 && eventId < events.length) {
      events[eventId].attendance.add(attendee);
      print(
          "Attendee ${attendee.name} has been registered for the event: ${events[eventId].title}");
    } else {
      print("Event id:$eventId not found");
    }
  }

  // Method to list attendees for a specific event
  void listAttendees(int eventId) {
    if (eventId >= 0 && eventId < events.length) {
      print("Attendees for event: ${events[eventId].title}");
      for (var i = 0; i < events[eventId].attendance.length; i++) {
        print(events[eventId].attendance[i]);
      }
    } else {
      print("Event id:$eventId not found");
    }
  }

  // Method to list all events
  void listEvents() {
    for (var i = 0; i < events.length; i++) {
      print("Event $i: ${events[i]}");
    }
  }

  // Method to check for schedule conflict
  void checkScheduleConflict(DateTime newEventTime) {
    for (var event in events) {
      final existingEventTime = event.datetime;

      if (existingEventTime == newEventTime) {
        print("Conflict detected with event: ${event.title}");
      }
    }
  }

  // Method to save events to a JSON file
  void saveEventsToFile(String filePath) {
    List<Map<String, dynamic>> jsonEvents =
        events.map((event) => event.toJson()).toList();
    String jsonString = jsonEncode(jsonEvents);
    File file = File(filePath);
    file.writeAsStringSync(jsonString);
    print("Events saved to $filePath");
  }

  // Method to load events from a JSON file
  void loadEventsFromFile(String filePath) {
    try {
      File file = File(filePath);
      String jsonString = file.readAsStringSync();
      List<dynamic> jsonList = jsonDecode(jsonString);
      events.clear();
      for (var jsonEvent in jsonList) {
        events.add(Event.fromJson(jsonEvent));
      }
      print("Events loaded from $filePath");
    } catch (e) {
      print("Error loading events from file: $e");
    }
  }
}

// Main function to run the command-line application
void main() {
  final eventManager = EventManager();

  // Load existing events from file (if any)
  eventManager.loadEventsFromFile('events.json');

  while (true) {
    print('\n--- Event Manager ---');
    print('1. Add Event');
    print('2. Edit Event');
    print('3. Delete Event');
    print('4. View Event');
    print('5. Register Attendee');
    print('6. List Attendees');
    print('7. List All Events');
    print('8. Check Schedule Conflict');
    print('9. Save & Exit');
    stdout.write('Choose an option: ');
    final input = stdin.readLineSync();

    switch (input) {
      case '1':
        stdout.write('Enter Event Title: ');
        String title = stdin.readLineSync()!;

        stdout.write('Enter Event DateTime (yyyy-MM-dd HH:mm): ');
        DateTime datetime = DateTime.parse(stdin.readLineSync()!);

        stdout.write('Enter Event Location: ');
        String location = stdin.readLineSync()!;

        stdout.write('Enter Event Description: ');
        String description = stdin.readLineSync()!;

        Event event = Event(
          title: title,
          datetime: datetime,
          location: location,
          description: description,
          attendance: [],
        );

        eventManager.addEvent(event);
        break;

      case '2':
        stdout.write('Enter Event ID to Edit: ');
        int eventId = int.parse(stdin.readLineSync()!);

        stdout.write('Enter New Event Title: ');
        String newTitle = stdin.readLineSync()!;

        stdout.write('Enter New Event DateTime (yyyy-MM-dd HH:mm): ');
        DateTime newDatetime = DateTime.parse(stdin.readLineSync()!);

        stdout.write('Enter New Event Location: ');
        String newLocation = stdin.readLineSync()!;

        stdout.write('Enter New Event Description: ');
        String newDescription = stdin.readLineSync()!;

        Event updatedEvent = Event(
          title: newTitle,
          datetime: newDatetime,
          location: newLocation,
          description: newDescription,
          attendance: [],
        );

        eventManager.editEvent(eventId, updatedEvent);
        break;

      case '3':
        stdout.write('Enter Event ID to Delete: ');
        int deleteId = int.parse(stdin.readLineSync()!);
        eventManager.deleteEvent(deleteId);
        break;

      case '4':
        stdout.write('Enter Event ID to View: ');
        int viewId = int.parse(stdin.readLineSync()!);
        eventManager.getEvent(viewId);
        break;

      case '5':
        stdout.write('Enter Event ID to Register Attendee: ');
        int registerEventId = int.parse(stdin.readLineSync()!);

        stdout.write('Enter Attendee Name: ');
        String attendeeName = stdin.readLineSync()!;

        stdout.write('Is Attendee Present? (true/false): ');
        bool isPresent = stdin.readLineSync()!.toLowerCase() == 'true';

        Attendee attendee = Attendee(name: attendeeName, isPresent: isPresent);
        eventManager.registerAttendee(registerEventId, attendee);
        break;

      case '6':
        stdout.write('Enter Event ID to List Attendees: ');
        int listAttendeesId = int.parse(stdin.readLineSync()!);
        eventManager.listAttendees(listAttendeesId);
        break;

      case '7':
        eventManager.listEvents();
        break;

      case '8':
        stdout.write('Enter Event DateTime to Check (yyyy-MM-dd HH:mm): ');
        DateTime conflictDatetime = DateTime.parse(stdin.readLineSync()!);
        eventManager.checkScheduleConflict(conflictDatetime);
        break;

      case '9':
        // Save events to file before exiting
        eventManager.saveEventsToFile('events.json');
        print('Exiting...');
        return;

      default:
        print('Invalid option. Please try again.');
    }
  }
}