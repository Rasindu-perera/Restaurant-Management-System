<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Feedback, dao.FeedbackDAO, dao.WaiterDAO, model.Waiter" %>
<%
    FeedbackDAO feedbackDAO = new FeedbackDAO();
    WaiterDAO waiterDAO = new WaiterDAO();
    
    List<Feedback> feedbackList = feedbackDAO.getAllFeedback();
    double averageRating = feedbackDAO.getAverageRating();
    Map<Integer, Integer> ratingDistribution = feedbackDAO.getRatingDistribution();
    Map<Integer, Double> waiterRatings = feedbackDAO.getWaiterRatings();
    
    // For display in JSP
    int fiveStars = ratingDistribution.getOrDefault(5, 0);
    int fourStars = ratingDistribution.getOrDefault(4, 0);
    int threeStars = ratingDistribution.getOrDefault(3, 0);
    int twoStars = ratingDistribution.getOrDefault(2, 0);
    int oneStars = ratingDistribution.getOrDefault(1, 0);
    
    int totalRatings = fiveStars + fourStars + threeStars + twoStars + oneStars;
%>
<!DOCTYPE html>
<html>
<head>
    <title>Customer Feedback Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .card {
            border-radius: 15px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .rating-summary {
            display: flex;
            align-items: center;
            margin-bottom: 8px;
        }
        .star-label {
            min-width: 80px;
        }
        .progress {
            flex-grow: 1;
            margin: 0 10px;
        }
        .chart-container {
            position: relative;
            height: 300px;
        }
        .rating-number {
            min-width: 40px;
            text-align: right;
        }
        .star-gold {
            color: #FFD700;
        }
    </style>
</head>
<body>
    <%-- Include admin header --%>
    <jsp:include page="admin_header.jsp" />
    
    <div class="container mt-4">
        <div class="row mb-4">
            <div class="col">
                <h2>Customer Feedback Dashboard</h2>
            </div>
        </div>
        
        <div class="row">
            <%-- Rating Summary Card --%>
            <div class="col-lg-6 mb-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title m-0">Rating Summary</h5>
                    </div>
                    <div class="card-body">
                        <div class="text-center mb-4">
                            <h2><%= String.format("%.1f", averageRating) %> <span class="star-gold">★</span></h2>
                            <p class="text-muted mb-0"><%= totalRatings %> reviews</p>
                        </div>
                        
                        <div class="rating-summary">
                            <span class="star-label">5 <span class="star-gold">★</span></span>
                            <div class="progress">
                                <div class="progress-bar bg-success" role="progressbar" 
                                     style="width: <%= totalRatings > 0 ? (fiveStars * 100 / totalRatings) : 0 %>%" 
                                     aria-valuenow="<%= fiveStars %>" aria-valuemin="0" aria-valuemax="<%= totalRatings %>"></div>
                            </div>
                            <span class="rating-number"><%= fiveStars %></span>
                        </div>
                        
                        <div class="rating-summary">
                            <span class="star-label">4 <span class="star-gold">★</span></span>
                            <div class="progress">
                                <div class="progress-bar bg-success" role="progressbar" 
                                     style="width: <%= totalRatings > 0 ? (fourStars * 100 / totalRatings) : 0 %>%" 
                                     aria-valuenow="<%= fourStars %>" aria-valuemin="0" aria-valuemax="<%= totalRatings %>"></div>
                            </div>
                            <span class="rating-number"><%= fourStars %></span>
                        </div>
                        
                        <div class="rating-summary">
                            <span class="star-label">3 <span class="star-gold">★</span></span>
                            <div class="progress">
                                <div class="progress-bar bg-warning" role="progressbar" 
                                     style="width: <%= totalRatings > 0 ? (threeStars * 100 / totalRatings) : 0 %>%" 
                                     aria-valuenow="<%= threeStars %>" aria-valuemin="0" aria-valuemax="<%= totalRatings %>"></div>
                            </div>
                            <span class="rating-number"><%= threeStars %></span>
                        </div>
                        
                        <div class="rating-summary">
                            <span class="star-label">2 <span class="star-gold">★</span></span>
                            <div class="progress">
                                <div class="progress-bar bg-warning" role="progressbar" 
                                     style="width: <%= totalRatings > 0 ? (twoStars * 100 / totalRatings) : 0 %>%" 
                                     aria-valuenow="<%= twoStars %>" aria-valuemin="0" aria-valuemax="<%= totalRatings %>"></div>
                            </div>
                            <span class="rating-number"><%= twoStars %></span>
                        </div>
                        
                        <div class="rating-summary">
                            <span class="star-label">1 <span class="star-gold">★</span></span>
                            <div class="progress">
                                <div class="progress-bar bg-danger" role="progressbar" 
                                     style="width: <%= totalRatings > 0 ? (oneStars * 100 / totalRatings) : 0 %>%" 
                                     aria-valuenow="<%= oneStars %>" aria-valuemin="0" aria-valuemax="<%= totalRatings %>"></div>
                            </div>
                            <span class="rating-number"><%= oneStars %></span>
                        </div>
                    </div>
                </div>
            </div>
            
            <%-- Rating Chart Card --%>
            <div class="col-lg-6 mb-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title m-0">Rating Distribution</h5>
                    </div>
                    <div class="card-body">
                        <div class="chart-container">
                            <canvas id="ratingChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <%-- Waiter Performance Card --%>
        <div class="row">
            <div class="col-12 mb-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title m-0">Waiter Performance</h5>
                    </div>
                    <div class="card-body">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Waiter ID</th>
                                    <th>Name</th>
                                    <th>Average Rating</th>
                                    <th>Rating</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Map.Entry<Integer, Double> entry : waiterRatings.entrySet()) { 
                                    int waiterId = entry.getKey();
                                    double rating = entry.getValue();
                                    Waiter waiter = waiterDAO.getWaiterById(waiterId);
                                    String waiterName = waiter != null ? waiter.getName() : "Unknown";
                                %>
                                <tr>
                                    <td><%= waiterId %></td>
                                    <td><%= waiterName %></td>
                                    <td><%= String.format("%.1f", rating) %></td>
                                    <td>
                                        <div class="progress" style="height: 20px;">
                                            <div class="progress-bar <%= rating >= 4.0 ? "bg-success" : (rating >= 3.0 ? "bg-warning" : "bg-danger") %>" 
                                                 role="progressbar" style="width: <%= (rating * 100) / 5 %>%;" 
                                                 aria-valuenow="<%= rating %>" aria-valuemin="0" aria-valuemax="5">
                                                <%= String.format("%.1f", rating) %>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        
        <%-- Recent Feedback Card --%>
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title m-0">Recent Feedback</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Table</th>
                                        <th>Order</th>
                                        <th>Waiter</th>
                                        <th>Rating</th>
                                        <th>Comment</th>
                                        <th>Date</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (feedbackList != null && !feedbackList.isEmpty()) {
                                        for (Feedback feedback : feedbackList) {
                                            Waiter waiter = waiterDAO.getWaiterById(feedback.getWaiterId());
                                            String waiterName = waiter != null ? waiter.getName() : "Unknown";
                                    %>
                                    <tr>
                                        <td><%= feedback.getFeedbackId() %></td>
                                        <td><%= feedback.getTableId() %></td>
                                        <td><%= feedback.getOrderId() %></td>
                                        <td><%= waiterName %></td>
                                        <td>
                                            <% for (int i = 1; i <= 5; i++) { %>
                                                <span class="<%= i <= feedback.getRating() ? "star-gold" : "" %>">★</span>
                                            <% } %>
                                        </td>
                                        <td><%= feedback.getComment() != null ? feedback.getComment() : "-" %></td>
                                        <td><%= feedback.getCreatedAt() %></td>
                                    </tr>
                                    <% } } else { %>
                                    <tr>
                                        <td colspan="7" class="text-center">No feedback available</td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Chart for rating distribution
        const ctx = document.getElementById('ratingChart').getContext('2d');
        const ratingChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['5 Stars', '4 Stars', '3 Stars', '2 Stars', '1 Star'],
                datasets: [{
                    label: 'Number of Ratings',
                    data: [<%= fiveStars %>, <%= fourStars %>, <%= threeStars %>, <%= twoStars %>, <%= oneStars %>],
                    backgroundColor: [
                        'rgba(40, 167, 69, 0.8)',
                        'rgba(40, 167, 69, 0.6)',
                        'rgba(255, 193, 7, 0.8)',
                        'rgba(255, 193, 7, 0.6)', 
                        'rgba(220, 53, 69, 0.8)'
                    ],
                    borderColor: [
                        'rgba(40, 167, 69, 1)',
                        'rgba(40, 167, 69, 1)',
                        'rgba(255, 193, 7, 1)',
                        'rgba(255, 193, 7, 1)',
                        'rgba(220, 53, 69, 1)'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            precision: 0
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>