cat .job.ad

export CUDA_VISIBLE_DEVICES=0,1,2

python condor_tensorflow.py

echo ">>>>>>>>>>\n"
echo ""
ls -a
echo "<<<<<<<<<<\n"
echo ""
cat .machine.ad
sleep 5

