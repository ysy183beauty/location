<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Cache-Control" content="no-store" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <title>编辑摄像头信息</title>
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0;" name="viewport" />
    <link rel="stylesheet" href="css/bootstrap/css/bootstrap.css">
    <link rel="stylesheet" href="css/addCamara.css">
    <link rel="stylesheet" type="text/css" href="css/demo.css">
    <link rel="stylesheet" type="text/css" href="css/style.css" />
    <link rel="stylesheet" type="text/css" href="css/basictable.css" />
    <link href="css/sweetalert.css" rel="stylesheet" />
    <script src="js/jquery-2.1.1.min.js"></script>
    <script src="js/bootstrap.js"></script>
    <script type="text/javascript" src="js/jquery.basictable.min.js"></script>
    <script type="text/javascript" src="js/sweetalert.min.js"></script>
    <style>
        #tipDiv {
            display: none;
            position: absolute;
            left: 40%;
            top: 230px;
            z-index: 9999;
            background: #d9d9d9;
            padding: 10px;
            border-radius: 5px;
        }
        #tipInfo {
            margin-top: 10px;
        }
    </style>
    <script type="text/javascript">
        //重置
        function doReset() {
            $("#lng").val("");
            $("#lat").val("");
        }
        //保存数据信息
        function doSave() {
            //获取经纬度
            var ltReg=new RegExp(/^\d+(\.\d{6,10})$/);
            var lng=$("#lng").val();
            if(lng==''){
                swal({
                    title : "经度不能为空！",
                    type : "error",
                    confirmButtonText : "确定",
                    closeOnConfirm : false
                });
                return false;
            }
            if(!ltReg.test(lng)){
                swal({
                    title : "经度格式不正确！",
                    type : "error",
                    confirmButtonText : "确定",
                    closeOnConfirm : false
                });
                return false;
            }
            var lat=$("#lat").val();
            if(lat==''){
                swal({
                    title : "纬度不能为空！",
                    type : "error",
                    confirmButtonText : "确定",
                    closeOnConfirm : false
                });
                return false;
            }
            if(!ltReg.test(lat)){
                swal({
                    title : "纬度格式不正确！",
                    type : "error",
                    confirmButtonText : "确定",
                    closeOnConfirm : false
                });
                return false;
            }
            $.ajax({
                type: "POST",
                url: "updateCameraInfo",
                async: true,
                data: {
                    "cameraName":$("#cameraName").val()==null?"":$("#cameraName").val(),
                    "lng":lng,
                    "lat":lat,
                    "id":$("#id").val()
                },
                dataType: "json",
                beforeSend: function () {
                    showTip('数据正在保存...');
                },
                success: function (msg) {
                    if (!msg.result){
                        swal({
                            title : "保存失败！",
                            type : "error",
                            confirmButtonText : "确定",
                            closeOnConfirm : false
                        });
                    }else{
                        window.location.href="/toEditList?msg=success";
                    }
                },
                error:function(XMLHttpRequest, textStatus, errorThrown){
                    alert(XMLHttpRequest.response);
                },
                complete: function() {
                    closeTip()
                }
            });
        }
        //显示
        function showTip(info) {
            $('#tipInfo').html(info);
            $('#tipDiv').show();
        }
        //加载结束关闭
        function closeTip() {
            $('#tipDiv').hide();
        }
    </script>
</head>
<body>
<div id="tipDiv">
    <center><img style="width:25px;" src="/img/123.gif"></center>
    <div id="tipInfo"></div>
</div>
<form class="form-horizontal" role="form" id="myForm">
    <input type="hidden" id="id" value="${id}">
    <div class="form-group form-group-bottom">
        <label for="cameraName" class="col-sm-2 control-label">摄像头名称</label>
        <div class="col-sm-10">
            <input type="text" class="form-control form-control-padding" id="cameraName" value="${cameraName}" readonly>
        </div>
    </div>
    <div class="form-group form-group-bottom">
        <label for="lng" class="col-sm-2 control-label">经度(格式:小数点后六到十位的数字)</label>
        <div class="col-sm-10">
            <input type="text" class="form-control form-control-padding" id="lng" value="${lng}">
        </div>
    </div>
    <div class="form-group form-group-bottom">
        <label for="lat" class="col-sm-2 control-label">纬度(格式:小数点后六到十位的数字)</label>
        <div class="col-sm-10">
            <input type="text" class="form-control form-control-padding" id="lat" value="${lat}">
        </div>
    </div>
    <div class="form-group form-group-bottom">
        <div class="col-sm-offset-2 col-sm-10">
            <button type="button"  class="btn btn-success button-width" onclick="doSave();">保存</button>
            <button type="button"  class="btn btn-danger button-width" onclick="doReset();">重置</button>
            <button type="button"  class="btn btn-primary button-width" onclick="javascript:history.go(-1);">返回</button>
        </div>
    </div>
</form>
</body>
</html>