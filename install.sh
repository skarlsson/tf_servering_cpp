rm -rf build serving

git clone --recursive https://github.com/tensorflow/serving.git -b 1.12.0
cd serving
git clone --recursive https://github.com/tensorflow/tensorflow.git -b v1.12.0
cd ..
mkdir build && cd build
cmake ..
make -j4
sudo make install






