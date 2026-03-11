#ifndef VDESCCALCULATOR_H
#define VDESCCALCULATOR_H

#include <cstdint>

class VDescCalculator
{
public:
    VDescCalculator();

    void update(float alt, uint32_t tMis);
    float velocidad() const;
    bool disponible() const;
    void reset();

    // Velocidad máxima razonable para un CanSat (m/s)
    // Cualquier valor mayor se considera error de sensor GPS
    static constexpr float VELOCIDAD_MAX = 100.0f;

private:
    float m_velocidad = 0.0f;
    float m_altAnterior = 0.0f;
    uint32_t m_tMisAnterior = 0;
    bool m_disponible = false;
    bool m_primerDato = true;
};

#endif // VDESCCALCULATOR_H
