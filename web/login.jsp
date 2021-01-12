<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1.0" />
    <title>登录界面信息</title>
    <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css" />
    <link href="css/sweetalert.css" rel="stylesheet" />
    <script src="js/jquery-2.1.1.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="js/sweetalert.min.js"></script>
    <style type="text/css">
        html,body {
            height: 100%;
        }
        .box {
            filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#6699FF', endColorstr='#6699FF'); /*  IE */
            background-image:linear-gradient(bottom, #6699FF 0%, #6699FF 100%);
            background-image:-o-linear-gradient(bottom, #6699FF 0%, #6699FF 100%);
            background-image:-moz-linear-gradient(bottom, #6699FF 0%, #6699FF 100%);
            background-image:-webkit-linear-gradient(bottom, #6699FF 0%, #6699FF 100%);
            background-image:-ms-linear-gradient(bottom, #6699FF 0%, #6699FF 100%);

            margin: 0 auto;
            position: relative;
            width: 100%;
            height: 100%;
        }
        .login-box {
            width: 100%;
            max-width:500px;
            height: 400px;
            position: absolute;
            top: 50%;

            margin-top: -200px;
            /*设置负值，为要定位子盒子的一半高度*/

        }
        @media screen and (min-width:500px){
            .login-box {
                left: 50%;
                /*设置负值，为要定位子盒子的一半宽度*/
                margin-left: -250px;
            }
        }

        .form {
            width: 100%;
            max-width:500px;
            height: 275px;
            margin: 25px auto 0px auto;
            padding-top: 25px;
        }
        .login-content {
            height: 300px;
            width: 100%;
            max-width:500px;
            background-color: rgba(255, 250, 2550, .6);
            float: left;
        }


        .input-group {
            margin: 0px 0px 30px 0px !important;
        }
        .form-control,
        .input-group {
            height: 40px;
        }

        .form-group {
            margin-bottom: 0px !important;
        }
        .login-title {
            padding: 20px 10px;
            background-color: rgba(0, 0, 0, .6);
        }
        .login-title h1 {
            margin-top: 10px !important;
        }
        .login-title small {
            color: #fff;
        }

        .link p {
            line-height: 20px;
            margin-top: 30px;
        }
        .btn-sm {
            padding: 8px 24px !important;
            font-size: 16px !important;
        }
        @font-face {
            font-family: 'Glyphicons Halflings';
            src: url('font/glyphicons-halflings-regular.ttf');
    </style>
    <script type="text/javascript">
        function login() {
           var userName=$("#username").val()==null?"":$("#username").val();
           if(userName==""){
               swal({
                   title : "用户名不能为空",
                   type : "error",
                   confirmButtonText : "确定",
                   closeOnConfirm : false
               });
               return;
           }
           var pwd=$("#password").val()==null?"":$("#password").val();
           if(pwd==""){
               swal({
                   title : "密码不能为空",
                   type : "error",
                   confirmButtonText : "确定",
                   closeOnConfirm : false
               });
               return;
           }
            $.ajax({
                type: "POST",
                url: "/login",
                async: true,
                data: {
                    "username": userName,
                    "password": pwd
                },
                dataType: "json",
                success: function (data) {
                    if(data.flag){
                        window.location.href="/toMenu";
                    }else{
                        swal({
                            title : data.msg,
                            type : "error",
                            confirmButtonText : "确定",
                            closeOnConfirm : false
                        });
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    alert(XMLHttpRequest.response);
                }
            });
        }
    </script>
</head>
<body>
<div class="box">
    <div class="login-box">
        <div class="login-title text-center">
            <h1><small>登录</small></h1>
        </div>
        <div class="login-content ">
            <div class="form">
                <form action="#" method="post">
                    <div class="form-group">
                        <div class="col-xs-12  ">
                            <div class="input-group">
                                <span class="input-group-addon"><span class="glyphicon glyphicon-user"></span></span>
                                <input type="text" id="username" name="username" class="form-control" placeholder="用户名">
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-xs-12  ">
                            <div class="input-group">
                                <span class="input-group-addon"><span class="glyphicon glyphicon-lock"></span></span>
                                <input type="password" id="password" name="password" class="form-control" placeholder="密码">
                            </div>
                        </div>
                    </div>
                    <div class="form-group form-actions">
                        <div class="col-xs-4 col-xs-offset-4 ">
                            <button type="button" class="btn btn-sm btn-info" onclick="login();"><span class="glyphicon glyphicon-off"></span> 登录</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<div style="text-align:center;">
</div>
</body>
</html>
