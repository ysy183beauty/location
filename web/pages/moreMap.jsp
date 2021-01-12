<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Cache-Control" content="no-store" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0;" name="viewport" />
    <title>多点定位</title>
    <link rel="stylesheet" href="css/index.css">
    <link href="css/sweetalert.css" rel="stylesheet" />
    <script src="js/jquery-2.1.1.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="js/jquery.basictable.min.js"></script>
    <script type="text/javascript" src="js/sweetalert.min.js"></script>
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=e3ZohdqyB0RL98hFOiC29xqh"></script>
    <script type="text/javascript">
        var map;
        var points=[];
        var cameraNames=[];
        /**
         * 页面加载完成事件
         */
        $(function () {
            //获取选中的数据信息
            var jsonObj = JSON.parse('${data}');//转换为json对象
            for(var i=0;i<jsonObj.length;i++){
                //保存摄像头名称
                cameraNames.push(jsonObj[i].cameraName);
                //存放经纬度信息
                var p=new BMap.Point(jsonObj[i].lng,jsonObj[i].lat);
                points.push(p);
            }
            createMap();
            createRoute();
        });
        //创建map地图信息
        function createMap() {
            map = new BMap.Map("container");//在百度地图容器中创建一个地图
            map.centerAndZoom('大理',15);//设定地图的中心点和坐标并将地图显示在地图容器中
            map.enableDragging();//启用地图拖拽事件，默认启用(可不写)
            map.enableScrollWheelZoom();//启用地图滚轮放大缩小
            map.enableDoubleClickZoom();//启用鼠标双击放大，默认启用(可不写)
            map.enableKeyboard();//启用键盘上下左右键移动地图
        }
        //创建导航路线
        function createRoute() {
            map.clearOverlays();                        //清除地图上所有的覆盖物
            var driving = new BMap.DrivingRoute(map);    //创建驾车实例
            for(var i=0;i<points.length-1;i++){
                driving.search(points[i], points[i+1]);//创建驾车搜索
            }
            driving.setSearchCompleteCallback(function(){
                var pts = driving.getResults().getPlan(0).getRoute(0).getPath();    //通过驾车实例，获得一系列点的数组
                var polyline = new BMap.Polyline(pts);
                map.addOverlay(polyline);
                //创建3个marker
                for(var i=0;i<points.length;i++){
                    var m= new BMap.Marker(points[i]);
                    map.addOverlay(m);
                    var lab= new BMap.Label(cameraNames[i],{position:points[i]});
                    map.addOverlay(lab);
                }
                setTimeout(function(){
                    map.setViewport(points);          //调整到最佳视野
                },1000);
            });
        }
        //获取达到某个字符第n次出现的位置
        function find(str,cha,num){
            var x=str.indexOf(cha);
            for(var i=0;i<num;i++){
                x=str.indexOf(cha,x+1);
            }
            return x;
        }
    </script>
</head>
<body>
<div style="width:100%;height:600px;" id="container"></div>
</body>
</html>
