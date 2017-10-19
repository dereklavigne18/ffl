db = require '../modules/db_helper.coffee'

padEnd = (startString, targetLength, padString) ->
  while startString.length < targetLength
    startString += padString
  return startString.substring(0, targetLength)

module.exports = (robot) ->

  # Matches any string with case-insensitive standings in it
  robot.respond /.*standings.*/i, (res) ->
    db.executeQuery(
        'CALL spLoadStandings()',
        (err, result, fields) ->
          attachments = [{title: 'Standings', text: ' '}]
          for team, i in result[0]
            dress = if i is 19 then ':dress:' else ''
            rank_length = if i < 9 then 8 else 7

            fields = [
              {
                value: padEnd("*#{i + 1}.*", rank_length, ' ') + "#{team.location} #{team.nickname} #{dress}",
                short: true
              },
              {
                value: "#{team.wins}-#{team.losses}-#{team.ties}     #{team.pointsFor}",
                short: true
              }
            ]

            if i < 8
              color = 'good'
            else if i < 16
              color = 'warning'
            else
              color = 'danger'
            attachments.push {text: ' ', color: color, mrkdwn_in: ['fields'], fields: fields}
          res.send {attachments: attachments}
    )


