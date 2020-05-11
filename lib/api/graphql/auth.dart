String createUser(String name, String username, String email) => """
  mutation CreateUser 
   {
    createUser(
      name: "$name",
      username: "$username",
      email: "$email"
    ) {
      user {
        id, name, username, email, currentProgram
      }
    }
  }
""";