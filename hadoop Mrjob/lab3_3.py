from mrjob.job import MRJob
from mrjob.step import MRStep
from mrjob.protocol import RawProtocol

class lab3_3(MRJob):
    OUTPUT_PROTOCOL=RawProtocol
    def steps(self):
        return[
            MRStep(mapper=self.map_get_ratings,
                  reducer=self.reduce_count_ratings)
        ]
    def map_get_ratings(self, _,line):
        (num,year,type1,loc,case,LAT,LONG,Date)=line.split(',')
        yield type1,int(case)
    def reduce_count_ratings(self,key,values):
        yield key.encode('utf-8'), str(sum(values))
if __name__=='__main__':
    lab3_3.run()
