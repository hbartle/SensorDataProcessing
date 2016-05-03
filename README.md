# Android Sensor Data Processing

This is a bundle of different algorithms and libraries to acquire and filter IMU sensor data over UDP.
It is possible to use an Android Smartphone with an accelerometer, gyroskope and a magnetometer for all three dimensions.

Proposed filter algorithms: 
				- Gradient Descent (Quaternion based)
				- Complementary Filter (Euler based)
				- standard Kalman Filter (Euler based)
				- extended, indirect Kalman Filter with adaptive estimation of external acceleration (Quaternion based)
				  (--> Still work in process)


