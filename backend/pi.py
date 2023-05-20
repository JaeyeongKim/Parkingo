import RPi.GPIO as gpio
import time
from flask import Flask
import requests

app = Flask(__name__)

threshold = 20
res_time = 0.1
num_car = 30 # edit this to change first car numbers

trig1 = 13
echo1 = 19

trig2 = 23
echo2 = 24

is_pass1 = 0
is_pass2 = 0
pre_is_pass1 = 0
pre_is_pass2 = 0

pre_dist1 = 1200
pre_dist2 = 1200

gpio.setmode(gpio.BCM)
gpio.setwarnings(False)

gpio.setup(trig1, gpio.OUT)
gpio.setup(trig2, gpio.OUT)

gpio.setup(echo1, gpio.IN)
gpio.setup(echo2, gpio.IN)

def dist(trig, echo):
  global srt, end

  gpio.output(trig, False)
  time.sleep(res_time)
  gpio.output(trig, True)
  time.sleep(0.00001)
  gpio.output(trig, False)
  while gpio.input(echo) == 0 :
    srt = time.time()
  while gpio.input(echo) == 1 :
    end = time.time()
  pulse_duration = end - srt
  distance = pulse_duration * 17000
  distance = round(distance)
  return distance

while True :

    dist1 = dist(trig1, echo1)
    dist2 = dist(trig2, echo2)

    if ((pre_dist1<threshold)&(dist1<threshold)):
        is_pass1 = 1

    else :
        is_pass1 = 0

    if ((pre_dist2<threshold)&(dist2<threshold)):
        is_pass2 = 2

    else :
        is_pass2 = 0

    #in
    if ((is_pass1 == 1)&(is_pass2 == 2)&(pre_is_pass2 == 0)):
      print("----------IN----------")
      num_car  = num_car+1
      url = 'http://server_ip/receive'
      response = requests.post(url,data= str(num_car))
      if response.status_code == 200:
        print("success")
      else:
        print("fail")

    #out
    elif ((is_pass1 == 1)&(is_pass2 == 2)&(pre_is_pass1 == 0)):
      print("----------OUT----------")
      num_car  = num_car-1
      url = 'http://server_ip/receive'
      response = requests.post(url,data= str(num_car))
      if response.status_code == 200:
        print("success")
      else:
        print("fail")

    pre_dist1 = dist1
    pre_dist2 = dist2
    pre_is_pass1 = is_pass1
    pre_is_pass2 = is_pass2

    print('%4d %4d %d %d' %(dist1, dist2, is_pass1, is_pass2))
