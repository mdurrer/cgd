#! /usr/bin/env python

class Level:
    """The Base Class for Levels"""
    def getLayout(self):
        """Get the Layout of the level"""
        """Returns a [][] list"""
        pass
    def getImages(self):
        """Get a list of all the images used by the level"""
        """Returns a list of all the images used.  The indices 
        in the layout refer to sprites in the list returned by
        this function"""
        pass