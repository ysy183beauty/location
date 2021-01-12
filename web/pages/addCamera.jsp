<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Cache-Control" content="no-store" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <title>新增摄像头信息</title>
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
            $(':input','#myForm').not(':button, :submit, :reset, :hidden').val('');
        }
        //保存数据信息
        function doSave() {
          //获取摄像头编号
          var carmerNum=$("#cameraNum").val();
          if(carmerNum==''){
              swal({
                  title : "摄像头编号不能为空！",
                  type : "error",
                  confirmButtonText : "确定",
                  closeOnConfirm : false
              });
              return false;
          }
          //验证只能输入六位数字
          var reg = new RegExp(/^\d{6}([-]\d+)?$/);
           if(!reg.test(carmerNum)){
               swal({
                   title : "摄像头编号只能为六位数字！",
                   type : "error",
                   confirmButtonText : "确定",
                   closeOnConfirm : false
               });
               return false;
           }
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
            //选择区域信息
            var regionName=$("#regionName").val();
            if(regionName==''){
                swal({
                    title : "区域名称不能为空！",
                    type : "error",
                    confirmButtonText : "确定",
                    closeOnConfirm : false
                });
                return false;
            }
            $.ajax({
                type: "POST",
                url: "saveCameraInfo",
                async: true,
                data: {
                    "carmerNum": carmerNum,
                    "cameraName":$("#cameraName").val()==null?"":$("#cameraName").val(),
                    "lng":lng,
                    "lat":lat,
                    "regionName":regionName
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
                        swal({
                            title : "保存成功！",
                            type : "success",
                            confirmButtonText : "确定",
                            closeOnConfirm : false
                        });
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
    <div class="form-group form-group-bottom">
        <label for="cameraNum" class="col-sm-2 control-label">摄像头编号</label>
        <div class="col-sm-10">
            <input type="text" class="form-control form-control-padding" id="cameraNum"
                   placeholder="请输入摄像头编号">
        </div>
    </div>
    <div class="form-group form-group-bottom">
        <label for="cameraName" class="col-sm-2 control-label">摄像头名称</label>
        <div class="col-sm-10">
            <input type="text" class="form-control form-control-padding" id="cameraName"
                   placeholder="请输入摄像头名称">
        </div>
    </div>
    <div class="form-group form-group-bottom">
        <label for="lng" class="col-sm-2 control-label">经度(格式:小数点后六到十位的数字)</label>
        <div class="col-sm-10">
            <input type="text" class="form-control form-control-padding" id="lng"
                   placeholder="请输入经度">
        </div>
    </div>
    <div class="form-group form-group-bottom">
        <label for="lat" class="col-sm-2 control-label">纬度(格式:小数点后六到十位的数字)</label>
        <div class="col-sm-10">
            <input type="text" class="form-control form-control-padding" id="lat"
                   placeholder="请输入纬度">
        </div>
    </div>
    <div class="form-group form-group-bottom">
        <label for="regionName" class="col-sm-2 control-label">所属区域</label>
        <div class="col-sm-10">
            <select class="form-control" name="regionName" id="regionName">
                <option value="">请选择</option>
                <option value="大理镇">大理镇</option>
                <option value="银桥镇">银桥镇</option>
                <option value="湾桥镇">湾桥镇</option>
                <option value="喜洲镇">喜洲镇</option>
                <option value="上关镇">上关镇</option>
                <option value="双廊镇">双廊镇</option>
            </select>
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
