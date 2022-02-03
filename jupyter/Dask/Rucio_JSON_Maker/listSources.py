#! /usr/bin/env python

from __future__ import print_function

import pandas as pd
import sys
import json
import argparse

from rucio.client import Client

parser = argparse.ArgumentParser(description='Process arguments.')
parser.add_argument('--dsets', dest='dsets', help='list of datasets')
parser.add_argument('--json', dest='json', help='output json file')
args = parser.parse_args()

rucio = Client()

dsets = pd.read_csv(args.dsets)


hostnames = ["root://xrootd.cmsaf.mit.edu:1094/",
             "root://cmsxrootd-site.fnal.gov/",
             "root://xrootd.rcac.purdue.edu/",
             "root://xrootd-local.unl.edu:1094/",
             "root://cmsio7.rc.ufl.edu:1094/",
             "root://redirector.t2.ucsd.edu:1094/",
             "root://cmsxrootd.hep.wisc.edu:1094/",
             "root://xcache-redirector.t2.ucsd.edu:2040/",
             "root://eoscms.cern.ch//eos/cms",
             "root://xrootd-vanderbilt.sites.opensciencegrid.org:1094/",
             "root://dcache-cms-xrootd.desy.de:1094/",
             "root://xrootd-cms.infn.it:1194/",
             "root://cmsxrootd-kit.gridka.de:1094/",
             "root://xrootd-cmst1-door.pic.es:1094//pnfs/pic.es/data/cms/disk",
             "root://maite.iihe.ac.be:1095/",
             "root://storage01.lcg.cscs.ch:1096//pnfs/lcg.cscs.ch/cms/trivcat",
             "root://ccxrootdcms.in2p3.fr:1094//pnfs/in2p3.fr/data/cms/disk/data",
             "root://xrootd.echo.stfc.ac.uk/",
             "root://grid-cms-xrootd.physik.rwth-aachen.de:1094/",
             "root://ingrid-se08.cism.ucl.ac.be:1094/",
             "root://t2-xrdcms.lnl.infn.it:7070/",
             "root://xrootd01.jinr-t1.ru:1094//pnfs/jinr-t1.ru/data/cms",
             "root://lcgsexrd.jinr.ru:1095/",
             "root://eos.grid.vbc.ac.at:1094//eos/vbc/experiments/cms",
             "root://gaexrdoor.ciemat.es:1094/",
             "root://xrootd.hep.kbfi.ee:1094/"]


hierarchy = ["T2_US_MIT",
             "T1_US_FNAL_Disk",
             "T2_US_Purdue",
             "T2_US_Nebraska",
             "T2_US_Florida",
             "T2_US_UCSD",
             "T2_US_Wisconsin",
             "T2_US_Caltech",
             "T2_CH_CERN",
             "T2_US_Vanderbilt",
             "T2_DE_DESY",
             "T1_IT_CNAF_Disk"
             "T1_DE_KIT_Disk",
             "T1_ES_PIC_Disk",
             "T2_BE_IIHE",
             "T2_CH_CSCS",
             "T1_FR_CCIN2P3_Disk"
             "T1_UK_RAL_Disk",
             "T2_DE_RWTH"
             "T2_BE_UCL",
             "T1_IT_Legnaro",
             "T1_RU_JINR_Disk",
             "T2_RU_JINR",
             "T2_AT_Vienna",
             "T2_ES_CIEMAT",
             "T2_EE_Estonia"]

jsondict = {}

dcounter = 0
for d in dsets['fullname'].values:
    blocks = rucio.list_content(scope='cms', name=d)
    shortname = dsets['shortname'].values.tolist()[dcounter]
    if shortname.startswith("#"):
        dcounter += 1
        continue
    
    for b in blocks:
        block_replicas = rucio.list_dataset_replicas(scope=b['scope'], name=b['name'], deep=True)
        files = rucio.list_content(scope='cms', name=b['name'])
        for f in files:
            file_replicas = rucio.list_replicas([{'scope':'cms','name':f['name']}])
            for fr in file_replicas:
                scounter = 0
                for s in hierarchy:
                    if s in fr['states'] and fr['states'][s] == 'AVAILABLE':
                        fname = hostnames[scounter] + fr['name']
                        print(fname)
                        if shortname not in jsondict:
                            jsondict[shortname] = []
                            jsondict[shortname].append(fname)
                        else:
                            jsondict[shortname].append(fname)
                        break                        
                    scounter += 1
    dcounter += 1

with open(args.json, 'w') as fp:
    json.dump(jsondict, fp, sort_keys=True, indent=4)
