# Requirement for this project
- bunjs
- xampp
- flutter
- android studio

## If not exist, they could be downloaded here
- bunjs (https://bun.sh/)
- xampp (https://www.apachefriends.org/)
- flutter (https://docs.flutter.dev/get-started/install)
- android studio (https://developer.android.com/studio)

# Step for backend
1. Start xampp
2. create the database
3. import the data by using flutter_project.sql file in the database folder
4. create the .env file then add the key (there is an example in .env.example)
5. before running the server, open the terminal then type `bun install` to install the dependencies
6. starting the server by typing `bun run dev` in the terminal

# Step for application
1. create the .env file then add the key (there is an example in .env.example)
2. before running the server, open the terminal then type `flutter pub get` to install the dependencies
3. starting the server by typing `flutter run` in the terminal