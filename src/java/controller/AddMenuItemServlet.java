package controller;

import dao.MenuItemDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.MenuItem;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption; // Import this

@WebServlet("/admin/add_Menu_Item")
@MultipartConfig
public class AddMenuItemServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String name = request.getParameter("name");
        double price = Double.parseDouble(request.getParameter("price"));
        int categoryId = Integer.parseInt(request.getParameter("category_id"));

        // Handle uploaded file
        Part filePart = request.getPart("image");
        String fileName = filePart.getSubmittedFileName();

        // ✅ Save path (e.g., webapp/images/)
        String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        // ✅ Save file to /images/
        
        File file = new File(uploadPath + File.separator + fileName);
        try (InputStream fileContent = filePart.getInputStream()) {
            // Add StandardCopyOption.REPLACE_EXISTING to overwrite if file exists
            Files.copy(fileContent, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
        }

        // ✅ Create item and save
        MenuItem item = new MenuItem();
        item.setName(name);
        item.setPrice(price);
        item.setCategoryId(categoryId);
        item.setImageUrl(fileName); // ✅ NEW: stores only 'filename.jpg'
 // Save relative path like: images/burger.jpg

        MenuItemDAO dao = new MenuItemDAO();
        dao.addMenuItem(item);

        response.sendRedirect("menu_items");
    }
}
