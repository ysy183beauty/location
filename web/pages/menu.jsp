<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Cache-Control" content="no-store" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <link rel="shortcut icon" type="image/x-icon" href="img/bitbug_favicon.ico" />
    <title>菜单列表信息</title>
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0;" name="viewport" />
    <link rel="stylesheet" href="css/index.css">
    <script type="text/javascript">
        function drivingOne() {
            window.location.href="/toList";
        }
        //多点导航
        function drivingMore() {
            window.location.href="/toMoreList";
        }
        //新增摄像头信息
        function doAdd() {
            window.location.href="/toAdd";
        }
        //修改摄像头信息
        function doEdit() {
            window.location.href="/toEditList";
        }
    </script>
</head>
<body>
<button id="btn" onclick="drivingOne();" class="ant-btn ant-btn-red" style="width: 100%;">单点导航</button>
<button onclick="drivingMore();" class="ant-btn ant-btn-qs" style="width: 100%;margin-top: 8px;">多点导航</button>
<button onclick="doAdd();" class="ant-btn ant-btn-blue" style="width: 100%;margin-top: 8px;">新增摄像头</button>
<button onclick="doEdit();" class="ant-btn ant-btn-yellow" style="width: 100%;margin-top: 8px;">修改摄像头</button>
</body>
</html>