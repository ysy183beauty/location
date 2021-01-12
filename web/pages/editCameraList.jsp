<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Cache-Control" content="no-store" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0;" name="viewport" />
    <title>摄像头列表数据列表</title>
    <link rel="stylesheet" href="css/index.css">
    <link rel="stylesheet" type="text/css" href="css/demo.css">
    <link rel="stylesheet" type="text/css" href="css/style.css" />
    <link rel="stylesheet" type="text/css" href="css/basictable.css" />
    <link href="css/sweetalert.css" rel="stylesheet" />
    <script src="js/jquery-2.1.1.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="js/jquery.basictable.min.js"></script>
    <script type="text/javascript" src="js/sweetalert.min.js"></script>
    <style>
        table {
            table-layout: fixed;
        }
        td {
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
        }
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
        //选中的数据集合
        var page=1;
        /**
         * 加载数据信息
         */
        //获取数据信息
        function getData(page,cameraName,type) {
            $.ajax({
                type: "POST",
                url: "selectMoreAll",
                async: true,
                data: {
                    "page":page,
                    "cameraName":cameraName,
                    "type":type
                },
                dataType: "json",
                beforeSend: function() {
                    showTip('数据正在加载...');
                },
                success: function(msg){
                    $("#formId").css("display","block");
                    $("#moreInfo").css("display","block");
                    var str="";
                    var html;
                    //没有查询到数据信息
                    if(msg.data.length==0){
                        if(type=="query"){//查询发出
                            //清空内容信息
                            $("#table-breakpoint").html("");
                            html="<thead><tr><th style='width: 50px;'></th><th>摄像头名称</th></tr></thead><tbody>";
                        }else if(type=="more"){
                            html="";
                            swal({
                                title : "没有更多了......！",
                                type : "error",
                                confirmButtonText : "确定",
                                closeOnConfirm : false
                            });
                        }
                    }else{
                        if(type=="query"){
                            //清空内容信息
                            $("#table-breakpoint").html("");
                            html="<thead><tr><th style='width: 50px;'></th><th>摄像头名称</th></tr></thead><tbody>";
                        }else if(type=="more"){
                            html="";
                        }
                        for(var i in msg.data){
                            str+="<tr><td><input type='radio' name='ck'></td>";
                            str+="<td style='display: none'>"+msg.data[i].id+"</td><td style='width: 350px;'>"+msg.data[i].cameraName+"</td><td style='display: none'>"+msg.data[i].cameraType+"</td>";
                            str+="<td style='display: none'>"+msg.data[i].ipAdrres+"</td><td style='display: none'>"+msg.data[i].lng+"</td><td style='display: none'>"+msg.data[i].lat+"</td>";
                            str+="</tr>";
                            html+=str;
                            str="";
                        }
                    }
                    if(type=="query"){
                        html+="</tbody>";
                    }
                    $("#table-breakpoint").append(html);
                    $("#table-breakpoint>tbody>tr").click(function () {
                        //选中状态
                        var checked=$(this).children().eq(0).children().prop("checked");
                        if(checked){//如果选中了
                            var id=$(this).children().eq(1).html();
                            window.location.href="/toEditCamera?id="+id;
                        }
                    });
                },
                error:function(XMLHttpRequest, textStatus, errorThrown){
                    alert(XMLHttpRequest.response);
                },
                complete: function() {
                    closeTip()
                }
            });
        }

        /**
         * 页面加载完成事件
         */
        $(function () {
            var msg="${msg}";
            if(msg!=''&&msg=='success'){
                swal({
                    title : "操作成功！",
                    type : "success",
                    confirmButtonText : "确定",
                    closeOnConfirm : false
                });
            }
            var cameraName=null;
            var type="query";//默认为查询
            getData(page,cameraName,type);
        });
        //点击更多按钮信息
        function getMore() {
            page=parseInt(page)+1;
            //获取输入框里面的值
            var cameraName=$("#camera_name").val();
            var type="more";
            getData(page,cameraName,type);
        }
        //点击查询按钮信息
        function query() {
            var type="query";//默认为查询
            var cameraName=$("#camera_name").val()==null?"":$("#camera_name").val();
            getData(page,cameraName,type);
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
        function doReturn() {
            window.location.href="/toMenu";
        }
    </script>
</head>
<body>
<div id="tipDiv">
    <center><img style="width:25px;" src="/img/123.gif"></center>
    <div id="tipInfo"></div>
</div>
<div style="margin:8px;display: none" id="formId">
    <table>
        <tr>
            <td style="text-align: center;font-weight:bold;font-size: 16px;">摄像头名称：</td>
            <td><input id="camera_name" class="easyui-textbox-simple tl-price-input" placeholder="摄像头名称" style="width: 100%;"/></td>
        </tr>
        <tr>
            <td></td>
            <td>
                <button id="btn" onclick="query();" class="ant-btn ant-btn-red">查询</button>
                <button onclick="doReturn();" class="ant-btn ant-btn-primary">返回</button>
            </td>
        </tr>
    </table>
</div>
<table id="table-breakpoint" style="margin:8px;width: 98%;"></table>
<button onclick="getMore();" class="ant-btn ant-btn-red" style="width: 100%;display: none;" id="moreInfo">更多......</button>
</body>
</html>