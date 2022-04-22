<%--
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
</head>
<body>

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
                    <button type="button" class="btn btn-primary">新增</button>
                    <button type="button" class="btn btn-danger">删除</button>
                </div>
            </div>
        <!-- 显示数据的信息头行-->
            <div class="row">
                <div class="col-md-12">
                    <table class="table table-hover">
                        <tr>
                            <th>#</th>
                            <th>名字</th>
                            <th>性别</th>
                            <th>邮箱</th>
                            <th>部门名字</th>
                            <th>操作</th>
                        </tr>
                        <c:forEach items="${requestScope.pageInfo.list}" var="emp">
                            <tr>
                                <td>${emp.empId}</td>
                                <td>${emp.empName}</td>
                                <td>${emp.gender == "M"?"男":"女"}</td>
                                <td>${emp.email}</td>
                                <td>${emp.department.deptName}</td>
                                <td>
                                    <button type="button" class="btn btn-info btn-sm">
                                        <span class="glyphicon glyphicon-pencil " aria-hidden="true"></span>
                                        编辑
                                    </button>
                                    <button type="button" class="btn btn-danger btn-sm">
                                        <span class="glyphicon glyphicon-remove" aria-hidden="true"></span>
                                        删除
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
            </div>

            <!-- 显示分页信息行-->
            <div class="row">
                <!-- 分页文字信息-->
                <div class="col-md-6">
                    当前第${requestScope.pageInfo.pageNum}页，
                    总共有${requestScope.pageInfo.pages}页，
                    总共${requestScope.pageInfo.total}条记录
                </div>
                <!-- 分页导航-->
                <div class="col-md-6">
                    <nav aria-label="Page navigation">
                        <ul class="pagination">
                            <c:if test="${!requestScope.pageInfo.isFirstPage}">
                                <li><a href="${APP_PATH}/emps/1">首页</a></li>
                                <li>
                                    <a href="${APP_PATH}/emps/${requestScope.pageInfo.prePage}" aria-label="Previous">
                                        <span aria-hidden="true">&laquo;</span>
                                    </a>
                                </li>
                            </c:if>

                            <c:forEach items="${requestScope.pageInfo.navigatepageNums}" var="page" >
                                <c:if test="${page == requestScope.pageInfo.pageNum}">
                                    <li class="active"><a href="${APP_PATH}/emps/${page}">${page}</a></li>
                                </c:if>
                                <c:if test="${page != requestScope.pageInfo.pageNum}">
                                    <li ><a href="${APP_PATH}/emps/${page}">${page}</a></li>
                                </c:if>
                            </c:forEach>

                            <c:if test="${!requestScope.pageInfo.isLastPage}">
                                <li>
<%--                                    <a href="${APP_PATH}/emps?pageNo=${requestScope.pageInfo.nextPage}" aria-label="Next">--%>
                                    <a href="${APP_PATH}/emps/${requestScope.pageInfo.nextPage}" aria-label="Next">
                                        <span aria-hidden="true">&raquo;</span>
                                    </a>
                                </li>
                                <li><a href="${APP_PATH}/emps/${requestScope.pageInfo.pages}">末页</a></li>
                            </c:if>
                        </ul>
                    </nav>
                </div>
            </div>
    </div>


</body>
</html>
