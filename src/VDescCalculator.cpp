#include "VDescCalculator.h"
#include <cstdint>

VDescCalculator::VDescCalculator()
{
}

void VDescCalculator::update(float alt, uint32_t tMis)
{
    if (m_primerDato) {
        m_altAnterior = alt;
        m_tMisAnterior = tMis;
        m_primerDato = false;
        return;
    }

    uint32_t dt = tMis - m_tMisAnterior;
    if (dt > 0) {
        // V_DESC = (ALT[n] - ALT[n-1]) / (T_MIS[n] - T_MIS[n-1]) × 1000
        // dt está en ms, resultado en m/s
        m_velocidad = (alt - m_altAnterior) / static_cast<float>(dt) * 1000.0f;
        m_disponible = true;
    }

    m_altAnterior = alt;
    m_tMisAnterior = tMis;
}

float VDescCalculator::velocidad() const
{
    return m_velocidad;
}

bool VDescCalculator::disponible() const
{
    return m_disponible;
}

void VDescCalculator::reset()
{
    m_velocidad = 0.0f;
    m_altAnterior = 0.0f;
    m_tMisAnterior = 0;
    m_disponible = false;
    m_primerDato = true;
}
