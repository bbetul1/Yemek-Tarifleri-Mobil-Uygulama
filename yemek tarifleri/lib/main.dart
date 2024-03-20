import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class User {
  final String username;
  final String password;

  User(this.username, this.password);
}

class Recipe {
  final String name;
  final String ingredients;
  final String instructions;
  final String imageAsset;
  final String heroTag;

  Recipe(this.name, this.ingredients, this.instructions, this.imageAsset)
      : heroTag = 'heroTag_$name';
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  List<User> users = [
    User('your_username', 'your_password'),
  ];
  User? currentUser;
  String passwordRequirementsMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Secret Favor',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 24.0,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Kullanıcı Adı',
                  labelStyle: TextStyle(color: Colors.yellow),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  labelStyle: TextStyle(color: Colors.yellow),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.yellow,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (usernameController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty) {
                        if (checkPasswordRequirements(passwordController.text)) {
                          User newUser = User(
                            usernameController.text,
                            passwordController.text,
                          );
                          users.add(newUser);
                          usernameController.clear();
                          passwordController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Kayıt başarıyla tamamlandı.'),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(passwordRequirementsMessage),
                            ),
                          );
                        }
                      }
                    },
                    child: Text('Kayıt Ol'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      currentUser = users.firstWhereOrNull(
                            (u) =>
                        u.username == usernameController.text &&
                            u.password == passwordController.text,
                      );

                      if (currentUser != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipePage(currentUser!),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Geçersiz kullanıcı adı veya şifre.'),
                          ),
                        );
                      }
                    },
                    child: Text('Giriş Yap'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool checkPasswordRequirements(String password) {
    int uppercaseCount = password.replaceAll(RegExp(r'[^A-Z]'), '').length;
    int lowercaseCount = password.replaceAll(RegExp(r'[^a-z]'), '').length;
    int digitCount = password.replaceAll(RegExp(r'[^0-9]'), '').length;
    int specialCharCount = password.replaceAll(RegExp(r'[a-zA-Z0-9]'), '').length;

    if (uppercaseCount >= 2 &&
        lowercaseCount >= 3 &&
        digitCount >= 2 &&
        specialCharCount >= 1 &&
        password.length >= 8) {
      return true;
    } else {
      passwordRequirementsMessage =
      'Şifreniz aşağıdaki kurallara uymalıdır:\n'
          '- En az 2 büyük harf\n'
          '- En az 3 küçük harf\n'
          '- En az 2 rakam\n'
          '- En az 1 noktalama işareti\n'
          '- Toplam 8 karakter uzunluğunda olmalıdır';
      return false;
    }
  }
}

class RecipePage extends StatefulWidget {
  final User user;

  RecipePage(this.user);

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  List<Recipe> recipes = [];
  List<Recipe> favoriteRecipes = [];
  List<Recipe> filteredRecipes = [];

  TextEditingController recipeNameController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();
  TextEditingController instructionsController = TextEditingController();

  @override
  void initState() {
    super.initState();

    recipes.add(
      Recipe(
        'Spaghetti Bolognese',
        'Makarna, kıyma, soğan, sarımsak, domates sosu, baharatlar',
        'Kıymayı kavurun, soğan ve sarımsağı ekleyin, domates sosu ve baharatları ilave edin. Haşlanmış makarnayla servis yapın.',
        'images/indir5.jpg',
      ),
    );

    recipes.add(
      Recipe(
        'Tavuk Izgara',
        'Tavuk göğsü, zeytinyağı, baharatlar',
        'Tavuk göğsünü zeytinyağı ve baharatlarla marine edin. Izgarada ya da tavada pişirin.',
        'images/indir4.jpg',
      ),
    );

    recipes.add(
      Recipe(
        'Sebzeli Quinoa Salatası',
        'Quinoa, renkli biber, domates, salatalık, taze nane, zeytinyağı, limon suyu',
        'Quinoa pişirin, doğranmış sebzelerle karıştırın. Zeytinyağı ve limon suyu ile soslayarak servis yapın.',
        'images/indi6.jpg',
      ),
    );

    recipes.add(
      Recipe(
        'Balık Tacos',
        'Somon veya levrek filetosu, taco kabuğu, marullar, salsa sosu',
        'Balık filetolarını ızgarada veya tavada pişirin. Taco kabuklarına marulları ve balığı yerleştirin. Üzerine salsa sosu ekleyerek servis yapın.',
        'images/indir2.jpg',
      ),
    );

    recipes.add(
      Recipe(
        'Mantarlı Risotto',
        'İtalyan risotto pirinci, mantar, soğan, sarımsak, tavuk suyu, parmesan peyniri',
        'Soğanı ve sarımsağı kavurun, mantarları ekleyin. Risotto pirincini ilave edip tavuk suyu ile pişirin. Son olarak parmesan peyniri ekleyerek karıştırın.',
        'images/indir.jpg',
      ),
    );

    // Initialize filteredRecipes with all recipes initially
    filteredRecipes = List.from(recipes);
  }

  // Function to filter recipes based on search query
  void filterRecipes(String query) {
    setState(() {
      filteredRecipes = recipes
          .where((recipe) =>
          recipe.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: filterRecipes,
          controller: recipeNameController,
          decoration: InputDecoration(
            hintText: 'Ara...',
            hintStyle: TextStyle(color: Colors.white70),
            icon: Icon(Icons.search),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              bool confirmExit = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Çıkış Yap'),
                  content: Text('Çıkmak istediğinize emin misiniz?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: Text('Hayır'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: Text('Evet'),
                    ),
                  ],
                ),
              );

              if (confirmExit == true) {
                Navigator.pop(context);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritePage(favoriteRecipes),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tarifler:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredRecipes.length,
                itemBuilder: (context, index) {
                  Recipe recipe = filteredRecipes[index];
                  bool isFavorite = favoriteRecipes.contains(recipe);

                  return ListTile(
                    title: Text(recipe.name),
                    subtitle: Text(recipe.ingredients),
                    leading: Hero(
                      tag: recipe.heroTag,
                      child: Image.asset(
                        recipe.imageAsset,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(recipe.name),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Hero(
                                tag: recipe.heroTag,
                                child: Image.asset(
                                  recipe.imageAsset,
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text('Malzemeler:'),
                              Text(recipe.ingredients),
                              SizedBox(height: 8),
                              Text('Tarif:'),
                              Text(recipe.instructions),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Kapat'),
                            ),
                          ],
                        ),
                      );
                    },
                    trailing: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : null,
                      ),
                      onPressed: () {
                        setState(() {
                          if (isFavorite) {
                            favoriteRecipes.remove(recipe);
                          } else {
                            favoriteRecipes.add(recipe);
                          }
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Recipe? newRecipe = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Tarif Ekle'),
              content: Column(
                children: [
                  TextField(
                    controller: recipeNameController,
                    decoration: InputDecoration(
                      labelText: 'Yemek Adı',
                    ),
                  ),
                  TextField(
                    controller: ingredientsController,
                    decoration: InputDecoration(
                      labelText: 'Malzemeler',
                    ),
                  ),
                  TextField(
                    controller: instructionsController,
                    decoration: InputDecoration(
                      labelText: 'Tarif',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                  child: Text('İptal'),
                ),
                TextButton(
                  onPressed: () {
                    String recipeName = recipeNameController.text;
                    String ingredients = ingredientsController.text;
                    String instructions = instructionsController.text;

                    if (recipeName.isNotEmpty &&
                        ingredients.isNotEmpty &&
                        instructions.isNotEmpty) {
                      Recipe newRecipe =
                      Recipe(recipeName, ingredients, instructions, '');
                      Navigator.pop(context, newRecipe);
                    } else {
                      showSnackBar(context, 'Boş alan bırakmayınız.');
                    }
                  },
                  child: Text('Ekle'),
                ),
              ],
            ),
          );

          if (newRecipe != null) {
            setState(() {
              recipes.add(newRecipe);
              filteredRecipes = List.from(recipes);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class FavoritePage extends StatelessWidget {
  final List<Recipe> favoriteRecipes;

  FavoritePage(this.favoriteRecipes);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favori Tarifler'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Favori Tarifler:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: favoriteRecipes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(favoriteRecipes[index].name),
                    subtitle: Text(favoriteRecipes[index].ingredients),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (var element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}
