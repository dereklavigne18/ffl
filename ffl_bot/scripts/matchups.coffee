db = require '../modules/db_helper.coffee'

module.exports = (robot) ->

  # Matches any string with case-insensitive matchups in it
  robot.respond /.*matchups*/i, (res) ->
    db.executeQuery(
        'CALL spLoadMatchups();',
        (err, result, fields) ->
          attachments = [{title: 'Matchups', text: ' '}]
          titleAttachments = {
            text: ' ',
            mrkdwn_in: ['fields'],
            fields: [
              {
                value: "*Home*",
                short: true
              },
              {
                value: "*Away*",
                short: true
              }
            ]
          }
          for matchup, i in result[0]
            homeDress = if matchup.homeRank is 20 then ':dress:' else ''
            awayDress = if matchup.awayRank is 20 then ':dress:' else ''

            fields = [
              {
                value: "*#{matchup.homeLocation} #{matchup.homeNickname} ##{matchup.homeRank}* #{homeDress}\n" + "Owner: #{matchup.homeOwnerFirstName} #{matchup.homeOwnerLastName}\n" + "#{matchup.homeWins}-#{matchup.homeLosses}-#{matchup.homeTies}     #{matchup.homePointsFor}\n",
                short: true
              },
              {
                value: "*#{matchup.awayLocation} #{matchup.awayNickname} ##{matchup.awayRank}* #{awayDress}\n" + "Owner: #{matchup.awayOwnerFirstName} #{matchup.awayOwnerLastName}\n" + "#{matchup.awayWins}-#{matchup.awayLosses}-#{matchup.awayTies}     #{matchup.awayPointsFor}\n",
                short: true
              }
            ]
            attachments.push {text: ' ', mrkdwn_in: ['fields'], fields: fields}
          res.send {attachments: attachments}
    )
