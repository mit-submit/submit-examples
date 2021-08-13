cd $PWD/grapple/
export PYTHONPATH=${PYTHONPATH}:${PWD}
cd $PWD/grapple/scripts/training/papu

echo "Starting to train"
pwd
cat ../../../../train.yaml
python3 train_pu.py -c ../../../../train.yaml
echo "Done training"
