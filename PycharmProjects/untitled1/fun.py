class Entity(object):
    def __init__(self,name,age):
        self.name = name
        self.age = age
        self.id = id(self)
        print("Hello Entity called %s with an age of %i"%(self.name,self.age))
    def getAge(self):
        return self.age
    def getName(self):
        return self.name
    def setAge(self,value):
        self.age = value
        return self.age
    def setName(self,value):
        self.name = value
        return self.name
    def getID(self):
        return id(self)
class Animal(Entity):
    def __init__(self,name,age,type=None):
        self.name = name
        self.age = age
        self.type = type
        self.id = id(self)
        print("Hello Animal called %s with an age of %i"%(self.name,self.age))
class Human(Animal):
    def __init__(self,name,age):
        self.name = name
        self.age = age
        self.type = "human"
        self.id = id(self)
        print ("Hello %s, %i, with the ID number %i" %(self.name,self.age,self.id))
    def getAge(self):
        return self.age
    def getName(self):
        return self.name
    def setAge(self,value):
        self.age = value
        return self.age
    def setName(self,value):
        self.name = value
        return self.name
    def getID(self):
        return id(self)


if __name__ == '__main__':
    print("Following: THE CREATION OF LIFE!\n")
    lifeformA = Entity("Lifeform",10000000000)
    animalA = Animal("Zazou",20)
    michael = Human("Michael Durrer",28)
    rene = Human ("René Liechti",60)
    print("\n")
    print(michael.getName()+"'s ID is:",michael.getID())
    print(rene.getName()+"'s ID is:",rene.getID())
    print(lifeformA.getName() + "'s name is",lifeformA.getID())
    print(animalA.getName() + "'s name is",lifeformA.getID())