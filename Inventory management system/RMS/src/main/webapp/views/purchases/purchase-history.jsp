<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>

    <title>Purchase History</title>
</head>
<body>
    <%@ include file="/includes/navbar.jsp" %>

<header>
    <h1>Purchase History</h1>
</header>

<main>
    <!-- Search Filter -->
    <div class="search-filter">
        <input type="text" id="purchaseSearch" placeholder="Search purchases..." class="form-control">
    </div>

    <table class="history-table">
        <thead>
        <tr>
            <th>Purchase ID</th>
            <th>Item Name</th>
            <th>Supplier</th>
            <th>Purchase Date</th>
            <th>Purchase Time</th>
            <th>Quantity</th>
            <th>Unit Price</th>
            <th>Total Cost</th>
            <th>Notes</th>
        </tr>
        </thead>
        <tbody id="purchaseTable">
        <c:forEach var="purchase" items="${purchases}">
            <tr>
                <td>${purchase.id}</td>
                <td>
                    <c:forEach var="item" items="${purchase.items}">
                        ${item.item.name}<br>
                    </c:forEach>
                </td>
                <td>${purchase.supplier.name}</td>
                <td><fmt:formatDate value="${purchase.purchaseDate}" pattern="yyyy-MM-dd" /></td>
                <td><fmt:formatDate value="${purchase.purchaseDate}" pattern="HH:mm:ss" /></td>
                <td>
                    <c:forEach var="item" items="${purchase.items}">
                        ${item.quantity} ${item.item.unit}<br>
                    </c:forEach>
                </td>
                <td>
                    <c:forEach var="item" items="${purchase.items}">
                        $${item.unitPrice}<br>
                    </c:forEach>
                </td>
                <td>$${purchase.totalCost}</td>
                <td>${purchase.notes}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</main>

<script>
    document.getElementById('purchaseSearch').addEventListener('input', function(e) {
        const searchTerm = e.target.value.toLowerCase();
        document.querySelectorAll('#purchaseTable tr').forEach(row => {
            const rowText = row.textContent.toLowerCase();
            row.style.display = rowText.includes(searchTerm) ? '' : 'none';
        });
    });
</script>
</body>
</html>