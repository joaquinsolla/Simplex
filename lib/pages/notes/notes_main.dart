import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:simplex/classes/note.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';
import 'package:simplex/services/firestore_service.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class NotesMainPage extends StatefulWidget {
  const NotesMainPage({Key? key}) : super(key: key);

  @override
  _NotesMainPageState createState() => _NotesMainPageState();
}

class _NotesMainPageState extends State<NotesMainPage> {
  final ScrollController _scrollController = ScrollController();
  FocusNode keywordsFocusNode = FocusNode();
  final keywordsController = TextEditingController();
  String keywords = '';
  bool showSearchbar = false;

  @override
  void dispose() {
    super.dispose();
    keywordsController.dispose();
  }

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    IconData searcherIcon = Icons.search_rounded;
    if (showSearchbar==true) searcherIcon = Icons.search_off_rounded;

    return HomeAreaWithSearchbar(_scrollController, showSearchbar,
        HomeHeader('Notas', [
          IconButton(
            icon: Icon(searcherIcon,
                color: colorSpecialItem, size: deviceWidth * 0.085),
            splashRadius: 0.001,
            onPressed: () {
              setState(() {
                showSearchbar=!showSearchbar;
                keywordsController.clear();
                keywords='';
                if (showSearchbar) keywordsFocusNode.requestFocus();
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.add_rounded,
                color: colorSpecialItem, size: deviceWidth * 0.085),
            splashRadius: 0.001,
            onPressed: () {
              Navigator.pushNamed(context, '/notes/add_note');
            },
          ),
          ]),
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            Container(
              width: deviceWidth*0.65,
              child: TextField(
                focusNode: keywordsFocusNode,
                controller: keywordsController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.search,
                maxLines: 1,
                style: TextStyle(color: colorMainText),
                decoration: InputDecoration(
                  fillColor: colorThirdBackground,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colorThirdBackground, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: colorSpecialItem, width: 2),
                  ),

                  hintText: 'Buscar notas...',
                  hintStyle: TextStyle(color: colorThirdText, fontStyle: FontStyle.italic),
                ),
                onChanged: (text){
                  setState(() {
                    keywords=text;
                  });
                },
              ),
            ),
            SizedBox(width: deviceWidth*0.015,),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: colorSecondBackground,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [ SizedBox(
                  //width: deviceWidth*0.1,
                  height: deviceHeight*0.07,
                  child: TextButton(
                    child: Text(
                      'Borrar',
                      style: TextStyle(
                          color: colorSpecialItem,
                          fontSize: deviceWidth * fontSize * 0.035,
                          fontWeight: FontWeight.normal),
                    ),
                    onPressed: (){
                      setState(() {
                        keywords='';
                        keywordsController.clear();
                        keywordsFocusNode.unfocus();
                      });
                    },
                  ),
                ),],
              ),
            ),
          ],),
        FooterEmpty(),
        [
          StreamBuilder<List<Note>>(
              stream: readNotesByTitle(keywords.trim()),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  debugPrint('[ERR] Cannot load notes: ' + snapshot.error.toString());
                  return ErrorContainer('No se pueden cargar las notas.', 0.75);
                }
                else if (snapshot.hasData) {
                  final notes = snapshot.data!;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (notes.length == 0 && keywords=='') NoItemsContainer('notas', 0.65),

                      if (notes.length == 0 && keywords!='') NoResultsContainer(0.65),

                      MasonryGridView.count(
                          padding: EdgeInsets.zero,
                          physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
                          shrinkWrap: true,
                          itemCount: notes.length,
                          crossAxisCount: 2,

                          itemBuilder: (context, index) {
                            return notes.map(buildNoteCard).toList()[index];
                          }),

                      if (notes != 0) SizedBox(height: deviceHeight*0.01,),
                      if (notes != 0) Container(
                        alignment: Alignment.center,
                        child: IconButton(
                          icon: Icon(Icons.arrow_circle_up_rounded,
                              color: colorSpecialItem, size: deviceWidth * 0.08),
                          splashRadius: 0.001,
                          onPressed: () async {
                            await Future.delayed(const Duration(milliseconds: 100));
                            SchedulerBinding.instance.addPostFrameCallback((_) {
                              _scrollController.animateTo(
                                  _scrollController.position.minScrollExtent,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.fastOutSlowIn);
                            });
                          },
                        ),
                      ),
                    ],
                  );
                }
                else return LoadingContainer('Cargando tus notas...', 0.75);
              }),
        ]
    );
  }

  Widget buildNoteCard(Note note){

    late int color;
    if (darkMode == false) {
      color = 0xFFFFFFFF;
    } else {
      color = 0xff1c1c1f;
    }

    Color secondColor = colorSecondText;
    Color iconColor = colorSpecialItem;
    Color backgroundColor = colorThirdBackground;
    if (darkMode) backgroundColor = colorSecondBackground;

    return FocusedMenuHolder(
      onPressed: (){
        selectedNote = note;
        Navigator.pushNamed(context, '/notes/note_details');
      },
      menuItems: <FocusedMenuItem>[
        FocusedMenuItem(
          backgroundColor: backgroundColor,
          title: Container(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.input_rounded, color: colorSpecialItem, size: deviceWidth * 0.06),
                SizedBox(width: deviceWidth*0.025,),
                Text('Ver detalles', style: TextStyle(
                    color: colorSpecialItem,
                    fontSize: deviceWidth * fontSize * 0.04,
                    fontWeight: FontWeight.normal),),
              ],
            ),
          ),
          onPressed: (){
            selectedNote = note;
            Navigator.pushNamed(context, '/notes/note_details');
          },
        ),
        FocusedMenuItem(
          backgroundColor: backgroundColor,
          title: Container(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.edit, color: colorSpecialItem, size: deviceWidth * 0.06),
                SizedBox(width: deviceWidth*0.025,),
                Text('Editar', style: TextStyle(
                    color: colorSpecialItem,
                    fontSize: deviceWidth * fontSize * 0.04,
                    fontWeight: FontWeight.normal),),
              ],
            ),
          ),
          onPressed: (){
            selectedNote = note;
            Navigator.pushNamed(context, '/notes/edit_note');
          },
        ),
        FocusedMenuItem(
          backgroundColor: backgroundColor,
          title: Container(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.share_rounded, color: colorSpecialItem, size: deviceWidth * 0.06),
                SizedBox(width: deviceWidth*0.025,),
                Text('Compartir', style: TextStyle(
                    color: colorSpecialItem,
                    fontSize: deviceWidth * fontSize * 0.04,
                    fontWeight: FontWeight.normal),),
              ],
            ),
          ),
          onPressed: (){
            // selectedTodo = todo;
            // TODO: SHARE
          },
        ),
        FocusedMenuItem(
          backgroundColor: backgroundColor,
          title: Container(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete_outline_rounded, color: Colors.red, size: deviceWidth * 0.06),
                SizedBox(width: deviceWidth*0.025,),
                Text('Eliminar', style: TextStyle(
                    color: Colors.red,
                    fontSize: deviceWidth * fontSize * 0.04,
                    fontWeight: FontWeight.normal),),
              ],
            ),
          ),
          onPressed: (){
            showDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text('Eliminar nota'),
                    content: Text('Una vez eliminada no podrás restaurarla.'),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () async {
                            await cancelNoteNotification(note.id);
                            await deleteNoteById(note.id);
                            Navigator.pop(context);
                            showSnackBar(context, 'Nota eliminada', Colors.green);
                          },
                          child: Text('Eliminar', style: TextStyle(color: colorSpecialItem),)),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancelar', style: TextStyle(color: Colors.red),),
                      )
                    ],
                  );
                });
          },
        ),
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
                      fontSize: deviceWidth * fontSize * 0.04,
                      fontWeight: FontWeight.bold)
              ),
              if (note.name == '') Text('Sin título',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: colorSecondText,
                      fontSize: deviceWidth * fontSize * 0.04,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic)
              ),

              SizedBox(height: deviceHeight*0.01,),
              if (note.content != '') Text(note.content,
                  maxLines: 8,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                      color: colorMainText,
                      fontSize: deviceWidth * fontSize * 0.03,
                      fontWeight: FontWeight.normal)
              ),
              if (note.content == '') Text('Sin contenido',
                  style: TextStyle(
                      color: colorSecondText,
                      fontSize: deviceWidth * fontSize * 0.03,
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
                          fontSize: deviceWidth * fontSize * 0.025,
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

