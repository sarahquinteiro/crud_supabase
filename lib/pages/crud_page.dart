import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_page.dart';

/// Tela de CRUD protegida por autenticação.
///
/// Operações disponíveis:
///   CREATE  → insert() com user_id do usuário logado
///   READ    → select() filtrado pelo user_id
///   UPDATE  → update().eq('id', id) — ícone de lápis no card
///   DELETE  → delete().eq('id', id) — ícone de lixeira no card
class CrudPage extends StatefulWidget {
  const CrudPage({super.key});

  @override
  State<CrudPage> createState() => _CrudPageState();
}

class _CrudPageState extends State<CrudPage> {
  final _supabase = Supabase.instance.client;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  String? _editingId;
  late Future<List<dynamic>> _dataFuture;

  // ID do usuário atualmente logado
  String get _userId => _supabase.auth.currentUser!.id;

  @override
  void initState() {
    super.initState();
    _dataFuture = _fetchData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // ── READ ─────────────────────────────────────────────────────────────
  Future<List<dynamic>> _fetchData() async {
    return await _supabase
        .from('users_data')
        .select()
        .eq('user_id', _userId)
        .order('name', ascending: true);
  }

  void _refresh() {
    setState(() {
      _dataFuture = _fetchData();
    });
  }

  // ── CREATE / UPDATE ───────────────────────────────────────────────────
  Future<void> _save() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();

    if (name.isEmpty || email.isEmpty) {
      _showSnackBar('Preencha nome e e-mail.', isError: true);
      return;
    }

    try {
      if (_editingId == null) {
        // CREATE
        await _supabase.from('users_data').insert({
          'name': name,
          'email': email,
          'user_id': _userId,
        });
        _showSnackBar('Registro criado!');
      } else {
        // UPDATE
        await _supabase.from('users_data').update({
          'name': name,
          'email': email,
        }).eq('id', _editingId!);
        _showSnackBar('Registro atualizado!');
      }

      _clear();
      _refresh();
    } catch (e) {
      _showSnackBar('Erro ao salvar: $e', isError: true);
    }
  }

  // ── DELETE ────────────────────────────────────────────────────────────
  Future<void> _delete(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Deseja realmente excluir este registro?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _supabase.from('users_data').delete().eq('id', id);
      _showSnackBar('Registro excluído.', isError: false);
      _refresh();
    } catch (e) {
      _showSnackBar('Erro ao excluir: $e', isError: true);
    }
  }

  // ── EDITAR ────────────────────────────────────────────────────────────
  void _edit(Map item) {
    setState(() {
      _nameController.text = item['name'];
      _emailController.text = item['email'];
      _editingId = item['id'];
    });
  }

  void _clear() {
    _nameController.clear();
    _emailController.clear();
    setState(() => _editingId = null);
  }

  // ── LOGOUT ────────────────────────────────────────────────────────────
  Future<void> _logout() async {
    await _supabase.auth.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  // ── Utilitário ────────────────────────────────────────────────────────
  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  // ── UI ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD com Auth – Supabase'),
        centerTitle: true,
        backgroundColor: colorScheme.inversePrimary,
        actions: [
          // Botão de refresh manual
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Atualizar',
            onPressed: _refresh,
          ),
          // Botão de logout
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── Formulário ─────────────────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _save(),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _save,
                            icon: Icon(
                              _editingId == null
                                  ? Icons.save_outlined
                                  : Icons.update,
                            ),
                            label: Text(
                                _editingId == null ? 'Salvar' : 'Atualizar'),
                          ),
                        ),
                        if (_editingId != null) ...[
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            onPressed: _clear,
                            icon: const Icon(Icons.cancel_outlined),
                            label: const Text('Cancelar'),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Lista de registros ─────────────────────────────────────
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _dataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Erro ao carregar dados: ${snapshot.error}'),
                    );
                  }

                  final data = snapshot.data ?? [];

                  if (data.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 64,
                            color: colorScheme.outline,
                          ),
                          const SizedBox(height: 16),
                          const Text('Nenhum registro. Adicione um acima.'),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];
                      final isEditing = _editingId == item['id'];

                      return Card(
                        color: isEditing
                            ? colorScheme.primaryContainer
                            : null,
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: colorScheme.secondaryContainer,
                            child: Text(
                              (item['name'] as String).isNotEmpty
                                  ? (item['name'] as String)[0].toUpperCase()
                                  : '?',
                              style: TextStyle(
                                color: colorScheme.onSecondaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            item['name'],
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(item['email']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Botão Editar
                              IconButton(
                                icon: const Icon(Icons.edit_outlined),
                                tooltip: 'Editar',
                                onPressed: () => _edit(item),
                              ),
                              // Botão Excluir
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                color: colorScheme.error,
                                tooltip: 'Excluir',
                                onPressed: () => _delete(item['id']),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
