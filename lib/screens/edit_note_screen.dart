import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../models/attachment_model.dart';
import '../models/note_model.dart';
import '../models/todo_item_model.dart';
import '../providers/notes_provider.dart';
import '../utils/responsive.dart';

class EditNoteScreen extends ConsumerStatefulWidget {
  final NoteModel note;

  const EditNoteScreen({super.key, required this.note});

  @override
  ConsumerState<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends ConsumerState<EditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

  late TextEditingController _titleController;
  late TextEditingController _descController;
  final _todoController = TextEditingController();

  late List<TodoItemModel> _todos;
  late List<AttachmentModel> _attachments;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _descController = TextEditingController(text: widget.note.description);
    _todos = List.from(widget.note.todos);
    _attachments = List.from(widget.note.attachments);
  }

  void _addTodo() {
    if (_todoController.text.trim().isEmpty) return;

    setState(() {
      _todos.add(
        TodoItemModel(id: _uuid.v4(), text: _todoController.text.trim()),
      );
      _todoController.clear();
    });
  }

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() {
      _attachments.add(
        AttachmentModel(
          id: _uuid.v4(),
          fileName: image.name,
          filePath: image.path,
          fileType: 'image',
        ),
      );
    });
  }

  void _updateNote() {
    if (!_formKey.currentState!.validate()) return;

    final updatedNote = widget.note.copyWith(
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      updatedAt: DateTime.now(),
      todos: _todos,
      attachments: _attachments,
    );

    ref.read(notesProvider.notifier).updateNote(updatedNote);
    Navigator.pop(context);
  }

  Future<void> _deleteNote() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('Delete Note?'),
        content: const Text('This note will be removed from your list.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(notesProvider.notifier).deleteNote(widget.note.id);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ResponsiveWrapper(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _TopBar(
                  title: 'Edit Note',
                  onSave: _updateNote,
                  onDelete: _deleteNote,
                ),
                const SizedBox(height: 18),
                _EditorCard(child: _buildForm()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _titleController,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            decoration: const InputDecoration(
              hintText: 'Note title',
              border: InputBorder.none,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Title is required';
              }
              return null;
            },
          ),
          const Divider(height: 28),
          TextFormField(
            controller: _descController,
            maxLines: 7,
            decoration: const InputDecoration(
              hintText: 'Start writing your note...',
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 18),
          _SectionTitle(title: 'Checklist', icon: Icons.check_circle_outline),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _todoController,
                  decoration: _inputDecoration('Add todo item'),
                ),
              ),
              const SizedBox(width: 10),
              IconButton.filled(
                onPressed: _addTodo,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._todos.map(
            (todo) => _TodoTile(
              todo: todo,
              onChanged: (value) {
                setState(() {
                  final index = _todos.indexWhere((e) => e.id == todo.id);
                  _todos[index] = todo.copyWith(isCompleted: value);
                });
              },
              onDelete: () {
                setState(() {
                  _todos.removeWhere((e) => e.id == todo.id);
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          _SectionTitle(title: 'Attachments', icon: Icons.image_outlined),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.add_photo_alternate_outlined),
              label: const Text('Add Image'),
            ),
          ),
          const SizedBox(height: 12),
          ..._attachments.map(
            (file) => _AttachmentTile(
              fileName: file.fileName,
              onDelete: () {
                setState(() {
                  _attachments.removeWhere((e) => e.id == file.id);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xffF8F7FC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String title;
  final VoidCallback onSave;
  final VoidCallback onDelete;

  const _TopBar({
    required this.title,
    required this.onSave,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.filledTonal(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
          ),
        ),
        IconButton.filledTonal(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline),
        ),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: onSave,
          icon: const Icon(Icons.check),
          label: const Text('Save'),
        ),
      ],
    );
  }
}

class _EditorCard extends StatelessWidget {
  final Widget child;

  const _EditorCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xff6C5CE7)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

class _TodoTile extends StatelessWidget {
  final TodoItemModel todo;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onDelete;

  const _TodoTile({
    required this.todo,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xffF8F7FC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: CheckboxListTile(
        value: todo.isCompleted,
        onChanged: onChanged,
        title: Text(
          todo.text,
          style: TextStyle(
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        secondary: IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.close),
        ),
      ),
    );
  }
}

class _AttachmentTile extends StatelessWidget {
  final String fileName;
  final VoidCallback onDelete;

  const _AttachmentTile({
    required this.fileName,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffF8F7FC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.image_outlined, color: Color(0xff6C5CE7)),
          const SizedBox(width: 10),
          Expanded(child: Text(fileName)),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}