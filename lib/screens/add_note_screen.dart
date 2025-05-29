import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../model/model_note.dart';
import '../helper/db_helper.dart';

class AddNoteScreen extends StatefulWidget {
  final Note? note;
  const AddNoteScreen({super.key, this.note});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  late final AnimationController _btnController;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
    _btnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _btnController.dispose();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void saveNote() async {
    if (_titleController.text.trim().isEmpty && _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul dan isi tidak boleh kosong')),
      );
      return;
    }
    _btnController.forward();

    final now = DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now());
    final note = Note(
      id: widget.note?.id,
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      date: now,
    );

    if (widget.note == null) {
      await DatabaseHelper.instance.insertNote(note);
    } else {
      await DatabaseHelper.instance.updateNote(note);
    }
    _btnController.reverse();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey,
        centerTitle: true,
        title: Text(
          widget.note == null ? 'Tambah' : 'Edit Catatan',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.1,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            children: [
              /// Input Judul
              TextField(
                controller: _titleController,
                cursorColor: Colors.black,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  height: 1.5,
                ),
                decoration: const InputDecoration(
                  hintText: 'Judul',
                  hintStyle: TextStyle(color: Colors.black45),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black26,
                      width: 1, // lebih tipis
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black87,
                      width: 1.5, // lebih tipis
                    ),
                  ),
                  contentPadding: EdgeInsets.only(
                    left: 0,
                    top: 20,
                    bottom: 20,
                  ),
                ),
              ).animate().fadeIn(duration: 400.ms),


              const SizedBox(height: 26),

              /// Input isi catatan (tanpa prefix icon)
              Expanded(
                child: TextField(
                  controller: _contentController,
                  cursorColor: Colors.black,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    height: 1.5,
                  ),
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    hintText: 'Isi Catatan',
                    hintStyle: TextStyle(color: Colors.black45),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black26,
                        width: 2,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white24,
                        width: 3,
                      ),
                    ),
                    contentPadding: EdgeInsets.only(
                      left: 0,
                      top: 20,
                      bottom: 20,
                    ),
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
              ),

              const SizedBox(height: 24),

              /// Tombol simpan bulat dengan gradient ungu dan icon putih, ukuran disesuaikan dengan teks
              ScaleTransition(
                scale: Tween(begin: 1.0, end: 1.08).animate(
                  CurvedAnimation(
                    parent: _btnController,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: Container(
                  width: 120, // disesuaikan dengan lebar teks+ikon agar proporsional
                  height: 38, // disesuaikan dengan tinggi teks dan ikon
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [Color(-11053732), Color(-11053732)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.shade200.withOpacity(0.6),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: saveNote,
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Iconsax.save_2, color: Colors.white, size: 18),
                            SizedBox(width: 6),
                            Text(
                              'Simpan',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
