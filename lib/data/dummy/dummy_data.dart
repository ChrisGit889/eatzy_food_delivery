class DummyData {
  List<String> restaurantImages = [
    'https://images.unsplash.com/photo-1555992336-03a23c4f1e1c',
    'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe',
    'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4',
    'https://images.unsplash.com/photo-1525610553991-2bede1a236e2',
  ];

  List<String> foodImages = [
    'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    'https://images.unsplash.com/photo-1555992336-03a23c4f1e1c',
    'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe',
    'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4',
    'https://images.unsplash.com/photo-1525610553991-2bede1a236e2',
  ];

  List categories = [
    {"name": "Pizza", "iconPath": "assets/images/Pizza.png"},
    {"name": "Burger", "iconPath": "assets/images/Burger.png"},
    {"name": "Snacks", "iconPath": "assets/images/Snacks.png"},
    {"name": "Drink", "iconPath": "assets/images/Water.png"},
    {"name": "Donut", "iconPath": "assets/images/Donut.png"},
  ];

  List popularRestaurants = [
    {
      "name": "Pizza Hut",
      "imagePath": "assets/images/Pizza-hut.png",
      "rating": 4.5,
      "reviews": 200,
      "address": "123 Main St",
      "menus": [
        {
          "name": "Pepperoni Pizza",
          "id": "dish_1",
          "imagePath": "assets/images/pick.png",
          "rating": 4.5,
          "reviews": 150,
          "price": 9.99,
          "description": "A delicious pepperoni pizza with extra cheese.",
        },
        {
          "name": "Cheese Pizza",
          "id": "dish_2",
          "imagePath": "assets/images/pick.png",
          "rating": 4.2,
          "reviews": 100,
          "price": 8.99,
          "description": "A classic cheese pizza with a crispy crust.",
        },
        {
          "name": "Veggie Pizza",
          "id": "dish_3",
          "imagePath": "assets/images/pick.png",
          "rating": 4.0,
          "reviews": 80,
          "price": 7.99,
          "description": "A healthy veggie pizza with fresh vegetables.",
        },
      ],
    },
    {
      "name": "Burger King",
      "imagePath": "assets/images/Burger-king.png",
      "rating": 4.0,
      "reviews": 120,
      "address": "456 Elm St",
      "menus": [
        {
          "name": "Cheeseburger",
          "id": "dish_4",
          "imagePath": "assets/images/pick.png",
          "rating": 4.2,
          "reviews": 100,
          "price": 7.99,
          "description":
              "A juicy cheeseburger with melted cheese and fresh toppings.",
        },
        {
          "name": "Bacon Burger",
          "id": "dish_5",
          "imagePath": "assets/images/pick.png",
          "rating": 4.3,
          "reviews": 90,
          "price": 8.99,
          "description":
              "A flavorful bacon burger with crispy bacon and savory sauce.",
        },
        {
          "name": "Veggie Burger",
          "id": "dish_6",
          "imagePath": "assets/images/pick.png",
          "rating": 4.1,
          "reviews": 70,
          "price": 6.99,
          "description":
              "A tasty veggie burger with a plant-based patty and fresh veggies.",
        },
      ],
    },
    {
      "name": "Subway",
      "imagePath": "assets/images/Subway.png",
      "rating": 4.2,
      "reviews": 150,
      "address": "789 Oak St",
      "menus": [
        {
          "name": "Turkey Sub",
          "id": "dish_7",
          "imagePath": "assets/images/pick.png",
          "rating": 4.3,
          "reviews": 110,
          "price": 6.99,
          "description": "A delicious turkey sub with fresh vegetables.",
        },
        {
          "name": "Ham Sub",
          "id": "dish_8",
          "imagePath": "assets/images/pick.png",
          "rating": 4.1,
          "reviews": 90,
          "price": 6.49,
          "description": "A savory ham sub with melted cheese.",
        },
        {
          "name": "Veggie Sub",
          "id": "dish_9",
          "imagePath": "assets/images/pick.png",
          "rating": 4.0,
          "reviews": 80,
          "price": 5.99,
          "description":
              "A healthy veggie sub with a variety of fresh vegetables.",
        },
      ],
    },
    {
      "name": "KFC",
      "imagePath": "assets/images/Kfc.png",
      "rating": 4.3,
      "reviews": 180,
      "address": "101 Pine St",
      "menus": [
        {
          "name": "Fried Chicken",
          "id": "dish_10",
          "imagePath": "assets/images/pick.png",
          "rating": 4.5,
          "reviews": 160,
          "price": 8.99,
          "description":
              "Crispy fried chicken pieces served with a side of fries.",
        },
        {
          "name": "Chicken Sandwich",
          "id": "dish_11",
          "imagePath": "assets/images/pick.png",
          "rating": 4.2,
          "reviews": 120,
          "price": 7.49,
          "description": "A tasty chicken sandwich with lettuce and mayo.",
        },
        {
          "name": "Veggie Wrap",
          "id": "dish_12",
          "imagePath": "assets/images/pick.png",
          "rating": 4.0,
          "reviews": 90,
          "price": 6.99,
          "description":
              "A healthy veggie wrap with fresh vegetables and hummus.",
        },
      ],
    },
    {
      "name": "Starbucks",
      "imagePath": "assets/images/Starbucks.png",
      "rating": 4.6,
      "reviews": 250,
      "address": "202 Maple St",
      "menus": [
        {
          "name": "Caffe Latte",
          "id": "dish_13",
          "imagePath": "assets/images/pick.png",
          "rating": 4.7,
          "reviews": 200,
          "price": 3.99,
          "description":
              "A creamy caffe latte made with espresso and steamed milk.",
        },
        {
          "name": "Cappuccino",
          "id": "dish_14",
          "imagePath": "assets/images/pick.png",
          "rating": 4.5,
          "reviews": 150,
          "price": 3.49,
          "description": "A classic cappuccino with a rich espresso flavor.",
        },
        {
          "name": "Mocha",
          "id": "dish_15",
          "imagePath": "assets/images/pick.png",
          "rating": 4.6,
          "reviews": 180,
          "price": 4.49,
          "description":
              "A delicious mocha made with espresso, chocolate, and steamed milk.",
        },
      ],
    },
    {
      "name": "Domino's",
      "imagePath": "assets/images/Dominos-pizza.png",
      "rating": 4.4,
      "reviews": 70,
      "address": "303 Birch St",
      "menus": [
        {
          "name": "BBQ Chicken Pizza",
          "id": "dish_16",
          "imagePath": "assets/images/pick.png",
          "rating": 4.5,
          "reviews": 60,
          "price": 10.99,
          "description": "A flavorful BBQ chicken pizza with tangy sauce.",
        },
        {
          "name": "Hawaiian Pizza",
          "id": "dish_17",
          "imagePath": "assets/images/pick.png",
          "rating": 4.2,
          "reviews": 50,
          "price": 9.99,
          "description": "A tropical Hawaiian pizza with ham and pineapple.",
        },
        {
          "name": "Meat Lovers Pizza",
          "id": "dish_18",
          "imagePath": "assets/images/pick.png",
          "rating": 4.3,
          "reviews": 40,
          "price": 11.99,
          "description":
              "A hearty meat lovers pizza with pepperoni, sausage, and bacon.",
        },
      ],
    },
  ];

  List popularFoods = [
    {
      "name": "Pepperoni Pizza",
      "imagePath": "assets/images/pick.png",
      "rating": 4.5,
      "reviews": 150,
      "price": 9.99,
    },
    {
      "name": "Cheeseburger",
      "imagePath": "assets/images/pick.png",
      "rating": 4.2,
      "reviews": 100,
      "price": 7.99,
    },
    {
      "name": "Veggie Hotdog",
      "imagePath": "assets/images/pick.png",
      "rating": 4.0,
      "reviews": 80,
      "price": 5.99,
    },
    {
      "name": "Chocolate Donut",
      "imagePath": "assets/images/pick.png",
      "rating": 4.8,
      "reviews": 200,
      "price": 2.99,
    },
    {
      "name": "Coca Cola",
      "imagePath": "assets/images/pick.png",
      "rating": 4.3,
      "reviews": 90,
      "price": 1.99,
    },
  ];
}
