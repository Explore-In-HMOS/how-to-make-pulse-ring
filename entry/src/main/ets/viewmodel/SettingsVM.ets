import { PRESETS, PulsePreset, getPresetByName } from '../model/Presets'

export interface SettingsDTO {
  themeIdx: number
  preset?: string
  ringHex?: string
}

export class SettingsVM {
  private _themeIdx: number = 0
  private _preset: PulsePreset | null = null
  private _ringHex: string | null = null

  get themeIdx(): number { return this._themeIdx }
  set themeIdx(v: number) { this._themeIdx = v | 0 }

  get preset(): PulsePreset | null { return this._preset }
  set presetName(name: string | null) {
    this._preset = name ? (getPresetByName(name) ?? null) : null
  }

  get ringHex(): string | null { return this._ringHex }
  set ringHex(v: string | null) { this._ringHex = v }

  toJSON(): SettingsDTO {
    return {
      themeIdx: this._themeIdx,
      preset: this._preset ? this._preset.name : undefined,
      ringHex: this._ringHex ?? undefined
    }
  }

  load(dto: SettingsDTO): void {
    this._themeIdx = dto.themeIdx | 0
    this._preset = dto.preset ? (getPresetByName(dto.preset) ?? null) : null
    this._ringHex = dto.ringHex ?? null
  }

  listPresets(): ReadonlyArray<PulsePreset> {
    return PRESETS
  }
}