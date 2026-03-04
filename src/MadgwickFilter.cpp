#include "MadgwickFilter.h"

static constexpr float DEG_TO_RAD = M_PI / 180.0f;
static constexpr float RAD_TO_DEG = 180.0f / M_PI;

MadgwickFilter::MadgwickFilter()
    : q0(1.0f), q1(0.0f), q2(0.0f), q3(0.0f)
    , m_beta(0.1f)
{
}

void MadgwickFilter::update(float ax, float ay, float az,
                             float gx, float gy, float gz,
                             float mx, float my, float mz,
                             float dt)
{
    // Convertir giroscopio de °/s a rad/s
    gx *= DEG_TO_RAD;
    gy *= DEG_TO_RAD;
    gz *= DEG_TO_RAD;

    float q0q0 = q0 * q0, q0q1 = q0 * q1, q0q2 = q0 * q2, q0q3 = q0 * q3;
    float q1q1 = q1 * q1, q1q2 = q1 * q2, q1q3 = q1 * q3;
    float q2q2 = q2 * q2, q2q3 = q2 * q3;
    float q3q3 = q3 * q3;

    // Normalizar acelerómetro
    float normA = invSqrt(ax * ax + ay * ay + az * az);
    if (normA == 0.0f) return;
    ax *= normA; ay *= normA; az *= normA;

    // Normalizar magnetómetro
    float normM = invSqrt(mx * mx + my * my + mz * mz);
    if (normM == 0.0f) {
        // Sin magnetómetro: usar solo IMU (6DOF)
        float s0, s1, s2, s3;
        float _2q0 = 2.0f * q0, _2q1 = 2.0f * q1, _2q2 = 2.0f * q2, _2q3 = 2.0f * q3;
        float _4q0 = 4.0f * q0, _4q1 = 4.0f * q1, _4q2 = 4.0f * q2;
        float _8q1 = 8.0f * q1, _8q2 = 8.0f * q2;

        s0 = _4q0 * q2q2 + _2q2 * ax + _4q0 * q1q1 - _2q1 * ay;
        s1 = _4q1 * q3q3 - _2q3 * ax + 4.0f * q0q0 * q1 - _2q0 * ay - _4q1 + _8q1 * q1q1 + _8q1 * q2q2 + _4q1 * az;
        s2 = 4.0f * q0q0 * q2 + _2q0 * ax + _4q2 * q3q3 - _2q3 * ay - _4q2 + _8q2 * q1q1 + _8q2 * q2q2 + _4q2 * az;
        s3 = 4.0f * q1q1 * q3 - _2q1 * ax + 4.0f * q2q2 * q3 - _2q2 * ay;

        float normS = invSqrt(s0 * s0 + s1 * s1 + s2 * s2 + s3 * s3);
        s0 *= normS; s1 *= normS; s2 *= normS; s3 *= normS;

        float qDot0 = 0.5f * (-q1 * gx - q2 * gy - q3 * gz) - m_beta * s0;
        float qDot1 = 0.5f * ( q0 * gx + q2 * gz - q3 * gy) - m_beta * s1;
        float qDot2 = 0.5f * ( q0 * gy - q1 * gz + q3 * gx) - m_beta * s2;
        float qDot3 = 0.5f * ( q0 * gz + q1 * gy - q2 * gx) - m_beta * s3;

        q0 += qDot0 * dt;
        q1 += qDot1 * dt;
        q2 += qDot2 * dt;
        q3 += qDot3 * dt;

        float normQ = invSqrt(q0 * q0 + q1 * q1 + q2 * q2 + q3 * q3);
        q0 *= normQ; q1 *= normQ; q2 *= normQ; q3 *= normQ;
        return;
    }
    mx *= normM; my *= normM; mz *= normM;

    // Campo magnético de referencia
    float hx = 2.0f * (mx * (0.5f - q2q2 - q3q3) + my * (q1q2 - q0q3) + mz * (q1q3 + q0q2));
    float hy = 2.0f * (mx * (q1q2 + q0q3) + my * (0.5f - q1q1 - q3q3) + mz * (q2q3 - q0q1));
    float bx = std::sqrt(hx * hx + hy * hy);
    float bz = 2.0f * (mx * (q1q3 - q0q2) + my * (q2q3 + q0q1) + mz * (0.5f - q1q1 - q2q2));

    // Función objetivo del gradiente
    float s0, s1, s2, s3;
    float _2q0mx = 2.0f * q0 * mx, _2q0my = 2.0f * q0 * my, _2q0mz = 2.0f * q0 * mz;
    float _2q1mx = 2.0f * q1 * mx;
    float _2bx = 2.0f * bx, _2bz = 2.0f * bz;
    float _4bx = 2.0f * _2bx, _4bz = 2.0f * _2bz;
    float _2q0 = 2.0f * q0, _2q1 = 2.0f * q1, _2q2 = 2.0f * q2, _2q3 = 2.0f * q3;

    s0 = -_2q2 * (2.0f * q1q3 - _2q0 * q2 - ax) + _2q1 * (2.0f * q0q1 + _2q2 * q3 - ay)
         - _2bz * q2 * (_2bx * (0.5f - q2q2 - q3q3) + _2bz * (q1q3 - q0q2) - mx)
         + (-_2bx * q3 + _2bz * q1) * (_2bx * (q1q2 - q0q3) + _2bz * (q0q1 + q2q3) - my)
         + _2bx * q2 * (_2bx * (q0q2 + q1q3) + _2bz * (0.5f - q1q1 - q2q2) - mz);

    s1 = _2q3 * (2.0f * q1q3 - _2q0 * q2 - ax) + _2q0 * (2.0f * q0q1 + _2q2 * q3 - ay)
         - 4.0f * q1 * (1.0f - 2.0f * q1q1 - 2.0f * q2q2 - az)
         + _2bz * q3 * (_2bx * (0.5f - q2q2 - q3q3) + _2bz * (q1q3 - q0q2) - mx)
         + (_2bx * q2 + _2bz * q0) * (_2bx * (q1q2 - q0q3) + _2bz * (q0q1 + q2q3) - my)
         + (_2bx * q3 - _4bz * q1) * (_2bx * (q0q2 + q1q3) + _2bz * (0.5f - q1q1 - q2q2) - mz);

    s2 = -_2q0 * (2.0f * q1q3 - _2q0 * q2 - ax) + _2q3 * (2.0f * q0q1 + _2q2 * q3 - ay)
         - 4.0f * q2 * (1.0f - 2.0f * q1q1 - 2.0f * q2q2 - az)
         + (-_4bx * q2 - _2bz * q0) * (_2bx * (0.5f - q2q2 - q3q3) + _2bz * (q1q3 - q0q2) - mx)
         + (_2bx * q1 + _2bz * q3) * (_2bx * (q1q2 - q0q3) + _2bz * (q0q1 + q2q3) - my)
         + (_2bx * q0 - _4bz * q2) * (_2bx * (q0q2 + q1q3) + _2bz * (0.5f - q1q1 - q2q2) - mz);

    s3 = _2q1 * (2.0f * q1q3 - _2q0 * q2 - ax) + _2q2 * (2.0f * q0q1 + _2q2 * q3 - ay)
         + (-_4bx * q3 + _2bz * q1) * (_2bx * (0.5f - q2q2 - q3q3) + _2bz * (q1q3 - q0q2) - mx)
         + (-_2bx * q0 + _2bz * q2) * (_2bx * (q1q2 - q0q3) + _2bz * (q0q1 + q2q3) - my)
         + _2bx * q1 * (_2bx * (q0q2 + q1q3) + _2bz * (0.5f - q1q1 - q2q2) - mz);

    // Normalizar gradiente
    float normS = invSqrt(s0 * s0 + s1 * s1 + s2 * s2 + s3 * s3);
    s0 *= normS; s1 *= normS; s2 *= normS; s3 *= normS;

    // Integrar
    float qDot0 = 0.5f * (-q1 * gx - q2 * gy - q3 * gz) - m_beta * s0;
    float qDot1 = 0.5f * ( q0 * gx + q2 * gz - q3 * gy) - m_beta * s1;
    float qDot2 = 0.5f * ( q0 * gy - q1 * gz + q3 * gx) - m_beta * s2;
    float qDot3 = 0.5f * ( q0 * gz + q1 * gy - q2 * gx) - m_beta * s3;

    q0 += qDot0 * dt;
    q1 += qDot1 * dt;
    q2 += qDot2 * dt;
    q3 += qDot3 * dt;

    // Normalizar quaternion
    float normQ = invSqrt(q0 * q0 + q1 * q1 + q2 * q2 + q3 * q3);
    q0 *= normQ; q1 *= normQ; q2 *= normQ; q3 *= normQ;
}

float MadgwickFilter::pitch() const
{
    float sinp = 2.0f * (q0 * q2 - q3 * q1);
    if (std::fabs(sinp) >= 1.0f)
        return std::copysign(90.0f, sinp);
    return std::asin(sinp) * RAD_TO_DEG;
}

float MadgwickFilter::roll() const
{
    float sinr = 2.0f * (q0 * q1 + q2 * q3);
    float cosr = 1.0f - 2.0f * (q1 * q1 + q2 * q2);
    return std::atan2(sinr, cosr) * RAD_TO_DEG;
}

float MadgwickFilter::yaw() const
{
    float siny = 2.0f * (q0 * q3 + q1 * q2);
    float cosy = 1.0f - 2.0f * (q2 * q2 + q3 * q3);
    return std::atan2(siny, cosy) * RAD_TO_DEG;
}

void MadgwickFilter::setBeta(float beta)
{
    m_beta = beta;
}

void MadgwickFilter::reset()
{
    q0 = 1.0f;
    q1 = q2 = q3 = 0.0f;
}

float MadgwickFilter::invSqrt(float x)
{
    if (x <= 0.0f) return 0.0f;
    return 1.0f / std::sqrt(x);
}
