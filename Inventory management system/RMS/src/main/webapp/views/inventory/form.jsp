<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>

<head>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>

    <title>
        <c:choose>
            <c:when test="${not empty item.id}">Edit Inventory Item</c:when>
            <c:otherwise>Add New Inventory Item</c:otherwise>
        </c:choose>
    </title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
 <%@ include file="/includes/navbar.jsp" %>
<header>
    <h1>
        <c:choose>
            <c:when test="${not empty item.id}">Edit Inventory Item</c:when>
            <c:otherwise>Add New Inventory Item</c:otherwise>
        </c:choose>
    </h1>
</header>

<main>
    <form action="${pageContext.request.contextPath}/inventory" method="post">
        <input type="hidden" name="action" value="${not empty item.id ? 'update' : 'create'}">
        <c:if test="${not empty item.id}">
            <input type="hidden" name="id" value="${item.id}">
        </c:if>

        <div class="form-group">
            <label for="name">Name:</label>
            <input type="text" id="name" name="name" value="${item.name}" required>
        </div>

        <div class="form-group">
            <label for="category">Category:</label>
            <select name="category" required>
                <c:forEach var="category" items="${categories}">
                    <option value="${category.id}" ${item != null && item.category.id == category.id ? 'selected' : ''}>
                        ${category.name}
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="form-group">
            <label for="quantity">Quantity:</label>
            <input type="number" id="quantity" name="quantity" step="0.01"
                   value="${item.currentQuantity}" required>
        </div>

        <div class="form-group">
            <label for="unit">Unit:</label>
            <select id="unit" name="unit" required>
                <option value="kg" ${item.unit == 'kg' ? 'selected' : ''}>kg</option>
                <option value="g" ${item.unit == 'g' ? 'selected' : ''}>g</option>
                <option value="lbs" ${item.unit == 'lbs' ? 'selected' : ''}>lbs</option>
                <option value="oz" ${item.unit == 'oz' ? 'selected' : ''}>oz</option>
                <option value="l" ${item.unit == 'l' ? 'selected' : ''}>liter</option>
                <option value="ml" ${item.unit == 'ml' ? 'selected' : ''}>ml</option>
                <option value="unit" ${item.unit == 'unit' ? 'selected' : ''}>unit</option>
            </select>
        </div>

        <div class="form-group">
            <label for="minStock">Minimum Stock Level:</label>
            <input type="number" id="minStock" name="minStock" step="0.01"
                   value="${item.minStockLevel}">
        </div>

        <div class="form-group">
            <label for="location">Storage Location:</label>
            <input type="text" id="location" name="location" value="${item.storageLocation}">
        </div>

        <div class="form-group">
            <label for="cost">Cost per Unit:</label>
            <input type="number" id="cost" name="cost" step="0.01"
                   value="${item.costPerUnit}">
        </div>

        <button type="submit">Save</button>
</main>
</body>
</html>