import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rrhh/providers/db_liderazgo_rrhh.dart';
import 'package:rrhh/src/tema/primary.dart';

class HomeListLiderazgo extends StatefulWidget {
  @override
  State<HomeListLiderazgo> createState() => _homeListLiderazgoState();
}

/*
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}
*/

class _homeListLiderazgoState extends State<HomeListLiderazgo> {
  // All journals
  List<Map<String, dynamic>> _journals = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshJournals() async {
    //final data = await SQLHelper.getItems();
    final data = await DBProvider.db.getAllResultadosPacking();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals(); // Loading the diary when the app starts
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingJournal =
      _journals.firstWhere((element) => element['idresultado'] == id);
      _titleController.text = existingJournal['title'];
      _descriptionController.text = existingJournal['description'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
          padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            // this will prevent the soft keyboard from covering the text fields
            bottom: MediaQuery.of(context).viewInsets.bottom + 120,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(hintText: 'Title'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(hintText: 'Description'),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  // Save new journal
                  if (id == null) {
                    await _addItem();
                  }

                  if (id != null) {
                    await _updateItem(id);
                  }

                  // Clear the text fields
                  _titleController.text = '';
                  _descriptionController.text = '';

                  // Close the bottom sheet
                  Navigator.of(context).pop();
                },
                child: Text(id == null ? 'Create New' : 'Update'),
              )
            ],
          ),
        ));
  }

// Insert a new journal to the database
  Future<void> _addItem() async {
    // await SQLHelper.createItem(
      //  _titleController.text, _descriptionController.text);
    _refreshJournals();
  }

  // Update an existing journal
  Future<void> _updateItem(int id) async {
   // await SQLHelper.updateItem(
     //   id, _titleController.text, _descriptionController.text);
    _refreshJournals();
  }

  // Delete an item
  void _deleteItem(int id) async {
    //await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a journal!'),
    ));
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: getAppBarUI(),

      ),
      body: _isLoading
          ? const Center(
            child: CircularProgressIndicator(),
          )
          : ListView.builder(
        itemCount:  _journals.length,
        itemBuilder: (context, index) => Card(
          color: Colors.orange[200],
          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Text(_journals[index]['nombres']),
              subtitle: Text(_journals[index]['fecha']+'  '+_journals[index]['hora']),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit,color: Colors.green),
                      onPressed: () => _showForm(_journals[index]['idresultado']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          _deleteItem(_journals[index]['idresultado']),
                    ),
                  ],
                ),
              )),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
       // child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
        tooltip: 'Capture Picture',
        label: Row(
          children: [
            IconButton(onPressed: () => _showForm(null), icon: Icon(Icons.save)),
            //IconButton(onPressed: () {}, icon: Icon(Icons.library_add_check)),
             Text('Sincronizar'),
            // Text('2'),
          ],
        ),

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );
  }

  Widget getAppBarUI() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.11,
      decoration: BoxDecoration(
        color: Primary.azul.withOpacity(1),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32.0),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Primary.azul.withOpacity(0.4 * 1),
              offset: const Offset(1.1, 1.1),
              blurRadius: 10.0),
        ],
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 28,
                  width: 28,
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    borderRadius: const BorderRadius.all(
                        Radius.circular(32.0)),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, 'home');
                    },
                    child: Center(
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Liderazgo en packing',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: Primary.fontName,
                        fontWeight: FontWeight.w700,
                        fontSize: 21,
                        letterSpacing: 1.2,
                        color: Primary.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
