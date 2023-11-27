//
// Copyright (c) Vatsal Manot
//

import Swift

public protocol _TTSService {
    func send<R: _TTSRequest>(_ request: R) async throws -> _TTSResponse
}

public protocol _TTSRequest {
    associatedtype Response
}

public protocol _TTSResponse {
    
}

public struct _TTSSimpleTextToSpeechRequest<Response: _TTSResponse>: _TTSRequest {
    public let text: String
}
