<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>

    <title>
        <c:choose>
            <c:when test="${not empty supplier.id}">Edit Supplier</c:when>
            <c:otherwise>Add New Supplier</c:otherwise>
        </c:choose>
    </title>
</head>
<body>
    <%@ include file="/includes/navbar.jsp" %>

<header>
    <h1>
        <c:choose>
            <c:when test="${not empty supplier.id}">Edit Supplier</c:when>
            <c:otherwise>Add New Supplier</c:otherwise>
        </c:choose>
    </h1>
</header>

<main>
    <form action="${pageContext.request.contextPath}/suppliers" method="post">
        <input type="hidden" name="action" value="${not empty supplier.id ? 'update' : 'create'}">
        <c:if test="${not empty supplier.id}">
            <input type="hidden" name="id" value="${supplier.id}">
        </c:if>

        <div class="form-group">
            <label for="name">Name:</label>
            <input type="text" id="name" name="name" value="${supplier.name}" required>
        </div>

        <div class="form-group">
            <label for="contactPerson">Contact Person:</label>
            <input type="text" id="contactPerson" name="contactPerson" value="${supplier.contactPerson}">
        </div>

        <div class="form-group">
            <label for="phone">Phone:</label>
            <input type="text" id="phone" name="phone" value="${supplier.phone}">
        </div>

        <div class="form-group">
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" value="${supplier.email}">
        </div>

        <button type="submit">Save</button>
    </form>
</main>
</body>
</html>