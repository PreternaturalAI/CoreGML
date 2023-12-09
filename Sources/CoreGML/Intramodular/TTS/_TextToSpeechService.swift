//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swift

public protocol _TextToSpeechService {
    func send<R: _TextToSpeechServiceRequest>(
        _ request: R
    ) async throws -> R.Response
}

public protocol _TextToSpeechServiceRequest: Codable, Hashable, Sendable {
    associatedtype Response: _TextToSpeechServiceResponse
}

public protocol _TextToSpeechServiceResponse: Codable, Hashable, Sendable {
    
}

public struct _TTSSimpleTextToSpeechRequest: _TextToSpeechServiceRequest {
    public let text: String
}

extension _TTSSimpleTextToSpeechRequest {
    public struct Response: _TextToSpeechServiceResponse {
        public let data: Data
    }
}
