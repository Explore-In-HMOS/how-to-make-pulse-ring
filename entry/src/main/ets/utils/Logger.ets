export enum LogLevel {
  Off = 0,
  Error = 1,
  Warn = 2,
  Info = 3,
  Debug = 4,
  Trace = 5
}

export type LogSink = (level: LogLevel, tag: string, message: string) => void

function nowIso(): string {
  // YYYY-MM-DD HH:mm:ss.mmm
  const d = new Date()
  const pad = (n: number, w: number = 2) => n.toString().padStart(w, '0')
  return `${d.getFullYear()}-${pad(d.getMonth()+1)}-${pad(d.getDate())} ` +
    `${pad(d.getHours())}:${pad(d.getMinutes())}:${pad(d.getSeconds())}.${pad(d.getMilliseconds(),3)}`
}

function levelLabel(level: LogLevel): string {
  switch (level) {
    case LogLevel.Error:
      return 'ERROR'

    case LogLevel.Warn:
      return 'WARN'

    case LogLevel.Info:
      return 'INFO'

    case LogLevel.Debug:
      return 'DEBUG'

    case LogLevel.Trace:
      return 'TRACE'

    default:
      return 'OFF'

  }
}

const defaultSink: LogSink = (level, tag, msg) => {
  const line = `[${nowIso()}] [${levelLabel(level)}] [${tag}] ${msg}`
  // In real usage you might use console.info/error by level.
  // Keeping single call avoids platform-specific differences.
  console.info(line)
}

export class Logger {
  private _level: LogLevel = LogLevel.Info
  private _tag: string
  private _sink: LogSink = defaultSink

  constructor(tag: string) {
    this._tag = tag
  }

  setLevel(level: LogLevel): void {
    this._level = level
  }

  get level(): LogLevel {
    return this._level
  }

  setSink(sink: LogSink | null): void {
    this._sink = sink ?? defaultSink
  }

  private emit(level: LogLevel, msg: string): void {
    if (level <= LogLevel.Off){
      return
    }
    if (level > this._level){
      return
    }
    this._sink(level, this._tag, msg)
  }

  error(msg: string): void {
    this.emit(LogLevel.Error, msg)
  }

  warn(msg: string): void {
    this.emit(LogLevel.Warn, msg)
  }

  info(msg: string): void {
    this.emit(LogLevel.Info, msg)
  }

  debug(msg: string): void {
    this.emit(LogLevel.Debug, msg)
  }

  trace(msg: string): void {
    this.emit(LogLevel.Trace, msg)
  }

  // Helper to log objects without JSON circular issues (best-effort).
  json(label: string, value: string | number | boolean | null | object): void {
    try {
      let text: string
      if (typeof value === 'string') {
        text = value
      } else if (typeof value === 'number' || typeof value === 'boolean' || value === null) {
        text = String(value)
      } else {
        // object
        text = JSON.stringify(value as object)
      }
      this.info(`${label}: ${text}`)
    } catch (_) {
      this.info(`${label}: [unserializable]`)
    }
  }
}