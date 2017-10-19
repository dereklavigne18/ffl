from Scrapers import MatchupsScraper

def updateMatchups(seasonIds):
    for seasonId in seasonIds:
        matchups = MatchupsScraper.scrape(seasonId)
        matchups.save()

if __name__ == '__main__':
    from argparse import ArgumentParser
    from Models.SeasonCollection import SeasonCollection

    parser = ArgumentParser()
    parser.add_argument('-s', '--seasons', nargs = '*')
    args = parser.parse_args()

    seasons = SeasonCollection()
    seasons.load()

    seasonIds = []
    if not args.seasons:
        seasonIds.append(seasons.searchBy({'isCurrent': True}).id)
    else:
        seasonIdInputs = [int(id) for id in args.seasons]
        for season in seasons:
            if season.id in seasonIdInputs:
                seasonIds.append(season.id)
        if not seasonIds:
            raise ValueError('No valid seasons provided')

    updateMatchups(seasonIds)