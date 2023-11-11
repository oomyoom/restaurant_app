const menuData = {
  menu_title: "The Halal Guys",
  menu_image: "./src/models/images/medium_4.png",
  menu_price: 10.0,
  categories: [
    {
      category_title: "Category 1",
      options: [
        { option_title: "Option 1", option_price: 5.0 },
        { option_title: "Option 2", option_price: 6.0 },
      ],
    },
    {
      category_title: "Category 2",
      options: [
        { option_title: "Option 3", option_price: 4.0 },
        { option_title: "Option 4", option_price: 7.0 },
      ],
    },
  ],
};

module.exports = { menuData };
