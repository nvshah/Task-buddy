import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

// Moor works by source gen. This file will all the generated code.
part 'moor_database.g.dart';

@UseMoor(tables: [Tasks])
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

  // Queries

  // All tables have getters in the generated class - we can select the tasks table, from Database
  Future<List<Task>> getAllTasks() => select(tasks).get();

  // Stream that emit elements when watched data chhanges
  Stream<List<Task>> watchAllTasks() => select(tasks).watch();

  Future insertTask(Task task) => into(tasks).insert(task);
  
  Future updateTask(Task task) => update(tasks).replace(task);

  Future deleteTask(Task task) => delete(tasks).delete(task);
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
  // // TODO: implement primaryKey
  // Set<Column> get primaryKey => {id, name};
}
