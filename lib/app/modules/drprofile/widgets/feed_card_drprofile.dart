import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:encontrarCuidado/app/modules/main/main_store.dart';
import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../drprofile_store.dart';
import 'report.dart';

class FeedCardProfile extends StatefulWidget {
  final String name;
  final String status;
  final String postId;
  final String avatar;
  final String speciality;
  final String description;
  final String imageUrl;
  final String timeAgo;
  final String likes;
  final String doctorId;
  final bool routerSearch;

  const FeedCardProfile({
    Key key,
    this.name,
    this.speciality,
    this.description,
    this.imageUrl,
    this.avatar,
    this.timeAgo,
    this.postId,
    this.status,
    this.likes,
    this.doctorId,
    this.routerSearch,
  }) : super(key: key);

  @override
  _FeedCardProfileState createState() => _FeedCardProfileState();
}

class _FeedCardProfileState extends State<FeedCardProfile> {
  final DrProfileStore store = Modular.get();
  final MainStore mainStore = Modular.get();
  bool report = false, connected = false, liked = false;

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    return Observer(
      builder: (context) {
        return store.mapReport[widget.postId] == false ||
                store.mapReport[widget.postId] == null
            ? StatefulBuilder(
                builder: (context, stateSet) {
                  return Stack(
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          if (report == true) {
                            stateSet(() {
                              report = false;
                            });
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              top: maxWidth * .04,
                              left: maxWidth * .05,
                              right: maxWidth * .05,
                              bottom: maxWidth * .02),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 10, left: 6),
                                child: Row(
                                  children: [
                                    StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection('doctors')
                                            .doc(widget.doctorId)
                                            .snapshots(),
                                        builder:
                                            (context, snapshotDoctorConnected) {
                                          if (snapshotDoctorConnected.hasData) {
                                            DocumentSnapshot doctorDoc =
                                                snapshotDoctorConnected.data;

                                            connected =
                                                doctorDoc['connected'] ||
                                                    doctorDoc[
                                                        'connected_secretary'];
                                          }
                                          return Row(
                                            children: [
                                              Stack(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage: widget
                                                                .avatar ==
                                                            null
                                                        ? AssetImage(
                                                            'assets/img/defaultUser.png')
                                                        : NetworkImage(
                                                            widget.avatar),
                                                    backgroundColor:
                                                        Colors.white,
                                                    radius: maxWidth * .06,
                                                  ),
                                                  Positioned(
                                                    bottom: 0,
                                                    right: 1,
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5),
                                                      height: 13,
                                                      width: 13,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color: connected
                                                            ? Color(0xff00B5AA)
                                                            : Colors.red,
                                                        border: Border.all(
                                                          width: 2,
                                                          color:
                                                              Color(0xfffafafa),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 3,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: wXD(240, context),
                                                    child: Text(
                                                      widget.name,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontSize:
                                                            maxWidth * .036,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xff484D54),
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        widget.speciality ==
                                                                null
                                                            ? 'Médico'
                                                            : widget.speciality,
                                                        style: TextStyle(
                                                          fontSize:
                                                              maxWidth * .036,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color:
                                                              Color(0xff484D54),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 5),
                                                        height: 5,
                                                        width: 5,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          color:
                                                              Color(0xff707070),
                                                        ),
                                                      ),
                                                      Text(
                                                        widget.timeAgo,
                                                        style: TextStyle(
                                                          fontSize:
                                                              maxWidth * .036,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color:
                                                              Color(0xff787C81),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        }),
                                    Spacer(),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        stateSet(() {
                                          report = !report;
                                        });
                                      },
                                      child: Container(
                                          alignment: Alignment.centerRight,
                                          width: wXD(40, context),
                                          height: wXD(40, context),
                                          child: Icon(Icons.more_vert)),
                                    ),
                                  ],
                                ),
                              ),
                              Center(
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * .3,
                                  width: MediaQuery.of(context).size.width * .9,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(18),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: widget.imageUrl,
                                      placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                              'assets/img/defaultUser.png'),
                                    ),
                                  ),
                                ),
                              ),
                              widget.routerSearch
                                  ? SizedBox(
                                      height: 10,
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('patients')
                                              .doc(store.authStore.user.uid)
                                              .collection('feed')
                                              .where('id',
                                                  isEqualTo: widget.postId)
                                              .snapshots(),
                                          builder:
                                              (context, snapshotFeedLiked) {
                                            if (snapshotFeedLiked.hasData) {
                                              QuerySnapshot feedQuery =
                                                  snapshotFeedLiked.data;

                                              if (feedQuery.docs.isNotEmpty) {
                                                DocumentSnapshot feedDoc =
                                                    feedQuery.docs.first;

                                                liked = feedDoc['liked'];
                                              }
                                            }
                                            return Row(
                                              children: [
                                                InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () {
                                                    store.toLike(widget.postId,
                                                        widget.doctorId);
                                                  },
                                                  child: Container(
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          liked
                                                              ? Icons.favorite
                                                              : Icons
                                                                  .favorite_border,
                                                          color: liked
                                                              ? Colors.red[900]
                                                              : Color(
                                                                  0xff484D54),
                                                        ),
                                                        SizedBox(
                                                          width: 9,
                                                        ),
                                                        Text(
                                                          'Curtir',
                                                          style: TextStyle(
                                                            fontSize:
                                                                maxWidth * .036,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Color(
                                                                0xff484D54),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 11,
                                                ),
                                              ],
                                            );
                                          })),
                              ExpandableText(
                                widget.description,
                                style: TextStyle(
                                    fontSize: maxWidth * .035,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff484D54)),
                                prefixText: "${widget.name}: ",
                                prefixStyle: TextStyle(
                                  fontSize: maxWidth * .036,
                                  fontWeight: FontWeight.bold,
                                ),
                                expandText: 'mais',
                                collapseText: 'menos',
                                maxLines: 3,
                                linkEllipsis: false,
                                linkColor: Colors.blue,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: maxWidth * .08,
                        right: maxWidth * .1,
                        child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            setState(() {
                              report = false;
                            });
                            print('widget.postId: ${widget.postId}');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    Report(postId: widget.postId),
                              ),
                            );
                          },
                          child: Container(
                            height: report ? maxWidth * .1 : 0,
                            width: report ? maxWidth * .4 : 0,
                            decoration: BoxDecoration(
                              color: Color(0xfffafafa),
                              borderRadius: BorderRadius.all(
                                Radius.circular(13),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0x29000000),
                                  offset: Offset(0, 3),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Reportar postagem',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: report ? maxWidth * .035 : 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )
            : Container(
                margin: EdgeInsets.only(
                    top: maxWidth * .04,
                    left: maxWidth * .05,
                    right: maxWidth * .05,
                    bottom: maxWidth * .02),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(13),
                  ),
                  color: Color(0xffEEEDED),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x29000000),
                      offset: Offset(0, 3),
                      blurRadius: 6,
                    ),
                  ],
                ),
                height: 80,
                width: maxWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(
                      flex: 5,
                    ),
                    Icon(
                      Icons.check_circle,
                      color: Color(0xff41C3B3),
                      size: maxWidth * .07,
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    Text(
                      'Agradecemos o aviso',
                      style: TextStyle(
                        fontSize: maxWidth * .04,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff484D54),
                      ),
                    ),
                    Spacer(
                      flex: 5,
                    ),
                  ],
                ),
              );
      },
    );
  }
}
