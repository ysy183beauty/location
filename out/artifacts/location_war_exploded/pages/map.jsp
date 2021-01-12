<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Cache-Control" content="no-store" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0;" name="viewport" />
    <title>路线导航信息</title>
    <link rel="stylesheet" href="css/index.css">
    <link href="css/sweetalert.css" rel="stylesheet" />
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=e3ZohdqyB0RL98hFOiC29xqh"></script>
    <script src="js/jquery-2.1.1.min.js" type="text/javascript"></script>
    <script src="js/sweetalert.min.js"></script>
    <script type="text/javascript">
        var orginLng="";
        var orginLat="";
        var localSearch;
        function initMap(){
            createMap();//创建地图
            setMapEvent();//设置地图事件
        }
        //创建地图函数：
        function createMap(){
            var map = new BMap.Map("BaiduDitu");//在百度地图容器中创建一个地图
            map.centerAndZoom('大理',15);//设定地图的中心点和坐标并将地图显示在地图容器中
            window.map = map;//将map变量存储在全局
        }
        //地图事件设置函数：
        function setMapEvent(){
            map.enableDragging();//启用地图拖拽事件，默认启用(可不写)
            map.enableScrollWheelZoom();//启用地图滚轮放大缩小
            map.enableDoubleClickZoom();//启用鼠标双击放大，默认启用(可不写)
            map.enableKeyboard();//启用键盘上下左右键移动地图
            localSearch = new BMap.LocalSearch(map);
        }
        $(function(){
            initMap();//创建和初始化地图
            createSearch();
            createAutocomlete();
            $("#s_p_search_btn").click(function () {
                searchPlace($("#searchplace").val());
            });
        });
        function createSearch() {
            var map = window.map;
            var local = new BMap.LocalSearch(map,
                {
                    renderOptions: { map: map, panel: "searchlist" }
                });
            window.local = local;
        }
        //搜索
        function searchPlace(value) {
            window.local.search(value);
        }
        function createAutocomlete() {
            var map = window.map;
            var ac = new BMap.Autocomplete(    //建立一个自动完成的对象
                {
                    "input": "searchplace",
                    "location": map
                });
            ac.addEventListener("onconfirm", function (e) {    //鼠标点击下拉列表后的事件
                var _value = e.item.value;
                var addr =_value.business+ _value.province + _value.city + _value.district + _value.street + _value.streetNumber ;
                searchPlace(addr);
                searchByStationName();
                $("#searchlist").css("display","none");//隐藏下拉框内容信息
            });
        }
        //点击导航按钮信息
        function changeInfo(){
            //判断初始位置是否选择了
            var searchplace=$("#searchplace").val();
            if(searchplace==""){
                swal({
                    title : "请输入起始位置！",
                    type : "error",
                    confirmButtonText : "确定",
                    closeOnConfirm : false
                });
                return;
            }
            var lngLat=$("#targetLngLat").val();
            var destinationLng=lngLat.split(",")[0];
            var destinationLat=lngLat.split(",")[1];
            var str="http://api.map.baidu.com/direction?";
            str+="origin="+orginLat+","+orginLng+"";
            str+="&destination="+destinationLat+","+destinationLng+"";
            str+="&mode=driving&region=大理&output=html";
            window.location.href=str;
        }

        function searchByStationName() {
            var keyword = document.getElementById("searchplace").value;
            localSearch.setSearchCompleteCallback(function (searchResult) {
                var poi = searchResult.getPoi(0);
                orginLng=poi.point.lng;
                orginLat=poi.point.lat;
                map.centerAndZoom(poi.point, 13);
            });
            localSearch.search(keyword);
        }
        function doReturn() {
           window.location.href="/toList";
        }
    </script>
</head>
<body class="easyui-layout">
<div class="Ditumap">
    <div style="margin-bottom:10px;">
        <table>
            <tr>
                <td>起始位置：</td>
                <td style="width: 75%;"><input id="searchplace" class="easyui-textbox-simple tl-price-input" placeholder="输入搜索起始位置" /></td>
            </tr>
            <tr>
                <td>终点位置：</td>
                <td style="width: 75%;">
                    <input type="text" class="easyui-textbox-simple tl-price-input" id="targetPosition" value="${cameraName}" readonly/>
                </td>
            </tr>
            <tr>
                <td>终点坐标：</td>
                <td style="width: 75%;"><input type="text" class="easyui-textbox-simple tl-price-input" id="targetLngLat" value="${lngLat}" readonly/></td>
            </tr>
            <tr>
                <td></td>
                <td><button id="btn" onclick="changeInfo();" class="ant-btn ant-btn-red">导航路线</button>
                    <button onclick="doReturn();" class="ant-btn ant-btn-red">返回</button>
                </td>
            </tr>
        </table>
    </div>
    <div id="searchlist" style="width:20%; height:80%; margin-right:10px; float:left;"></div>
    <div style="width:100%;height:380px;border:none; float:left;min-width:150px;" id="BaiduDitu"></div>
    <div style="clear:both;"></div>
</div>
</body>
</html>