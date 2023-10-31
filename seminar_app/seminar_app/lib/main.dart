import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:image_picker/image_picker.dart';

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
          const Color.fromRGBO(233, 30, 99, 1).value,
          const <int, Color>{
            50: Color.fromRGBO(233, 30, 99, 1),
            100: Color.fromRGBO(233, 30, 99, 1),
            200: Color.fromRGBO(233, 30, 99, 1),
            300: Color.fromRGBO(233, 30, 99, 1),
            400: Color.fromRGBO(233, 30, 99, 1),
            500: Color.fromRGBO(233, 30, 99, 1),
            600: Color.fromRGBO(233, 30, 99, 1),
            700: Color.fromRGBO(233, 30, 99, 1),
            800: Color.fromRGBO(233, 30, 99, 1),
            900: Color.fromRGBO(233, 30, 99, 1),
          },
        ),
        brightness: Brightness.dark,
      ),
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(
        title: 'Uni Kassel Helper', // Pass the function
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

@override
State<MyHomePage> createState() => _MyHomePageState();

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

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TestScreen();
  }
}

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  InAppWebViewController? webViewController;
  final GlobalKey webViewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: InAppWebView(
            key: webViewKey,
            initialUrlRequest: URLRequest(
              url: Uri.parse('https://map.uni-kassel.de/viewer'),
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
    ));
  }
}

class ImpressumPage extends StatelessWidget {
  const ImpressumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ImpressumScreen();
  }
}

class ImpressumScreen extends StatefulWidget {
  const ImpressumScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _ImpressumScreenState createState() => _ImpressumScreenState();
}

class _ImpressumScreenState extends State<ImpressumScreen> {
  InAppWebViewController? webViewController;
  final GlobalKey webViewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: InAppWebView(
            key: webViewKey,
            initialUrlRequest: URLRequest(
              url: Uri.parse('https://map.uni-kassel.de/viewer'),
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
    ));
  }
}

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MapScreen();
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  InAppWebViewController? webViewController;
  final GlobalKey webViewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(children: [
        Expanded(
          child: Text(
            "Adresse:\nUniversität Kassel\nMönchebergstraße 19\n34109 Kassel\nDeutschland\n\nTelefon: 0561 804-0\nFax: +49 561 804-2330\nE-Mail: poststelle@uni-kassel.de\nInternet: www.uni-kassel.de",
            style: TextStyle(fontSize: 14),
          ),
        ),
      ]),
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
      body: Column(
        children: [
          Expanded(
            child: InAppWebView(
              key: webViewKey,
              initialUrlRequest: URLRequest(
                url: Uri.parse(
                    'https://www.studierendenwerk-kassel.de/speiseplaene/zentralmensa-arnold-bode-strasse'),
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
        title: const Text('Kalender Event hinzufügen'),
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
  late MeetingDataSource _meetingDataSource;

  List<XFile>? get images => null; // Declare _meetingDataSource as 'late'
  void _addNote(String note, List<XFile> images) {
    setState(() {
      notes.add(note);
    });
    _saveNotes(notes);
  }

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
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        toolbarHeight: 80,
      ),
      drawer: Drawer(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                height: 120,
                width: double.infinity,
                color: const Color.fromARGB(255, 49, 49, 49),
                child: Center(
                  child: Image.asset(
                    'images/uniKassel.png',
                    height: 50,
                  ),
                ),
              ),
              const SizedBox(
                  height:
                      16), // Add a SizedBox to create space between the categories
              Text('   Bereiche',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600])),
              _buildDrawerItem(0, Icons.notes, 'Notizen'),
              _buildDrawerItem(1, Icons.calendar_today, 'Kalender'),
              _buildDrawerItem(2, Icons.fastfood, 'Mensa'),
              _buildDrawerItem(3, Icons.map, 'Map'),
              const SizedBox(
                  height:
                      16), // Add a SizedBox to create space between the categories
              Text('   Andere',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[
                          600])), // Add a Text widget to label the category
              _buildDrawerItem(
                4,
                Icons.warning,
                'Test',
              ), // Add isSubItem parameter to indicate that this is a sub-item
              _buildDrawerItem(
                5,
                Icons.info,
                'Impressum',
              ), // Add isSubItem parameter to indicate that this is a sub-item
            ],
          ),
        ),
      ),
      body: _currentIndex == 0
          ? buildNotesScreen()
          : _currentIndex == 1
              ? buildCalendarScreen()
              : _currentIndex == 2
                  ? buildMensaScreen()
                  : _currentIndex == 3
                      ? buildMapScreen()
                      : _currentIndex == 4
                          ? buildMapScreen()
                          : _currentIndex == 5
                              ? buildMapScreen()
                              : Container(),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoteCreationScreen(
                      onNoteAdded: _handleNoteAdded,
                    ),
                  ),
                );
                _closeSnackBar();
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  void _handleNoteAdded(String note, List<XFile> images) {
    // Implement the logic to add the note and images to your data structure.
    _addNote(note, images);
  }

  Widget _buildDrawerItem(int index, IconData icon, String title) {
    final isSelected = _currentIndex == index;
    const selectedColor = Color.fromRGBO(233, 30, 99, 1);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: isSelected
            ? Border.all(
                color: selectedColor,
                width: 2,
              )
            : null,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: isSelected ? 5 : 0,
        child: ListTile(
          leading: SizedBox(
            width: 24,
            height: 24,
            child: Icon(
              icon,
              color: isSelected ? selectedColor : Colors.white,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: isSelected ? selectedColor : Colors.white,
            ),
          ),
          onTap: () {
            setState(() {
              _currentIndex = index;
              Navigator.pop(context);
            });
          },
        ),
      ),
    );
  }

  Widget buildMensaScreen() {
    return const MensaPage();
  }

  Widget buildMapScreen() {
    return const MapPage();
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
                        color: const Color.fromRGBO(233, 30, 99, 1),
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
                                _editNote(index, newNote, images!);
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

  void _editNote(int index, String newNote, List<XFile> images) {
    setState(() {
      notes[index] = newNote;
    });
    // Save the images in a separate list or storage (e.g., SharedPreferences).
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
  final Function(String, List<XFile>) onNoteAdded;

  const NoteCreationScreen({Key? key, required this.onNoteAdded})
      : super(key: key);

  @override
  _NoteCreationScreenState createState() => _NoteCreationScreenState();
}

class _NoteCreationScreenState extends State<NoteCreationScreen> {
  final TextEditingController _noteController = TextEditingController();
  final List<XFile> _images = [];

  void _addImage() async {
    final imagePicker = ImagePicker();
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _images.add(image);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note erstellen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _noteController,
              decoration:
                  const InputDecoration(labelText: 'Gib hier deine Notiz ein'),
              onEditingComplete: () {
                _saveNote();
              },
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _addImage,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromRGBO(233, 30, 99, 1)),
              ),
              child: const Text('Bild hinzufügen'),
            ),
            SizedBox(
              height: 100.0, // Adjust the height as needed
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _images.length,
                itemBuilder: (context, index) {
                  return Image.file(File(_images[index].path));
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _saveNote();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.pink),
              ),
              child: const Text('Notiz speichern'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveNote() {
    final note = _noteController.text;
    if (note.isNotEmpty) {
      widget.onNoteAdded(note, _images); // Pass both note and images
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
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.pink),
              ),
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
