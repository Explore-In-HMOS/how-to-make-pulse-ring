export interface PulsePreset {
  name: string
  min: number     // vp
  max: number     // vp
  duration: number // ms
  easing: string
}

export const PRESETS: PulsePreset[] = [
  { name: 'Calm',       min: 84,  max: 140, duration: 1800, easing: 'smooth' },
  { name: 'Focus',      min: 90,  max: 132, duration: 1500, easing: 'ease-in-out' },
  { name: 'Box-Soft',   min: 96,  max: 136, duration: 2000, easing: 'ease' },
  { name: 'PowerNap',   min: 88,  max: 144, duration: 2200, easing: 'linear-out-slow-in' },
  { name: 'SlowCalm',   min: 80,  max: 142, duration: 2600, easing: 'smooth' },
  { name: 'QuickFocus', min: 92,  max: 128, duration: 1200, easing: 'fast-out-slow-in' },
]

export function getPresetByName(name: string): PulsePreset | undefined {
  for (let i = 0; i < PRESETS.length; i++) {
    if (PRESETS[i].name === name) return PRESETS[i]
  }
  return undefined
}

export function pickByDuration(ms: number): PulsePreset {
  let best = PRESETS[0]
  let score = Number.POSITIVE_INFINITY
  for (let i = 0; i < PRESETS.length; i++) {
    const p = PRESETS[i]
    const s = Math.abs(p.duration - ms)
    if (s < score) { score = s; best = p }
  }
  return best
}

export function closestPreset(min: number, max: number, duration: number): PulsePreset {
  let best = PRESETS[0]
  let score = Number.POSITIVE_INFINITY
  for (let i = 0; i < PRESETS.length; i++) {
    const p = PRESETS[i]
    const s = Math.abs(p.min - min) + Math.abs(p.max - max) + Math.abs(p.duration - duration) / 100
    if (s < score) { score = s; best = p }
  }
  return best
}