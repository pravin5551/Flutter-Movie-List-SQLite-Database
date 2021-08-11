import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:movie_list/models/photo.dart';
import 'package:movie_list/utils/database_helper.dart';
import 'package:movie_list/utils/photo_helper.dart';
import 'package:movie_list/utils/util.dart';

class NoteDetail extends StatefulWidget {

	final String appBarTitle;
	final Photo photo;

	NoteDetail(this.photo, this.appBarTitle);

	@override
  State<StatefulWidget> createState() {

    return NoteDetailState(this.photo, this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {


	DatabaseHelper helper = DatabaseHelper();

	String appBarTitle;
	Photo photo;

	TextEditingController titleController = TextEditingController();
	TextEditingController descriptionController = TextEditingController();
	TextEditingController movieimageController = TextEditingController();

	// String imageString;

	NoteDetailState(this.photo, this.appBarTitle);

	@override
  Widget build(BuildContext context) {

		TextStyle textStyle = Theme.of(context).textTheme.title;

		titleController.text = photo.movieTitle;
		descriptionController.text = photo.director;
		movieimageController.text = photo.movieImage;


		return WillPopScope(

	    onWillPop: () {
	    	// Write some code to control things, when user press Back navigation button in device navigationBar
		    moveToLastScreen();
	    },

	    child: Scaffold(
	    appBar: AppBar(
		    // title: Text(appBarTitle),
		    leading: IconButton(icon: Icon(
				    Icons.arrow_back),
				    onPressed: () {
		    	    // Write some code to control things, when user press back button in AppBar
		    	    moveToLastScreen();
				    }
		    ),
	    ),

	    body: Padding(
		    padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
		    child: ListView(
			    children: <Widget>[


						// First Element
						// Image.asset('assets/logos/google.jpg'),

				    //Second Element
						FormHelper.picPicker(
							photo.movieImage,

									(file) => {
								setState(
											() {
												photo.movieImage= file.path;
									},
								)
							},
						),
						btnSubmit(),

				    // Third Element
				    Padding(
					    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					    child: TextField(
						    controller: titleController,
						    style: textStyle,
						    onChanged: (value) {
						    	debugPrint('Something changed in Title Text Field');
						    	updateTitle();
						    },
						    decoration: InputDecoration(
							    labelText: 'Movie Name',
							    labelStyle: textStyle,
							    border: OutlineInputBorder(
								    borderRadius: BorderRadius.circular(5.0)
							    )
						    ),
					    ),
				    ),

						// Fourth Element
						Padding(
							padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
							child: TextField(
								controller: movieimageController,
								style: textStyle,
								onChanged: (value) {
									debugPrint('Something changed in Image link Field');
									updateImage();
								},
								decoration: InputDecoration(
										labelText: 'Movie Image link',
										labelStyle: textStyle,
										border: OutlineInputBorder(
												borderRadius: BorderRadius.circular(5.0)
										)
								),
							),
						),

				    // Fifth Element
				    Padding(
					    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					    child: TextField(
						    controller: descriptionController,
						    style: textStyle,
						    onChanged: (value) {
							    debugPrint('Something changed in Description Text Field');
							    updateDescription();
						    },
						    decoration: InputDecoration(
								    labelText: 'Director name',
								    labelStyle: textStyle,
								    border: OutlineInputBorder(
										    borderRadius: BorderRadius.circular(5.0)
								    )
						    ),
					    ),
				    ),

				    // Sixth Element
				    Padding(
					    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					    child: Row(
						    children: <Widget>[
						    	Expanded(
								    child: RaisedButton(
									    color: Theme.of(context).primaryColorDark,
									    textColor: Theme.of(context).primaryColorLight,
									    child: Text(
										    'Save',
										    textScaleFactor: 1.5,
									    ),
									    onPressed: () {
									    	setState(() {
									    	  debugPrint("Save button clicked");
									    	  _save();
									    	});
									    },
								    ),
							    ),

							    Container(width: 5.0,),

							    Expanded(
								    child: RaisedButton(
									    color: Theme.of(context).primaryColorDark,
									    textColor: Theme.of(context).primaryColorLight,
									    child: Text(
										    'Delete',
										    textScaleFactor: 1.5,
									    ),
									    onPressed: () {
										    setState(() {
											    debugPrint("Delete button clicked");
											    _delete();
										    });
									    },
								    ),
							    ),

						    ],
					    ),
				    ),

			    ],
		    ),
	    ),

    ));
  }

  void moveToLastScreen() {
		Navigator.pop(context, true);
  }


	void updateImage(){
		photo.movieImage = movieimageController.text;
	}

	// Update the title of Note object
  void updateTitle(){
    photo.movieTitle = titleController.text;
  }

	// Update the description of Note object
	void updateDescription() {
		photo.director = descriptionController.text;
	}

	// Save data to database
	void _save() async {

		moveToLastScreen();

		photo.date = DateFormat.yMMMd().format(DateTime.now());
		int result;
		if (photo.id != null) {  // Case 1: Update operation
			result = await helper.updateNote(photo);
		} else { // Case 2: Insert Operation
			result = await helper.insertNote(photo);
		}

		if (result != 0) {  // Success
			_showAlertDialog('Status', 'Movie Saved Successfully');
		} else {  // Failure
			_showAlertDialog('Status', 'Problem Saving Movie');
		}

	}

	void _delete() async {

		moveToLastScreen();

		// Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
		// the detail page by pressing the FAB of NoteList page.
		if (photo.id == null) {
			_showAlertDialog('Status', 'No Movie was deleted');
			return;
		}

		// Case 2: User is trying to delete the old note that already has a valid ID.
		int result = await helper.deletePhoto(photo.id);
		if (result != 0) {
			_showAlertDialog('Status', 'Movie Deleted Successfully');
		} else {
			_showAlertDialog('Status', 'Error Occurred while Deleting Movie');
		}
	}

	void _showAlertDialog(String title, String message) {

		AlertDialog alertDialog = AlertDialog(
			title: Text(title),
			content: Text(message),
		);
		showDialog(
				context: context,
				builder: (_) => alertDialog
		);
	}

	Widget btnSubmit() {
		return new Align(
			alignment: Alignment.center,
			child: InkWell(
				onTap: () {
					updateImage();
				},
				child: Container(
					height: 40.0,
					margin: EdgeInsets.all(10),
					width: 100,
					color: Colors.blueAccent,
					child: Center(
						child: Text(
							"Save Product",
							style: TextStyle(
								color: Colors.white,
								fontWeight: FontWeight.bold,
							),
						),
					),
				),
			),
		);
	}



}










