import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
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
        useMaterial3: true,
        primarySwatch: MaterialColor(
          const Color.fromARGB(255, 0, 150, 136).value,
          const <int, Color>{
            50: Color.fromARGB(255, 0, 150, 136),
            100: Color.fromARGB(255, 0, 150, 136),
            200: Color.fromARGB(255, 0, 150, 136),
            300: Color.fromARGB(255, 0, 150, 136),
            400: Color.fromARGB(255, 0, 150, 136),
            500: Color.fromARGB(255, 0, 150, 136),
            600: Color.fromARGB(255, 0, 150, 136),
            700: Color.fromARGB(255, 0, 150, 136),
            800: Color.fromARGB(255, 0, 150, 136),
            900: Color.fromARGB(255, 0, 150, 136),
          },
        ),
        brightness: Brightness.dark,
      ),
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(
        title: 'Uni Kassel Helper',
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
  // ignore: library_private_types_in_public_api
  _EventCreationScreenState createState() => _EventCreationScreenState();
}

class ColorPicker extends StatelessWidget {
  final Color currentColor;
  final ValueChanged<Color> onColorSelected;

  const ColorPicker(
      {super.key, required this.currentColor, required this.onColorSelected});

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

class MensaPage extends StatelessWidget {
  const MensaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MensaScreen();
  }
}

class MensaScreen extends StatefulWidget {
  const MensaScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MensaScreenState createState() => _MensaScreenState();
}

class _MensaScreenState extends State<MensaScreen> {
  InAppWebViewController? webViewController;
  final GlobalKey webViewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 120, 119, 119).withOpacity(0.1),
      appBar: AppBar(
        title: const Text('Mensa'),
      ),
      body: Column(
        children: [
          Expanded(
            child: InAppWebView(
              key: webViewKey,
              initialUrlRequest: URLRequest(
                url: Uri.parse(
                    'https://zoomquilt.org'), // Replace with your initial URL
              ),
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(),
                android: AndroidInAppWebViewOptions(
                  useWideViewPort: true,
                  loadWithOverviewMode: true,
                ),
              ),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          void navigateToUrl(String url) async {
            if (webViewController != null) {
              await webViewController!.loadUrl(
                urlRequest: URLRequest(url: Uri.parse(url)),
              );
            }
          }

          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                color: const Color.fromARGB(255, 120, 119, 119).withOpacity(
                    0.1), // Set the background color to transparent
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        navigateToUrl(
                            'https://www.studierendenwerk-kassel.de/speiseplaene/zentralmensa-arnold-bode-strasse');
                        Navigator.pop(context);
                      },
                      child: const Text('Zentralmensa Arnold-Bode-Straße'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        navigateToUrl(
                            'https://www.studierendenwerk-kassel.de/nc/mensahoppergoesmoritz');
                        Navigator.pop(context);
                      },
                      child: const Text('Moritz Abendangebot'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        navigateToUrl(
                            'https://www.studierendenwerk-kassel.de/speiseplaene/torcafe');
                        Navigator.pop(context);
                      },
                      child: const Text('TorCafé'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        navigateToUrl('https://mensa71-url.com');
                        Navigator.pop(context);
                      },
                      child: const Text('Mensa 71, Wilhelmshöher Allee'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        navigateToUrl(
                            'https://www.studierendenwerk-kassel.de/speiseplaene/mensa-heinr-plett-strasse');
                        Navigator.pop(context);
                      },
                      child: const Text('Mensa Heinr.-Plett-Straße'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Icons.menu),
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
  CalendarController _calendarController = CalendarController();
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
      body: _currentIndex == 0
          ? buildNotesScreen()
          : _currentIndex == 1
              ? buildCalendarScreen()
              : buildMensaScreen(),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: 'Mensa',
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

  Widget buildMensaScreen() {
    return const MensaPage();
  }

  Widget buildNotesScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notizen'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    color:
                        Colors.transparent, // Make the background transparent
                  ),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      _deleteNote(index);
                      //  ScaffoldMessenger.of(context).showSnackBar(
                      //  SnackBar(
                      //  content: const Text('Die Notiz wurde gelöscht.'),
                      // action: SnackBarAction(
                      //   label: 'Rückgängig2',
                      // onPressed: () {
                      // _undoDelete(
                      //      deletedNote);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 0, 150, 136),
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
      ),
    );
  }

  Widget buildCalendarScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalender'),
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
            _undoDelete(deletedNote); // Pass the deleted note to undo
          },
        ),
      ),
    );
  }

  void _undoDelete(String deletedNote) {
    if (deletedNotes.isNotEmpty) {
      deletedNotes.remove(deletedNote); // Remove the note from deletedNotes
      notes.add(deletedNote);
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
  // ignore: library_private_types_in_public_api
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
  // ignore: library_private_types_in_public_api
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
