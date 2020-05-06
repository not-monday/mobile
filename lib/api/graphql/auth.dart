const String CREATE_USER = r"""
  mutation test {
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