#!/usr/bin/env python
# coding: utf-8

# In[3]:


import time

def countdowntimer(t):
    while t:
        mins, secs = divmod(t,60)
        timer = '{:02d}:{:02d}'.format(mins,secs)
        print(timer,end = '\r')
        time.sleep(1)
        t = t-1
    print("Countdown over!")
    
t = int(input("Please enter number of seconds: "))
countdowntimer(t)

