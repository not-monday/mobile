String queryUser(String id) => """
    query user {
       user(id : "$id") {
         name
         id
         email
       } 
    }
""";