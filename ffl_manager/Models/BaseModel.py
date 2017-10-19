class BaseModel(object):
    
    def __str__(self):
        out = '{\n'
        for key, value in self.__dict__.items():
            out += key + ': ' + str(value) + ',\n'
        out = out.rstrip(',\n')
        out += '}'
        return out

    def populate(self, data):
        if data is None:
            return False

        for attr, value in self.__dict__.items():
            if attr in data.keys():
                setattr(self, attr, data[attr])
