class BaseCollection(object):
    SORT_ORDER_ASCENDING = False
    SORT_ORDER_DESCENDING = True

    def __init__(self):
        self.models = []

    def __str__(self):
        out = '[\n'
        for model in self.models:
            out += str(model) + ',\n'
        out = out.rstrip(',\n')
        out += ']'
        return out

    def __iter__(self):
        return iter(self.models)

    def __add__(self, other):
        collection = self.__class__()
        collection.models = self.models + other.models
        return collection

    def toArray(self):
        return [model.__dict__ for model in self.models]

    def first(self):
        if (len(self.models)):
            return self.models[0]
        return None

    def last(self):
        if (len(self.models)):
            return self.models[-1]
        return None

    def populate(self, data):
        if data is None:
            return False

        for modelData in data:
            model = self.modelClass()()
            model.populate(modelData)
            self.push(model)

    def push(self, model):
        self.models.append(model)

    def searchBy(self, searchParams):
        for model in self.models:
            match = True
            for propertyName, value in searchParams.items():
                if value != getattr(model, propertyName):
                    match = False
                    break
            if match:
                return model

    def sortBy(self, sortParams):
        for propertyName, ascending in reversed(sortParams):
            self.models = sorted(self.models, key = lambda model: getattr(model, propertyName), reverse = not ascending)

    def filter(self, filters):
        for attribute, value in filters.items():
            self.filterBy(attribute, value)

    def filterBy(self, attribute, value):
        matchingModels = []
        for model in self.models:
            if getattr(model, attribute) == value:
                matchingModels.append(model)

        self.models = matchingModels
