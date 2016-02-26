class B(object):
    number = float()
    string = str()
    def __init__(self,number,string):
        self.number = number
        self.string = string
    def __repr__(self):
        return "%f,%s" %(self.number,self.string)