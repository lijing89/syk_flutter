import 'package:flutter/material.dart';
import '../common/model/MainModel.dart';
import 'package:scoped_model/scoped_model.dart';
import '../widget/photoScale.dart';
import 'package:video_player/video_player.dart';

class InfoPage extends StatefulWidget {
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollViewController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _scrollViewController = ScrollController(initialScrollOffset: 0.0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: NestedScrollView(
          controller: _scrollViewController,
          headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: Text('Info'),
                pinned: true,
                floating: true,
                forceElevated: boxIsScrolled,
                expandedHeight: 200.0,
                flexibleSpace: Container(
                  child: Image.asset(
                    'assets/images/timg1.jpg',
                    width: double.infinity,
                    repeat: ImageRepeat.repeat,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                bottom: TabBar(
                  controller: _tabController,
                  tabs: <Widget>[
                    Tab(
                      text: "page1",
                      icon: Icon(Icons.filter_1),
                    ),
                    Tab(
                      text: "page2",
                      icon: Icon(Icons.filter_2),
                    ),
                  ],
                ),
              )
            ];
          },
          body: TabBarView(
            children: <Widget>[
              PageOne(),
              PageTwo(),
            ],
            controller: _tabController,
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.control_point),
        //   onPressed: () {
        //     _tabController.animateTo(1,
        //         curve: Curves.bounceInOut,
        //         duration: Duration(milliseconds: 10));
        //     _scrollViewController
        //         .jumpTo(_scrollViewController.position.maxScrollExtent);
        //   },
        // ),
      ),
    );
  }
}

class PageOne extends StatefulWidget {
  @override
  _PageOneState createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  void showPhoto(BuildContext context, f, source) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(title: Text('图片')),
            body: SizedBox.expand(
              child: Hero(
                tag: -1,
                child: new Photo(
                  url: f,
                  source: source,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new GestureDetector(
                onTap: () {
                  showPhoto(context, 'assets/images/timg3.jpg', 1);
                },
                child: Hero(
                  tag: -2,
                  child: Image.asset(
                    'assets/images/timg3.jpg',
                    width: 260.0,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              model.imageData == null
                  ? Text('右侧按钮-->')
                  : new GestureDetector(
                      onTap: () {
                        showPhoto(context, model.imageData, 2);
                      },
                      child: Hero(
                        tag: 2,
                        child: Image.file(
                          model.imageData,
                          width: 260.0,
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}

class PageTwo extends StatefulWidget {
  @override
  _PageTwoState createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  // List ListData = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  VideoPlayerController _controller;
  bool isDownLoad = true;
  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('assets/videos/video.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.initialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
