import 'dart:async';
import 'package:flutter/material.dart';
import 'package:movie_list/models/photo.dart';
import 'package:movie_list/screens/photo_detail.dart';
import 'package:movie_list/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';


class NoteList extends StatefulWidget {

	@override
  State<StatefulWidget> createState() {

    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {

	DatabaseHelper databaseHelper = DatabaseHelper();
	List<Photo> noteList;
	int count = 0;

	@override
  Widget build(BuildContext context) {

		if (noteList == null) {
			noteList = List<Photo>();
			updateListView();
		}

    return Scaffold(

	    appBar: AppBar(
		    title: Text('Yellow Class Assignment'),
	    ),

	    body: getNoteListView(),

	    floatingActionButton: FloatingActionButton(
		    onPressed: () {
		      debugPrint('FAB clicked');
		      navigateToDetail(Photo('', ''), 'Add Movie');
		    },

		    tooltip: 'Add Movie',

		    child: Icon(Icons.add),

	    ),
    );
  }

  ListView getNoteListView() {

		TextStyle titleStyle = Theme.of(context).textTheme.subhead;

		return ListView.builder(
			itemCount: count,
			itemBuilder: (BuildContext context, int position) {
				return Card(
					color: Colors.white,
					elevation: 2.0,
					child: ListTile(

						leading: CircleAvatar(
							backgroundColor: Colors.yellow,			//getPriorityColor(this.noteList[position].priority),
							child:Image.asset("assets/logos/google.jpg"),						//getPriorityIcon(this.noteList[position].priority),

						),

						title: Text(this.noteList[position].movieTitle, style: titleStyle,),

						subtitle: Text(this.noteList[position].date),

						trailing: GestureDetector(
							child: Icon(Icons.delete, color: Colors.grey,),
							onTap: () {
								_delete(context, noteList[position]);
							},
						),


						onTap: () {
							debugPrint("MovieTile Tapped");
							navigateToDetail(this.noteList[position],'Edit Movie');
						},

					),
				);
			},
		);
  }



	void _delete(BuildContext context, Photo note) async {

		int result = await databaseHelper.deleteNote(note.id);
		if (result != 0) {
			_showSnackBar(context, 'Movie Deleted Successfully');
			updateListView();
		}
	}

	void _showSnackBar(BuildContext context, String message) {

		final snackBar = SnackBar(content: Text(message));
		Scaffold.of(context).showSnackBar(snackBar);
	}

  void navigateToDetail(Photo photo, String title) async {
	  bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
		  return NoteDetail(photo, title);
	  }));

	  if (result == true) {
	  	updateListView();
	  }
  }

  void updateListView() {

		final Future<Database> dbFuture = databaseHelper.initializeDatabase();
		dbFuture.then((database) {

			Future<List<Photo>> noteListFuture = databaseHelper.getNoteList();
			noteListFuture.then((noteList) {
				setState(() {
				  this.noteList = noteList;
				  this.count = noteList.length;
				});
			});
		});
  }
}







