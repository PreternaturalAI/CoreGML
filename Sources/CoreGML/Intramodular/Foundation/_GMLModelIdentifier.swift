//
// Copyright (c) Vatsal Manot
//

import CorePersistence
import Foundation
import Swallow

@HadeanIdentifier("rajil-pagik-tibah-jibod")
@RuntimeDiscoverable
public enum _GMLModelIdentifierScope: Codable, Hashable, Sendable {
    case one(_GMLModelIdentifier)
    case choiceOf(Set<_GMLModelIdentifier>)
    
    public var _oneValue: _GMLModelIdentifier? {
        guard case .one(let value) = self else {
            if case .choiceOf(let set) = self, let value = try? set.toCollectionOfOne().first {
                return value
            }
            
            return nil
        }

        return value
    }
    
    public init(_ identifier: _GMLModelIdentifier) {
        self = .one(identifier)
    }
    
    public func `as`<T: _GMLModelIdentifierRepresentable>(
        _ type: T.Type
    ) throws -> T {
        switch self {
            case .one(let identifier):
                return try T(from: identifier)
            case .choiceOf(let identifiers):
                return try identifiers.compactMap({ try? T(from: $0) }).toCollectionOfOne().first
        }
    }
}

/// A general purpose type to identify distinct machine-learning models.
///
/// It's intended for use with both local and API-only models.
@HadeanIdentifier("ludab-gulor-porin-zuvok")
@RuntimeDiscoverable
public struct _GMLModelIdentifier: Hashable, Sendable {
    public let provider: _GMLModelIdentifier.Provider
    public let name: String
    public let revision: String?
    
    public var description: String {
        provider.rawValue + "/" + name
    }
    
    public init(
        provider: _GMLModelIdentifier.Provider,
        name: String,
        revision: String?
    ) {
        self.provider = provider
        self.name = name
        self.revision = revision
    }
    
    public init?(description: String) {
        let components = description.components(separatedBy: "/")
        
        guard !components.isEmpty else {
            assertionFailure()
            
            return nil
        }
        
        guard components.count == 2 else {
            if components.count == 1 {
                let component = components.first!
                
                guard let provider = Self._guessPrimaryProvider(forRawIdentifier: component) else {
                    return nil
                }
                
                self.init(
                    provider: provider,
                    name: component,
                    revision: nil
                )
                
                return
            } else {
                return nil
            }
        }
        
        self.init(
            provider: .init(rawValue: components.first!),
            name: components.last!,
            revision: nil
        )
    }
    
    private static func _guessPrimaryProvider(
        forRawIdentifier identifier: String
    ) -> _GMLModelIdentifier.Provider? {
        if _Anthropic_Model(rawValue: identifier) != nil {
            return ._Anthropic
        } else if _Mistral_Model(rawValue: identifier) != nil {
            return ._Mistral
        } else if _OpenAI_Model(rawValue: identifier) != nil {
            return ._OpenAI
        }
        
        return nil
    }
}

// MARK: - Conformances

extension _GMLModelIdentifier: Codable {
    public enum CodingKeys {
        case provider
        case name
        case revision
    }
    
    private struct _WithRevisionRepresentaton: Codable, Hashable {
        let provider: _GMLModelIdentifier.Provider
        let name: String
        let revision: String
    }
    
    public init(from decoder: Decoder) throws {
        let containerKind = try decoder._determineContainerKind()
        
        do {
            switch containerKind {
                case .singleValue:
                    let container = try decoder.singleValueContainer()
                    
                    self = try Self(description: container.decode(String.self)).unwrap()
                case .unkeyed:
                    throw Never.Reason.illegal
                case .keyed:
                    let representation = try _WithRevisionRepresentaton(from: decoder)
                    
                    self.init(
                        provider: representation.provider,
                        name: representation.name,
                        revision: representation.revision
                    )
            }
        } catch {
            throw error
        }
    }
    
    public func encode(
        to encoder: Encoder
    ) throws {
        var container = encoder.singleValueContainer()
        
        if let revision {
            try container.encode(
                _WithRevisionRepresentaton(
                    provider: provider,
                    name: name,
                    revision: revision
                )
            )
        } else {
            try container.encode(description)
        }
    }
}

extension _GMLModelIdentifier: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self = Self(description: value)!
    }
}

extension _GMLModelIdentifier: _GMLModelIdentifierRepresentable {
    public init(from identifier: _GMLModelIdentifier) throws {
        self = identifier
    }
    
    public func __conversion() throws -> _GMLModelIdentifier {
        self
    }
}

// MARK: - Auxiliary

extension _GMLModelIdentifier {
    private enum _Anthropic_Model: String {
        case claude_v1 = "claude-v1"
        case claude_v2 = "claude-2"
        case claude_instant_v1 = "claude-instant-v1"
        
        case claude_v1_0 = "claude-v1.0"
        case claude_v1_2 = "claude-v1.2"
        case claude_v1_3 = "claude-v1.3"
        case claud_instant_v1_0 = "claude-instant-v1.0"
        case claud_instant_v1_2 = "claude-instant-v1.2"
        case claud_instant_1 = "claude-instant-1"
    }
    
    private enum _Mistral_Model: String {
        case mistral_tiny = "mistral-tiny"
        case mistral_small = "mistral-small"
        case mistral_medium = "mistral-medium"
    }

    private enum _OpenAI_Model: String {
        case gpt_3_5_turbo = "gpt-3.5-turbo"
        case gpt_3_5_turbo_16k = "gpt-3.5-turbo-16k"
        case gpt_4 = "gpt-4"
        case gpt_4_32k = "gpt-4-32k"
        case gpt_4_1106_preview = "gpt-4-1106-preview"
        case gpt_4_vision_preview = "gpt-4-vision-preview"
        case gpt_3_5_turbo_0301 = "gpt-3.5-turbo-0301"
        case gpt_3_5_turbo_0613 = "gpt-3.5-turbo-0613"
        case gpt_3_5_turbo_16k_0613 = "gpt-3.5-turbo-16k-0613"
        case gpt_4_0314 = "gpt-4-0314"
        case gpt_4_0613 = "gpt-4-0613"
        case gpt_4_32k_0314 = "gpt-4-32k-0314"
        case gpt_4_32k_0613 = "gpt-4-32k-0613"
    }
}
