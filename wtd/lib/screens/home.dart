import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/home_controller.dart';
import '../constants/colors.dart';

class Home extends StatefulWidget {
      Home({Key? key}) : super(key: key);
      static const routeName='/home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeController _controller= Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    _controller.loadToDoItemListData();
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15),
            child: Column(
              children: [
                searchBox(),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text('All ToDos',
                    style: TextStyle(
                        fontSize: 30,
                        color: tdBlack
                    ) ,),
                ),
                Expanded(
                  child: Obx(()=>ListView.builder(
                    itemCount: _controller.todoList.length,
                    itemBuilder: (context, index) => Container(
                      margin: EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            onTap: (){
                              setState(() {
                                if(_controller.todoList[index].isDone==false){
                                  _controller.todoList[index].isDone=true;
                                  //_controller.updateToDoItemByIndex(index, todo!);
                                }else{
                                  _controller.todoList[index].isDone=false;
                                  //_controller.updateToDoItemByIndex(index, todo!);
                                }
                              });
                            },
                            tileColor: Colors.white,
                            leading: _controller.todoList[index].isDone!?Icon(Icons.check_box, color: tdBlue,):Icon(Icons.check_box_outline_blank, color: tdBlue,),
                            trailing: IconButton(
                              onPressed: () {
                                _controller.deleteDataByIndex(index);
                              },
                              icon: Icon(Icons.delete, color: tdRed,),),
                            title: Text(_controller.todoList[index].todoText.toString(),
                              style: TextStyle(
                                decoration: _controller.todoList[index].isDone!? TextDecoration.lineThrough:null
                              ) ,),
                          )
                        ],
                      ),
                    ),
                  ))
                )
              ],
            )
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                    child: Container(
                     margin: EdgeInsets.only(
                      bottom: 20,
                      right: 20,
                      left: 20
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0,0.0),
                      blurRadius: 10.0,
                      spreadRadius: 0
                    )],
                    borderRadius: BorderRadius.circular(10)
                  ),
                      child: TextField(
                        controller: _controller.todoController,
                        decoration: InputDecoration(
                          hintText: 'Add a new todo item',
                          border: InputBorder.none,
                        ),
                      ),
                )),
                Container(
                  margin: EdgeInsets.only(
                      bottom: 20,
                      right: 20
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: tdBlue,
                      minimumSize: Size(60,60),
                      elevation: 10
                    ),
                    onPressed: () {
                      if(_controller.todoController.text.isEmpty){
                        Get.showSnackbar(
                          const GetSnackBar(
                            message:'Please Add Your Task Here',
                            icon: Icon(Icons.announcement, color: Colors.white,),
                            duration: Duration(seconds: 2),
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: tdBlack,
                            margin: EdgeInsets.all(20),
                            borderRadius: 10,
                          ),
                        );
                      }else{
                        _controller.addToDoItem();
                        Get.showSnackbar(
                          const GetSnackBar(
                            message: 'Task Added Successfully!',
                            snackPosition: SnackPosition.BOTTOM,
                            duration: Duration(seconds: 2),
                            backgroundColor: tdBlack,
                            margin: EdgeInsets.all(20),
                            borderRadius: 10,
                            icon: Icon(Icons.done, color: Colors.white,),
                          ),
                        );
                      }
                    },
                    child: Text('+',
                      style: TextStyle(
                        fontSize: 40
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:[
          Icon(
            Icons.menu,
            color: tdBlack,
            size: 30,
          ),
          Container(
            height: 40,
            width: 40,
            child: ClipRect(
              child: Image.asset('assets/images/wtd-logo.png'),
            ),
          )
        ],
      ),
    );
  }
  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
      ),
      child: TextField(
        //onChanged: (value)=> _searchToDo(value),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
            prefixIcon: Icon(
              Icons.search,
              color: tdBlack,
              size: 20,
            ),
            prefixIconConstraints: BoxConstraints(
                maxHeight: 20,
                minWidth: 25
            ),
            border: InputBorder.none,
            hintText: 'Search',
            hintStyle: TextStyle(color: tdGrey)
        ),
      ),
    );
  }
  // void _deleteTodoItem(String id){
  //   setState(() {
  //     todoList.removeWhere((item) => item.id==id);
  //   });
  // }

  // void _searchToDo(String enteredKeyword){
  //   List <ToDo> results=[];
  //   if(enteredKeyword.isEmpty){
  //     results=todoList;
  //   }else{
  //     results=todoList
  //         .where((item) => item.todoText!
  //         .toLowerCase()
  //         .contains(enteredKeyword.toLowerCase()))
  //         .toList();
  //   }
  //   setState(() {
  //     _foundTodo=results;
  //   });
  // }
}
