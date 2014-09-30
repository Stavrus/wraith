angular.module('wraith.filters')

.filter 'userMatchBool', () ->
  (users, match_users, boolName, boolValue) ->
    result = []
    if users && match_users
      match_hash = {}
      for profile in match_users
        match_hash[profile.id] = profile

      for user in users
        result.push(user) if match_hash[user.match_user_ids[0]][boolName] == boolValue
    return result
