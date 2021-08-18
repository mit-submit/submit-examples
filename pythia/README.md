# Installing pythia

In High Energy Physics pythia one of the most used generators. It is a very mature package with a huge amount of features that allows experimentalists and theorists alike to study many aspects of particle collisions.

The package is very well documented (https://pythia.org/) and it seems superflues to put a documentation here but just to make sure inexperienced users find an easy to use installation for our submit system readily available.

A one line example of how to install pythia is to use:

       git clone https://github.com/mit-submit/submit-examples
       cd submit-examples/pythia
       source ./install.sh

To run run a specific pythia setup simply do this:

       cd submit-examples/pythia/pythia8306/examples
       make main01
       ./main01

This builds the main01.cc files to oobtain the executable main01. The program will by default generate 100 events at LHC conditions and shows the charged multiplicity in a histogram at the end. It is easy to build any of the other examples and based of that your own. I find it useful to look through the various examples and pick up ideas of the available features.
