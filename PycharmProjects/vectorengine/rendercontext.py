from bitmap import *
class RenderContext(Bitmap):
	width, height = float(), float()
	zbuffer = np.array([], dtype=int)
	def __init__(self,*args):
		if len(args) == 2:
			self.width, self.height = args[0],args[1]
			self.display = np.zeros([self.width * self.height * 4],dtype=int)
			self.display = Image.fromarray(self.display)
		else:
			img = Image.open(args[0])
			img =  img.convert("RGBA")
			self.width,self.height = img.size
				#self.display = np.array([self.width * self.height * 4], dtype=int)
			self.display = np.array(img)
			self.display = Image.fromarray(self.display)
		self.zbuffer= np.zeros([self.width*self.height],dtype=int)
	def ClearDepthBuffer(self):
		for x in len(self.width*self.height):
			self.zbuffer[x] = 0

