<%-- 
    Document   : logout
    Created on : May 4, 2025, 1:28:17 PM
    Author     : RasinduPerera
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Invalidate the current session
    session.invalidate();

    // Redirect to login page (change the path if needed)
    response.sendRedirect("/RestaurantSystem_Updated/login.jsp");
%>
