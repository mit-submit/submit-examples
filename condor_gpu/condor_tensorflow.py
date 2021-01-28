#!/usr/bin/python

import socket
import tensorflow as tf

sess = tf.Session(config=tf.ConfigProto(log_device_placement=True))

print(sess)

print(socket.gethostname())

# Your tensorflow code

