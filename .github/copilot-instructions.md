# Copilot instructions for note_cards

Purpose
- Help AI agents understand the app structure, state flow, and common edit patterns so they can make safe, focused changes.

Quick start (Windows)
- flutter pub get
- flutter analyze
- flutter run -d <device-id>   # e.g. `flutter run -d windows` or an emulator id
- flutter test                 # run if any tests exist

Primary files to read first
- lib/main.dart — app bootstrap. Wraps app in ProviderScope and constructs NotesApp (ConsumerWidget).
- lib/notes_provider.dart — Riverpod provider(s) and NotesNotifier. All state mutations (insertNote, clearNotes, etc.) live here.
- lib/note_card.dart — Note model and UI pieces (cards / list rows). Also search the repo for NotesView to find its implementation file.

Architecture & data flow (big picture)
- Root: ProviderScope (main.dart). State is held and mutated via Riverpod providers in lib/notes_provider.dart.
- UI reads state with ref.watch(notesProvider) or ref.read(notesProvider.notifier) to call mutators.
- Mutations should be implemented in NotesNotifier (not the UI). UI widgets should be thin: display + user interaction only.
- FloatingActionButton handlers in main.dart currently call ref.read(notesProvider.notifier).insertNote(...) and clearNotes(). Ensure these notifier methods update state so ref.watch rebuilds subscribers.

Project-specific conventions
- Use Riverpod's ConsumerWidget/ConsumerStatefulWidget for widgets that interact with providers.
- Prefer moving any persistent UI state into providers instead of relying on StatelessWidget constructors to retain state across rebuilds.
- When a widget needs to persist local UI state across parent rebuilds (e.g., scroll position, controllers), use a ConsumerStatefulWidget with AutomaticKeepAliveClientMixin or store that state in the provider.

Common edits the agent will be asked to do
- Implement NotesNotifier methods referenced from main.dart (insertNote, clearNotes).
- Convert a top-level widget to ConsumerStatefulWidget to access ref in initState and keep local controllers alive.
- Fix rebuild issues: ensure UI reads from providers (ref.watch) instead of holding ephemeral local lists created inside build().

Examples (patterns useful in this repo)
- Read state and rebuild on changes:
```dart
// use inside a ConsumerWidget or ConsumerState/ConsumerStatefulWidget
final notes = ref.watch(notesProvider);
```
- Call notifier to mutate
```dart
ref.read(notesProvider.notifier).insertNote(Note(...));
```
- Make NotesView persist across parent rebuilds
```dart
class NotesView extends ConsumerStatefulWidget {
  const NotesView({Key? key}): super(key: key);
  @override
  ConsumerState<NotesView> createState() => _NotesViewState();
}
class _NotesViewState extends ConsumerState<NotesView> with AutomaticKeepAliveClientMixin {
  @override bool get wantKeepAlive => true;
  @override Widget build(BuildContext context) {
    super.build(context);
    final notes = ref.watch(notesProvider);
    return ListView(...); // render notes
  }
}
```

Repository-specific tips
- Search for NotesView to confirm where it is defined — ensure that file follows the Consumer* patterns above.
- Keep mutation logic in notes_provider.dart so tests and multiple widgets share a single source of truth.

When editing .github/copilot-instructions.md
- If an existing copilot-instructions.md exists, merge this content while preserving any project-specific CI/agent instructions already present.