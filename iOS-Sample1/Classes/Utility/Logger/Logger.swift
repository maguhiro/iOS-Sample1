import SwiftyBeaver

let log = Logger.shared

public final class Logger {
  public static let shared = Logger()

  private let format = "$DHH:mm:ss$d $C$L$c $N.$F:$l [$T] - $M $X"

  private lazy var console: ConsoleDestination = {
    let console = ConsoleDestination()
    console.asynchronously = true
    console.minLevel = .debug
    console.format = format
    return console
  }()

  private init() {
    SwiftyBeaver.addDestination(console)
  }
}

// MARK: ログ出力メソッド

public extension Logger {
  func v(_ message: CustomStringConvertible, context: Any? = nil, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
    print(.verbose, message: message, context: context, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
  }

  func d(_ message: CustomStringConvertible, context: Any? = nil, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
    print(.debug, message: message, context: context, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
  }

  func i(_ message: CustomStringConvertible, context: Any? = nil, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
    print(.info, message: message, context: context, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
  }

  func w(_ message: CustomStringConvertible, context: Any? = nil, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
    print(.warning, message: message, context: context, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
  }

  func e(_ message: CustomStringConvertible, context: Any? = nil, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
    print(.error, message: message, context: context, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
  }
}

// swiftlint:disable function_parameter_count
// SwiftyBeaverに渡す引数に対応するため
private extension Logger {
  func print(_ logLevel: SwiftyBeaver.Level,
             message: CustomStringConvertible,
             context: Any?,
             functionName: String,
             fileName: String,
             lineNumber: Int) {
    SwiftyBeaver.custom(level: logLevel, message: message.description, file: fileName, function: functionName, line: lineNumber, context: context)
  }
}

// swiftlint:enable function_parameter_count
