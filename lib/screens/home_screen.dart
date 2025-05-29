import 'package:buku_sqflite/screens/add_note_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../helper/db_helper.dart';
import '../model/model_note.dart';
import '../widgets/note_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> notes = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  void fetchNotes() async {
    final data = await DatabaseHelper.instance.getNotes();
    setState(() => notes = data);
  }

  void onSearch(String value) {
    setState(() => searchQuery = value.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    final filteredNotes = notes.where((note) {
      return note.title.toLowerCase().contains(searchQuery) ||
          note.content.toLowerCase().contains(searchQuery);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header dan Search Bar
            Container(
              color: Colors.grey,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  // Header
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      const Text(
                        "My Notes.",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          "gambar/tia.jpg",
                          height: 46,
                          width: 46,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Search Bar tanpa ikon
                  TextField(
                    onChanged: onSearch,
                    decoration: InputDecoration(
                      hintText: "Search",
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.deepPurpleAccent),
                      ),
                    ),
                    style: const TextStyle(color: Colors.black87),
                    cursorColor: Colors.deepPurpleAccent,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // List Catatan
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: filteredNotes.isEmpty
                    ? Center(
                  child: Text(
                    searchQuery.isEmpty
                        ? 'Belum ada catatan'
                        : 'Catatan tidak ditemukan',
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
                    : GridView.builder(
                  itemCount: filteredNotes.length,
                  padding: const EdgeInsets.only(bottom: 60),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (context, index) {
                    return NoteCard(
                      note: filteredNotes[index],
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddNoteScreen(
                              note: filteredNotes[index],
                            ),
                          ),
                        );
                        fetchNotes();
                      },
                      onDelete: () async {
                        await DatabaseHelper.instance
                            .deleteNote(filteredNotes[index].id!);
                        fetchNotes();
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      // FAB
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white24,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddNoteScreen()),
          );
          fetchNotes();
        },
        child: const Icon(Iconsax.add),
      ),
    );
  }
}
