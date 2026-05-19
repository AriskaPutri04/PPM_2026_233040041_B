import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/tambah':
          // Menggunakan argumen opsional untuk deteksi tambah atau edit
            final catatanLama = settings.arguments as Catatan?;
            return MaterialPageRoute(
              builder: (_) => TambahCatatanPage(catatanLama: catatanLama),
            );
          case '/detail':
            final catatan = settings.arguments as Catatan;
            return MaterialPageRoute(
              builder: (_) => DetailCatatanPage(catatan: catatan),
            );
        }
        return null;
      },
    );
  }
}

// === BluePrint Model Catatan dengan Tambahan Field Email ===
class Catatan {
  final String judul;
  final String isi;
  final String kategori;
  final String email; // <-- Tambahan Validasi Lanjutan
  final DateTime dibuatPada;

  Catatan({
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.email,
    required this.dibuatPada,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // === STATE ===
  final List<Catatan> _catatan = [
    Catatan(
      judul: 'Belajar Flutter',
      isi: 'Mempelajari Stateful Widget, Form, dan Navigation.',
      kategori: 'Kuliah',
      email: 'mahasiswa@unpas.ac.id',
      dibuatPada: DateTime.now(),
    ),
  ];

  // === FITUR FILTER: Variabel State Filter ===
  String _kategoriFilter = 'Semua';
  final _filterOpsi = const ['Semua', 'Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];

  // Fungsi navigasi tambah catatan baru
  Future<void> _bukaTambahCatatan() async {
    final hasil = await Navigator.pushNamed(context, '/tambah');

    if (hasil is Catatan) {
      setState(() => _catatan.add(hasil));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Catatan "${hasil.judul}" ditambahkan')),
      );
    }
  }

  // === FITUR EDIT: Fungsi Navigasi ke Detail & Menangkap Hasil Update ===
  Future<void> _bukaDetailCatatan(Catatan catatanLama, int indeksAsli) async {
    final hasilUpdate = await Navigator.pushNamed(
      context,
      '/detail',
      arguments: catatanLama,
    );

    // Jika user menekan simpan saat edit di dalam halaman detail
    if (hasilUpdate is Catatan) {
      setState(() {
        _catatan[indeksAsli] = hasilUpdate;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Catatan "${hasilUpdate.judul}" diperbarui')),
      );
    }
  }

  String _formatTanggal(DateTime dt) {
    final bulanOpsi = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${dt.day.toString().padLeft(2, '0')} ${bulanOpsi[dt.month - 1]} ${dt.year}';
  }

  void _hapusCatatan(int indexAsli) {
    final judulDihapus = _catatan[indexAsli].judul;
    setState(() {
      _catatan.removeAt(indexAsli);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Catatan "$judulDihapus" telah dihapus')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // === FITUR FILTER: Memfilter list sebelum di-render ke layar ===
    final listTerfilter = _catatan.where((c) {
      if (_kategoriFilter == 'Semua') return true;
      return c.kategori == _kategoriFilter;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Mahasiswa'),
        // === FITUR FILTER: Menambahkan Dropdown Filter ke AppBar ===
        actions: [
          DropdownButton<String>(
            value: _kategoriFilter,
            icon: const Icon(Icons.filter_list, color: Colors.indigo),
            underline: const SizedBox(),
            items: _filterOpsi.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (v) {
              if (v != null) setState(() => _kategoriFilter = v);
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: listTerfilter.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.note_alt_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Belum ada catatan.',
              style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _kategoriFilter == 'Semua'
                  ? 'Tekan tombol + di bawah untuk menambah.'
                  : 'Tidak ada catatan dengan kategori "$_kategoriFilter".',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: listTerfilter.length,
        itemBuilder: (context, i) {
          final c = listTerfilter[i];
          // Mencari indeks asli pada rumpun list utama agar operasi hapus/edit tidak salah sasaran
          final indeksAsli = _catatan.indexOf(c);

          return ListTile(
            title: Text(c.judul),
            subtitle: Text('${c.kategori} • ${_formatTanggal(c.dibuatPada)}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () => _hapusCatatan(indeksAsli),
            ),
            onTap: () => _bukaDetailCatatan(c, indeksAsli),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _bukaTambahCatatan,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TambahCatatanPage extends StatefulWidget {
  final Catatan? catatanLama; // <-- FITUR EDIT: Menerima data opsional

  const TambahCatatanPage({super.key, this.catatanLama});

  @override
  State<TambahCatatanPage> createState() => _TambahCatatanPageState();
}

class _TambahCatatanPageState extends State<TambahCatatanPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _judulCtrl;
  late final TextEditingController _isiCtrl;
  late final TextEditingController _emailCtrl; // <-- VALIDASI LANJUTAN

  String _kategori = 'Kuliah';
  final _kategoriOpsi = const ['Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];

  @override
  void initState() {
    super.initState();
    // === FITUR EDIT: Mengisi nilai awal jika mendeteksi aksi pengeditan ===
    _judulCtrl = TextEditingController(text: widget.catatanLama?.judul ?? '');
    _isiCtrl = TextEditingController(text: widget.catatanLama?.isi ?? '');
    _emailCtrl = TextEditingController(text: widget.catatanLama?.email ?? '');
    _kategori = widget.catatanLama?.kategori ?? 'Kuliah';
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _isiCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    final catatanHasil = Catatan(
      judul: _judulCtrl.text.trim(),
      isi: _isiCtrl.text.trim(),
      kategori: _kategori,
      email: _emailCtrl.text.trim(),
      dibuatPada: widget.catatanLama?.dibuatPada ?? DateTime.now(), // Mempertahankan tanggal lama jika edit
    );

    Navigator.pop(context, catatanHasil);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.catatanLama != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Catatan' : 'Tambah Catatan')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _judulCtrl,
              decoration: const InputDecoration(
                labelText: 'Judul',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Judul wajib diisi';
                if (v.trim().length < 3) return 'Minimal 3 karakter';
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _kategori,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
              items: _kategoriOpsi
                  .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              onChanged: (v) => setState(() => _kategori = v!),
            ),
            const SizedBox(height: 16),
            // === VALIDASI LANJUTAN: Field Email Baru Berbasis Regex ===
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email Pengirim',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
                // Regex standar pola validasi format alamat email
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(v.trim())) return 'Format email tidak valid';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _isiCtrl,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Isi',
                prefixIcon: Icon(Icons.notes),
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Isi wajib diisi' : null,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _simpan,
              icon: Icon(isEdit ? Icons.update : Icons.save),
              label: Text(isEdit ? 'Perbarui' : 'Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}

// === HALAMAN DETAIL: Diperbarui untuk mendukung rantai data Edit ===
class DetailCatatanPage extends StatefulWidget {
  final Catatan catatan;
  const DetailCatatanPage({super.key, required this.catatan});

  @override
  State<DetailCatatanPage> createState() => _DetailCatatanPageState();
}

class _DetailCatatanPageState extends State<DetailCatatanPage> {
  late Catatan _currentCatatan;

  @override
  void initState() {
    super.initState();
    _currentCatatan = widget.catatan;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          // Mengembalikan objek catatan terbaru saat menekan tombol back di AppBar
          onPressed: () => Navigator.pop(context, _currentCatatan),
        ),
        actions: [
          // === FITUR EDIT: Tombol edit diletakkan di pojok kanan AppBar ===
          IconButton(
            icon: const Icon(Icons.edit_note, size: 28),
            onPressed: () async {
              final hasilEdit = await Navigator.pushNamed(
                context,
                '/tambah',
                arguments: _currentCatatan, // Melempar data lama ke form
              );

              if (hasilEdit is Catatan) {
                setState(() {
                  _currentCatatan = hasilEdit; // Memperbarui UI detail secara lokal
                });
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          // Mengamankan data agar saat ditekan back tombol fisik/gesture perangkat, data tetap terkirim balik
          Navigator.pop(context, _currentCatatan);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _currentCatatan.judul,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Chip(label: Text(_currentCatatan.kategori)),
                  const SizedBox(width: 8),
                  Chip(
                    avatar: const Icon(Icons.person_outline, size: 16),
                    label: Text(_currentCatatan.email, style: const TextStyle(fontSize: 12)),
                  ),
                ],
              ),
              const Divider(height: 32),
              Text(
                _currentCatatan.isi,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}