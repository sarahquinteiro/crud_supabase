# 📱 Flutter + Supabase — CRUD com Autenticação

Aplicação Flutter integrada ao **Supabase** desenvolvida como projeto acadêmico, cobrindo os conceitos das Partes 1, 2 e 3 do material didático da disciplina.

> ✅ **O banco de dados já está configurado e funcionando.**
> Não é necessário criar uma conta no Supabase para rodar este projeto.
> Basta clonar, instalar as dependências e executar.

---

## ✅ Funcionalidades implementadas

| Parte | Operação | Descrição |
|-------|----------|-----------|
| 1 | `SELECT` | Listar usuários com `FutureBuilder` |
| 1 | `INSERT` | Cadastrar novo usuário |
| 2 | `UPDATE` | Editar nome e e-mail |
| 2 | `DELETE` | Excluir registro com confirmação |
| 3 | `AUTH`   | Login, cadastro e logout via Supabase Auth |
| 3 | `RLS`    | Cada usuário acessa apenas seus próprios dados |

---

## 🚀 Como rodar o projeto

### Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado (versão 3.0 ou superior)
- [Git](https://git-scm.com/) instalado
- Google Chrome instalado

Verifique se o Flutter está instalado corretamente:
```bash
flutter doctor
```

---

### Passo 1 — Clonar o repositório

```bash
git clone https://github.com/sarahquinteiro/crud_supabase.git
cd crud_supabase
```

---

### Passo 2 — Instalar as dependências

```bash
flutter pub get
```

---

### Passo 3 — Rodar no navegador

```bash
flutter run -d chrome
```

O app abrirá no Chrome com a tela de login. Crie uma conta com qualquer e-mail e senha para acessar o CRUD.

---

## 🗂️ Estrutura do projeto

```
lib/
├── main.dart              ← Inicialização do Supabase + Auth Gate
└── pages/
    ├── login_page.dart    ← Tela de login e cadastro (Parte 3)
    └── crud_page.dart     ← CRUD completo (Partes 1, 2 e 3)
```

---

## 🛠️ Tecnologias utilizadas

- [Flutter](https://flutter.dev/) — framework de desenvolvimento mobile/web
- [Supabase](https://supabase.com/) — Backend-as-a-Service (banco de dados + autenticação)
- [supabase_flutter](https://pub.dev/packages/supabase_flutter) — SDK oficial do Supabase para Flutter

---

## 🧠 Conceitos abordados

- **`WidgetsFlutterBinding.ensureInitialized()`** — inicialização antes do `runApp()`
- **`async` / `await`** — operações assíncronas sem travar a interface
- **`FutureBuilder`** — gerencia os 3 estados: waiting, done e error
- **`mounted`** — segurança em `setState()` após operações assíncronas
- **RLS (Row Level Security)** — cada usuário acessa apenas seus próprios dados
- **Auth Gate** — redireciona para login ou CRUD conforme a sessão ativa

---

## 👩‍💻 Autora

**Sarah Quinteiro**
[github.com/sarahquinteiro](https://github.com/sarahquinteiro)

---

## 📚 Referências

- [Documentação Supabase](https://supabase.com/docs)
- [Documentação Flutter](https://docs.flutter.dev)
- [supabase_flutter no pub.dev](https://pub.dev/packages/supabase_flutter)
- Material didático da disciplina — Professor Elias Oliveira
