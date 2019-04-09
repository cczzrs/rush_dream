
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

import 'package:rush_dream/page/widget/home_drawer.dart';


class V1Widget extends StatelessWidget {
    final String s;
    final Color color;
    const V1Widget({ Key key , this.s, this.color=Colors.white}) : super(key: key);
    
    @override
    Widget build(BuildContext context) {
        //这里返回你需要的控件
        //这里末尾有没有的逗号，对于格式化代码而已是不一样的。
        return Container(
            //白色背景
            color: color,
            //Dart语法中，?? 表示如果text为空，就返回尾号后的内容。
            child: Text(this.s ?? "这就是无状态DMEO"),
        );
    }
}


class V2Widget extends StatelessWidget {
    
    // v1：将默认应用移动到具有固定名称的单独功能
    //添加变换小部件，旋转和透视
    Offset _offset = Offset(0.4, 0.7); // new
    @override
    Widget build(BuildContext context) {
        return Transform(
                // Transform widget
                transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001) // perspective
                    ..rotateX(_offset.dy)
                    ..rotateY(_offset.dx),
                alignment: FractionalOffset.center,
                child: new V1Widget(s:"3D testing"),
        );
    }
}

class V3Widget<T> extends StatefulWidget {
    static final String sName = "myhome";
    @override
    _FlipPanelState createState() => _FlipPanelState();
}

enum FlipDirection { up, down }

class _FlipPanelState extends State<V3Widget>
        with TickerProviderStateMixin {
    AnimationController _controller;
    Duration duration;
    FlipDirection action = FlipDirection.up;
    final _perspective = 0.003;
    final _zeroAngle = 0.0001;
    
    @override
    void initState() {
        super.initState();
        _controller = new AnimationController(duration: duration, vsync: this)
            ..addStatusListener((status) {
                if (status == AnimationStatus.completed) {
                    _controller.reverse();
                }
                if (status == AnimationStatus.dismissed) {
                }
            })
            ..addListener(() {
                setState(() {
                });
            });
    }
    
    @override
    Widget build(BuildContext context) {
        return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                _buildUpperFlipPanel(),
                Padding(
                    padding: EdgeInsets.only(top: 1.0),
                ),
//                _buildLowerFlipPanel(),
            ],
        );
    }


    Widget _buildUpperFlipPanel() => action == FlipDirection.up
            ? Stack(
        children: [
            Transform(
                    alignment: Alignment.bottomCenter,
                    transform: Matrix4.identity()
                        ..setEntry(3, 2, _perspective)
                        ..rotateX(_zeroAngle),
                    child: new HomeDrawer(),
            ),
        ],
    )
            : Stack(
        children: [
            Transform(
                    alignment: Alignment.bottomCenter,
                    transform: Matrix4.identity()
                        ..setEntry(3, 2, _perspective)
                        ..rotateX(_zeroAngle),
                child: new HomeDrawer(),
            ),
        ],
    );
}