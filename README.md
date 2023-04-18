# Clarus Tech Test
## Context
Assuming we’re working on a simple system for managing warehouses, our users expect to be able to create orders for the selected warehouse in our system.
Users then might want to dispatch these orders to send stocks to their clients, and doing this physically removes them from the warehouse.

The application should consist of 5 primary resources:


* Warehouse - representing physical warehouse
* Product - representing a product that is being stored in warehouses (one product can be used in all warehouses in the system)
* Stock - represents the physical stock in a warehouse, stores information about what product that is, which warehouse its physically in and what is its quantity - for example stock can be a bottle of water stored in a warehouse in Manchester while a product would simply be a bottle of water
* StockBalance - represents the count of all available and ordered stocks in each warehouse, it is expected to hold information about:
  * What warehouse is it
  * What product is it
  * How many stocks are available
  * How many stocks were ordered
* Order - represents an order placed to a warehouse by an end-client, it is expected to hold information about:
  * What warehouse it was ordered from
  * What product was ordered
  * What stock was automatically selected
  * Status of the order - can either be “new” or “dispatched”

The application is experiencing really high traffic, we can expect up to 1000 orders to be created every second, make sure the system can process that without failures.

## Business requirements
For the first MVP the business came up with given user stories:

### As a user I want to be able to create an order for a product so that I can order the given product and have it delivered to me.

Given that I try to create an order when the available stock balance is greater than zero then I can see the order created in the system with the first stock available in selected warehouse selected and the available stock balance decreased by 1 and ordered balance increased by 1

Given that I try to create an order when the available stock balance is zero then I expect to see an error message and no new order in the system


### As a user I want to be able to dispatch an order so that I can mark the order as delivered and remove stocks from the system

Given that I try to dispatch an order when the order is in “new” status then I can see the order marked as “dispatched” and I can see the stock removed from the system and the ordered balance decreased by 1

Given that I try to dispatch an order when the order is in “dispatched” status then I expect to see an error message

### As a user I want to be able to create a stock so that I can bring more stocks that can then be ordered

Given that I try to create a new stock when the stock is created successfully then I can see the available stock balance increased by 1

Given that I try to create a stock when the creation fails then I expect the stock balance to not be affected

## Technical Details
We want it to be a simple REST API, it was decided with the FrontEnd team that we’d expose endpoints to:
* Create order
* Create stock
* Retrieve information about stock balance and order


## Delivery
* Implement the described endpoints that will match the given user stories and acceptance criteria.
* Add tests

## “Nice To Have”
* Nice responses from the endpoints (up to you what it will look like)
* Good logic separation
* Any improvements over standard scaffolded rails API that you see fit
* No race conditions
# clarus-app
# clarus-app
