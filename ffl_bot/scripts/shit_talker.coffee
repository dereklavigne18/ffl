db = require '../modules/db_helper.coffee'

module.exports = (robot) ->

  shitPhrases = [
    'licks wienie',
    'is a little bitch',
    'bends the knee',
    'is Reek',
    'eats at Wienie Hut Jr',
    'lays with men',
    'lights the menorah',
    'tapes their ankles',
    'sucks on ice'
  ]

  # Regex looking for talk shit
  robot.respond /talk\sshit/i, (res) ->
    db.executeQuery(
        'CALL spLoadMatchups();',
        (err, result, fields) ->
          phrase = res.random shitPhrases

          for matchup in result[0]
            if matchup.homeUserId is res.message.user.id
              res.send "@#{matchup.awayUserUsername} #{phrase}"
              return
            else if matchup.awayUserId is res.message.user.id
              res.send "@#{matchup.homeUserUsername} #{phrase}"
              return
          res.send "Your opponent hasn't joined slack cause he #{phrase}"
    )

