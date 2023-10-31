import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness platformBrightness = MediaQuery.platformBrightnessOf(context);
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: MaterialColor(
          const Color.fromRGBO(235, 18, 185, 1).value,
          const <int, Color>{
            50: Color.fromRGBO(148, 9, 116, 1),
            100: Color.fromRGBO(148, 9, 116, 1),
            200: Color.fromRGBO(148, 9, 116, 1),
            300: Color.fromARGB(255, 148, 9, 116),
            400: Color.fromRGBO(148, 9, 116, 1),
            500: Color.fromRGBO(148, 9, 116, 1),
            600: Color.fromRGBO(148, 9, 116, 1),
            700: Color.fromRGBO(148, 9, 116, 1),
            800: Color.fromRGBO(148, 9, 116, 1),
            900: Color.fromRGBO(148, 9, 116, 1),
          },
        ),
        brightness: platformBrightness,
      ),
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(
        title: 'Uni Kassel Seminar',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class EventCreationScreen extends StatefulWidget {
  const EventCreationScreen({super.key});

  @override
  _EventCreationScreenState createState() => _EventCreationScreenState();
}

class ColorPicker extends StatelessWidget {
  final Color currentColor;
  final ValueChanged<Color> onColorSelected;

  const ColorPicker({super.key, required this.currentColor, required this.onColorSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text('Event Farbe:'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            colorButton(Colors.blue),
            colorButton(Colors.red),
            colorButton(Colors.green),
            colorButton(Colors.yellow),
            colorButton(Colors.purple),
            colorButton(Colors.orange),
          ],
        ),
      ],
    );
  }

  Widget colorButton(Color color) {
    return InkWell(
      onTap: () {
        onColorSelected(color);
      },
      child: Container(
        width: 40,
        height: 40,
        color: color,
        margin: const EdgeInsets.all(5),
        child: currentColor == color
            ? const Icon(
                Icons.check,
                color: Colors.white,
              )
            : null,
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}

class _EventCreationScreenState extends State<EventCreationScreen> {
  DateTime selectedDate = DateTime.now();
  Color selectedColor = Colors.blue; // Default color
  late MeetingDataSource _meetingDataSource;
  final TextEditingController _eventTitleController = TextEditingController();
  final TextEditingController _eventDescriptionController =
      TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalender Event hinzuügen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _eventTitleController,
              decoration: const InputDecoration(labelText: 'Event Name'),
            ),
            TextField(
              controller: _eventDescriptionController,
              decoration:
                  const InputDecoration(labelText: 'Event Beschreibung'),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(
                "${selectedDate.toLocal()}".split(' ')[0],
              ),
              trailing: ElevatedButton(
                onPressed: () => _selectDate(context),
                child: const Text('Wähle ein Datum'),
              ),
            ),
            ColorPicker(
              currentColor: selectedColor,
              onColorSelected: (Color color) {
                setState(() {
                  selectedColor = color;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Get event details from controllers
                String eventTitle = _eventTitleController.text;
                String eventDescription = _eventDescriptionController.text;
                DateTime eventDate = selectedDate;
                Color eventColor = selectedColor;

                // Create a new Appointment object
                Appointment newEvent = Appointment(
                  startTime: eventDate,
                  endTime: eventDate
                      .add(const Duration(hours: 1)), // Event duration (1 hour)
                  subject: eventTitle,
                  color: eventColor,
                  notes: eventDescription,
                );

                // Add the event to the MeetingDataSource
                _meetingDataSource.appointments!.add(newEvent);

                // Update the calendar display
                setState(() {});

                Navigator.pop(context); // Close the event creation page.
              },
              child: const Text('Event hinzuügen'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final CalendarController _calendarController = CalendarController();
  List<String> notes = [];
  List<String> deletedNotes = [];
  int _currentIndex = 0;
  late MeetingDataSource
      _meetingDataSource; // Declare _meetingDataSource as 'late'

  @override
  void initState() {
    super.initState();
    _loadNotes();
    _meetingDataSource =
        MeetingDataSource([]); // Initialize the data source within initState.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: Image.asset('images/Kassel.png'),
      ),
      body: _currentIndex == 0 ? buildNotesScreen() : buildCalendarScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
          _closeSnackBar(); // Close SnackBar when navigating between tabs
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.notes),
            label: 'Notizen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Kalender',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        NoteCreationScreen(onNoteAdded: _addNote),
                  ),
                );
                _closeSnackBar(); // Close SnackBar when opening the NoteCreationScreen
              },
              tooltip: 'Notiz erstellen',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget buildNotesScreen() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: UniqueKey(),
                background: Container(
                  color: Colors.transparent, // Make the background transparent
                ),
                onDismissed: (direction) {
                  if (direction == DismissDirection.endToStart) {
                    _deleteNote(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Die Notiz wurde gelöscht.'),
                        action: SnackBarAction(
                          label: 'Rückgängig',
                          onPressed: () {
                            _undoDelete(); // Implement the undo action here
                          },
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 207, 23, 182),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  padding: const EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Text(notes[index]),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteEditScreen(
                            initialNote: notes[index],
                            onNoteEdited: (newNote) {
                              _editNote(index, newNote);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildCalendarScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: SfCalendar(
        view: CalendarView.month,
        dataSource: _meetingDataSource, // Use the initialized data source
        firstDayOfWeek: 1,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // When the FAB is pressed, open a screen to add a calendar event.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EventCreationScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _saveNotes(List<String> notes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('notes', notes);
  }

  void _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final savedNotes = prefs.getStringList('notes');
    if (savedNotes != null) {
      setState(() {
        notes = savedNotes;
      });
    }
  }

  void _addNote(String note) {
    setState(() {
      notes.add(note);
    });
    _saveNotes(notes);
  }

  void _editNote(int index, String newNote) {
    setState(() {
      notes[index] = newNote;
    });
    _saveNotes(notes);
  }

  void _deleteNote(int index) {
    String deletedNote = notes.removeAt(index);
    deletedNotes.add(deletedNote);
    _saveNotes(notes);
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Die Notiz wurde gelöscht.'),
        action: SnackBarAction(
          label: 'Rückgängig',
          onPressed: () {
            _undoDelete();
          },
        ),
      ),
    );
  }

  void _undoDelete() {
    if (deletedNotes.isNotEmpty) {
      String restoredNote = deletedNotes.removeLast();
      notes.add(restoredNote);
      _saveNotes(notes);
      setState(() {});
    }
  }

  void _closeSnackBar() {
    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar(); // Close the current Snackbar
  }
}

class NoteCreationScreen extends StatefulWidget {
  final Function(String) onNoteAdded;

  const NoteCreationScreen({Key? key, required this.onNoteAdded})
      : super(key: key);

  @override
  _NoteCreationScreenState createState() => _NoteCreationScreenState();
}

class _NoteCreationScreenState extends State<NoteCreationScreen> {
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notiz erstellen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _noteController,
              decoration:
                  const InputDecoration(labelText: 'Gib hier deine Notiz ein'),
              onEditingComplete: _saveNote,
              textInputAction:
                  TextInputAction.done, // Triggers "Done" action on keyboard
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _saveNote,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
              ),
              child: const Text('Notiz Speichern'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveNote() {
    final note = _noteController.text;
    if (note.isNotEmpty) {
      widget.onNoteAdded(note);
    }
    Navigator.pop(context);
  }
}

class NoteEditScreen extends StatefulWidget {
  final String initialNote;
  final Function(String) onNoteEdited;

  const NoteEditScreen(
      {Key? key, required this.initialNote, required this.onNoteEdited})
      : super(key: key);

  @override
  _NoteEditScreenState createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _noteController.text = widget.initialNote;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notiz ändern'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(labelText: 'Notiz ändern'),
              onEditingComplete: _editNote,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _editNote,
              child: const Text('Änderungen Speichern'),
            ),
          ],
        ),
      ),
    );
  }

  void _editNote() {
    final newNote = _noteController.text;
    if (newNote.isNotEmpty) {
      widget.onNoteEdited(newNote);
    }
    Navigator.pop(context);
  }
}
