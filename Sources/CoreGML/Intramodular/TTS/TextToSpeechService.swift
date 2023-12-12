//
// Copyright (c) Vatsal Manot
//

import Foundation
import Merge
import Swift

/// A unified interface for a text-to-speech (TTS) service.
public protocol TextToSpeechService: _MaybeAsyncProtocol {
    func send<R: TextToSpeechServiceRequest>(
        _ request: R
    ) async throws -> R.Response
}

public protocol TextToSpeechServiceRequest: Codable, Hashable, Sendable {
    associatedtype Response: TextToSpeechServiceResponse
}

public protocol TextToSpeechServiceResponse: Codable, Hashable, Sendable {
    
}

public struct _TTSSimpleTextToSpeechRequest: TextToSpeechServiceRequest {
    public let text: String
}

extension _TTSSimpleTextToSpeechRequest {
    public struct Response: TextToSpeechServiceResponse {
        public let data: Data
    }
}
