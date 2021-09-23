mixin Queries {
  static String getGender = '''
    query getGender(\$id: String!) {
      User(where: {id: {_eq: \$id}}) {
        gender
      }
    }
  ''';
  static String getHistories = '''
    query getHistories(\$user_id: String!) {
      RunHistory(order_by: {date: desc}, where: {user_id: {_eq: \$user_id}}) {
        id
        avg
        date
        distance
        image
        steps
        time
        user_id
      }
    }
  ''';
  static String getInfoUser = '''
    query getUser(\$id: String!) {
      User(where: {id: {_eq: \$id}}) {
        email
        gender
        money
        name
        id
        user_skin_id
        badges
      }
    }
  ''';

  static String getGoal = '''
    query getGoal(\$user_id: String!) {
      Goal(where: {user_id: {_eq: \$user_id}}) {
        step
        time
        distance
      }
    }
  ''';

  static String get7DaysHistories = '''
   query get7DaysHistories(\$user_id: String!, \$date: timestamp!) {
      RunHistory(order_by: {date: desc}, where: {user_id: {_eq: \$user_id}, date: {_gte: \$date}}) {
        avg
        date
        distance
        id
        steps
        time
        user_id
      }
    }
  ''';

  static String getSumDistanceToday = '''
    query getSumDistanceToday(\$user_id: String!, \$date: timestamp!) {
      RunHistory_aggregate(where: {_and: {user_id: {_eq: \$user_id}, date: {_gte: \$date}}}) {
        aggregate {
          sum {
            distance
            steps
          }
        }
      }
    }
    ''';

  static String getReward = '''
   query getReward(\$user_id: String!) {
      GetReward(where: {user_id: {_eq: \$user_id}}) {
        days_row
        get_reward
      }
    }
  ''';

  static String getRewardDaily = '''
   query getDailyReward(\$user_id: String!) {
      DailyReward(where: {user_id: {_eq: \$user_id}}) {
        days_row
        current_daily
      }
    }
  ''';

  static String getAllBadges = '''
    query getAllBadges {
      Badges {
        id
        subtitle
        title
        level
      }
    }
  ''';
}
