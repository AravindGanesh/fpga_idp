import numpy as np

#message = 'message[0] <= \"x\";' + '\n'

#A = '{'

#for i in range(26):
	#for j in range(26):
		#A += 'Res1[' + str(25-i) + '][' + str(25-j) + '], '
	
##message += 'message[677] <= \"x\";' + '\n'

#A += '} = Res;'

message = ''

for i in range(676):
	message += 'message['+ str(i) + ' ] <= Res['+  str(8*(675-i) +7)+':'+str(8*(675-i))+'];' + '\n'


print(message)
