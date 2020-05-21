from mrjob.job import MRJob
from mrjob.step import MRStep

class lab3_2(MRJob):
	def steps(self):
		return[
			MRStep(mapper=self.map_get_ratings,
			       reducer=self.reduce_count_ratings)
			,
			MRStep(reducer=self.reduce_ratings)
		]
	def map_get_ratings(self, _ , line):
		(user_id,movie_id,rating,timestamp)=line.split('\t')
		yield movie_id,1
	def reduce_count_ratings(self,key,values):
		yield None, (key ,str(sum(values)).zfill(5))
	def reduce_ratings(self,_,values):
		for key,value in sorted(values, key=lambda x:x[1]):
			yield key ,value
if __name__=='__main__':
	lab3_2.run()
