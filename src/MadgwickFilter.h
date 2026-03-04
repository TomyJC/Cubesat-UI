#ifndef MADGWICKFILTER_H
#define MADGWICKFILTER_H

#include <cmath>

class MadgwickFilter
{
public:
    MadgwickFilter();

    // acc en g, gyro en °/s (se convierte internamente a rad/s), mag en µT
    void update(float ax, float ay, float az,
                float gx, float gy, float gz,
                float mx, float my, float mz,
                float dt);

    float pitch() const; // grados
    float roll() const;  // grados
    float yaw() const;   // grados

    void setBeta(float beta);
    void reset();

private:
    float q0, q1, q2, q3; // quaternion
    float m_beta;

    static float invSqrt(float x);
};

#endif // MADGWICKFILTER_H
