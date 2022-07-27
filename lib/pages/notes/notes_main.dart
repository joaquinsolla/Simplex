import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:simplex/classes/note.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/services/firestore_service.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class NotesMainPage extends StatefulWidget {
  const NotesMainPage({Key? key}) : super(key: key);

  @override
  _NotesMainPageState createState() => _NotesMainPageState();
}

class _NotesMainPageState extends State<NotesMainPage> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return homeArea([
      homeHeaderDouble(
        'Notas',
        IconButton(
          icon: Icon(Icons.help_outline_rounded,
              color: colorSpecialItem, size: deviceWidth * 0.085),
          splashRadius: 0.001,
          onPressed: () {
            snackBar(context, '[Beta] En desarrollo', colorSpecialItem);
            //TODO
            //Navigator.pushNamed(context, '/notes/notes_help');
          },
        ),
        IconButton(
          icon: Icon(Icons.add_rounded,
              color: colorSpecialItem, size: deviceWidth * 0.085),
          splashRadius: 0.001,
          onPressed: () {
            snackBar(context, '[Beta] En desarrollo', colorSpecialItem);
          },
        ),
      ),

      StreamBuilder<List<Note>>(
          stream: readAllNotes(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              debugPrint('[ERR] Cannot load notes: ' + snapshot.error.toString());
              return errorContainer('No se pueden cargar las notas.', 0.75);
            }
            else if (snapshot.hasData) {
              final notes = snapshot.data!;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (notes.length == 0 && darkMode==true) Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Container(
                      width: deviceWidth * 0.85,
                      alignment: Alignment.center,
                      child: Image.asset('assets/todo_preview_dark.png',
                        scale: deviceWidth * 0.0001,),
                    ),],
                  ),
                  if (notes.length == 0 && darkMode==false) Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Container(
                      width: deviceWidth * 0.85,
                      alignment: Alignment.center,
                      child: Image.asset('assets/todo_preview_light.png',
                        scale: deviceWidth * 0.0001,),
                    ),],
                  ),

                  MasonryGridView.count(
                  shrinkWrap: true,
                  itemCount: notes.length,
                  crossAxisCount: 2,

                  itemBuilder: (context, index) {
                    // display each item with a card
                    return notes.map(buildNoteCard).toList()[index];

                    //Wrap(children: notes.map(buildNoteCard).toList(),)

                  }),
                ],
              );
            }
            else return loadingContainer('Cargando tus notas...', 0.75);

          }),

    ]);

  }

  Widget buildNoteCard(Note note){

    late int color;
    if (darkMode == false) {
      color = 0xFFFFFFFF;
    } else {
      color = 0xff1c1c1f;
    }

    Color backgroundColor = colorThirdBackground;
    if (darkMode) backgroundColor = colorSecondBackground;
    Color secondColor = colorSecondText;
    Color iconColor = colorSpecialItem;

    return FocusedMenuHolder(
      onPressed: (){
        selectedNote = note;
        Navigator.pushNamed(context, '/todos/todo_details');
      },
      menuItems: <FocusedMenuItem>[

        //TODO

      ],
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Color(color),

        child: Container(
          padding: EdgeInsets.all(deviceWidth*0.02),
          width: deviceWidth*0.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              if (note.name != '') Text(note.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: colorMainText,
                      fontSize: deviceWidth * 0.04,
                      fontWeight: FontWeight.bold)
              ),
              if (note.name == '') Text('Sin título',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: colorSecondText,
                      fontSize: deviceWidth * 0.04,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic)
              ),

              SizedBox(height: deviceHeight*0.01,),
              if (note.content != '') Text(note.content,
                  maxLines: 8,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: colorMainText,
                      fontSize: deviceWidth * 0.03,
                      fontWeight: FontWeight.normal)
              ),
              if (note.content == '') Text('Sin contenido',
                  style: TextStyle(
                      color: colorSecondText,
                      fontSize: deviceWidth * 0.03,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic)
              ),
              Divider(color: secondColor,),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  Icon(Icons.edit_note_rounded, color: iconColor, size: deviceWidth*0.04,),
                  SizedBox(width: deviceWidth*0.01,),
                  Text('Editado: ' + dateToString(note.modificationDate),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: colorSecondText,
                          fontSize: deviceWidth * 0.025,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic)
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}

