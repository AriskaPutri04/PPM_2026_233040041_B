import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Nomor 6: Menggunakan ThemeData dengan useMaterial3: true agar NavigationBar tampil maksimal
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6750A4),
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget { // Diubah ke StatefulWidget untuk menangani indeks navigasi
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 1; // Indeks default untuk Profil

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Nomor 2: Mengubah theme color menjadi warna soft (Color(0xFF...))
      backgroundColor: const Color(0xFFF3E5F5),
      appBar: AppBar(
        title: const Text('Profil Saya'),
        backgroundColor: const Color(0xFFE1BEE7),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          children:[
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFFCE93D8)),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            const ListTile(leading: Icon(Icons.home), title: Text('Beranda')),
            const ListTile(leading: Icon(Icons.person), title: Text('Profil')),

            // Nomor 5: AlertDialog placeholder saat "Pengaturan" ditekan
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {
                Navigator.pop(context); // Tutup drawer
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Pengaturan'),
                    content: const Text('Halaman pengaturan belum tersedia.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.widgets),
              title: const Text('Widget Gallery'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GalleryHome()),
                );
              },
            ),
            const ListTile(leading: Icon(Icons.info), title: Text('Tentang')),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column( 
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // === HEADER PROFIL ===
            Center(
              child: Column(
                children: [
                  // Nomor 1: CircleAvatar menampilkan foto dari URL GitHub
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue,
                    backgroundImage: AssetImage('asset/photoDiri.jpeg'),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Ariska Putri',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Mahasiswa Teknik Informatika',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // === BARIS STATISTIK (Row + Expanded) ===
            Row(
              children: const [
                Expanded(child: _StatBox(label: 'Post', value: '12')),
                Expanded(child: _StatBox(label: 'Teman', value: '402')),
                Expanded(child: _StatBox(label: 'Like', value: '1.2K')),
              ],
            ),
            const SizedBox(height: 24),

            // === SECTION CARD ===
            const _SectionCard(
              icon: Icons.info_outline,
              iconColor: const Color(0xFFCE93D8),
              title: 'Tentang Saya',
              content: 'Saya suka belajar hal baru, menulis dan suka jalan-jalan '
                  'saat waktu libur tidak ada kesibukan kuliah dan tugas telah selesai.',
            ),
            const _SectionCard(
              icon: Icons.school,
              iconColor: const Color(0xFFCE93D8),
              title: 'Pendidikan',
              content: 'Universitas Pasundan — Semester 5\nIPK: 3.62',
            ),
            const _SectionCard(
              icon: Icons.favorite,
              iconColor: const Color(0xFFCE93D8),
              title: 'Hobi & Minat',
              content: 'Hobi Berenang & Travelling | Minat Sistem Informasi',
            ),
            const _SectionCard(
              icon: Icons.email,
              iconColor: const Color(0xFFCE93D8),
              title: 'Kontak',
              content: 'ariskaputri918@gmail.com\n+62 878-367-0479',
            ),

            // Nomor 3: Tambahkan Section Card ke-5 berjudul "Skills" dengan Wrap
            const _SectionCard(
              icon: Icons.star,
              iconColor: const Color(0xFFCE93D8),
              title: 'Skills',
              content: '', // Dikosongkan karena menggunakan parameter isSkills
              isSkills: true,
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),

      // Nomor 4: SnackBar bertuliskan "Edit profil belum tersedia" saat FAB ditekan
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Edit profil belum tersedia')),
          );
        },
        label: const Text('Edit'),
        icon: const Icon(Icons.edit),
      ),

      // Nomor 6: Ganti BottomNavigationBar menjadi NavigationBar (Material 3)
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
          NavigationDestination(icon: Icon(Icons.message_outlined), label: 'Pesan'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Setting'),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;
  final String content;
  final bool isSkills; // Tambahan untuk deteksi section skills

  const _SectionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.content,
    this.isSkills = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  // Nomor 3: Implementasi Wrap berisi 5 Chip skill
                  isSkills
                      ? Wrap(
                    spacing: 8,
                    children: const [
                      Chip(label: Text('PHP')),
                      Chip(label: Text('Laravel')),
                      Chip(label: Text('Dart')),
                      Chip(label: Text('Flutter')),
                      Chip(label: Text('UI/UX')),
                    ],
                  )
                      : Text(content, style: const TextStyle(height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//5.2 Class GalleryHome
class GalleryHome extends StatelessWidget {
  const GalleryHome({super.key});
  @override
  Widget build(BuildContext context) {
    final categories = [
      ('Display', Icons.image, Colors.blue),
      ('Input', Icons.edit, Colors.green),
      ('Button', Icons.smart_button, Colors.orange),
      ('Feedback', Icons.notifications, Colors.purple),
      ('Layout', Icons.dashboard, Colors.teal),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Widget Gallery')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final (name, icon, color) = categories[i];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: color,
                child: Icon(icon, color: Colors.white),
              ),
              title: Text(name),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryPage(name: name),
                  ),
                );
              },
            ),
          );
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
    // return Scaffold(
    //   appBar: AppBar(title: Text(name)),
    //   body: Center(child: Text('Konten kategori $name')),
    // );

    final body = switch (name) {
      'Display' => const _DisplayDemo(),
      'Input' => const _InputDemo(),
      'Button' => const _ButtonDemo(),
      'Feedback' => const _FeedbackDemo(),
      'Layout' => const _LayoutDemo(),
      _ => const Center(child: Text('?')),
    };

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: body,
      ),
    );
  }
}

// Demo Display
class _DisplayDemo extends StatelessWidget {
  const _DisplayDemo();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Card', style: TextStyle(fontWeight: FontWeight.bold)),
        const Card(
          child: ListTile(
            leading: Icon(Icons.album),
            title: Text('Judul Item'),
            subtitle: Text('Sub-judul'),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Chip', style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8,
          children: const [
            Chip(label: Text('Flutter')),
            Chip(label: Text('Dart')),
            Chip(label: Text('Mobile')),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Divider', style: TextStyle(fontWeight: FontWeight.bold)),
        const Divider(thickness: 2),
        const SizedBox(height: 16),
        const Text('CircleAvatar & Icon',
            style: TextStyle(fontWeight: FontWeight.bold)),
        Row(children: const [
          CircleAvatar(child: Text('A')),
          SizedBox(width: 12),
          CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.check)),
          SizedBox(width: 12),
          Icon(Icons.star, color: Colors.amber, size: 40),
        ]),
      ],
    );
  }
}

//Demo Input
class _InputDemo extends StatefulWidget {
  const _InputDemo();
  @override
  State<_InputDemo> createState() => _InputDemoState();
}

class _InputDemoState extends State<_InputDemo> {
  bool _checked = false;
  bool _switched = true;
  double _slider = 0.5;
  String? _dropdown = 'Apel';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('TextField'),
        const SizedBox(height: 4),
        const TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Nama',
            hintText: 'Ketik nama Anda',
          ),
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: const Text('Checkbox'),
          value: _checked,
          onChanged: (v) => setState(() => _checked = v ?? false),
        ),
        SwitchListTile(
          title: const Text('Switch'),
          value: _switched,
          onChanged: (v) => setState(() => _switched = v),
        ),
        const Text('Slider'),
        Slider(
          value: _slider,
          onChanged: (v) => setState(() => _slider = v),
        ),
        const SizedBox(height: 8),
        const Text('Dropdown'),
        DropdownButton<String>(
          value: _dropdown,
          items: ['Apel', 'Jeruk', 'Mangga']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => setState(() => _dropdown = v),
        ),
      ],
    );
  }
}

//Demo Button
class _ButtonDemo extends StatelessWidget {
  const _ButtonDemo();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(onPressed: () {}, child: const Text('Elevated')),
        const SizedBox(height: 8),
        FilledButton(onPressed: () {}, child: const Text('Filled')),
        const SizedBox(height: 8),
        OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
        const SizedBox(height: 8),
        TextButton(onPressed: () {}, child: const Text('Text Button')),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.send),
          label: const Text('Dengan Icon'),
        ),
        const SizedBox(height: 8),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.favorite, color: Colors.red),
        ),
      ],
    );
  }
}

//Demo Feedback
class _FeedbackDemo extends StatelessWidget {
  const _FeedbackDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Halo dari SnackBar!')),
            );
          },
          child: const Text('Tampilkan SnackBar'),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) =>
                  AlertDialog(
                    title: const Text('Konfirmasi'),
                    content: const Text('Yakin ingin lanjut?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Batal'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Ya'),
                      ),
                    ],
                  ),
            );
          },
          child: const Text('Tampilkan Dialog'),
        ),
        const SizedBox(height: 16),
        const Text('Progress Indicator:'),
        const SizedBox(height: 8),
        const LinearProgressIndicator(value: 0.6),
        const SizedBox(height: 12),
        const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}

//Demo Layout
class _LayoutDemo extends StatelessWidget {
  const _LayoutDemo();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Stack — widget bertumpuk'),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: Stack(
            children: [
              Container(width: double.infinity, color: Colors.blue.shade100),
              Positioned(
                top: 12, left: 12,
                child: Container(width: 50, height: 50, color: Colors.red),
              ),
              const Positioned(
                bottom: 12, right: 12,
                child: Icon(Icons.star, size: 40, color: Colors.amber),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text('Wrap — auto-pindah baris saat penuh'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(
            8,
                (i) => Container(
              padding: const EdgeInsets.all(12),
              color: Colors.teal.shade100,
              child: Text('Item ${i + 1}'),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text('GridView (count: 3)'),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: List.generate(
              6,
                  (i) => Container(
                color: Colors.purple.shade100,
                alignment: Alignment.center,
                child: Text('${i + 1}'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
