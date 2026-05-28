import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/login_page.dart';
import 'pages/crud_page.dart';

void main() async {
  // Garante que as bindings do Flutter estejam prontas antes de usar
  // recursos nativos ou assíncronos.
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o cliente Supabase.
  // Substitua pelos valores reais do seu projeto em https://supabase.com
  await Supabase.initialize(
    url: 'https://nryrwnjultoobrlahiyj.supabase.co', // ← Project URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5yeXJ3bmp1bHRvb2JybGFoaXlqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg3OTk1OTMsImV4cCI6MjA5NDM3NTU5M30.c7CGGTCscCtxMVNFaEsonqMhmXWeMGaQBf6HecWPaAw',       
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Verifica se já existe um usuário logado para decidir qual tela abrir
    final user = Supabase.instance.client.auth.currentUser;

    return MaterialApp(
      title: 'Flutter + Supabase Auth',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Auth Gate: se não há usuário logado → LoginPage, senão → CrudPage
      home: user == null ? const LoginPage() : const CrudPage(),
    );
  }
}
