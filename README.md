# FOOD WASTE MANAGEMENT DATABASE

### "Cutting food waste is a delicious way of saving money, helping to feed the world and protect the planet" 

This database was created to help a food waste management company keep track of orders and subscriptions, 
incentivise customers and to analyse the amount of food saved that would have just gone to landfill.

The customers are split into single orders and recurring subscriptions. Subscription deliveries can be skipped 
but the company would like to offer incentives to customers who go a certain period of time without skipping deliveries. 
Any additional orders placed on top of subscription deliveries would also generate a discount. 

In order to do this I have used nested queries and joins to analyse:
- Which subscription customers have placed additional orders
- The number of boxes sold
- Calculating the food weight of each box
- Whether subscription deliveries have been skipped
- Orders with food items needing temperature-controlled environments

Stored procedures:
- To check if the food expiry date is soon after the delivery date.
- To show subscription customers who placed additional orders 

Views:
- To analyse customer feedback and run queries on the view to analyse ratings 
- In order to calculate food weight saved I had to create two view tables and run a query join these view tables.

Stored function:
- To calculate food weight saved 

What I would do better next time:
- If I had more time or was to extend this project I would add multiple weeks of subscriptions/orders in order to do more complex analysis and display analysis in tableau.
- I would re-design my food table to enable better analysis 

