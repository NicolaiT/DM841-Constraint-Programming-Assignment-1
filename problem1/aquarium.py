import os
import numpy
from minizinc import Instance, Model, Solver

instances = [file for file in os.listdir('.') if file.endswith('.in')]

def clean_line(line):
	line = line.split(' ')
	line = [int(s.strip('\n')) for s in line]
	return line

for i in range(0,len(instances)):
	print(f'Starting solving instance{i}')
	aquarium = Model('aquarium.mzn')
	gecode = Solver.lookup('gecode')
	instance = Instance(gecode, aquarium)
	file = open(instances[i],'r')
	instance['s'] = int(file.readline())

	instance['column_clues'] = clean_line(file.readline())
	instance['row_clues'] = clean_line(file.readline())
	start_array = []

	for line in file:
		start_array.append(clean_line(line))

	#print(start_array)

	instance['tanks'] = start_array

	#print(f's: {instance["s"]}')
	#print(f'column clues:  {instance["column_clues"]}')
	#print(f'row clues:  {instance["row_clues"]}')
	#print(f'tanks clues: {instance["tanks"]}')
	result = instance.solve(processes=4)

	print(f'Solution for instance{i}')
	print(result.statistics)
	print(result.solution)

	result_file = open(f'instance.{i}.out', 'w')
	result_file.write(str(result.solution))
	result_file.close()