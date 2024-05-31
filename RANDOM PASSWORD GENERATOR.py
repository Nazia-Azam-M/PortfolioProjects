#!/usr/bin/env python
# coding: utf-8

# In[2]:


import random

print("Welcome to random password generator")
random_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890!@#$%^&"
numofpwds = int(input("Please enter the number of passwords to be generated : "))
pwdlen = int(input("Please enter the length of the passsword needed : "))

print("Here are your random passwords : ")
for x in range (numofpwds):
    pwd = ""
    for chars in range(pwdlen):
        pwd = pwd + random.choice(random_chars)
    print(pwd)

