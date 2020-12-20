rm -rf ./data
curl https://s3.amazonaws.com/fast-ai-imageclas/imagenette2-160.tgz -O imagenette2-160.tgz
tar -xzvf imagenette2-160.tgz
mkdir -p ./data/raw/train
mkdir -p ./data/raw/val
mv imagenette2-160/train data/raw/train
mv imagenette2-160/val data/raw/val
rm -rf imagenette2-160
rm imagenette2-160.tgz