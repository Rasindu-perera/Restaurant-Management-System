package controller;

import dao.MenuItemDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.Category;
import model.MenuItem;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;

@WebServlet("/admin/editMenuItem")
@MultipartConfig
public class EditMenuItemServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final MenuItemDAO menuItemDAO = new MenuItemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id"); // Get the parameter as a String

        if (idParam == null || idParam.isEmpty()) {
            // Handle the error: ID is missing
            request.setAttribute("errorMessage", "Missing or invalid item ID.");
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
            return;
        }

        int itemId;
        try {
            itemId = Integer.parseInt(idParam);  // THEN, parse it.
        } catch (NumberFormatException e) {
             // Handle the error: ID is not a valid number.
            request.setAttribute("errorMessage", "Invalid item ID format.  Please provide a number.");
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
            return;
        }


        // Fetch the menu item and categories
        MenuItem item = menuItemDAO.getMenuItemById(itemId); // Implement this in MenuItemDAO
        List<Category> categories = menuItemDAO.getAllCategories(); //And this

        if (item == null) {
            // Handle the error: Item not found
            request.setAttribute("errorMessage", "Menu item not found");
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
            return;
        }

        request.setAttribute("item", item);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/admin/edit_menu_item.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        double price = Double.parseDouble(request.getParameter("price"));
        int categoryId = Integer.parseInt(request.getParameter("category_id"));

        MenuItem existingItem = menuItemDAO.getMenuItemById(id);
        if (existingItem == null)
        {
            request.setAttribute("errorMessage", "Menu item not found");
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
            return;
        }

        String fileName = existingItem.getImageUrl(); //keep old image name
        Part filePart = request.getPart("image");
        if (filePart != null && filePart.getSize() > 0) {
            fileName = handleFileUpload(filePart, getServletContext().getRealPath(""), existingItem.getImageUrl());
            if (fileName == null){
                request.setAttribute("errorMessage", "Error uploading image");
                request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
                return;
            }
        }

        // Create item and save
        MenuItem item = new MenuItem();
        item.setId(id);
        item.setName(name);
        item.setPrice(price);
        item.setCategoryId(categoryId);
        item.setImageUrl(fileName);

        menuItemDAO.updateMenuItem(item); // Implement this in MenuItemDAO

        response.sendRedirect("menu_items"); // Redirect to menu items list
    }

    private String handleFileUpload(Part filePart, String uploadPath, String oldFileName) throws IOException {
        String fileName = filePart.getSubmittedFileName();
        if (fileName == null || fileName.isEmpty()) {
            return oldFileName;
        }

        String fullPath = uploadPath + File.separator + "images";
        File uploadDir = new File(fullPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        File file = new File(fullPath + File.separator + fileName);

        //delete old file
        if (oldFileName != null){
            File oldFile = new File(uploadPath + File.separator + "images" + File.separator + oldFileName);
            if(oldFile.exists()){
                oldFile.delete();
            }
        }
        try (InputStream fileContent = filePart.getInputStream()) {
            Files.copy(fileContent, file.toPath());
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
        return fileName;
    }
}