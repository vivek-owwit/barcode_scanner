// Model Class for Sqiflite

class Note {

  // _variables are private to our own libraries
  int _Sequence;
  String _description;

  //Constructor to create our note Object
  Note(this._description);

  // Named Constructor
  Note.withSeq(this._Sequence);

  // define getter for variables
  int get Seq => _Sequence;
  String get description => _description;

  // define setter for variables except Sequence as it is automatically generated in database
  set description(String newdescription){
    this._description = newdescription;
  }

  // Convert a Note object  into a Map object
  Map<String, dynamic> toMap() {
    //create empty map object
    var map = Map<String, dynamic>();
    //insert scan description  in map object with key of description
    map['description'] = _description;
    // for Seq check for Null
    if(Seq != null){
      map['Seq'] = _Sequence;
    }

  }

  // Extract a Note object from a Map object
  Note.fromMapObject(Map<String, dynamic> map){
    this._Sequence = map['Seq'];
    this._description = map['description'];
  }
}