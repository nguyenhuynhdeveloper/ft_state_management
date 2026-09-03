/*
 * 📚 FLUTTER BLOC PATTERN - INDEX
 * 
 * File này giúp bạn navigate nhanh đến các files quan trọng trong project
 */

// ============================================================
// 🚀 BẮT ĐẦU TỪ ĐÂY
// ============================================================

/**
 * 1️⃣ ĐỌC TRƯỚC KHI CODE
 * 
 * - README.md                    → Tổng quan project, cách chạy
 * - BLOC_GUIDE.md               → Hướng dẫn chi tiết từng file
 * - CHEAT_SHEET.dart            → Quick reference, code examples
 * - PROJECT_SUMMARY.md          → Tổng kết toàn bộ project
 */


// ============================================================
// 📖 LEARNING PATH - HỌC THEO THỨ TỰ
// ============================================================

/**
 * 2️⃣ BEGINNER - BẮT ĐẦU TỪ CƠ BẢN
 * 
 * Step 1: Hiểu data model
 * ├── lib/models/todo.dart              → Todo model với Equatable
 * └── lib/models/todo_filter.dart       → Filter enum
 * 
 * Step 2: Hiểu repository pattern
 * └── lib/repositories/todo_repository.dart → Data layer
 * 
 * Step 3: Hiểu Events
 * ├── lib/events/todo_event.dart        → 7 todo events
 * ├── lib/events/filter_event.dart      → Filter events
 * └── lib/events/search_event.dart      → Search events
 * 
 * Step 4: Hiểu States
 * ├── lib/states/todo_state.dart        → 5 todo states
 * ├── lib/states/filter_state.dart      → Filter state
 * └── lib/states/search_state.dart      → Search state
 */


/**
 * 3️⃣ INTERMEDIATE - LOGIC LAYER
 * 
 * Step 5: Hiểu BLoC logic (⭐ QUAN TRỌNG NHẤT)
 * ├── lib/blocs/todo_bloc.dart                  → Main BLoC (224 lines)
 * │   ├── Event handlers
 * │   ├── Async operations
 * │   ├── Error handling
 * │   └── Transformers (restartable)
 * │
 * ├── lib/blocs/filter_bloc.dart                → Simple BLoC
 * ├── lib/blocs/search_bloc.dart                → Debounce demo (⭐)
 * ├── lib/blocs/filtered_todos_bloc.dart        → BLoC communication (⭐)
 * └── lib/blocs/simple_bloc_observer.dart       → Logging (⭐)
 */


/**
 * 4️⃣ ADVANCED - UI INTEGRATION
 * 
 * Step 6: Hiểu setup và provider
 * └── lib/main.dart                     → BlocObserver + MultiBlocProvider
 * 
 * Step 7: Hiểu UI integration (⭐ QUAN TRỌNG)
 * ├── lib/screens/home_screen.dart              → Main screen (430 lines)
 * │   ├── BlocBuilder examples
 * │   ├── BlocListener examples
 * │   ├── context.read() usage
 * │   └── Multiple BLoCs
 * │
 * ├── lib/screens/add_todo_screen.dart          → Add form + dispatch events
 * ├── lib/screens/edit_todo_screen.dart         → Edit form + update
 * └── lib/screens/statistics_screen.dart        → BlocConsumer demo (⭐)
 */


/**
 * 5️⃣ EXPERT - COMPLETE REFERENCE
 * 
 * Step 8: Đọc complete reference
 * ├── lib/examples/all_bloc_features.dart       → ALL widgets & methods (609 lines)
 * │   ├── Every BLoC widget
 * │   ├── Every context method
 * │   ├── Every transformer
 * │   └── Copy-paste examples
 * │
 * └── lib/utils/bloc_extensions.dart            → Extension utilities
 */


// ============================================================
// 🎯 THEO FEATURE - TÌM THEO TÍNH NĂNG
// ============================================================

/**
 * 📦 XEM THEO WIDGETS
 */

class BlocWidgetReference {
  // BlocProvider examples
  static const blocProvider = [
    'lib/main.dart',                          // Single & Multiple providers
    'lib/examples/all_bloc_features.dart',    // All provider examples
  ];

  // BlocBuilder examples
  static const blocBuilder = [
    'lib/screens/home_screen.dart',           // Multiple BlocBuilders
    'lib/screens/statistics_screen.dart',     // BlocBuilder in statistics
    'lib/examples/all_bloc_features.dart',    // BlocBuilder reference
  ];

  // BlocListener examples
  static const blocListener = [
    'lib/screens/home_screen.dart',           // Show snackbar on error/success
    'lib/examples/all_bloc_features.dart',    // BlocListener reference
  ];

  // BlocConsumer examples
  static const blocConsumer = [
    'lib/screens/statistics_screen.dart',     // Main BlocConsumer demo (⭐)
    'lib/examples/all_bloc_features.dart',    // BlocConsumer reference
  ];

  // BlocSelector examples
  static const blocSelector = [
    'lib/examples/all_bloc_features.dart',    // BlocSelector examples
  ];
}


/**
 * 🔧 XEM THEO METHODS
 */

class BlocMethodReference {
  // context.read() usage
  static const contextRead = [
    'lib/screens/home_screen.dart',           // Dispatch events
    'lib/screens/add_todo_screen.dart',       // Add todo
    'lib/screens/edit_todo_screen.dart',      // Update todo
  ];

  // context.watch() usage
  static const contextWatch = [
    'lib/examples/all_bloc_features.dart',    // Watch examples
  ];

  // context.select() usage
  static const contextSelect = [
    'lib/examples/all_bloc_features.dart',    // Select examples
  ];

  // emit() usage
  static const emit = [
    'lib/blocs/todo_bloc.dart',               // All emit examples
    'lib/blocs/filter_bloc.dart',             // Simple emit
    'lib/blocs/search_bloc.dart',             // Emit with debounce
  ];

  // on<Event>() registration
  static const onEvent = [
    'lib/blocs/todo_bloc.dart',               // Multiple handlers
    'lib/blocs/search_bloc.dart',             // Handler with transformer
  ];
}


/**
 * ⚡ XEM THEO TRANSFORMERS
 */

class TransformerReference {
  // debounce() - Delay 300ms
  static const debounce = [
    'lib/blocs/search_bloc.dart',             // Main debounce demo (⭐)
    'lib/examples/all_bloc_features.dart',    // Debounce reference
  ];

  // restartable() - Cancel old operations
  static const restartable = [
    'lib/blocs/todo_bloc.dart',               // TodoLoadRequested handler
    'lib/examples/all_bloc_features.dart',    // Restartable reference
  ];

  // sequential(), concurrent(), droppable()
  static const others = [
    'lib/examples/all_bloc_features.dart',    // All transformer examples
  ];
}


/**
 * 👁️ XEM THEO OBSERVER
 */

class ObserverReference {
  // BlocObserver implementation
  static const observer = [
    'lib/blocs/simple_bloc_observer.dart',    // Complete observer (⭐)
    'lib/main.dart',                          // Observer setup
    'lib/examples/all_bloc_features.dart',    // Observer reference
  ];
}


/**
 * 🔗 XEM THEO COMMUNICATION
 */

class CommunicationReference {
  // BLoC to BLoC communication
  static const communication = [
    'lib/blocs/filtered_todos_bloc.dart',     // Listen 3 BLoCs (⭐)
    'lib/main.dart',                          // Provide with dependencies
  ];

  // Multiple BLoCs in one app
  static const multipleBloCs = [
    'lib/main.dart',                          // MultiBlocProvider setup
    'lib/screens/home_screen.dart',           // Use multiple BLoCs
  ];
}


// ============================================================
// 🎓 THEO MỨC ĐỘ - TÌM THEO DIFFICULTY
// ============================================================

/**
 * 🟢 EASY - Dễ hiểu, cơ bản
 */
class EasyFiles {
  static const files = [
    'lib/models/todo.dart',
    'lib/models/todo_filter.dart',
    'lib/events/filter_event.dart',
    'lib/states/filter_state.dart',
    'lib/blocs/filter_bloc.dart',
  ];
}


/**
 * 🟡 MEDIUM - Cần hiểu async, transformers
 */
class MediumFiles {
  static const files = [
    'lib/repositories/todo_repository.dart',
    'lib/events/todo_event.dart',
    'lib/states/todo_state.dart',
    'lib/blocs/todo_bloc.dart',
    'lib/blocs/search_bloc.dart',
    'lib/screens/add_todo_screen.dart',
    'lib/screens/edit_todo_screen.dart',
  ];
}


/**
 * 🔴 HARD - Advanced concepts
 */
class HardFiles {
  static const files = [
    'lib/blocs/filtered_todos_bloc.dart',     // BLoC communication
    'lib/screens/home_screen.dart',           // Multiple widgets
    'lib/screens/statistics_screen.dart',     // BlocConsumer
    'lib/examples/all_bloc_features.dart',    // Complete reference
  ];
}


// ============================================================
// 📊 STATISTICS - THỐNG KÊ PROJECT
// ============================================================

/**
 * 📈 PROJECT STATS
 */
class ProjectStats {
  static const stats = {
    'Total Dart files': 21,
    'Total lines': '3,500+',
    'BLoCs': 4,
    'Events': '10+',
    'States': '8+',
    'Screens': 4,
    'Models': 2,
    'Repositories': 1,
    'Documentation files': 4,
  };

  static const coverage = {
    'Core Concepts': '100%',
    'BLoC Widgets': '100%',
    'Context Methods': '100%',
    'Transformers': '100%',
    'Observer': '100%',
    'Advanced Features': '100%',
  };
}


// ============================================================
// 🔍 QUICK SEARCH - TÌM NHANH
// ============================================================

/**
 * Tìm kiếm nhanh theo keyword
 */
class QuickSearch {
  static Map<String, List<String>> search(String keyword) {
    final results = <String, List<String>>{};

    switch (keyword.toLowerCase()) {
      case 'event':
        results['Events'] = [
          'lib/events/todo_event.dart',
          'lib/events/filter_event.dart',
          'lib/events/search_event.dart',
        ];
        break;

      case 'state':
        results['States'] = [
          'lib/states/todo_state.dart',
          'lib/states/filter_state.dart',
          'lib/states/search_state.dart',
        ];
        break;

      case 'bloc':
        results['BLoCs'] = [
          'lib/blocs/todo_bloc.dart',
          'lib/blocs/filter_bloc.dart',
          'lib/blocs/search_bloc.dart',
          'lib/blocs/filtered_todos_bloc.dart',
        ];
        break;

      case 'screen':
      case 'ui':
        results['Screens'] = [
          'lib/screens/home_screen.dart',
          'lib/screens/add_todo_screen.dart',
          'lib/screens/edit_todo_screen.dart',
          'lib/screens/statistics_screen.dart',
        ];
        break;

      case 'debounce':
        results['Debounce'] = [
          'lib/blocs/search_bloc.dart',
        ];
        break;

      case 'observer':
        results['Observer'] = [
          'lib/blocs/simple_bloc_observer.dart',
          'lib/main.dart',
        ];
        break;

      case 'communication':
        results['Communication'] = [
          'lib/blocs/filtered_todos_bloc.dart',
        ];
        break;

      default:
        results['Try'] = [
          'event', 'state', 'bloc', 'screen', 'debounce', 
          'observer', 'communication'
        ];
    }

    return results;
  }
}


// ============================================================
// 📝 CHECKLISTS - DANH SÁCH KIỂM TRA
// ============================================================

/**
 * ✅ CHECKLIST: Đã hiểu các concepts chưa?
 */
class LearningChecklist {
  static const concepts = [
    '[ ] Hiểu Event là gì và cách định nghĩa',
    '[ ] Hiểu State là gì và các loại states',
    '[ ] Hiểu Bloc class và cách tạo',
    '[ ] Hiểu on<Event>() và event handlers',
    '[ ] Hiểu emit() và cách phát states',
    '[ ] Hiểu BlocProvider và cách provide',
    '[ ] Hiểu BlocBuilder và khi nào dùng',
    '[ ] Hiểu BlocListener và khi nào dùng',
    '[ ] Hiểu BlocConsumer và khi nào dùng',
    '[ ] Hiểu context.read() vs context.watch()',
    '[ ] Hiểu transformers và cách dùng',
    '[ ] Hiểu BlocObserver và logging',
    '[ ] Hiểu BLoC communication',
  ];

  static const practices = [
    '[ ] Đã chạy app thành công',
    '[ ] Đã test thêm/sửa/xóa todo',
    '[ ] Đã test filter và search',
    '[ ] Đã xem console logs',
    '[ ] Đã đọc code comments',
    '[ ] Đã modify code và test',
    '[ ] Đã tạo event/state mới',
    '[ ] Đã tạo BLoC mới',
  ];
}


// ============================================================
// 🎯 RECOMMENDED READING ORDER
// ============================================================

/**
 * 📖 THỨ TỰ ĐỌC ĐỀ XUẤT
 */
class RecommendedOrder {
  static const order = [
    // Phase 1: Documentation (30 mins)
    '1. README.md                           - Tổng quan',
    '2. CHEAT_SHEET.dart                    - Quick reference',
    '',
    // Phase 2: Foundation (1 hour)
    '3. lib/models/todo.dart                - Data model',
    '4. lib/events/todo_event.dart          - Events',
    '5. lib/states/todo_state.dart          - States',
    '6. lib/repositories/todo_repository.dart - Data layer',
    '',
    // Phase 3: BLoC Logic (1.5 hours)
    '7. lib/blocs/simple_bloc_observer.dart - Observer',
    '8. lib/blocs/todo_bloc.dart            - Main BLoC ⭐',
    '9. lib/blocs/search_bloc.dart          - Debounce ⭐',
    '10. lib/blocs/filtered_todos_bloc.dart - Communication ⭐',
    '',
    // Phase 4: UI Integration (1.5 hours)
    '11. lib/main.dart                      - Setup',
    '12. lib/screens/home_screen.dart       - Main screen ⭐',
    '13. lib/screens/statistics_screen.dart - BlocConsumer ⭐',
    '14. lib/screens/add_todo_screen.dart   - Forms',
    '',
    // Phase 5: Reference (As needed)
    '15. lib/examples/all_bloc_features.dart - Complete reference',
    '16. BLOC_GUIDE.md                      - Detailed guide',
    '17. PROJECT_SUMMARY.md                 - Summary',
  ];
}


// ============================================================
// 🎉 KẾT LUẬN
// ============================================================

/**
 * 🚀 START HERE
 * 
 * 1. Mở README.md để hiểu tổng quan
 * 2. Chạy app: flutter run
 * 3. Đọc code theo recommended order
 * 4. Test features trong app
 * 5. Xem console logs để hiểu flow
 * 6. Modify code và experiment
 * 7. Đọc BLOC_GUIDE.md để hiểu sâu hơn
 * 8. Reference CHEAT_SHEET.dart khi cần
 * 
 * Happy Learning! 🎓
 */

void main() {
  print('🎯 Flutter BLoC Pattern - Complete Demo');
  print('📚 Start with README.md');
  print('🚀 Run: flutter run');
  print('✨ Learn by doing!');
}
