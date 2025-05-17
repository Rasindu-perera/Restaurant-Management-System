<%@ page import="java.util.*" %>
<%@ page import="model.MenuItem" %>
<%
    Map<String, List<MenuItem>> categorizedMenu = (Map<String, List<MenuItem>>) request.getAttribute("categorizedMenu");
    String firstCategory = categorizedMenu != null && !categorizedMenu.isEmpty() ? 
                          categorizedMenu.keySet().iterator().next() : "";
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>China Pearl Restaurant</title>
  <link rel="stylesheet" href="StyleCss/menu.css">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
    <div class="page">
        <div class="main-bg">
        <div class="header">
            <div class="header-left d-flex align-items-center">
                <img src="images/restlogo.png" alt="Logo of China Pearl Restaurant featuring a pearl inside a shell, symbolizing elegance and quality" class="logo">
                <div class="restaurant-title mb-0">
                  <h1 class="restaurant-title mb-0">China Pearl<br>Restaurant</h1>
                </div>
            </div>
            
        <div class="image-circle-right d-flex align-items-center">
          <img src="images/food-bowl.png" alt="Food Bowl" class="header-img">
        </div>
      </div>
      <div class="intro_block">
        <div class="cuisine-line">
          <span class="sri-lankan">Sri Lankan</span><br>
          <span class="chinese">Chinese</span>
        </div>
        <div class="desc">
          A Chinese restaurant is a place where you can eat food that comes from or is inspired by China. The menu usually includes dishes like fried rice, noodles, dumplings, sweet and sour chicken, spring rolls, and more. Many Chinese restaurants use ingredients like soy sauce, ginger, garlic, and rice. Some are more traditional, while others offer a modern or local twist. You can eat there (dine-in), take the food home (takeout), or get it delivered.
        </div>
      </div><br><br><br>
      
    </div>
    <div class="tab"">
        <div class="category-filter">
            <div id="menu_box" class="menu_box-Left d-flex align-items-center">
            Menu
            </div>
            <ul class="list_category">
                <% if (categorizedMenu != null) {
                    for (String category : categorizedMenu.keySet()) {
                 %>
                <li onclick="filterCategory('<%= category.replaceAll(" ", "_") %>')" 
                class="<%= category.equals(firstCategory) ? "active" : "" %>">
                <%= category %>
                </li>
                <% } } %>
            </ul>
        </div>

        <!-- Menu Items -->
        <div class="menu_tab">

        <form action="cart" method="post">
            <% if (categorizedMenu != null) {
                for (Map.Entry<String, List<MenuItem>> entry : categorizedMenu.entrySet()) {
                String category = entry.getKey();
                List<MenuItem> items = entry.getValue();
            %>
            <div class="category-block" data-category="<%= category.replaceAll(" ", "_") %>"
                accesskey=""style="display: <%= category.equals(firstCategory) ? "block" : "none" %>">
                <div class="category-box">
                    <h2><%= category %></h2>
                </div>
            <% for (MenuItem item : items) { %>
                <div class="menu-card">
                    <img src="images/<%= item.getImageUrl() %>" alt="<%= item.getName() %>" width="100">
                    <div>
                        <strong><%= item.getName() %></strong>
                        <div>Rs. <%= item.getPrice() %></div>
                        <label for="quantity_<%= item.getId() %>">Quantity</label>
                        <input type="number" id="quantity_<%= item.getId() %>" name="quantity_<%= item.getId() %>" value="0" min="0">
                        <input type="hidden" name="itemIds" value="<%= item.getId() %>">
                    </div>
                </div>
            <% } %>
            </div>
        <% } } %>
        <button type="submit">Add to Cart</button>
    </form>

        </div>
    </div>

    <!-- JavaScript Filtering -->
    <script>
      function filterCategory(category) {
        // Update active state of category buttons
        const categoryButtons = document.querySelectorAll('.category-filter-wrapper li');
        categoryButtons.forEach(button => {
          button.classList.remove('active');
          if (button.textContent.toLowerCase() === category.toLowerCase()) {
            button.classList.add('active');
          }
        });

        // Show only the selected category
        const blocks = document.querySelectorAll('.category-block');
        blocks.forEach(function(block) {
          block.style.display = block.getAttribute('data-category') === category ? 'block' : 'none';
        });
      }

      // Initialize with first category selected
      document.addEventListener('DOMContentLoaded', function() {
        const firstCategoryButton = document.querySelector('.category-filter-wrapper li');
        if (firstCategoryButton) {
          filterCategory(firstCategoryButton.textContent.trim().replace(/\s+/g, '_'));
        }
      });
    </script>
    </div>
</body>
</html>
