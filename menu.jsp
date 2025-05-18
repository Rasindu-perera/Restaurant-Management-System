<%-- 
    Author     : RasinduPerera
--%>
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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        /* Asian-inspired styling */
        body {
            font-family: 'Roboto', sans-serif;
            background: #f9f3e9 url('images/cherry-blossom-bg.jpg') no-repeat;
            background-size: cover;
            margin: 0;
            padding: 0;
        }
        
        .category-title {
            background-color: #e74c3c;
            color: white;
            padding: 12px 25px;
            border-radius: 30px;
            display: inline-block;
            font-size: 24px;
            margin-bottom: 30px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 25px;
            padding: 20px;
        }
        
        .menu-item {
            background-color: #111;
            border-radius: 25px;
            overflow: hidden;
            color: white;
            box-shadow: 0 8px 16px rgba(0,0,0,0.2);
            transition: transform 0.3s;
        }
        
        .menu-item:hover {
            transform: translateY(-10px);
        }
        
        .menu-item img {
            width: 100%;
            height: 180px;
            object-fit: cover;
        }
        
        .item-name {
            padding: 10px 15px;
            font-size: 16px;
            text-align: center;
        }
        
        .item-controls {
            padding: 10px 15px;
        }
        
        .control-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 8px;
            background: white;
            border-radius: 30px;
            padding: 5px 10px;
        }
        
        .control-label {
            color: #111;
            font-weight: bold;
        }
        
        .control-input {
            width: 60px;
            background: #333;
            border: none;
            color: white;
            padding: 5px;
            border-radius: 15px;
            text-align: center;
        }
        
        .add-to-cart {
            background-color: #e74c3c;
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 30px;
            width: 100%;
            margin-top: 10px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        .add-to-cart:hover {
            background-color: #c0392b;
        }
        
        /* Additional Asian-inspired decorative elements */
        .page-header {
            text-align: center;
            padding: 40px 0;
        }
        
        .decorative-border {
            border: 2px solid #e74c3c;
            border-radius: 40px;
            padding: 30px;
            margin: 20px;
            background-color: rgba(255,255,255,0.8);
        }
    </style>
    <link rel="stylesheet" href="StyleCss/menu.css">
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
    <br><br><br><br>
    
    <div class="decorative-border">
        <!-- Category navigation -->
        <div style="text-align: center; margin-bottom: 30px;">
            <% if (categorizedMenu != null) {
                for (String category : categorizedMenu.keySet()) { %>
                    <button onclick="filterCategory('<%= category.replaceAll(" ", "_") %>')" 
                        class="category-title <%= category.equals(firstCategory) ? "active" : "" %>">
                        <%= category %>
                    </button>
                <% } 
            } %>
        </div>
        
        <!-- Menu items -->
        <form action="cart" method="post">
            <% if (categorizedMenu != null) {
                for (Map.Entry<String, List<MenuItem>> entry : categorizedMenu.entrySet()) {
                    String category = entry.getKey();
                    List<MenuItem> items = entry.getValue();
            %>
            <div class="menu-category" data-category="<%= category.replaceAll(" ", "_") %>" 
                 style="display: <%= category.equals(firstCategory) ? "block" : "none" %>">
                <h2 class="category-title"><%= category %></h2>
                <div class="menu-grid">
                    <% for (MenuItem item : items) { %>
                    <div class="menu-item">
                        <img src="images/<%= item.getImageUrl() %>" alt="<%= item.getName() %>">
                        <div class="item-name"><%= item.getName() %></div>
                        <div class="item-controls">
                            <div class="control-row">
                                <span class="control-label">Quantity</span>
                                <input type="number" class="control-input" id="quantity_<%= item.getId() %>" 
                                       name="quantity_<%= item.getId() %>" value="0" min="0">
                            </div>
                            <div class="control-row">
                                <span class="control-label">Rs</span>
                                <span class="control-input"><%= item.getPrice() %></span>
                                <input type="hidden" name="itemIds" value="<%= item.getId() %>">
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>
            <% } } %>
            
            <div style="text-align: center; margin-top: 30px;">
                <button type="submit" class="add-to-cart" >Add to Cart</button>
                
            </div>
        </form>
    </div>

    <!-- JavaScript for Category Filtering -->
    <script>
        function filterCategory(category) {
            // Update active state of category buttons
            const categoryButtons = document.querySelectorAll('.category-title');
            categoryButtons.forEach(button => {
                button.classList.remove('active');
                if (button.textContent.trim().replaceAll(' ', '_') === category) {
                    button.classList.add('active');
                }
            });

            // Show only the selected category
            const blocks = document.querySelectorAll('.menu-category');
            blocks.forEach(function(block) {
                block.style.display = block.getAttribute('data-category') === category ? 'block' : 'none';
            });
        }
    </script>
</body>
</html>
