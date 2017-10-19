from Scrapers import TeamsScraper

def updateTeams(divisionIds, seasonIds):
    for divisionId in divisionIds:
        for seasonId in seasonIds:
            teams = TeamsScraper.scrape(divisionId, seasonId)
            teams.save()

if __name__ == '__main__':
    from argparse import ArgumentParser
    from Models.SeasonCollection import SeasonCollection
    from Models.DivisionCollection import DivisionCollection

    parser = ArgumentParser()
    parser.add_argument('-y', '--yahoo', action = 'store_true')
    parser.add_argument('-e', '--espn', action = 'store_true')
    parser.add_argument('-s', '--season', nargs = '*')
    args = parser.parse_args()

    divisions = DivisionCollection()
    divisions.load()

    divisionIds = []
    if args.yahoo:
        divisionIds.append(divisions.searchBy({'isYahoo': True}).id)
    if args.espn:
        divisionIds.append(divisions.searchBy({'isYahoo': False}).id)
    if not divisionIds:
        raise ValueError('Either the ESPN or Yahoo flag must be set')

    seasons = SeasonCollection()
    seasons.load()

    seasonIds = []
    if not args.season:
        seasonIds.append(seasons.searchBy({'isCurrent': True}).id)
    else:
        seasonIdInputs = [int(id) for id in args.season]
        for season in seasons:
            if season.id in seasonIdInputs:
                seasonIds.append(season.id)
        if not seasonIds:
            raise ValueError('No valid seasons provided')

    updateTeams(divisionIds, seasonIds)