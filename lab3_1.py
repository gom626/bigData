from mrjob.job import MRJob
from mrjob.step import MRStep

class lab3_1(MRJob):
	def steps(self):
		return[
			MRStep(mapper=self.map_get_ratings,
			       reducer=self.reduce_count_ratings)
		]
	def map_get_ratings(self, _ , line):
		(user_id,movie_id,rating,timestamp)=line.split('\t')
		yield movie_id,1
	def reduce_count_ratings(self,key,values):
		yield key,sum(values)
if __name__=='__main__':
	lab3_1.run()
