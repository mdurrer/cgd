from B import B
class C (B):
    def __init__(self,number,string,floater):
        super().__init__(number,string)
        self.floater = floater
    def __repr__(self):
        return "%f,%s%f" %(self.number,self.string,self.floater)