message = ''

for i in range(676):
	#message += 'message['+ str(i) + ' ] <= A['+  str(5*(783-i) +4)+':'+str(5*(783-i))+'];' + '\n'
	message += 'message['+ str(i) + ' ] <= Res['+  str(8*(675-i) +7)+':'+str(8*(675-i))+'];' + '\n'



print(message)
