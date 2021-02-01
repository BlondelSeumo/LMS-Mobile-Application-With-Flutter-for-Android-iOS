import 'package:eclass/provider/home_data_provider.dart';
import 'package:eclass/zoom/join_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../common/theme.dart' as T;
import 'package:intl/intl.dart';

class ZoomMeetingList extends StatefulWidget {
  ZoomMeetingList(this._visible);
  final bool _visible;
  @override
  _ZoomMeetingListState createState() => _ZoomMeetingListState();
}

class _ZoomMeetingListState extends State<ZoomMeetingList> {

  Widget showShimmer(BuildContext context) {
    return Container(
      height: 260,
      child: ListView.builder(
          itemCount: 10,
          padding: EdgeInsets.symmetric(horizontal: 18.0),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index){
            return Container(
              margin: EdgeInsets.fromLTRB(0, 0.0, 18.0, 0.0),
              width: MediaQuery.of(context).orientation == Orientation.landscape
                  ? 260
                  : MediaQuery.of(context).size.width / 1.8,
              child: Shimmer.fromColors(
                  baseColor: Color(0xFFd3d7de),
                  highlightColor: Color(0xFFe2e4e9),
                  child: Card(
                    elevation: 0.0,
                    color: Color.fromRGBO(45, 45, 45, 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                  )),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    var zoomMeetingList = Provider.of<HomeDataProvider>(context).zoomMeetingList;
    return SliverToBoxAdapter(
      child: widget._visible == true ?
      zoomMeetingList == null ? SizedBox.shrink() : Container(
        height: 260,
        child: ListView.builder(
            itemCount: zoomMeetingList.length,
            padding: EdgeInsets.only(left: 18.0, bottom: 24.0, top: 5.0),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.only(right: 18.0),
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  width: MediaQuery.of(context).orientation == Orientation.landscape
                      ? 260
                      : MediaQuery.of(context).size.width / 1.6,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                          color: Color(0x1c2464).withOpacity(0.30),
                          blurRadius: 16.0,
                          offset: Offset(-13.0, 20.5),
                          spreadRadius: -15.0)
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "${zoomMeetingList[index].meetingTitle}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: mode.txtcolor,
                          fontWeight: FontWeight.w700,
                          fontSize: 20),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      zoomMeetingList[index].agenda == null ? SizedBox.shrink() : Text("${zoomMeetingList[index].agenda}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: mode.txtcolor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600
                      ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Text("Meeting Id: ",
                            maxLines: 2,
                            style: TextStyle(
                                color: mode.txtcolor,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                          Text("${zoomMeetingList[index].meetingId}",
                            maxLines: 2,
                            style: TextStyle(
                                color: mode.txtcolor,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Text("Starting at:",  style: TextStyle(
                              color: mode.txtcolor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500
                          ),
                          ),
                          SizedBox(width: 5,),
                          Text(" ${DateFormat('dd-MM-yyyy | hh:mm').format(DateTime.parse("${zoomMeetingList[index].startTime}"))}",  style: TextStyle(
                              color: mode.easternBlueColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600
                          ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5,),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         RaisedButton(
                             shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(4.0)
                             ),
                             color: mode.easternBlueColor,
                             onPressed: (){
                               Navigator.push(context, MaterialPageRoute(builder: (context) => JoinWidget(),
                               ));
                             }, child: Text("Join Meeting", style: TextStyle(color: Colors.white),
                         ))
                       ],
                     )
                    ],
                  ),
                ),
              );
            }),
      ) : showShimmer(context),
    );
  }
}
