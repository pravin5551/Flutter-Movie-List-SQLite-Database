
class Photo {

	int _id;
	String _movieTitle;
	String _director;
	String _date;


	Photo(this._movieTitle, this._date,  [this._director]);//square bracket for keeping description a optional

	Photo.withId(this._id, this._movieTitle, this._date,  [this._director]);

	int get id => _id;

	String get title => _movieTitle;

	String get description => _director;

	// String get image => _image;

	String get date => _date;

	//Here i'm giving priority that length of title should be less than 255 characters
	set title(String newTitle) {
		if (newTitle.length <= 255) {
			this._movieTitle = newTitle;
		}
	}

	set description(String newDescription) {
		if (newDescription.length <= 255) {
			this._director = newDescription;
		}
	}

	// set image(String newImage) {
	//
	// 		this._image = newImage;
	// }

	set date(String newDate) {
		this._date = newDate;
	}

	// Convert a Note object into a Map object
	Map<String, dynamic> toMap() {

		var map = Map<String, dynamic>();
		if (id != null) {
			map['id'] = _id;
		}
		map['title'] = _movieTitle;
		map['description'] = _director;
		// map['image'] = _image;
		map['date'] = _date;

		return map;
	}

	// Extract a Note object from a Map object
	Photo.fromMapObject(Map<String, dynamic> map) {
		this._id = map['id'];
		this._movieTitle = map['title'];
		this._director = map['description'];
		// this._image = map['image'];
		this._date = map['date'];
	}
}









