<%@ page import="java.util.TimerTask" %><%--
  Created by IntelliJ IDEA.
  User: hcxs1986
  Date: 2022/4/18
  Time: 11:44
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib  uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Title</title>

    <%
        pageContext.setAttribute("APP_PATH",request.getContextPath());
    %>
    <!-- 引入JQuery-->
    <script type="text/javascript" src="${APP_PATH}/static/js/jquery-1.12.4.min.js"></script>
    <!-- 引入样式-->
    <link href="${APP_PATH}/static/bootstrap-3.4.1-dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="${APP_PATH}/static/bootstrap-3.4.1-dist/js/bootstrap.min.js"></script>

<script type="text/javascript" >

    //定义一个记录总页数的数据
    var totalPages;

    //记录当前的页数
    var pageNow;

    //重置表单信息
    function reset_form(ele){
        $(ele)[0].reset();
        //清空表单样式
        $(ele).find("*").removeClass("has-error has-success");
        $(ele).find(".help-block").text("");
    }

    //在网页加载完成后执行
    $(function () {
        //默认访问首页
        $(to_page(1));

        //给全选框绑定点击事件
        $("#check_all").click(function () {
            //使用prop方法可以获取checked、readOnly、selected、disabled等属性的值
            //会根据当前的状态返回true或false
            var state = $(this).prop("checked");
            $(".check_item").prop("checked",state);
        });

        //给每个check_item绑定点击事件
        $(document).on("click",".check_item",function () {
            var length = $(".check_item:checked").length;
            if (length == 5){
                $("#check_all").prop("checked",true);
            }
            else {
                $("#check_all").prop("checked",false);
            }
        })


        //给与新增同一行的删除绑定单击事件
        $("#btn-del").click(function () {
            var nums = "";
            var names = "";
            $.each($(".check_item:checked"),function () {
                nums += $(this).parents("tr").find("td:eq(1)").text() + ",";
                names += $(this).parents("tr").find("td:eq(2)").text() + ",";
            })
            //去除nums多余的，
            nums = nums.substring(0,nums.length -1 );

            //创建一个json对象存放数据
            var jsonObj = {"nums":nums};

            if (nums.length != 0){
                if (confirm("确定要删除名字分别为【" + names + "】的员工记录吗？")){
                    $.ajax({
                        url:"${APP_PATH}/emps",
                        type:"delete",
                        data:JSON.stringify(jsonObj),
                        contentType : "application/json;charsetset=UTF-8",
                        dataType:"json",
                        success:function (result) {
                            //提示删除完成
                            alert(result.message);
                            //显示下一页数据
                            to_page(pageNow);
                        }
                    })
                }
            }
            else{
                alert("请先选择需要删除的员工！")
            }

        })

        //给修改员工模拟框的提交按钮绑定单击事件
        $("#update_emp").click(function () {
            //提交之前先判断修改的邮箱是否符合规则以及是否存在
            var checkResult = check_email("#empEmail_update")
            if (checkResult){
                $.ajax({
                    url:"${APP_PATH}/emps/" + $(this).attr("edit_id"),
                    type:"post",
                    data:$("#empUpdateModal form").serialize(),
                    success:function (result) {
                        //1.关闭模拟框
                        $('#empUpdateModal').modal('hide');
                        //2.跳转末页查看数据
                        to_page(pageNow);
                    }
                });
            }

        });

        //给删除员工按钮绑定单击事件
        $(document).on("click",".btn_delete",function () {
            //1.弹出是否确认删除的对话框
            if (confirm("确定要删除名字为：" + $(this).attr("empName")  + "的员工吗？")){
                $.ajax({
                    url:"${APP_PATH}/emps/" + $(this).attr("del_id"),
                    type:"delete",
                    success:function (result) {
                        //提示删除成功并返回当前删除页
                        alert(result.message)
                        to_page(pageNow);
                    }
                });
            }

        })

        //给编辑按钮绑定单击事件
        $(document).on("click",".btn_edit",function () {
            $("#empUpdateModal form").find("*").removeClass("has-error has-success");
            $("#empUpdateModal form").find(".help-block").text("");

            //1.查询部门信息显示在下拉框内
            $.ajax({
                url:"${APP_PATH}/depts",
                type:"get",
                success:function (result) {
                    getUpdateDeptNames(result)
                }
            })
            //2.查询修改的员工信息显示在模态框内
            $.ajax({
                url:"${APP_PATH}/emps/" + $(this).attr("edit_id"),
                type:"get",
                success:function (result) {
                    getEmp(result);
                }
            })
            //3.弹出模态框
            //将员工id传递过去
            $("#update_emp").attr("edit_id",$(this).attr("edit_id"));

            $('#empUpdateModal').modal({
                backdrop:"static",
            });
        })

        //给新增选项绑定单击事件
        $("#btn-add").click(function () {
        //在添加用户之前还原表单的原本样式和内容
            reset_form("#empAddModal form")
            //清空后发起ajax请求查询部门信息
            $.ajax({
                url:"${APP_PATH}/depts",
                type:"get",
                success:function (result) {
                    getDeptNames(result)
                }
            })
            //弹出模态框
            $('#empAddModal').modal({
                backdrop:"static",
            });
        });

        //给新增员工模拟框的提交按钮绑定单击事件
        $("#add_emp").click(function () {
            //1.将模拟框中填写的表单数据提交给服务器后进行保存
            //2.由于只对邮箱做了后端验证，为防止先输入邮箱存在还可以提交的bug
            //先对邮箱进行验证，符合则发送ajax请求，不符合则禁止提交按钮
            if ($("#add_emp").attr("ajax-val") == "error"){
                return false;
            }
            //3.前端页面对提交的数据再次进行校验
            if (!check_add_form()){
                return false;
            }

            //4.发送ajax请求保存员工信息
            $.ajax({
                url:"${APP_PATH}/emps",
                type:"post",
                data:$("#empAddModal form").serialize(),
                success:function (result) {
                    if (result.code == 100){
                        //当员工保存成功之后
                        //1.关闭模拟框
                        $('#empAddModal').modal('hide');
                        //2.跳转末页查看数据
                        to_page(totalPages)
                    }
                    else{
                        //显示失败信息，哪个字段有信息显示哪个字段的
                        if (undefined != result.extend.errors.empName){
                            //显示用户名错误信息
                            show_check_state("#empName","error",result.extend.errors.empName)
                        }
                        if (undefined != result.extend.errors.email)
                            //显示邮箱错误信息
                            show_check_state("#empEmail","error",result.extend.errors.email)
                    }

                }
            });
        });

        //发送ajax请求给邮箱输入框的内容做后端验证
        $("#empEmail").change(function () {
                var end =check_email("#empEmail");
                if (end){
                    $.ajax({
                        url:"${APP_PATH}/checkEmail",
                        type:"get",
                        data: "email=" +  $("#empEmail").val(),
                        success:function (result) {
                            if (result.code == 100){
                                show_check_state("#empEmail","success","该邮箱可用");
                                $("#add_emp").attr("ajax-val","success")
                            }
                            else{
                                show_check_state("#empEmail","error",result.extend.val_msg);
                                $("#add_emp").attr("ajax-val","error")
                            }
                        }
                    });
                }
        });

    });

    //查询员工的信息
    function getEmp(result){

        var empName = result.extend.employee.empName;
        $("#UpdateEmpName").text(empName);

        var email = result.extend.employee.email;
        $("#empEmail_update").val(email)

        var gender = result.extend.employee.gender;
        $("#empUpdateModal input[name=gender]").val([gender])

        var dId = result.extend.employee.dId;
        $("#deptNames_update").val([dId]);

    }

    //前端校验邮箱是否符合规则
    function check_email(ele){
        var email = $(ele).val();
        var checkEmail = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;

        if (!checkEmail.test(email)){
            show_check_state(ele,"error","邮箱不符合规则")
            return false;
        }else {
            show_check_state(ele,"success","")
        }
        //完全没有问题 返回true
        return true;
    }



    //前端校验表单信息
    function check_add_form(){
        //1.获取提交的表单内容
        var name = $("#empName").val();
        var email = $("#empEmail").val();

        //2.验证姓名和邮箱是否符合规则
        var nameCheck = /(^[a-zA-Z0-9_-]{4,16}$)|(^[\u2E80-\u9FFF]{2,10}$)/;
        var checkEmail = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
        if (!nameCheck.test(name)){
            show_check_state("#empName","error","用户名必须是4-16的英文和数字组合或2-10位的中文")
            return false;
        }else {
            show_check_state("#empName","success","")
        }
        if (!checkEmail.test(email)){
            show_check_state("#empEmail","error","邮箱不符合规则")
            return false;
        }else {
            show_check_state("#empEmail","success","")
        }
        //完全没有问题 返回true
        return true;
    }

    function show_check_state(ele,status,message){
        //清除当前元素的校验状态
        $(ele).parent().removeClass("has-success has-error");
        $(ele).next("span").text("");
        if ("success" == status){
            $(ele).parent().addClass("has-success")
            $(ele).next("span").text(message)
        }else if ("error" == status){
            $(ele).parent().addClass("has-error")
            $(ele).next("span").text(message)
        }

    }

    //查出所有部门信息并显示在员工新增下拉列表中
    function getDeptNames(result){
        //在每次打开下拉框之前把此表清空
        $("#deptNames").empty();
        //获取所有部门的信息
        var deptNames = result.extend.depts
        //通过遍历将部门的名字逐个添加到下拉框的选项中
        $.each(deptNames,function (index,dept) {
            var options = $("<option></option>").append(dept.deptName).attr("value",dept.deptId)
            $(options).appendTo("#deptNames")
        })

    }

    //查出所有部门信息并显示在修改员工下拉列表中
    function getUpdateDeptNames(result){
        //在每次打开下拉框之前把此表清空
        $("#deptNames_update").empty();
        //获取所有部门的信息
        var deptNames = result.extend.depts
        //通过遍历将部门的名字逐个添加到下拉框的选项中
        $.each(deptNames,function (index,dept) {
            var options = $("<option></option>").append(dept.deptName).attr("value",dept.deptId)
            $(options).appendTo("#deptNames_update")
        })

    }

    //跳转至指定页面
    function to_page(pn){
        $.ajax({
            url:"${APP_PATH}/emps",
            type:"get",
            data:"pageNo=" + pn,
            success:function (result) {
                //ajax请求成功后执行的回调函数中的具体操作
                //1.解析并显示员工数据
                $(build_emps_table(result));
                //2.解析并显示分页信息
                $(build_page_info(result));
                //3.解析并显示分页条数据
                $(build_page_nav(result));

            }
        });
    }

    //显示员工数据
    function build_emps_table(result){
        $("#check_all").prop("checked",false);
        //在发起ajax请求之前清空此表
        $("#emps_table tbody").empty();

        var emps = result.extend.pageInfo.list;
        $.each(emps,function (index,item) {
            var checkBox = $("<td><input type='checkbox' class='check_item'/></td>")
            var empIdTd = $("<td></td>").append(item.empId);
            var empNameTd = $("<td></td>").append(item.empName);
            var genderTd = $("<td></td>").append(item.gender=="M"?"男":"女");
            var emailTd = $("<td></td>").append(item.email);
            var deptNameTd = $("<td></td>").append(item.department.deptName);
            /**
             <button type="button" class="btn btn-info btn-sm">
             <span class="glyphicon glyphicon-pencil " aria-hidden="true"></span>
             编辑
             </button>
             * */
            var editBtn = $("<button></button>").addClass("btn btn-info btn-sm btn_edit")
                .append($("<span></span>")).addClass("glyphicon glyphicon-pencil").append("编辑");
            editBtn.attr("edit_id",item.empId);

            var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm btn_delete")
                .append($("<span></span>")).addClass("glyphicon glyphicon-remove").append("删除");
            delBtn.attr("del_id",item.empId);
            delBtn.attr("empName",item.empName);

            var btn = $("<td></td>").append(editBtn).append("").append(delBtn);
            //append()方法完成以后还是返回原来的元素
            $("<tr></tr>").append(checkBox)
                            .append(empIdTd)
                            .append(empNameTd)
                            .append(genderTd)
                            .append(emailTd)
                            .append(deptNameTd)
                            .append(btn)
                            .appendTo("#emps_table tbody");
        });
    }
    //解析分页信息
    function build_page_info(result){
        //在发起ajax请求之前清空此表
        $("#page_info_area").empty();

        var pageNum = result.extend.pageInfo.pageNum;
        var pages = result.extend.pageInfo.pages;
        var pageTotal = result.extend.pageInfo.total;
        $("#page_info_area").append("当前第 "+ pageNum +"页," +
            "总共有"+ pages + "页," +
            "总共" + pageTotal + "条记录");
        totalPages = pageTotal / result.extend.pageInfo.pageSize;
        if (totalPages > 0){
            totalPages += 1;
        }
        pageNow = pageNum;

    }
    //解析显示分页条
    function build_page_nav(result){
        //在发起ajax请求之前清空此表
        $("#page_nav").empty();
        /**
         * <ul class="pagination">
         <li>
         <a href="#" aria-label="Previous">
         <span aria-hidden="true">&laquo;</span>
         </a>
         </li>
         <li><a href="#">1</a></li>
         <li><a href="#">2</a></li>
         <li>
         <a href="#" aria-label="Next">
         <span aria-hidden="true">&raquo;</span>
         </a>
         </li>
         </ul>
         */
        var ul = $("<ul></ul>").addClass("pagination");


        var firstLi = $("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
        var preLi = $("<li></li>").append($("<a></a>").append("&laquo;"));

        var nextLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
        var lastLi = $("<li></li>").append($("<a></a>").append("末页").attr("href","#"));

        if (result.extend.pageInfo.hasPreviousPage){
            //添加首页和前一页的提示
            //为首页和上一页添加点击的跳转ajax
            ul.append(firstLi).append(preLi)
            $(firstLi).click(function () {
                to_page(1)
            })
            $(preLi).click(function () {
                to_page(result.extend.pageInfo.prePage)
            })
        }


        var nums = result.extend.pageInfo.navigatepageNums;
        $.each(nums,function (index,num) {
            var numLi = $("<li></li>").append($("<a></a>").append(num));
            if (result.extend.pageInfo.pageNum == num){
                numLi.addClass("active")
            }
            $(numLi).click(function () {
                to_page(num)
            })
            ul.append(numLi);
        })

        if (result.extend.pageInfo.hasNextPage){
            //添加下一页和末页的提示
            //为下一页和末页添加点击的跳转ajax
            ul.append(nextLi).append(lastLi);
            $(nextLi).click(function () {
                to_page(result.extend.pageInfo.nextPage)
            })
            $(lastLi).click(function () {
                to_page(result.extend.pageInfo.pages)
            })
        }
        var nav = $("<nav></nav>").append(ul);
        //将nav标签的内容插入到指定id的标签中
        nav.appendTo("#page_nav");
    }


</script>
</head>
<body>

<!-- 员工添加模态框Modal -->
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">新增员工</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">名字</label>
                        <div class="col-sm-10">
                            <input type="text" name="empName" class="form-control" id="empName" placeholder="xxx">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="empEmail" placeholder="xxx">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">性别</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">部门名字</label>
                        <div class="col-sm-10">
                            <select id="deptNames" name="dId" style="width: 120px;height: 30px" class="form-control">

                            </select>
                        </div>

                    </div>

                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="add_emp" >提交</button>
            </div>
        </div>
    </div>
</div>

<!-- 员工修改模态框Modal -->
<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabe2">修改员工</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <input  type="hidden" name="_method" value="PUT" >
                    <div class="form-group">
                        <label class="col-sm-2 control-label">名字</label>
                        <div class="col-sm-10">
                            <p class="form-control-static" id="UpdateEmpName"></p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="empEmail_update" placeholder="xxx">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">性别</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_update" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_update" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">部门名字</label>
                        <div class="col-sm-10">
                            <select id="deptNames_update" name="dId" style="width: 120px;height: 30px" class="form-control">

                            </select>
                        </div>

                    </div>

                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="update_emp" >更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 显示界面的搭建-->
<div class="container">
    <!-- 标题行-->
    <div class="row">
        <div class="col-md-12">
            <h1>SSM_CRUD</h1>
        </div>
    </div>
    <!-- 增加、修改的按钮行-->
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button type="button" class="btn btn-primary" id="btn-add">新增</button>
            <button type="button" class="btn btn-danger" id="btn-del">删除</button>
        </div>
    </div>
    <!-- 显示数据的信息头行-->
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="emps_table">
                <thead>
                <tr>
                    <th>
                        <input type="checkbox" id="check_all"/>
                    </th>
                    <th>#</th>
                    <th>名字</th>
                    <th>性别</th>
                    <th>邮箱</th>
                    <th>部门名字</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>

                </tbody>

            </table>
        </div>
    </div>

    <!-- 显示分页信息行-->
    <div class="row">
        <!-- 分页文字信息-->
        <div class="col-md-6" id="page_info_area">

        </div>
        <!-- 分页导航-->
        <div class="col-md-6" id="page_nav">

        </div>
    </div>
</div>


</body>
</html>
