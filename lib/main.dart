
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in';

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

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CalendarController _calendarController = CalendarController();
  List<String> notes = [];
  List<String> deletedNotes = [];
  int _currentIndex = 0;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadNotes();
    _initializeFirebase();
  }

  void _initializeFirebase() async {
    await Firebase.initializeApp();
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await auth.signInWithCredential(credential);
      final User? user = authResult.user;
      // You can now use the user information as needed.
    } catch (error) {
      print(error);
    }
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
          _closeSnackBar();
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
                _closeSnackBar();
              },
              tooltip: 'Notiz erstellen',
              child: const Icon(Icons.add),
            )
          : ElevatedButton(
              onPressed: () => _signInWithGoogle(),
              child: Text('Google Sign-In'),
            ),
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
                  color: Colors.transparent,
                ),
                onDismissed: (direction) {
                  if (direction == DismissDirection.endToStart) {
                    _deleteNote(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Die Notiz wurde gelöscht.'),
                        action: SnackBarAction(
                          label: 'Rückgängig',
                          onPressed: () {
                            _undoDelete();
                          },
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(0, 128, 128, 1),
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
    return SfCalendar(
      view: CalendarView.month,
      dataSource: MeetingDataSource([]),
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
        content: 
Text('Die Notiz wurde gelöscht.'),
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
        .hideCurrentSnackBar();
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
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _saveNote,
              child: const Text('Notiz Speichern'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
              ),
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

void _saveNotes(List<String> notes) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('notes', notes);
}

void _loadNotes() async {
  final prefs = await SharedPreferences.getInstance();
  final savedNotes = prefs.getStringList('notes');
  if (savedNotes != null) {
    notes = savedNotes;
  }
}

void _addNote(String note) {
  notes.add(note);
  _saveNotes(notes);
}

void _editNote(int index, String newNote) {
  notes[index] = newNote;
  _saveNotes(notes);
}

void _deleteNote(int index) {
  String deletedNote = notes.removeAt(index);
  deletedNotes.add(deletedNote);
  _saveNotes(notes);
}

void _undoDelete() {
  if (deletedNotes.isNotEmpty) {
    String restoredNote = deletedNotes.removeLast();
    notes.add(restoredNote);
    _saveNotes(notes);
  }
}

void _closeSnackBar() {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
}