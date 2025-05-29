import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';

import '../model/model_note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback? onEdit;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Baris atas: Judul + Menu
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Judul
                Expanded(
                  child: Text(
                    note.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                /// Menu Popup
                PopupMenuButton<String>(
                  icon: const Icon(Iconsax.more_circle5, color: Colors.black),
                  onSelected: (value) {
                    if (value == 'edit') {
                      if (onEdit != null) onEdit!();
                    } else if (value == 'delete') {
                      onDelete();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: const [
                          Icon(Iconsax.trash, color: Colors.red, size: 18),
                          SizedBox(width: 8),
                          Text("Hapus"),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// Isi Catatan (dibatasi tinggi supaya tanggal tetap sejajar)
            SizedBox(
              height: 80,
              child: Text(
                note.content,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ),

            const Spacer(),

            const SizedBox(height: 12),

            /// Baris bawah: Tanggal + Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 6),
                    Text(
                      note.date,
                      style: const TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ],
                ),

              ],
            ),
          ],
        ),
      ).animate().fade(duration: 400.ms).slideY(begin: 0.3, duration: 400.ms),
    );
  }
}
