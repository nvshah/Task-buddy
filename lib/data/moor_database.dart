import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

// Moor works by source gen. This file will all the generated code.
part 'moor_database.g.dart';

@UseMoor(tables: [Tasks], daos: [TaskDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      //specify the location of db file
      : super((FlutterQueryExecutor.inDatabaseFolder(
          //db file name
          path: 'db.sqlite',
          //For debugging
          logStatements: true,
        )));

  @override
  int get schemaVersion => 1;
}

//Database Table name :- Tasks
//Generated Data class :- Task (by default)
//@DataClassName('Todo')
class Tasks extends Table {
  // We can call builder by 2 ways i.e call() or directly using ()
  //IntColumn get idu => integer().autoIncrement()();

  // autoIncrement automatically sets this to be the primary key
  // below is giving error while generating moor generated file via build_runner so use () approach instead of call()
  //IntColumn get id => integer().autoIncrement().call();
  IntColumn get id => integer().autoIncrement()();

  //Constraints, if not fulfilled exception will be thrown
  TextColumn get name => text().withLength(min: 1, max: 50)();

  //DateTime is not supported by natively Sqlite, but Moor manages in backend
  DateTimeColumn get dueDate => dateTime().nullable()();

  //Boolean are too not supported by Sqlite native. So Moor converts it to integer for us
  //using call() gives error while generating generated file
  //BoolColumn get completed => boolean().withDefault(Constant(false)).call();
  BoolColumn get completed => boolean().withDefault(Constant(false))();

  // //custom primary key for current table
  // @override
  // Set<Column> get primaryKey => {id, name};
}

@UseDao(
  tables: [Tasks],
  queries: {
    //2nd Version to get completed tasks | Stream
    'completedTaksGenerated':
        'SELECT * FROM tasks WHERE completed = 1 ORDER BY due_date DESC, name;',
  },
)
class TaskDao extends DatabaseAccessor<AppDatabase> with _$TaskDaoMixin {
  final AppDatabase db;

  //called by the AppDatabase class
  TaskDao(this.db) : super(db);

  // Queries -----

  // All tables have getters in the generated class - we can select the tasks table, from Database
  //Get all as Single List
  Future<List<Task>> getAllTasks() => select(tasks).get();
  // Stream that emit elements when watched data chhanges
  // Get all as a Stream
  Stream<List<Task>> watchAllTasks() => select(tasks).watch();
  Future insertTask(Insertable<Task> task) => into(tasks).insert(task);
  Future updateTask(Insertable<Task> task) => update(tasks).replace(task);
  Future deleteTask(Insertable<Task> task) => delete(tasks).delete(task);

  //Get Tasks in Order (according to dueDate, name)
  Stream<List<Task>> watchAllOrderedTasks() {
    return (select(tasks)
          // Statements like orderBy and where return void => the need to use a cascading ".." operator
          ..orderBy(
            ([
              //primary sorting by due date
              (t) =>
                  OrderingTerm(expression: t.dueDate, mode: OrderingMode.desc),
              //secondary alphabetical sorting
              (t) => OrderingTerm(expression: t.name),
            ]),
          ))
        .watch();
  }

  //Get The tasks which are completed | Stream | 1st Version
  Stream<List<Task>> watchCompletedTasks() {
    // where returns void, need to use cascading operator (..)
    return (select(tasks)
          ..orderBy(
            ([
              //primary sorting by due date
              (t) =>
                  OrderingTerm(expression: t.dueDate, mode: OrderingMode.desc),
              //secondary alphabetical sorting
              (t) => OrderingTerm(expression: t.name),
            ]),
          )
          ..where((t) => t.completed.equals(true)))
        .watch();
  }
  
  //3rd Version of same query to get Completed Task Stream
  Stream<List<Task>> watchCompletedTasksCustom() {
    // customSelect or customSelectStream gives us QueryRow list
    return customSelectStream(
      'SELECT * FROM tasks WHERE completed = 1 ORDER BY due_date DESC, name;',
      // The Stream will emit new values when the data inside the Tasks table changes
      readsFrom: {tasks},
    )
        // This runs each time the Stream emits a new value.
        .map((rows) {
      return rows.map((row) => Task.fromData(row.data, db)).toList();
    });
  }
}
