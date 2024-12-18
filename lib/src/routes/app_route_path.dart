enum AppRoute {
  auth(path: "/auth"),
  login(path: "login"),
  register(path: "register"),
  home(path: "/home/:user_id/:email/:username"),
  mainPage(path: "/main_page/:user_id/:email/:username"),
  createProduct(path: "/product/add"),
  updateProduct(path: "/product/update/:product_id/:product_name/:product_price"),
  params(path: "/params/:user_id/:email/:username"),
  anilistUser(path: "/anilist/:username"),
  animeList(path: "/anime_list"),
  commentsPage(path: "/comments/:post_id/:user_id");


  final String path;
  const AppRoute({required this.path});
}
