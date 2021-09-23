mixin Mutations {
  static String addHistory() {
    return '''mutation InsertRunHistory(\$avg: Int!,\$date: timestamp!,\$distance: float8!,\$image: String!, \$steps: Int!,\$time: String!,\$user_id: String!, \$money: Int!) {
      insert_RunHistory(objects: {avg: \$avg, date: \$date, distance: \$distance, image: \$image, steps: \$steps, time: \$time, user_id: \$user_id, money: \$money}) {
        returning {
          id
          avg
          distance
          date
          image
          steps
          time
          money
          user_id
        }
      }
    }''';
  }

  static String addUserInfo() {
    return '''mutation InsertUser(\$id: String!, \$name: String!,\$email: String!, \$money: Int!) {
      insert_User(objects: {id: \$id, name: \$name, email: \$email,money: \$money}) {
        returning {
          id
          email
          money
          name
          user_skin_id
        }
      }
    }''';
  }

  static String updateGender() {
    return '''mutation UpdateGenderUser(\$gender: Gender_enum!, \$id: String!) {
      update_User(where: {id: {_eq: \$id}}, _set: {gender: \$gender}) {
        returning {
          id
          gender
        }
      }
    }''';
  }

  static String addGoals() {
    return '''mutation updateGoal(\$distance: float8!, \$time: Int!, \$step: Int!, \$user_id: String!) {
      delete_Goal(where: {user_id: {_eq: \$user_id}}) {
        affected_rows
      }
      insert_Goal(objects: {distance: \$distance, time: \$time, step: \$step, user_id: \$user_id}) {
        returning {
          distance
          step
          time
          user_id
        }
      }
    }''';
  }

  static String updateMoney() {
    return '''mutation updateUser(\$user_id: String!, \$money: Int!) {
      update_User(where: {id: {_eq: \$user_id}}, _set: {money: \$money}) {
        returning {
          money
          email
          name
        }
      }
    }''';
  }

  static String insertReward() {
    return '''mutation insertGetReward(\$user_id: String!) {
      insert_GetReward(objects: {days_row: 1, user_id: \$user_id}) {
        returning {
      get_reward
      days_row
    }
  }
}
''';
  }

  static String insertRewardDaily() {
    return '''mutation insertDailyReward(\$user_id: String!, \$current_daily: timestamp!) {
      insert_DailyReward(objects: {days_row: 0, user_id: \$user_id, current_daily: \$current_daily}) {
        returning {
          current_daily
          days_row
        }
      }
    }
  ''';
  }

  static String updateReward() {
    return '''mutation updateGetReward(\$user_id: String!, \$get_reward: timestamp!) {
      update_GetReward(where: {user_id: {_eq: \$user_id}}, _set: {get_reward: \$get_reward}) {
        returning {
          get_reward
        }
      }
    }''';
  }

  static String updateRewardDaily() {
    return '''mutation updateDailyReward(\$user_id: String!,\$current_daily: timestamp!, \$days_row: Int!) {
      update_DailyReward(where: {user_id: {_eq: \$user_id}}, _set: {current_daily: \$current_daily, days_row: \$days_row}) {
        returning {
          current_daily
          days_row
        }
      }
    }
  ''';
  }
}
