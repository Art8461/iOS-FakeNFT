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
    case network(Error)
    case decoding(Error)
    case invalidData
    case notFound(String)
    case unknown(Error)

    var localizedDescription: String {
        switch self {
        case .network(let error):
            if let clientError = error as? NetworkClientError {
                switch clientError {
                case .urlSessionError:
                    return "Сетевая ошибка: не удалось получить ответ от сервера"
                case .httpStatusCode(let code):
                    return "Сетевая ошибка: сервер вернул HTTP статус \(code)"
                case .urlRequestError(let err):
                    return "Сетевая ошибка: \(err.localizedDescription)"
                case .parsingError:
                    return "Ошибка парсинга ответа от сервера"
                }
            }
            // Любая другая системная ошибка
            return "Сетевая ошибка: \(error.localizedDescription)"
            
        case .decoding(let error):
            return "Ошибка декодирования: \(error.localizedDescription)"
        case .invalidData:
            return "Некорректные данные"
        case .notFound(let msg):
            return "Не найдено: \(msg)"
        case .unknown(let error):
            return "Неизвестная ошибка: \(error.localizedDescription)"
        }
    }
}


