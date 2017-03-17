# grow_river.py -
#
# A demonstration of a technique for generating random rivers in a gameworld.  Specifically,
# it demonstrates how one might build a world one region at a time, creating regions only
# as the player explores them.  This technique allows one to grow a river that terminates
# at a body of water in one region, but has its spring in another.
#
# This is quick hack demo code and should be treated as such.  No warranty is provided as to the quality
# of code (probably poor).  USE AT YOUR OWN RISK!!

from random import randrange
from copy import copy

LENGTH = 20
WIDTH = 20
PLAINS = 0
WATER = 1
TREES = 2
HILLS = 3

class Terrain:
	def __init__(self,ch,type,elevation):
		self.__ch = ch
		self.__type = type
		self.__elevation = elevation
	
	def get_ch(self):
		return self.__ch

	def get_type(self):
		return self.__type

	def get_elevation(self):
		return self.__elevation

class Region:
	def __init__(self,length,width):
		self.__borders = []
		self.__length = length 
		self.__width = width
		self.__area = length * width
		self.__border_features = []

		# default the map squares to be plains
		self.__map = [Terrain('.',PLAINS,1)] * self.__area

	def set_sqr(self,r,c,sqr):
		self.__map[r*self.__width + c] = sqr
	
	def get_sqr(self,r,c):
		return self.__map[r*self.__width + c]

	def dump(self):
		for sqr in range(0,self.__area):
			if sqr % self.__width == 0:
				print

			print self.__map[sqr].get_ch(),

		print

		for j in self.__border_features:
			print 'There is a river bordering at ',j[1],j[2]

	def get_length(self):
		return self.__length

	def get_width(self):
		return self.__width

	def get_area(self):
		return self.__area

	def in_same_area(self,r0,c0,r1,c1):
		return self.get_sqr(r0,c0).get_type() == self.get_sqr(r1,c1)

	def add_border_feature(self,terrain,r,c,r_dir,c_dir):
		self.__border_features.append((terrain,r,c,r_dir,c_dir))	

	def get_border_features(self):
		return self.__border_features

class RegionGenerator:
	def __init__(self):
		self.__count = 0

	def get_new_region(self):
		# cook the first region so it is guaranteed to have a river flowing west.
		if self.__count == 0:
			self.__count += 1
			self.r0 = self.__region0()
			self.__add_cooked_river(self.r0,3,15)
			return self.r0
		elif self.__count == 1:
			self.__count += 1
			r1 = self.__region1()
			self.__handle_border_features(r1,('',self.r0,'',''))
			return r1

	def __region0(self):
		region0 = Region(LENGTH,WIDTH)

		# first, add a lake
		start = 8
		for j in range(0,12):
			for k in range(start,WIDTH):
				region0.set_sqr(j,k,Terrain('~',WATER,0))

			start += 1
		
		# add some hills
		end = 1
		for j in range(5,LENGTH):
			for k in range(0,end):
				region0.set_sqr(j,k,Terrain('^',HILLS,2))

			end += 1

		# add a few trees for variety
		for j in range(6,10):
			region0.set_sqr(11,j,Terrain('#',TREES,1))

		for j in range(8,11):
			region0.set_sqr(12,j,Terrain('#',TREES,1))
			region0.set_sqr(9,j,Terrain('#',TREES,1))

		for j in (9,10):
			region0.set_sqr(13,j,Terrain('#',TREES,1))

		for j in (7,8):
			region0.set_sqr(10,j,Terrain('#',TREES,1))

		return region0

	def __region1(self):
		region1 = Region(LENGTH,WIDTH)
	
		#add some hills
		for r in range(5,region1.get_length()):
			start = randrange(5,15)
			for c in range(start,region1.get_width()):
				region1.set_sqr(r,c,Terrain('^',HILLS,2))


		# add some trees
		for r in range(3,region1.get_length()-2):
			end = randrange(1,9)
			for c in range(0,end):
				region1.set_sqr(r,c,Terrain('#',TREES,1))
		return region1

	def __add_cooked_river(self,region,r,c):
		move = +1

		while 1:
			elevation = region.get_sqr(r,c).get_elevation()
			region.set_sqr(r,c,Terrain('~',WATER,elevation))
			prev_r = r
			prev_c = c
			r += move
			c -= 1

			if r == region.get_length() or r == -1:
				break

			if c == region.get_width() or c == -1:
				break
	
			move = self.__cooked_change_river_dir()
	
		elevation = region.get_sqr(prev_r,prev_c).get_elevation()
		region.add_border_feature(Terrain('~',WATER,elevation),prev_r,prev_c,move,-1)

	def __cooked_change_river_dir(self):
		x = randrange(0,100)

		if x < 60:
			return +1
		elif x in range(61,80):
			return 0
		else:
			return -1

	def __handle_border_features(self,region,bordering_regions):
		# handle northern border
		if bordering_regions[0] != '':
			for br in bordering_regions[0].get_border_features():
				if br[0].get_type() == WATER and br[1] == region.get_length()-1:
					self.__add_river(region,br[0],region.get_width()-1,br[3],br[4],br[0].get_elevation())

		# handle eastern border
		if bordering_regions[1] != '':
			for br in bordering_regions[1].get_border_features():
				if br[0].get_type() == WATER and br[2] == 0:
					self.__add_river(region,br[1],region.get_width()-1,br[3],br[4],br[0].get_elevation())
		
		# handle southern border
		if bordering_regions[2] != '':
			for br in bordering_regions[2].get_border_features():
				if br[0].get_type() == WATER and br[1] == 0:
					self.__add_river(region,br[1],region.get_width()-1,br[3],br[4],br[0].get_elevation())

		# handle western border
		if bordering_regions[3] != '':
			for br in bordering_regions[3].get_border_features():
				if br[0].get_type() == WATER and br[2] == region.get_width()-1:
					self.__add_river(region,br[1],region.get_width()-1,br[3],br[4],br[0].get_elevation())

	def __add_river(self,region,r,c,r_dir,c_dir,elevation):
		region.set_sqr(r,c,Terrain('~',WATER,elevation))
		stop_chance = 5
		
		move = (r_dir,c_dir)

		while 1:
			stop = randrange(0,100)

			if stop < stop_chance:
				break
			else:
				stop_chance += 5
			
			next_r = r + move[0]
			next_c = c + move[1]
			
			if next_r == region.get_length() or next_r == -1:
				region.add_border_feature(Terrain('~',WATER,elevation),r,c,move,-1)
				break
			elif next_c == region.get_width() or next_c == -1:
				region.add_border_feature(Terrain('~',WATER,elevation),r,c,move,-1)
				break

			next_sqr = region.get_sqr(next_r,next_c)

			if next_sqr.get_elevation() < elevation:
				break
			else:
				r = next_r
				c = next_c
				region.set_sqr(r,c,Terrain('*',WATER,next_sqr.get_elevation()))
				elevation = next_sqr.get_elevation()
				move = self.__change_river_dir(move)
			
	def __change_river_dir(self,move):
		j = randrange(0,100)
	
		# only change the dir about 1 in 4
		if j > 25:
			return move

		j = randrange(0,50)
		if j < 50: # change x
			m = move[0] + 1
			k = randrange(0,50)

			if k < 50:
				delta = 1
			else:
				delta = -1

			m += delta
			m = (m % 2) - 1
			return (m,move[1])
		else:
			m = move[1] + 1
			k = randrange(0,50)

			if k < 50:
				delta = 1
			else:
				delta = -1

			m += delta
			m = (m % 2) - 1
			return (move[0],m)

rg = RegionGenerator()

r0 = rg.get_new_region()
r0.dump()

r1 = rg.get_new_region()
r1.dump()
			
		
