#!/usr/bin/env python
# coding: utf-8

# In[2]:


import numpy as np
from PIL import Image


# In[45]:


im = Image.open('img_137.jpg')
im = np.array(im)
im = im%32
# print(im)


# In[50]:


xstr = ''
xstr += '{'
for i in range(0,28):
    for j in range(0,28):
        xstr += '5\'d'
        xstr += str(im[i][j])
        xstr += ','
        #print('5\'d'+'im[i+'+str(i)+'][j+'+str(j)+'],')
        
xstr = xstr[:-1]
xstr += '}'
# print(xstr)


# In[52]:


def replace_in_file(filename, key, new_value):
    f = open(filename, "r")
    lines = f.readlines()
    f.close()
    for i, line in enumerate(lines):
        if line.split('=')[0].strip(' \n') == key:
            lines[i] = key + ' = ' + new_value + '\n'
    f = open(filename, "w")
    f.write("".join(lines))
    f.close()

replace_in_file("tb_sobel.v", 'A', xstr)


# In[47]:


# file = open('test.v','w')
# file.close()


# In[ ]:


xstr += '{'
for i in range(0,28):
    for j in range(0,28):
        xstr +='\''
        xstr += '5'
        xstr += '\\'
        xstr += '\'d'
        xstr += '\''
        xstr += '+'
        xstr += 'str(im[i+'
        xstr += str(i)
        xstr += '][j+'
        xstr += str(j)
        xstr += ']),'
        #print('5\'d'+'im[i+'+str(i)+'][j+'+str(j)+'],')
        
xstr = xstr[:-1]
xstr += '};'
print(xstr)
