//
//  ProfileLogger.swift
//  FakeNFT
//
//  Created by Андрей Пермяков on 07.02.2026.
//

import Foundation

final class Logger {
    
    static let shared = Logger()
    private init() {}
    
    enum Level: String {
        case info = "ℹ️ INFO"
        case success = "✅ SUCCESS"
        case error = "❌ ERROR"
    }
    
    func log(
        _ message: String,
        level: Level = .info,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let fileName = (file as NSString).lastPathComponent
        print("[\(level.rawValue)] [\(fileName):\(line) \(function)] - \(message)")
    }
    
    func logSuccess(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .success, file: file, function: function, line: line)
    }
    
    func logError(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .error, file: file, function: function, line: line)
    }
}

enum ProfileNetworkError: Error {
    case network(String)
    case decoding(String)
    case invalidData
    case notFound(String)
    case unknown(String)

    var localizedDescription: String {
        switch self {
        case .network(let msg): return "Сетевая ошибка: \(msg)"
        case .decoding(let msg): return "Ошибка декодирования: \(msg)"
        case .invalidData: return "Некорректные данные"
        case .notFound(let msg): return "Не найдено: \(msg)"
        case .unknown(let msg): return "Неизвестная ошибка: \(msg)"
        }
    }
}
