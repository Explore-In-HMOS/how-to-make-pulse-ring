export interface RGB { r: number; g: number; b: number }
export interface RGBA extends RGB { a: number }

export function clampByte(n: number): number {
  if (n < 0){
    return 0
  }
  if (n > 255){
    return 255
  }
  return n | 0
}

export function rgbToHex(c: RGB): string {
  const r = clampByte(c.r).toString(16).padStart(2, '0')
  const g = clampByte(c.g).toString(16).padStart(2, '0')
  const b = clampByte(c.b).toString(16).padStart(2, '0')
  return `#${r}${g}${b}`
}

export function hexToRgb(hex: string): RGB | null {
  const m = /^#?([0-9a-fA-F]{6})$/.exec(hex)
  if (!m){
    return null
  }
  const n = parseInt(m[1], 16)
  return { r: (n >> 16) & 0xff, g: (n >> 8) & 0xff, b: n & 0xff }
}

export function mix(a: RGB, b: RGB, t: number): RGB {
  const k = Math.max(0, Math.min(1, t))
  return {
    r: (a.r + (b.r - a.r) * k) | 0,
    g: (a.g + (b.g - a.g) * k) | 0,
    b: (a.b + (b.b - a.b) * k) | 0
  }
}

export function luma(c: RGB): number {
  // Rec. 709
  return 0.2126 * c.r + 0.7152 * c.g + 0.0722 * c.b
}

export function readableOn(c: RGB): '#000' | '#fff' {
  return luma(c) > 128 ? '#000' : '#fff'
}