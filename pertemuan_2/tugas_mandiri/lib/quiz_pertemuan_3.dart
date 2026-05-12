import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const TugasMandiri());
}

// ============================================================
// MODEL DATA
// ============================================================
class ProfileData {
  String name;
  String bio;
  String education;
  String location;
  String contact;
  List<String> skills;
  Uint8List? profileImage;

  ProfileData({
    this.name = 'Ariska Putri',
    this.bio = 'Saya suka belajar hal baru, menulis dan suka jalan-jalan.',
    this.education = 'Universitas Pasundan — Semester 5',
    this.location = 'Bandung, Jawa Barat',
    this.contact = 'ariskaputri918@gmail.com',
    List<String>? skills,
    this.profileImage,
  }) : skills = skills ?? ['PHP', 'Dart', 'Flutter', 'UI/UX', 'Laravel'];
}

class ExperienceData {
  String title;
  String description;
  Uint8List? image;

  ExperienceData({
    required this.title,
    required this.description,
    this.image,
  });
}

// ============================================================
// APP MAIN
// ============================================================
class TugasMandiri extends StatelessWidget {
  const TugasMandiri({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6750A4), // Your Purple-ish Theme
      ),
      home: const ProfilePage(),
    );
  }
}

// ============================================================
// PROFILE PAGE
// ============================================================
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileData _profile = ProfileData();
  ExperienceData _experience = ExperienceData(
    title: 'Belum Ada Pengalaman',
    description: 'Klik menu "Edit Pengalaman" di Drawer untuk menambahkan.',
  );

  void _openEditProfile() async {
    final updated = await Navigator.push<ProfileData>(
      context,
      MaterialPageRoute(builder: (_) => EditProfilePage(profile: _profile)),
    );
    if (updated != null) setState(() => _profile = updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E5F5), // Your Lavender Light Background
      appBar: AppBar(
        title: const Text('Profil Saya'),
        backgroundColor: const Color(0xFFE1BEE7), // Your Pale Lavender AppBar
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _profile.profileImage != null
                        ? MemoryImage(_profile.profileImage!)
                        : const AssetImage('assets/photoDiri.jpeg') as ImageProvider,
                  ),
                  const SizedBox(height: 12),
                  Text(_profile.name,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const Text('Mahasiswa Teknik Informatika',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Row(
              children: [
                Expanded(child: _StatBox(label: 'Post', value: '12')),
                Expanded(child: _StatBox(label: 'Teman', value: '402')),
                Expanded(child: _StatBox(label: 'Like', value: '1.2K')),
              ],
            ),
            const SizedBox(height: 24),

            _SectionCard(icon: Icons.info_outline, title: 'Tentang Saya', content: _profile.bio),
            _SectionCard(icon: Icons.school, title: 'Pendidikan', content: _profile.education),
            _SectionCard(icon: Icons.location_on, title: 'Lokasi', content: _profile.location),
            _SectionCard(icon: Icons.email, title: 'Kontak', content: _profile.contact),

            // Skills Card
            Card(
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.star, color: Color(0xFFCE93D8), size: 28),
                        SizedBox(width: 16),
                        Text('Skills', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: _profile.skills.map((s) => Chip(
                        label: Text(s),
                        backgroundColor: const Color(0xFFF3E5F5),
                      )).toList(),
                    ),
                  ],
                ),
              ),
            ),

            // Pengalaman Card
            _buildExperienceCard(),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openEditProfile,
        label: const Text('Edit Profil'),
        icon: const Icon(Icons.edit),
        backgroundColor: const Color(0xFF6750A4),
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildExperienceCard() {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.work_history, color: Color(0xFFCE93D8), size: 28),
                SizedBox(width: 16),
                Text('Pengalaman', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            if (_experience.image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(_experience.image!, height: 180, width: double.infinity, fit: BoxFit.cover),
              ),
            const SizedBox(height: 8),
            Text(_experience.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(_experience.description, style: const TextStyle(height: 1.4)),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF3E5F5),
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFFCE93D8)),
            child: Text('Menu Navigasi', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profil'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.widgets),
            title: const Text('Widget Gallery'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const GalleryHome()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text('Edit Pengalaman'),
            onTap: () async {
              Navigator.pop(context);
              final result = await Navigator.push<ExperienceData>(
                context,
                MaterialPageRoute(builder: (_) => UploadExperiencePage(initialData: _experience)),
              );
              if (result != null) setState(() => _experience = result);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Pengaturan'),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Pengaturan'),
                  content: const Text('Halaman pengaturan belum tersedia.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================
// EDIT PROFILE PAGE
// ============================================================
class EditProfilePage extends StatefulWidget {
  final ProfileData profile;
  const EditProfilePage({super.key, required this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameCtrl, _bioCtrl, _eduCtrl, _locCtrl, _contactCtrl, _skillsCtrl;
  Uint8List? _pickedImage;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.profile.name);
    _bioCtrl = TextEditingController(text: widget.profile.bio);
    _eduCtrl = TextEditingController(text: widget.profile.education);
    _locCtrl = TextEditingController(text: widget.profile.location);
    _contactCtrl = TextEditingController(text: widget.profile.contact);
    _skillsCtrl = TextEditingController(text: widget.profile.skills.join(', '));
    _pickedImage = widget.profile.profileImage;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final xfile = await picker.pickImage(source: ImageSource.gallery);
    if (xfile != null) {
      final bytes = await xfile.readAsBytes();
      setState(() => _pickedImage = bytes);
    }
  }

  void _save() {
    final updated = ProfileData(
      name: _nameCtrl.text.trim(),
      bio: _bioCtrl.text.trim(),
      education: _eduCtrl.text.trim(),
      location: _locCtrl.text.trim(),
      contact: _contactCtrl.text.trim(),
      skills: _skillsCtrl.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
      profileImage: _pickedImage,
    );
    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FF),
      appBar: AppBar(title: const Text('Edit Profil'), backgroundColor: const Color(0xFFE1BEE7)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(alignment: Alignment.bottomRight, children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: _pickedImage != null ? MemoryImage(_pickedImage!) : const AssetImage('assets/photoDiri.jpeg') as ImageProvider,
              ),
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(radius: 15, backgroundColor: Theme.of(context).primaryColor, child: const Icon(Icons.camera_alt, size: 16, color: Colors.white)),
              ),
            ]),
            const SizedBox(height: 20),
            _buildField(_nameCtrl, 'Nama Lengkap *', Icons.person),
            _buildField(_bioCtrl, 'Bio / Tentang Saya', Icons.info, maxLines: 3),
            _buildField(_eduCtrl, 'Pendidikan', Icons.school),
            _buildField(_locCtrl, 'Lokasi', Icons.location_on),
            _buildField(_contactCtrl, 'Kontak', Icons.email),
            _buildField(_skillsCtrl, 'Skills (pisah koma)', Icons.star),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: _save, child: const Text('Simpan Perubahan'))),
          ],
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController ctrl, String label, IconData icon, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(controller: ctrl, maxLines: maxLines, decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon), border: const OutlineInputBorder())),
    );
  }
}

// ============================================================
// UPLOAD EXPERIENCE PAGE
// ============================================================
class UploadExperiencePage extends StatefulWidget {
  final ExperienceData initialData;
  const UploadExperiencePage({super.key, required this.initialData});

  @override
  State<UploadExperiencePage> createState() => _UploadExperiencePageState();
}

class _UploadExperiencePageState extends State<UploadExperiencePage> {
  late TextEditingController _titleCtrl, _descCtrl;
  Uint8List? _image;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.initialData.title);
    _descCtrl = TextEditingController(text: widget.initialData.description);
    _image = widget.initialData.image;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final xfile = await picker.pickImage(source: ImageSource.gallery);
    if (xfile != null) {
      final bytes = await xfile.readAsBytes();
      setState(() => _image = bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FF),
      appBar: AppBar(title: const Text('Edit Pengalaman'), backgroundColor: const Color(0xFFE1BEE7)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 180, width: double.infinity,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey)),
                child: _image != null ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.memory(_image!, fit: BoxFit.cover)) : const Icon(Icons.add_a_photo, size: 50, color: Color(0xFFCE93D8)),
              ),
            ),
            const SizedBox(height: 20),
            TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Judul Pengalaman', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _descCtrl, maxLines: 4, decoration: const InputDecoration(labelText: 'Deskripsi', border: OutlineInputBorder())),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () => Navigator.pop(context, ExperienceData(title: _titleCtrl.text, description: _descCtrl.text, image: _image)), child: const Text('Simpan Pengalaman'))),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// WIDGET GALLERY
// ============================================================
class GalleryHome extends StatelessWidget {
  const GalleryHome({super.key});
  @override
  Widget build(BuildContext context) {
    final categories = [('Display', Icons.image, Colors.blue), ('Input', Icons.edit, Colors.green), ('Button', Icons.smart_button, Colors.orange), ('Feedback', Icons.notifications, Colors.purple), ('Layout', Icons.dashboard, Colors.teal)];
    return Scaffold(
      appBar: AppBar(title: const Text('Widget Gallery'), backgroundColor: const Color(0xFFE1BEE7)),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final (name, icon, color) = categories[i];
          return Card(child: ListTile(leading: CircleAvatar(backgroundColor: color, child: Icon(icon, color: Colors.white)), title: Text(name), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryPage(name: name)))));
        },
      ),
    );
  } 
}

class CategoryPage extends StatelessWidget {
  final String name;
  const CategoryPage({super.key, required this.name});
  @override
  Widget build(BuildContext context) {
    final body = switch (name) { 'Display' => const _DisplayDemo(), 'Input' => const _InputDemo(), 'Button' => const _ButtonDemo(), 'Feedback' => const _FeedbackDemo(), 'Layout' => const _LayoutDemo(), _ => const Center(child: Text('?')) };
    return Scaffold(appBar: AppBar(title: Text(name)), body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: body));
  }
}

class _DisplayDemo extends StatelessWidget {
  const _DisplayDemo();
  @override
  Widget build(BuildContext context) => const Column(children: [Card(child: ListTile(title: Text('Card Widget'))), Chip(label: Text('Chip Widget'))]);
}

class _InputDemo extends StatelessWidget {
  const _InputDemo();
  @override
  Widget build(BuildContext context) => const TextField(decoration: InputDecoration(labelText: 'Input Widget', border: OutlineInputBorder()));
}

class _ButtonDemo extends StatelessWidget {
  const _ButtonDemo();
  @override
  Widget build(BuildContext context) => ElevatedButton(onPressed: () {}, child: const Text('Button Widget'));
}

class _FeedbackDemo extends StatelessWidget {
  const _FeedbackDemo();
  @override
  Widget build(BuildContext context) => const Center(child: CircularProgressIndicator());
}

class _LayoutDemo extends StatelessWidget {
  const _LayoutDemo();
  @override
  Widget build(BuildContext context) => const Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [Icon(Icons.star), Icon(Icons.star), Icon(Icons.star)]);
}

// ============================================================
// HELPERS
// ============================================================
class _StatBox extends StatelessWidget {
  final String label, value;
  const _StatBox({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Column(children: [Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), Text(label, style: const TextStyle(color: Colors.grey))]);
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title, content;
  const _SectionCard({required this.icon, required this.title, required this.content});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFCE93D8)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(content),
      ),
    );
  }
}