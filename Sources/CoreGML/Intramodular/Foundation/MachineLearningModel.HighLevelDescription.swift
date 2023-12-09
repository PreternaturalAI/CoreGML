//
// Copyright (c) Vatsal Manot
//

import Swallow

extension MachineLearningModel {
    public struct HighLevelDescription: Codable, Hashable, Sendable {
        public let rawValue: [Descriptor]
        
        public init(rawValue: [Descriptor]) {
            self.rawValue = rawValue
        }
    }
}

extension MachineLearningModel {
    public enum Descriptor: Codable, Hashable, Sendable {
        public enum _TypeDescriptor: String, Codable, Hashable, Sendable {
            case largeLanguageModel = "llm"
            case embeddingModel = "embedding"
        }
        
        case type(_TypeDescriptor)
    }
}
