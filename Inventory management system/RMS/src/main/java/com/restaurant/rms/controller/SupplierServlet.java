package com.restaurant.rms.controller;

import com.restaurant.rms.model.Supplier;
import com.restaurant.rms.service.SupplierService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "SupplierServlet", value = "/suppliers")
public class SupplierServlet extends HttpServlet {
    private final SupplierService supplierService;

    public SupplierServlet() {
        this.supplierService = new SupplierService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "new":
                showNewForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteSupplier(request, response);
                break;
            default:
                listSuppliers(request, response);
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("create".equals(action)) {
            createSupplier(request, response);
        } else if ("update".equals(action)) {
            updateSupplier(request, response);
        }
    }

    private void listSuppliers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Supplier> suppliers = supplierService.getAllSuppliers();
        request.setAttribute("suppliers", suppliers);
        request.getRequestDispatcher("/views/suppliers/list.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/suppliers/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        Supplier supplier = supplierService.getSupplierById(id);
        request.setAttribute("supplier", supplier);
        request.getRequestDispatcher("/views/suppliers/form.jsp").forward(request, response);
    }

    private void createSupplier(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        Supplier supplier = new Supplier();
        supplier.setName(request.getParameter("name"));
        supplier.setContactPerson(request.getParameter("contactPerson"));
        supplier.setPhone(request.getParameter("phone"));
        supplier.setEmail(request.getParameter("email"));

        supplierService.saveSupplier(supplier);
        response.sendRedirect("suppliers");
    }

    private void updateSupplier(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        Long id = Long.parseLong(request.getParameter("id"));
        Supplier supplier = supplierService.getSupplierById(id);
        supplier.setName(request.getParameter("name"));
        supplier.setContactPerson(request.getParameter("contactPerson"));
        supplier.setPhone(request.getParameter("phone"));
        supplier.setEmail(request.getParameter("email"));

        supplierService.updateSupplier(supplier);
        response.sendRedirect("suppliers");
    }

    private void deleteSupplier(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        supplierService.deleteSupplier(id);
        response.sendRedirect("suppliers");
    }
}